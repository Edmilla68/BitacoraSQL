USE [Depositos]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ConectarWSAlmafin_ObtenerChasis]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select dbo.fn_ConectarWSAlmafin_ObtenerChasis('Mca: HYUNDAI, CH:024993-024998-024999 Mod: ACCENT, VE: GL, Color NEGRO Fab:2017/Mod:2018')  
ALTER FUNCTION [dbo].[fn_ConectarWSAlmafin_ObtenerChasis] (@valorChasis VARCHAR(5000))
RETURNS VARCHAR(30)
AS
BEGIN
	DECLARE @Chasis VARCHAR(20)
		,@exists INT
		,@CaracterInicio INT
		,@longitud INT
		,@CaracterFin INT
		,@NroChasis VARCHAR(30)

	--set @valorChasis = 'Mca: HYUNDAI, CH:KMHD741CAJU567163, Mod:NEW ELANTRA,VE:GL, Color GRIS Fab:2017/Mod:2018'  
	SET @exists = CHARINDEX('CH:', @valorChasis)

	IF @exists > 0
	BEGIN
		SET @CaracterInicio = @exists + 3
		SET @longitud = LEN(@valorChasis) - @CaracterInicio
		SET @valorChasis = SUBSTRING(@valorChasis, @CaracterInicio, @longitud)
		SET @CaracterFin = CHARINDEX(',', @valorChasis) - 1
		SET @valorChasis = SUBSTRING(@valorChasis, 1, @CaracterFin)
		SET @NroChasis = ltrim(rtrim(@valorChasis))
		
		if LEN(@NroChasis) > 17 
		begin
			select @NroChasis = replace(numcha01, 'CH:','')
			from DDTicket01 (nolock)
			where isnull(numcha01,'') like SUBSTRING(@NroChasis,1,17) + '%'
			and codemb06 = 'VEH'
			
			SET @NroChasis = ISNULL(@NroChasis,'')
		end
	END
	ELSE
	BEGIN
		SET @NroChasis = ''
	END

	RETURN @NroChasis
END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_monto_minimo_x_servicio]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_monto_minimo_x_servicio]
(
	@DEPOSI VARCHAR(1),
	@TIPCLI VARCHAR(1),
	@CODCLI VARCHAR(13),
	@CODSER VARCHAR(8),
	@DOCMON VARCHAR(1)
)
RETURNS DECIMAL(12,4)
AS
BEGIN
	DECLARE @monto DECIMAL(12,4)
	SELECT @monto=(CASE WHEN mon.TIPMON54='D' THEN TARMIN53
					    WHEN mon.TIPMON54='S' THEN TARMIN53S END)
	  FROM SERVICIOS_ORS_SER v
      LEFT JOIN DDCLIMON54 mon
        ON mon.TIPCLI54 = v.TIPCLI53
       AND mon.CODCLI54 = v.CODCLI53 
	 WHERE v.DEPOSI52 = @DEPOSI
	   AND v.TIPCLI53 = @TIPCLI 
	   AND v.CODCLI53 = @CODCLI
	   AND v.SERVIC52 = @CODSER
	   AND mon.TIPMON54 = @DOCMON

	RETURN @monto
END

GO
--/****** Object:  UserDefinedFunction [dbo].[fn_Reporte_Aceros_Arequipa]    Script Date: 07/03/2019 03:08:33 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER FUNCTION [dbo].[fn_Reporte_Aceros_Arequipa] ()            
--returns @RepAcero table (Tipo char(20), numcer13 char(9), feccer13 smalldatetime, DUA char(20),Serie char(4),           
--     TotBul int, BulNac int, BulRet int, SldBul int, BulDisp int,           
--     Ubicacion varchar(30), Referencia varchar(800) )          
          
--begin            
--declare @Report table (Tipo char(20), numcer13 char(9), feccer13 smalldatetime, DUA char(20), Serie char(4),           
--     TotBul int, BulNac int, BulRet int, SldBul int, BulDisp int,           
--     Ubicacion varchar(30), Referencia varchar(800) )          
          
-----ADUANERO          
--insert @Report (Tipo, numcer13,feccer13, Dua, Serie, TotBul,BulNac, BulRet, SldBul, Ubicacion, Referencia)          
--select distinct Tipo = 'Aduanero',--a.numcer13,,a.feccer13,          
--    numcer13 = substring(a.numcer13,2,6) + '-' + substring(a.numcer13,8,9),a.feccer13,          
--    DUA=substring(a.numdui11,1,3)+'-'+substring(a.numdui11,4,2)+'-'+  
--	substring(a.numdui11,6,2)+'-'+substring(a.numdui11,8,6),
--	Serie = b.numser12,          
--    TotBul = b.numbul14, BulNac = sum(isnull(numbul17,0)),          
--    BulRet = b.bulent14, SldBul= (b.numbul14 - b.bulent14),          
--    Ubicacion = substring(codubi71,1,4) + ' - '  + substring(codubi71,5,10),           
--    Referencia = b.desmer14              
--from DDCerAdu13 a          
--inner join dddceadu14 b on a.numcer13 = b.numcer13          
--left join DDSERDES17 c on a.numcer13 = c.numcer13 and b.numser12 = c.numser12          
--inner join DVIngAdu21 d on a.numcer13 = d.numcer13        
--inner join ddsoladu10 e on a.numsol10 = e.numsol10          
--where a.tipcli02= '4' and a.codcli02='20370146994' and a.flgval13 = 1--and a.numcer13 = 'A00864800' --A00788000--          
--group by a.numcer13,a.feccer13,a.numdui11,b.numser12,b.numbul14, b.bulent14, codubi71, b.desmer14          
--order by a.numcer13, b.numser12--feccer13 desc--          
          
--update @Report          
--set BulDisp =  BulNac - BulRet          
          
-----SIMPLE          
--insert @Report (Tipo,numcer13,feccer13, Dua, Serie, TotBul,BulNac, BulRet, SldBul,BulDisp, Ubicacion, Referencia)          
--select distinct Tipo = 'Simple', --numcer74 = a.numcer74,a.feccer74,          
--    numcer74 = substring(a.numcer74,2,7),a.feccer74, 
--    DUA=substring(f.numdui11,1,3)+'-'+substring(f.numdui11,4,2)+'-'+  
--	substring(f.numdui11,6,2)+'-'+substring(f.numdui11,8,6)+'-'+substring(f.numdui11,14,1),         
--    Serie = b.numser67,          
--    TotBul = b.bulrec67, BulNac = sum(isnull(bulret76,0)),          
--    BulRet = b.bulent67,SldBul= b.bulrec67-b.bulent67,          
--    BulDisp = b.bulrec67-b.bulent67,          
--    Ubicacion = substring(codubi71,1,4) + ' - '  + substring(codubi71,5,10),           
--    Referencia = b.desmer67           
--from DDCerSim74 a           
--inner join DDDSoSim67 b on a.numsol62 = b.numsol62           
--left  join DDRetSim75 c on a.numcer74 = c.numcer74          
--left  join DDDReSim76 d on b.numser67 = d.numser67 and c.numret75 = d.numret75          
--inner join DVIngSim91_11 e on a.numcer74 = e.numcer74       
--inner join ddsolsim62 f on a.numsol62 = f.numsol62         
--where a.tipcli02= '4' and a.codcli02='20370146994' and a.flgval74 = 1 --and a.numcer74 = 'S004597'--'S004416'           
--group by a.numcer74, a.feccer74,f.numdui11,b.numser67,b.bulrec67, b.bulent67,codubi71,b.desmer67        
--order by a.numcer74 ,b.numser67      
          
          
          
--insert @RepAcero              
--select * from @Report          
          
--return            
--end     
--GO
/****** Object:  UserDefinedFunction [dbo].[fn_Valor_Cadena]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_Valor_Cadena] (    
@CodAgeAduana varchar(11),    
@AgeGeneral char(1),    
@CodAgeMaritimo char(4),     
@CiaConsolidadora char(1),    
@AgeTransporte char(1),    
@EmpresaAfin char(1),    
@Importador char(1),    
@Otros char(1),  
@CiaSeguros char(1),    
@HorasExtras char(1),  
@FacAdelanto char(1),  
@BloWebConsol char(1),   
@Embarcador char(1),    
@LineaArea char(1),    
@CodAgeCarga char(4),    
@Exportador char(1),   
@CliProspecto char(1),    
@TarifaFlatImpo char(1),    
@TarifaFlatExpo char(1)    
)    
  
returns varchar(20)    
begin    
 declare @Cadena varchar(20)    
     
 if @CodAgeAduana <> ''    
 begin    
  set @CodAgeAduana = '1'    
 end    
 if @CodAgeAduana = ''    
 begin    
  set @CodAgeAduana = '0'    
 end    
    
 if @CodAgeMaritimo <> ''    
 begin    
  set @CodAgeMaritimo = '1'    
 end    
 if @CodAgeMaritimo = ''    
 begin    
  set @CodAgeMaritimo = '0'    
 end    
    
 if @CodAgeCarga <> ''    
 begin    
  set @CodAgeCarga = '1'    
 end    
 if @CodAgeCarga = ''    
 begin    
  set @CodAgeCarga = '0'    
 end    
    
 set @Cadena =  @CodAgeAduana + '' + @AgeGeneral + '' +  RTRIM(@CodAgeMaritimo)  + '' + @CiaConsolidadora + '' +    
     @AgeTransporte + '' + @EmpresaAfin + '' + @Importador + '' + @Otros + '' + @CodAgeAduana + '' + @CiaSeguros + '' +    
  @HorasExtras + '' + @FacAdelanto + '' + @BloWebConsol + '' +   
     @Embarcador + '' + @LineaArea + '' + RTRIM(@CodAgeCarga) + '' + @Exportador + '' + @CliProspecto + '' +  
  @TarifaFlatImpo  + '' + @TarifaFlatExpo     
    
  
 return @Cadena    
end 


GO
/****** Object:  View [dbo].[DQBancos49]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  View dbo.DQBancos49    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DQBancos49]
as
select * from descarga..DQBANCOS49
GO
/****** Object:  View [dbo].[DQTipPag48]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DQTipPag48    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DQTipPag48]
as
select * from descarga..dqtippag48
GO
/****** Object:  View [dbo].[vAboCtaCli]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[vAboCtaCli]  
as  
Select a.tipdes52, a.docdes52, a.fecpag56, a.nropag56, c.destip48,   
b.nomban49, a.nrodoc56, a.monpag56  
from 
ddpagos56 a 
inner join dqtippag48 c on (a.codtip48=c.codtip48) 
left join DQBANCOS49 b on  (a.codban49=b.codban49) 

GO
/****** Object:  View [dbo].[DQRegime15]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DQRegime15    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DQRegime15]
as
Select codreg15=codreg56, desreg15=desreg56 from descarga..DQREGIME56
GO
/****** Object:  View [dbo].[DVRetAdu33_112]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVRetAdu33_112    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[DVRetAdu33_112]
AS
SELECT
    a.numret18,a.fecret18,a.numdui16,a.obsret18,
    b.fecdui16,b.feccan16,b.valcif16,b.numdui11,b.numcer13,b.numbul16,b.cifent16,
    g.valfob11,g.valfle11,g.valseg11, g.fobdes11, g.fledes11, g.segdes11,
    c.codrep11, c.nomrep77,
    d.cliente,NombreA=d.nombre,
    tipdes=e.claseabc,coddes=e.contribuy, NombreC=e.nombre,
    tipdep=i.claseabc,coddep=i.contribuy, NombreB=i.nombre,
    j.codreg15, j.desreg15
FROM
    DRRetAdu18 a,
    DDDuiDes16 b,
    DQMaeRep77 c,
    AAClientesAA d,
    AAClientesAA e,
    DDDuiDep11 g,
    DDSolAdu10 h,
    AAClientesAA i,
    DQRegime15 j 
WHERE
    a.numdui16 = b.numdui16 AND
    a.codrep77 = c.codrep11 AND
    b.codage19 = d.cliente AND
    b.tipcli02 = e.claseabc AND b.codcli02 = e.contribuy AND
    b.numdui11 = g.numdui11 AND
    g.numsol10 = h.numsol10 AND
    h.tipcli02 = i.claseabc AND h.codcli02 = i.contribuy AND
    SUBSTRING(b.numdui16,6,2)=j.codreg15

GO
/****** Object:  UserDefinedFunction [dbo].[fn_r_abandono_legal_1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER FUNCTION [dbo].[fn_r_abandono_legal_1] (@FECINI char(8),@FECFIN char(8))  
RETURNS TABLE   
AS

RETURN
Select a.numdui11,a.fecdui11,b.numman10,d.codadu02,b.conemb10,c.priing69,a.tipcam11,a.valcif11,a.abaleg11,b.desmer10,a.numbul11,a.codemb06,c.pesnet69,e.nombre
From DDDUiDep11 a
Inner Join DDSolAdu10 b on b.numsol10=a.numsol10 
Inner Join DDRecMer69 c on c.numsol62=b.numsol10
Inner Join Descarga..DQPuerto02 d on d.codpue02=b.codpue03
Inner Join AAClientesAA e on e.contribuy=b.codcli02
Where CONVERT(CHAR(8),a.abaleg11,112) between @FECINI and @FECFIN and c.flgval69='1' and c.flgemi69='1'  






GO
/****** Object:  UserDefinedFunction [dbo].[fn_r_abandono_legal_1_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_r_abandono_legal_1_NEW] (
	@FECINI CHAR(8)
	,@FECFIN CHAR(8)
	)
RETURNS TABLE
AS
RETURN

SELECT a.numdui11
	,a.fecdui11
	,b.numman10
	,d.codadu02
	,b.conemb10
	,c.priing69
	,a.tipcam11
	,a.valcif11
	,a.abaleg11
	,b.desmer10
	,a.numbul11
	,a.codemb06
	,c.pesnet69
	,e.nombre
	,numbul12 = (select sum(ISNULL(unidad12,0)) from DDSerDep12 zz where zz.numdui11 = a.numdui11 and zz.numsol10 = a.numsol10)
FROM DDDUiDep11 a
INNER JOIN DDSolAdu10 b ON b.numsol10 = a.numsol10
INNER JOIN DDRecMer69 c ON c.numsol62 = b.numsol10
INNER JOIN Descarga..DQPuerto02 d ON d.codpue02 = b.codpue03
INNER JOIN AAClientesAA e ON e.contribuy = b.codcli02
WHERE CONVERT(CHAR(8), a.abaleg11, 112) BETWEEN @FECINI
		AND @FECFIN
	AND c.flgval69 = '1'
	AND c.flgemi69 = '1'
GO
/****** Object:  UserDefinedFunction [dbo].[fn_r_facturacion_por_almacenes]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER FUNCTION [dbo].[fn_r_facturacion_por_almacenes] (@CODALM varchar(9),@FECINI char(8),@FECFIN char(8))  
RETURNS TABLE   
AS

RETURN
--**********ADUANERO**************
Select a.numcer52,a.codcom50,a.numcom52,a.feccom52,b.nombre,a.subtot52,a.igvtot52,TOTAL=a.subtot52+a.igvtot52,a.merdep52 
From ddcabcom52 a, aaclientesaa b
where a.codcli02=b.contribuy and convert(char(8),a.feccom52,112) between @FECINI and @FECFIN and 
a.flgemi52='1' and a.flgval52='1' and a.numcer52 in (
Select numcer13 from ddceradu13
where flgval13='1' and 
numsol10 in (
	Select b.numsol10
	From ddrecmer69 a
	Inner Join ddsoladu10 b on b.numsol10=a.numsol62
	where a.codubi71=@CODALM and a.flgval69='1' and a.flgemi69='1' and b.flgval10='1' and b.flgemi10='1' and 
	Left(a.numrec69,1)='A'))
UNION ALL
--**********SIMPLE**************
Select a.numcer52,a.codcom50,a.numcom52,a.feccom52,b.nombre,a.subtot52,a.igvtot52,TOTAL=a.subtot52+a.igvtot52,a.merdep52 
From ddcabcom52 a, aaclientesaa b
where a.codcli02=b.contribuy and convert(char(8),a.feccom52,112) between @FECINI and @FECFIN and 
a.flgemi52='1' and a.flgval52='1' and a.numcer52 in (
Select numcer74 from ddcersim74
where flgval74='1' and 
numsol62 in (
	Select b.numsol62
	From ddrecmer69 a
	Inner Join ddsolsim62 b on b.numsol62=a.numsol62
	where a.codubi71=@CODALM and a.flgval69='1' and a.flgemi69='1' and b.flgval62='1' and b.flgemi62='1' and 
	Left(a.numrec69,1)='S'))







GO
/****** Object:  UserDefinedFunction [dbo].[Paul]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Paul] ()
RETURNS table
AS
return (Select * from ddsoladu10)

GO
/****** Object:  View [dbo].[DDGUIREM01]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[DDGUIREM01]
AS
Select solicitud=b.numsol10,a.numctr65,tarctr65=convert(decimal(15,2),convert(decimal(15,2),a.tarctr65)/1000),
a.tipctr65,a.tamctr65,b.codnav08,b.numvia10
From DDCtrDep65 a, DDsoladu10 b
where 
a.tipctr65<>'' and a.tarctr65>0 and a.numsol62=b.numsol10 and b.numvia10<>''
Union All
Select solicitud=b.numsol62,a.numctr65,tarctr65=convert(decimal(15,2),convert(decimal(15,2),a.tarctr65)/1000),
a.tipctr65,a.tamctr65,b.codnav08,numvia10=b.numvia62
From DDCtrDep65 a, ddsolsim62 b
where 
a.tipctr65<>'' and a.tarctr65>0 and a.numsol62=b.numsol62 and b.numvia62<>''






GO
/****** Object:  View [dbo].[DEP_REL_SERVICIO_X_FACTURA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DEP_REL_SERVICIO_X_FACTURA]
as
select MM=month(a.feccom52), DD=day(a.feccom52), FACTURA=a.numcom52, FECHA_EMISION=a.feccom52, MONEDA=a.tipmon52,
COD_SER=b.codcon51,SERVICIO=b.descon53, IMPORTE=b.valcon53, 
CEN_COS_D=c.cencos51, CEN_COS_S=c.cencoss51, CEN_COS_CD=cencoscd51, 
COD_OFI_D=codsbd03, COD_OFI_S=codsbd03s
from DdCabCom52 a 
inner join DdDetCom53 b on (a.numcom52=b.numcom52)
inner join DQConCom51 c on (substring(b.codcon51,1,5)=c.codcon51)
where year(a.feccom52)=year(getdate()) and a.nomdes52<>'ANULADO'


GO
/****** Object:  View [dbo].[DQCtaDep50]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DQCtaDep50    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DQCtaDep50]
AS
Select * from Descarga..DQCTADEP50
GO
/****** Object:  View [dbo].[DQPAISES07]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DQPAISES07]  
as  
Select codpai07, despai07, nacpai07,codpaiEqui07 = isnull(codpaiEqui07,'')  from descarga..DQPAISES07

GO
/****** Object:  View [dbo].[DQTipCam28]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.DQTipCam28    Script Date: 08-09-2002 08:44:02 PM *****
*/
ALTER VIEW [dbo].[DQTipCam28]
AS
SELECT     fecfor28, fecnor28, camleg28
FROM         Terminal.dbo.DQTIPCAM28

GO
/****** Object:  View [dbo].[DTSALREC39_VIEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DTSALREC39_VIEW    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DTSALREC39_VIEW] AS


Select 
b.numcer74, a.numret75, a.nument79, c.fecsal01, a.bultot79, a.codemb06, a.pesbru79, a.pretot79
from 
DDEntMer79 a, DDRetSim75 b, DDTicket01 c
where 
a.numret75=b.numret75 and 
a.nument79=
c.numgui01 and c.tipope01='R'
GO
/****** Object:  View [dbo].[dv_Reporte_Aceros_Arequipa]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[dv_Reporte_Aceros_Arequipa]
as
select * from dbo.fn_Reporte_Aceros_Arequipa()

GO
/****** Object:  View [dbo].[DV_SERV_PEND_FACT]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DV_SERV_PEND_FACT]
as
select YY=year(fecord58), MM=month(fecord58), ORDSER=a.numord58, FECHA=fecord58,CERTIFICADO=numcer58, 
SOLICITUD=numsol58, SERVICIO=codcon51, TARIFA=valser59, IMPORTE=valcob59, OBSERV=obsser59  from 
DDDOrSer59 a (nolock) 
inner join DDOrdSer58 b (nolock) on (a.numord58=b.numord58) 
where 
b.numsol58 is null and a.numcom52 is null and year(fecord58)>= year(getdate())-1
GO
--/****** Object:  View [dbo].[DV_SERVCIOS_COBRADOS_DEPOSITO]    Script Date: 07/03/2019 03:08:33 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER VIEW [dbo].[DV_SERVCIOS_COBRADOS_DEPOSITO]
--as
--/*
--select 'A' as TIP, substring(a.numcer52,1,1) as DEP,
--b.codcon51 as CODIGO, descon53 as SERVICIO, tipmon52 as MON,
--cencos51 as CEN_COST, 
--case tipmon52 when 'D' then codsbd03 else codsbd03s end as COD_OFI, d.nombre as CLIENTE, 
--sum(valcon53) as IMPORTE  
--from DDCabCom52 a
--inner join DDDetCom53 b on (a.numcom52=b.numcom52)
--inner join DQConCom51 c on (substring(b.codcon51,1,5)=c.codcon51)
--inner join aaclientesaa d on (a.codcli02=d.contribuy)
--where feccom52>='20130101' and feccom52<'20130901' and
--flgval52='1' and iniper52 is not null
--group by b.codcon51, descon53,tipmon52,cencos51,substring(a.numcer52,1,1), d.nombre,
--case tipmon52 when 'D' then codsbd03 else codsbd03s end
--union
--select 'M', substring(a.numcer52,1,1) as DEP,b.codcon51, descon53,tipmon52,cencos51, 
--case tipmon52 when 'D' then codsbd03 else codsbd03s end as COD_OFI,d.nombre, sum(valcon53)  
--from DDCabCom52 a
--inner join DDDetCom53 b on (a.numcom52=b.numcom52)
--inner join DQConCom51 c on (substring(b.codcon51,1,5)=c.codcon51)
--inner join aaclientesaa d on (a.codcli02=d.contribuy)
--where feccom52>='20130101' and feccom52<'20130901' 
--and flgval52='1' and iniper52 is  null
--group by b.codcon51, descon53,tipmon52,cencos51,substring(a.numcer52,1,1),d.nombre,
--case tipmon52 when 'D' then codsbd03 else codsbd03s end
--union
--select 'M','-' as DEP, 'OOOOO', e.dg_servicio, 
--case a.moneda when '1' then 'S' else 'D' end,b.centrocosto,c.dc_servicio,
--d.nombre, sum(b.tarifa*b.cantidad)
--from terminal..DCORDFAC01 a
--inner join terminal..DDORDFAC01 b on (a.Id_orden=b.Id_orden)
--inner join terminal..TRUNNE_SERV c 
--on (b.TipoServ=c.dc_servicio and b.sucursal=c.dc_sucursal_imputacion and b.centrocosto=c.dc_centro_costo_imputacion)
--inner join terminal..aaclientesaa d on (a.RucxCuenta=d.contribuy)
--inner join terminal..TTSERV e on (c.dc_servicio=e.dc_servicio) 
--where usuario 
--in ('gsandoval','edinga','jhalejos') and FechaDoc>='20130101' and
--FechaDoc<'20130901' and estado<>'A'
--group by
--e.dg_servicio, 
--case a.moneda when '1' then 'S' else 'D' end,b.centrocosto,c.dc_servicio,
--d.nombre

--*/



--Select 'D' as SIST, 'A' as TIPO,   
--case tipmon52 when 'D' then codsbd03 else codsbd03s end as COD_OFI,
--    a.descon53 as SERVICIO, a.numcom52 as NRO_DOCUMENTO,
--    c.docdes52 as RUC ,d.nombre as CLIENTE,a.valcon53 as VALOR,  
--    DOLARES=case when c.TIPMON52 = 'D' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53/e.camleg28)) end,  
--    SOLES  =case when c.TIPMON52 = 'S' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53*e.camleg28)) end,
--c.numcer52   as CERTIFICADO
--    From   
--    dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal..dqtipcam28 e, DQConCom51 f
  
--    Where   
--    f.codcon51=substring(a.codcon51,1,5) and
--    a.numcom52=c.numcom52 and c.flgval52='1' and c.flgemi52='1' and   
--    c.tipdes52=d.claseabc and c.docdes52=d.contribuy and   
--    convert(char(8),c.feccom52,112) between '20130101' and '20130901' and   
--    substring(a.numcom52,1,3)='015' and a.CodCom50='01' and   
--    e.fecfor28=convert(char(8),c.feccom52,112) and c.tipdes52='4'  
--    and c.facesp52='N'
--Union  
--    Select 'D', 'M',  
--case tipmon52 when 'D' then codsbd03 else codsbd03s end as COD_OFI,
--    a.descon53,a.numcom52,c.docdes52,d.nombre,a.valcon53,  
--    DOLARES=case when c.TIPMON52 = 'D' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53/e.camleg28)) end,  
--    SOLES  =case when c.TIPMON52 = 'S' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53*e.camleg28)) end,c.numcer52   
--    From   
--    dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal..dqtipcam28 e, DQConCom51 f  
--    Where   
--	f.codcon51=substring(a.codcon51,1,5) and
--    a.numcom52=c.numcom52 and c.numcer52=a.numcer52 and c.flgval52='1' and c.flgemi52='1' and   
--    c.tipdes52=d.claseabc and c.docdes52=d.contribuy and   
--    convert(char(8),c.feccom52,112) between '20130101' and '20130901' and   
--    substring(a.numcom52,1,3)='015' and a.CodCom50='01' and   
--    e.fecfor28=convert(char(8),c.feccom52,112) and c.tipdes52='4' 
--    and c.facesp52='S' 
--Union
--select 'O','M', c.dc_servicio, e.dg_servicio, a.NumeroDoc,
--a.RucxCuenta,d.nombre, b.tarifa*b.cantidad,
--    DOLARES=case when a.moneda = '2' then convert(decimal(15,2),b.tarifa*b.cantidad) else convert(decimal(15,2),(b.tarifa*b.cantidad/f.camleg28)) end,  
--    SOLES  =case when a.moneda = '1' then convert(decimal(15,2),b.tarifa*b.cantidad) else convert(decimal(15,2),(b.tarifa*b.cantidad*f.camleg28)) end,   
--''
--from terminal..DCORDFAC01 a
--inner join terminal..DDORDFAC01 b on (a.Id_orden=b.Id_orden)
--inner join terminal..TRUNNE_SERV c 
--on (b.TipoServ=c.dc_servicio and b.sucursal=c.dc_sucursal_imputacion and b.centrocosto=c.dc_centro_costo_imputacion)
--inner join terminal..aaclientesaa d on (a.RucxCuenta=d.contribuy)
--inner join terminal..TTSERV e on (c.dc_servicio=e.dc_servicio)
--inner join terminal..dqtipcam28 f on (f.fecfor28=convert(char(8),a.FechaDoc,112)) 
--where usuario 
--in ('gsandoval','edinga','jhalejos') and FechaDoc>='20130101' and
--FechaDoc<'20130901' and estado<>'A'
--   -- Order by a.descon53,d.nombre,a.numcom52  


--GO
/****** Object:  View [dbo].[DV_STOCK_DISPONIBLE_CTR_D]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DV_STOCK_DISPONIBLE_CTR_D] 
as
select distinct 'D' as OPE, a.numman10, a.numsol10, 
substring(a.desmer10,1,255)as MERC, a.fecsol10, 
substring(f.NOMBRE,1,100) as AGE, '' as CONSOL, '' as CTR, '' as CND, 
substring(h.nombre,1,00) as CLIE, '' as UBI, '' as DOC
from depositos..DDSolAdu10 a (nolock)
left  join AACLIENTESAA f (nolock) on (a.codage19=f.CLIENTE)
left  join AACLIENTESAA h (nolock) on (a.codcli02=h.CONTRIBUY)
where a.feclle10>='20120101'
union
select distinct 'D' as OPE, '' as DOC, a.numsol62, 
substring(a.desmer62,1,255)as MERC, a.fecsol62, 
substring(f.NOMBRE,1,100) as AGE, '' as CONSOL, '' as CTR, '' as CND, 
substring(h.nombre,1,00) as CLIE, '' as UBI, '' as DOC
from depositos..DDSolSim62 a (nolock)
left  join AACLIENTESAA f (nolock) on (a.codage19=f.CLIENTE)
left  join AACLIENTESAA h (nolock) on (a.codcli02=h.CONTRIBUY)
where a.fecsol62>='20120101'
GO
/****** Object:  View [dbo].[DVCTRDEP]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DVCTRDEP]
as
select YY=year(fecsol10),MM=month(fecsol10), SOLICITUD=numsol10,DE20,DE40 from DDSolAdu10 where year(fecsol10)=year(getdate())
union
select year(fecsol62),month(fecsol62),numsol62,DE20,DE40 from DDSolSim62 where year(fecsol62)=year(getdate())

GO
/****** Object:  View [dbo].[DVDRESIM86]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DVDRESIM86]
AS
SELECT a.numret75, b.numser67, b.bultot76, b.pretot76, b.bulret76, b.preret76, d.codemb06, d.desmer67, d.bulblo67, e.codubi71
FROM DDRetSim75 a,DDDReSim76 b,DDCerSim74 c,DDDSoSim67 d,DDRecMer69 e
where 
a.numret75 = b.numret75 and a.numcer74 = c.numcer74 and 
                       c.numsol62 = d.numsol62 AND b.numser67 = d.numser67 and 
                       d.numsol62 = e.numsol62 and 
(c.flgval74 = '1') AND (e.flgval69 = '1')



GO
/****** Object:  View [dbo].[DVEntSer24]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVEntSer24    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DVEntSer24]
As
Select nument79, numdui16, numser17, totbul80=SUM(numbul80) 
from DDDEnMer80 
group by nument79, numdui16, numser17
GO
/****** Object:  View [dbo].[DVFACDEP01]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DVFACDEP01]
as
    Select YY=year(c.feccom52), MM=month(c.feccom52), TIPO=substring(c.numcer52,1,1),  
    SERVICIO=a.descon53,FACTURA=a.numcom52,RUC=c.docdes52,CLIENTE=d.nombre,IMPORTE=a.valcon53,
    DOLARES=case when c.TIPMON52 = 'D' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53/e.camleg28)) end,
    SOLES  =case when c.TIPMON52 = 'S' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53*e.camleg28)) end,
    CERTIFICADO=c.numcer52, CANT=cantid53 
    From 
    dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal..dqtipcam28 e
    Where 
    a.numcom52=c.numcom52 and c.flgval52='1' and c.flgemi52='1' and 
    c.tipdes52=d.claseabc and c.docdes52=d.contribuy and 
    year(c.feccom52)= year(getdate()) and
    e.fecfor28=convert(char(8),c.feccom52,112) and c.facesp52='N'
Union
    Select YY=year(c.feccom52), MM=month(c.feccom52), TIPO=substring(c.numcer52,1,1)  , 
    a.descon53,a.numcom52,c.docdes52,d.nombre,a.valcon53,
    DOLARES=case when c.TIPMON52 = 'D' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53/e.camleg28)) end,
    SOLES  =case when c.TIPMON52 = 'S' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53*e.camleg28)) end,
    c.numcer52, CANT=cantid53  
    From 
    dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal..dqtipcam28 e
    Where 
    a.numcom52=c.numcom52 and c.numcer52=a.numcer52 and c.flgval52='1' and c.flgemi52='1' and 
    c.tipdes52=d.claseabc and c.docdes52=d.contribuy and 
    year(c.feccom52)= year(getdate()) and
    e.fecfor28=convert(char(8),c.feccom52,112) and c.facesp52='S'


GO
/****** Object:  View [dbo].[DVIngAdu21]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVIngAdu21    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[DVIngAdu21]
AS
Select c.numdui11, c.numcer13, c.fecdui11, tippla= Case When (c.tippla11="M") Then "1" Else "2" End, 
c.numpla11, c.codter09, a.numrec69, a.fecrec69, a.priing69, 
a.bultot69, a.codemb06, b.desmer10, a.pesnet69,
b.tipcli02, b.codcli02, c.valcif11, c.parara11, c.totser11, a.codubi71, b.codage19, c.tipcam11
from DDRecMer69 a, DDSolAdu10 b, DDDuiDep11 c
where 
a.numsol62=b.numsol10 and b.numsol10=c.numsol10 and flgval69='1' and flgemi69='1'
GO
/****** Object:  View [dbo].[DVIngAdu21_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[DVIngAdu21_NEW]
AS
Select c.numdui11, c.numcer13, c.fecdui11, tippla= Case When (c.tippla11='M') Then '1' Else '2' End, 
c.numpla11, c.codter09, a.numrec69, a.fecrec69, a.priing69, 
a.bultot69, a.codemb06, b.desmer10, a.pesnet69,
b.tipcli02, b.codcli02, c.valcif11, c.parara11, c.totser11, a.codubi71, b.codage19, c.tipcam11,
d.nombre
from DDRecMer69 a, DDSolAdu10 b, DDDuiDep11 c,AAClientesAA d
where a.numsol62=b.numsol10 and b.numsol10=c.numsol10 and flgval69='1' and flgemi69='1' and 
b.tipcli02=d.claseabc and b.codcli02=d.contribuy


GO
/****** Object:  View [dbo].[DVIngAdu21_NEW1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DVIngAdu21_NEW1]
AS
SELECT c.numdui11
	,c.numcer13
	,c.fecdui11
	,tippla = CASE 
		WHEN (c.tippla11 = 'M')
			THEN '1'
		ELSE '2'
		END
	,c.numpla11
	,c.codter09
	,a.numrec69
	,a.fecrec69
	,a.priing69
	,a.bultot69
	,a.codemb06
	,b.desmer10
	,a.pesnet69
	,b.tipcli02
	,b.codcli02
	,c.valcif11
	,c.parara11
	,c.totser11
	,a.codubi71
	,b.codage19
	,c.tipcam11
	,d.nombre
	,bultot69UC = (select SUM(ISNULL(unidad12,0)) from DDDReMer70 zz where zz.numrec69 = a.numrec69)
FROM DDRecMer69 a
	,DDSolAdu10 b
	,DDDuiDep11 c
	,AAClientesAA d
WHERE a.numsol62 = b.numsol10
	AND b.numsol10 = c.numsol10
	AND flgval69 = '1'
	AND flgemi69 = '1'
	AND b.tipcli02 = d.claseabc
	AND b.codcli02 = d.contribuy

GO
/****** Object:  View [dbo].[DVIngCer36_11]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVIngCer36_11    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[DVIngCer36_11]
AS
Select 
a.numcer13,a.feccer13,a.numdui11,d.fecdui11,a.tipcli02,a.codcli02,e.nombre,c.numrec69,
c.priing69,c.pesnet69,a.numbul13,b.codemb06,b.desmer10,a.pescer13,a.cifcer13,a.bulent13,
a.cifent13,a.pesent13

From 
DDCerAdu13 a,DDSolAdu10 b,DDRecMer69 c,DDDuiDep11 d,AAClientesAA e
Where 
a.numsol10=b.numsol10 and b.numsol10=c.numsol62 and a.numdui11=d.numdui11 and
a.tipcli02=e.claseabc and (a.codcli02=e.contribuy or a.codcli02=e.catcliente) and
a.flgval13='1' and c.flgval69='1' and c.flgemi69='1'
GO
/****** Object:  View [dbo].[DVIngDep84]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVIngDep84    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DVIngDep84]
as
Select tottkt84=count(*), docaut84=docaut01, numgui84=numgui01, PriIng84=MIN(fecing01), UltIng84=MAX(fecing01), PriSal84=MIN(fecsal01), UltSal84=MAX(fecsal01)
from ddticket01 
where tipope01="D"
group by docaut01, numgui01
GO
/****** Object:  View [dbo].[DVIngSim91_11]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER VIEW [dbo].[DVIngSim91_11]
As
Select 
a.numcer74,a.feccer74,c.numsol62,c.tipcli02,c.codcli02,d.nombre,b.numrec69,b.fecrec69, 
b.priing69,b.bultot69,b.codemb06,c.desmer62,b.pesnet69,b.pretot69,bulent74,preent74,pesent74,b.codubi71 
From 
DDCerSim74 a,DDRecMer69 b,DDSolSim62 c,AAClientesAA d
where 
b.numsol62=a.numsol62 and b.numsol62=c.numsol62 and
a.flgval74='1' and b.flgval69='1' and b.flgemi69='1' and
a.tipcli02=d.claseabc and a.codcli02=d.contribuy





GO
/****** Object:  View [dbo].[DVLevAba94]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER VIEW [dbo].[DVLevAba94] AS 

SELECT 
a.numdui16, a.numdui11, b.fecdui11, b.abaleg11, a.fecusu16, a.numbul16, cifdol=a.valcif16, b.tipcam11, 
cifsol=ROUND(a.valcif16*b.tipcam11,3), c.codemb06, c.desmer10, a.pesbru16, a.cifent16, b.numbul11, b.valcif11,
c.numman10, cli.nombre
FROM 
DDDuiDes16 a (nolock) left join AAClientesAA cli (nolock) on a.codcli02 = cli.contribuy , DDDuiDep11 b (nolock), DDSolAdu10 c (nolock)
WHERE 
a.flglev16='1' AND a.numdui11=b.numdui11 AND b.numsol10=c.numsol10 




GO
/****** Object:  View [dbo].[DVLevAba94_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DVLevAba94_NEW]
AS
SELECT a.numdui16
	,a.numdui11
	,b.fecdui11
	,b.abaleg11
	,a.fecusu16
	,a.numbul16
	,cifdol = a.valcif16
	,b.tipcam11
	,cifsol = ROUND(a.valcif16 * b.tipcam11, 3)
	,c.codemb06
	,c.desmer10
	,a.pesbru16
	,a.cifent16
	,b.numbul11
	,b.valcif11
	,c.numman10
	,cli.nombre
	,numbul17 = (select SUM(ISNULL(zz.unidad12,0)) from DDSerDes17 zz where zz.numdui16 = a.numdui16)
FROM DDDuiDes16 a(NOLOCK)
LEFT JOIN AAClientesAA cli(NOLOCK) ON a.codcli02 = cli.contribuy
	,DDDuiDep11 b(NOLOCK)
	,DDSolAdu10 c(NOLOCK)
WHERE a.flglev16 = '1'
	AND a.numdui11 = b.numdui11
	AND b.numsol10 = c.numsol10

GO
/****** Object:  View [dbo].[DVPesIng85]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVPesIng85    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DVPesIng85]
As
Select numsol62, PesBru85=SUM(pesbru69), PesNet85=SUM(pesnet69)
from DDRecMer69 where flgval69 ='1'
group by numsol62
GO
/****** Object:  View [dbo].[DVPreRec87]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVPreRec87    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[DVPreRec87]
as
Select a.numsol62, b.numrec69, pretot69=SUM(b.prerec70)
from DDRecMer69 a, DDDReMer70 b
where a.numrec69=b.numrec69
group by a.numsol62, b.numrec69
GO
/****** Object:  View [dbo].[DVRETMER01]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[DVRETMER01]  
as  
select numtkt01, b.numcer74, fecing01,fecsal01, a.codemb06, bultos=cast(numbul01 as char(8)),  
obsret75=substring(obsret75,1,30), desmer62=substring(e.desmer62,1,50)      
from DDTicket01 a (nolock)  
inner join DDRetSim75 b (nolock) on (a.docaut01=b.numret75)  
inner join DDCerSim74 c (nolock) on (b.numcer74=c.numcer74)  
inner join DDRecMer69 d (nolock) on (c.numsol62=d.numsol62)  
inner join DDSolSim62 e (nolock) on (d.numsol62=e.numsol62)  
where a.codcli02='20303585622' and   
a.codemb06 <> 'CTR'  
and fecsal01>=convert(char(8),dateadd(day,-1,getdate()),112)  
and fecsal01< convert(char(8),getdate(),112)  
--and fecsal01>='20120427'
union  
  
select b.numtkt01, a.numdui16,fecing01, fecsal01,   
b.codemb06, cast(numbul01 as char(8)), substring(e.obsret18,1,30), substring(d.desmer10,1,50)      
from   
DDEntMer79 a (nolock)  
inner join DDTicket01 b (nolock) on (a.Numtkt01=b.Numtkt01)  
inner join DDCerAdu13 c (nolock) on (a.numcer13=c.numcer13)  
inner join DDSolAdu10 d (nolock) on (d.numsol10=c.numsol10)  
inner join DRRetAdu18 e (nolock) on (a.numdui16=e.numdui16)  
where c.codcli02='20303585622'   
and b.codemb06 <> 'CTR'  
and fecsal01>=convert(char(8),dateadd(day,-1,getdate()),112)  
and fecsal01< convert(char(8),getdate(),112)
--and fecsal01>='20120427'

GO
/****** Object:  View [dbo].[DVSalAdu23_11_11]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVSalAdu23_11_11    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[DVSalAdu23_11_11]
AS
Select 
a.numdui11,a.numdui16,c.fecdui16,c.valcif16,a.numret75,a.nument79,a.fecent79,d.fecsal01,
a.bultot79,a.codemb06,a.pesbru79,tipdes=c.tipcli02,coddes=c.codcli02,
tipdep=h.tipcli02,coddep=h.codcli02,a.pretot79,a.cuadep79,c.parara16,
c.totser16,c.codage19,e.tipcam11,h.desmer10
From 
DDEntMer79 a,DDDuiDes16 c,DDTicket01 d,DDDuiDep11 e,DDSolAdu10 h
Where 
a.numdui16=c.numdui16 and a.nument79=d.numgui01 and d.tipope01="R" and 
a.numdui11=e.numdui11 and e.numsol10=h.numsol10
GO
/****** Object:  View [dbo].[DVSALCER37_VIEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVSALCER37_VIEW    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[DVSALCER37_VIEW]

AS


Select 
a.numdui11,a.numcer13,a.numdui16,a.numret75,a.nument79,a.fecent79,c.fecsal01,a.bultot79,
a.codemb06,a.pesbru79,b.tipcli02,b.codcli02,d.nombre,a.pretot79,a.cuadep79,b.codage19
From 
DDEntMer79 a,DDDuiDes16 b,DDTicket01 c,AAClientesAA d 
Where 
a.numdui16=b.numdui16 and a.nument79=c.numgui01 and c.tipope01='R' and 
b.tipcli02=d.claseabc and (b.codcli02=d.contribuy or b.codcli02=d.catcliente)
GO
/****** Object:  View [dbo].[DVSalRec39]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVSalRec39    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DVSalRec39]
AS
Select b.numcer74, a.numret75, a.nument79, c.fecsal01, a.bultot79, a.codemb06, a.pesbru79, a.pretot79
from DDEntMer79 a, DDRetSim75 b, DDTicket01 c
where a.numret75=b.numret75 and 
      a.nument79=c.numgui01 and c.tipope01="R"
GO
/****** Object:  View [dbo].[DVSalSer38]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVSalSer38    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DVSalSer38]
AS
Select b.numcer13, b.numser70, a.nument79, c.fecsal01, numbul80=SUM(b.numbul80), preent80=SUM(preent80)
from DDEntMer79 a, DDDEnMer80 b, DDTicket01 c
where a.nument79=b.nument79 and a.nument79=c.numgui01 and c.tipope01="R" and SUBSTRING(a.nument79,1,1)='A'
group by b.numcer13, b.numser70, a.nument79, c.fecsal01
GO
/****** Object:  View [dbo].[DVSalSer40]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVSalSer40    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[DVSalSer40]
AS

Select 
c.numcer74 , c.numsol62, a.numser70, nument79=a.nument79, d.fecsal01, 
numbul80=(a.numbul80), preent80=SUM(a.preent80)
From 
DDDEnMer80 a , DDRecMer69 b, DDCerSim74 c, DDTicket01 d
Where 
SUBSTRING(a.nument79,1,1)='S' and a.numrec69=b.numrec69 and b.numsol62=c.numsol62 and
a.nument79=d.numgui01 and d.tipope01="R" and c.flgval74='1' and b.flgval69='1'
Group by 
c.numcer74, c.numsol62, a.nument79, d.fecsal01, a.numser70, a.numbul80, a.preent80
GO
/****** Object:  View [dbo].[DVSalSim92_11]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.DVSalSim92_11    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[DVSalSim92_11]
As
Select 
c.numcer74,c.tipcli02,c.codcli02,f.nombre,a.numret75,a.nument79,a.fecent79,d.fecsal01,
a.bultot79,a.codemb06,e.desmer62,a.pesbru79,a.pretot79,d.codage19
From 
DDEntMer79 a,DDRetSim75 b,DDCerSim74 c,DDTicket01 d,DDSolSim62 e,AAClientesAA f
Where 
a.numret75=b.numret75 and b.numcer74=c.numcer74 and 
a.nument79=d.numgui01 and d.tipope01='R' and
c.numsol62=e.numsol62 and c.tipcli02=f.claseabc and 
c.codcli02=f.contribuy


GO
/****** Object:  View [dbo].[DVSERVIC52]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[DVSERVIC52]
AS
--rdelacuba 02/11/2006: Se incluye detracción de transporte
SELECT     detrac51=b.detrac51, dettrans=b.dettrans,a.*
FROM         dbo.DDSERVIC52 a INNER JOIN
                      dbo.DQConCom51 b ON a.CONCEP51 = b.codcon51
WHERE     (b.visible51 = 'S')


GO
/****** Object:  View [dbo].[ODItems06]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.ODItems06    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[ODItems06]
As
	Select * from Descarga..ODItems06
GO
/****** Object:  View [dbo].[ORUsrItm11]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.ORUsrItm11    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[ORUsrItm11]
As
	Select * from Descarga..ORUsrItm11
GO
/****** Object:  View [dbo].[SERVICIOS_ORS_SER]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[SERVICIOS_ORS_SER] AS        
SELECT numacu53=coalesce(b.numacu53,''),gloacu53=coalesce(b.gloser53,''),a.*,    
DETRAC51=(Select detrac51 from dqconcom51 where codcon51=a.CONCEP51 and visible51='S'),    
DETTRANS=(Select dettrans from dqconcom51 where codcon51=a.CONCEP51 and visible51='S')
,b.TIPCLI53,b.CODCLI53  --13/08/2014 AOG
,b.TIPACU53,b.TARMIN53,b.TARMIN53S --06/08/2014
FROM 
ddservic52 a (NOLOCK) 
	left join ddacuerd53 b (NOLOCK) on (a.servic52=b.codser53 and a.deposi52=b.tipdep53)   
WHERE     
a.STATUS52='A' and a.VISIBLE52='S' and     
b.ESTADO53='A' and a.APLICA52<>'P' 



GO
/****** Object:  View [dbo].[SIP_SERVICIOS_ORS_SER]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[SIP_SERVICIOS_ORS_SER] AS  
  
Select numacu53=coalesce(b.numacu53,''),gloacu53=coalesce(b.gloser53,''),cliente53=coalesce(b.CODCLI53,''),a.*,  
nombre53=coalesce((Select nombre from AAclientesAA where contribuy=b.codcli53),''),  
desmed52=(Select unimed54 from PDUNIMED54 where numuni54=a.unimed52),  
HORLIB53=coalesce(b.horlib53,0)  
From 
Pdservic52 a 
left join Pdacuerd53 b  on (a.servic52=b.codser53)
Where      
a.STATUS52='A' and a.VISIBLE52='S' and b.ESTADO53='A'   
  
  

GO
/****** Object:  View [dbo].[TARIFAS_CERTIFICADO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TARIFAS_CERTIFICADO]
AS
Select 
b.numacu53,a.deposi52,b.tipdep53,a.servic52,b.codser53,a.APLICA52,b.TIPCLI53,b.CODCLI53,
b.GLOSER53,b.CLAACU53,b.tipacu53,b.APLMIN53,b.tarmin53,b.tarmin53s,b.estado53,b.valacu53,b.valacu53s
From 
ddservic52 a, ddacuerd53 b
Where 
a.servic52=b.codser53 and a.deposi52=b.tipdep53 and (b.CODSER53 LIKE 'ALMAN%' or b.CODSER53 LIKE 'ALMVE%')
and b.estado53 = 'A'


GO
/****** Object:  View [dbo].[TM_CLIENTES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TM_CLIENTES]
AS
select * from terminal.dbo.aaclientesaa

GO
/****** Object:  View [dbo].[TM_EMBALAJE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TM_EMBALAJE]

AS

select * from terminal.dbo.DQEMBALA06


GO
/****** Object:  View [dbo].[Ubicaciones]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.Ubicaciones    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[Ubicaciones] 
AS

Select a.codubi71,Descripcion=b.desalm83+' / '+a.desubi71
From dqtipubi71 a, DQTipAlm83 b
where a.almzon71=b.codalm83 and a.visible71='S' and b.visible83='S'
GO
/****** Object:  View [dbo].[vMovCtaCli]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.vMovCtaCli    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER VIEW [dbo].[vMovCtaCli]
as
Select tipdes52, docdes52, codcom50, numcom52, fecope=feccom52, total=subtot52+igvtot52, tipo="C", signo=-1
from ddcabcom52
where FlgEmi52='1' and FlgVal52 = '1'
Union all
Select a.tipdes52, a.docdes52, b.codcom50, b.numcom52, fecope=a.fecpag56, total=b.monpag57, tipo="A", signo=+1
from ddpagos56 a, ddPagCom57 b
where a.NroPag56=b.NroPag56
GO
/****** Object:  StoredProcedure [dbo].[AVISO_A_ALMACEN_ADUANERO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AVISO_A_ALMACEN_ADUANERO    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER PROCEDURE [dbo].[AVISO_A_ALMACEN_ADUANERO] 
@FLAG tinyint
AS
Declare
@SelectA1 varchar(255),
@SelectA2 varchar(255),
@FromA varchar(255),
@WhereA1 varchar(255),
@WhereA2 varchar(255),
@WhereA3 varchar(255),
@CondicA varchar(30),

@SelectS1 varchar(255),
@SelectS2 varchar(255),
@FromS varchar(255),
@WhereS1 varchar(255),
@WhereS2 varchar(255),
@WhereS3 varchar(255),
@CondicS varchar(30)

Select @SelectA1="SELECT 
distinct m.numret18,m.fecvig18,a.numdui16,b.numdui11,b.numcer13,l.codubi71,
b.numbul16,d.cliente,NombreA=d.nombre,coddep=i.contribuy, NombreB=i.nombre,"

Select @SelectA2="coddes=e.contribuy,NombreC=e.nombre,
k.numser12,k.numbul17,k.bulent17,sldbul17=(k.numbul17-k.bulent17),k.codemb06,k.desmer17 "

Select @FromA="FROM
DRRetAdu18 a,DDDuiDes16 b,AAClientesAA d,AAClientesAA e,
DDDuiDep11 g,DDSolAdu10 h,AAClientesAA i,DDSERDES17 k,DDRecMer69 l,DRVIGADU18 m,
DDENTMER79 n "

Select @WhereA1="WHERE
a.NUMRET18=m.NUMRET18 and a.flgval18='1' and 
convert(char(8),FECVIG18,112)=convert(char(8),getdate(),112) and 
a.numdui16 = b.numdui16 AND b.codage19 = d.cliente AND
b.codcli02 = e.contribuy AND "

Select @WhereA2="b.numdui11=g.numdui11 AND g.numsol10=h.numsol10 AND
h.codcli02=i.contribuy AND "

Select @WhereA3="k.numdui16=a.numdui16 and h.numsol10=l.numsol62 and 
CONVERT(CHAR(8),n.fecent79,112)=CONVERT(CHAR(8),GETDATE(),112) AND n.flgval79='1' and 
m.numret18 not in (Select numret75 from DDENTMER79) "

Select @CondicA="and m.IMPAVI18='0' "

/******************************************************************************************/

Select @SelectS1="Select 
NUMRET18=b.numret75,b.fecvig18,'','',NUMCER13=a.numcer74,e.codubi71,
numbul16=0,CLIENTE=a.codage19,NOMBREA=g.nombre,coddep=c.codcli02,NOMBREB=f.nombre,"


Select @SelectS2="CODDES='',NOMBREC='',
NUMSER12=h.numser67,NUMBUL17=h.bultot76,BULENT17=h.bulret76,SLDBUL17=(h.bultot76-h.bulret76),
i.codemb06,DESMER17=i.desmer67 "

Select @FromS="From 
DDRETSIM75 a,DDVIGSIM75 b,DDCerSim74 c,DDSolSim62 d,DDRecMer69 e,AAClientesAA f,
Descarga..AAClientesAA g,DDDReSim76 h,DDDSoSim67 i "

Select @WhereS1="Where 
a.numret75=b.numret75 and a.flgval75='1' and 
convert(char(8),b.fecvig18,112)=convert(char(8),getdate(),112) and "



Select @WhereS2="a.numcer74=c.numcer74 and c.numsol62=d.numsol62 and d.numsol62=e.numsol62 and 
c.tipcli02=f.claseabc and c.codcli02=f.contribuy and "


Select @WhereS3="a.codage19*=g.cliente and g.cliente<>'' and 
a.numret75=h.numret75 and h.numser67=i.numser67 and d.numsol62=i.numsol62 and 
b.numret75 not in (Select numret75 from DDENTMER79) "

Select @CondicS="and b.IMPAVI75='0' "

/******************************************************************************************/

if @FLAG=1
Execute (@SelectA1+@SelectA2+@FromA+@WhereA1+@WhereA2+@WhereA3+@CondicA+"UNION ALL "+
         @SelectS1+@SelectS2+@FromS+@WhereS1+@WhereS2+@WhereS3+@CondicS)
else
Execute (@SelectA1+@SelectA2+@FromA+@WhereA1+@WhereA2+@WhereA3+" UNION ALL "+
         @SelectS1+@SelectS2+@FromS+@WhereS1+@WhereS2+@WhereS3)
GO
/****** Object:  StoredProcedure [dbo].[BALANZA_ENTREGA_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.BALANZA_ENTREGA_ADU    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[BALANZA_ENTREGA_ADU]
@NUMENT CHAR(7)
AS

Select a.numret75,a.numdui16,a.numdui11,a.numcer13,c.codage19,c.tipcli02,
c.codcli02,d.nombre,a.numpla79,a.numtkt01,a.bultot79,a.codemb06,a.flgval79,
a.flgemi79,a.ultcer79,a.pesbru79
From 
DDEntMer79 a,DRRetAdu18 b,DDDuiDes16 c,AAClientesAA d
Where a.numret75=b.numret18 and b.numdui16=c.numdui16 and 
c.tipcli02=d.claseabc and c.codcli02=d.contribuy and 
a.nument79=@NUMENT
GO
/****** Object:  StoredProcedure [dbo].[BALANZA_ENTREGA_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.BALANZA_ENTREGA_SIM    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[BALANZA_ENTREGA_SIM]
@NUMENT CHAR(7)
AS

Select 
a.numret75,c.numsol62,b.numcer74,b.codage19,c.tipcli02,c.codcli02,d.nombre,a.numpla79,a.numtkt01,
a.bultot79,a.codemb06,a.flgemi79,a.flgval79,a.ultcer79,a.pesbru79
From 
DDEntMer79 a,DDRetSim75 b,DDCerSim74 c,AAClientesAA d
Where 
a.nument79=@NUMENT and a.numret75=b.numret75 and b.numcer74=c.numcer74 And 
c.tipcli02=d.claseabc and c.CodCli02=d.Contribuy
GO
/****** Object:  StoredProcedure [dbo].[busca_OBJTYPE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:				EDUARDO MILLA
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[busca_OBJTYPE]
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
/****** Object:  StoredProcedure [dbo].[BUSCAR_USER_SAAWEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[BUSCAR_USER_SAAWEB]
@cuenta varchar(50)
AS
SELECT cuenta , password , razonsocial , emailAduana ,emailContactos , nombreAduana
FROM  DINFOSUSERSAAWEB
WHERE cuenta = @cuenta


GO
/****** Object:  StoredProcedure [dbo].[CERTIFICADO_SUSPENDIDOS_EN_FAC]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CERTIFICADO_SUSPENDIDOS_EN_FAC] AS  
  
Select   
CERTIFICADO=a.numcer13,FECHA=a.feccer13,TIPCLIENTE=a.ticlfa13,CODCLIENTE=a.coclfa13,  
NOMBRE=b.nombre  
From   
ddceradu13 a 
left join AAClientesAA b  on (a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy)
Where   
a.flgval13='1' and a.flstfa13='S'   
UNION ALL  
Select   
CERTIFICADO=a.numcer74,FECHA=a.feccer74,TIPCLIENTE=a.ticlfa74,CODCLIENTE=a.coclfa74,  
NOMBRE=b.nombre  
From   
ddcersim74 a 
left join AAClientesAA b  on (a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy)
Where a.flgval74='1' and a.flstfa74='S'   
order by certificado
 
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ACTA_APERTURA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CG_ADU_ACTA_APERTURA]
      @NUMSOL CHAR(7),
      @Tipo   Char(1)
AS

SET NOCOUNT ON

If @Tipo = '1' 
   Select NumActa from DDACTAPER11
   where  NumSol = @NumSOl
Else
   Select NumActa as NumDoc, FecUsu11 as FecEmi, NomUsu11 as Usu, IsNull( FlgEmi11, '0' ) as Imp from DDACTAPER11
   where  NumSol = @NumSOl

SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ACTA_INVENTARIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CG_ADU_ACTA_INVENTARIO]
      @NUMSOL CHAR(7),
      @Tipo   Char(1)
AS

SET NOCOUNT ON

If @Tipo = '1' 
   Select NumActa from DDACTAINV13
   where  NumSol = @NumSOl
Else
   Select NumActa as NumDoc, FecActa as FecEmi, NomUsu13 as Usu, IsNull( FlgEmi13, '0' ) as Imp from DDACTAINV13
   where  NumSol = @NumSOl

SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_CERTIFICADO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_CERTIFICADO    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_CERTIFICADO]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select NUMCER=numcer13,NUMDOC=substring(numcer13,1,1)+'-'+substring(numcer13,2,6)+'-'+substring(numcer13,8,2),
FECEMI=fecusu13,USU=nomusu13,IMP='1'
From DDCERADU13 
Where numsol10=@DEPOSI+@NUMSOL and flgval13='1'
else
Select NUMCER=numcer74,NUMDOC=substring(numcer74,1,1)+'-'+substring(numcer74,2,6),
FECEMI=fecusu74,USU=nomusu74,IMP='1'  
From DDCERSIM74 
Where numsol62=@DEPOSI+@NUMSOL and flgval74='1'
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_CONTENEDOR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_CONTENEDOR    Script Date: 08-09-2002 08:44:05 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_CONTENEDOR]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

Select NUMDOC=numctr65,FECEMI=fecusu65,USU=nomusu65,IMP='1'
From DDCtrDep65 
Where numsol62=@DEPOSI+@NUMSOL
order by numctr65
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_DUADEP]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_DUADEP    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_DUADEP]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select NUMDOC=substring(numdui11,1,3)+'-'+substring(numdui11,4,2)+'-'+
substring(numdui11,6,2)+'-'+substring(numdui11,8,6),FECEMI=fecusu11,USU=nomusu11,IMP='1'
From DDDUIDEP11 
where numsol10=@DEPOSI+@NUMSOL
order by numDUI11
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_DUADES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_DUADES    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_DUADES]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select NUMDOC=substring(b.numdui16,1,3)+'-'+substring(b.numdui16,4,2)+
'-'+substring(b.numdui16,6,2)+'-'+substring(b.numdui16,8,6)+'-'+substring(b.numdui16,14,1),
FECEMI=b.fecusu16,USU=nomusu16,IMP='1'
From ddduidep11 a,ddduides16 b 
Where a.numdui11=b.numdui11 and a.numsol10=@DEPOSI+@NUMSOL
Order by b.numdui16
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_DUADES_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CG_ADU_DUADES_SOLICITUD    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_DUADES_SOLICITUD]
@DUADES CHAR(14)
AS

Select a.numsol10 From ddduidep11 a,ddduides16 b 
Where a.numdui11=b.numdui11 and b.numdui16=@DUADES
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ENTMER_ORDRET]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.CG_ADU_ENTMER_ORDRET    Script Date: 08-09-2002 08:44:07 PM ******/  
ALTER PROCEDURE [dbo].[CG_ADU_ENTMER_ORDRET]
@ORDRET CHAR(8),  
@DEPOSI CHAR(1)  
AS  
  
Select NUMDOC=substring(nument79,1,1)+'-'+substring(nument79,2,6),FECEMI=fecusu79,USU=nomusu79,IMP=flgemi79  
From DDENTMER79  
where flgval79='1' and numret75=substring(@ORDRET,1,1)+substring(@ORDRET,3,6)  
order by nument79

GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ENTREGA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_ENTREGA    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_ENTREGA]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select NUMDOC=d.nument79,USU=d.nomusu79,IMP=d.flgemi79  
From ddduides16 a,DRRetAdu18 b,Ddduidep11 c,ddentmer79 d 
where a.numdui16=b.numdui16 and a.numdui11=c.numdui11 and 
b.flgval18='1' and d.flgval79='1' and 
b.numret18=d.numret75 and numsol10=@DEPOSI+@NUMSOL
order by d.nument79
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ENTREGA_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CG_ADU_ENTREGA_SOLICITUD    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_ENTREGA_SOLICITUD]
@NUMENT CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select numsol10 
from ddduides16 a,DRRetAdu18 b,Ddduidep11 c,ddentmer79 d 
where a.numdui16=b.numdui16 and a.numdui11=c.numdui11 and 
b.flgval18='1' and d.flgval79='1' and 
b.numret18=d.numret75 and d.nument79=@DEPOSI+@NUMENT
else
Select numsol10=c.numsol62 
from DDRetSim75 a,ddentmer79 b,DDCerSim74 c
where a.numret75=b.numret75 and a.numcer74=c.numcer74 and 
a.flgval75='1' and b.flgval79='1' and c.flgval74='1' and 
b.nument79=@DEPOSI+@NUMENT
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_FACTURA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CG_ADU_FACTURA]  
@NUMSOL CHAR(6),  
@DEPOSI CHAR(1)  
AS  
  
if @DEPOSI='A'   
Select NUMDOC=substring(b.numcom52,1,3)+'-'+substring(b.numcom52,4,7),FECEMI=b.fecusu52,USU=b.nomusu52,IMP=b.flgemi52   
From ddceradu13 a (nolock),ddcabcom52 b (nolock)   
where a.numcer13=b.numcer52 and b.flgval52='1' and   
a.numsol10=@DEPOSI+@NUMSOL  
order by b.feccom52  
else  
Select NUMDOC=substring(b.numcom52,1,3)+'-'+substring(b.numcom52,4,7),FECEMI=b.fecusu52,USU=b.nomusu52,IMP=b.flgemi52   
From DDCerSim74 a (nolock),ddcabcom52 b (nolock)   
where a.numcer74=b.numcer52 and b.flgval52='1' and   
a.numsol62=@DEPOSI+@NUMSOL  
order by b.feccom52
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_FACTURA_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CG_ADU_FACTURA_SOLICITUD]
@NUMFAC CHAR(10),
@DEPOSI CHAR(1)
AS
BEGIN

/*rdelacuba 03/11/2006: Se aplican los cambios necesarios para calcular el valor referencial*/
DECLARE @dettranS char(1), @dettranC char(1), @tc decimal(5,3), @tot_fac decimal(15,2), 
	@num_cert varchar(9), @porc_igv decimal(12,2),
	@servicio varchar(8), @val_fac decimal(15,2), @val_ref decimal(12,2), @num_sol varchar(7), @tot_viajes int,
	@valor_referencial decimal(15,2), @aplica int, @val_ref_calc decimal(15,2) , @peso decimal(15,2),@VALREF decimal(15,2)

--Verificando si es factura por detracción de transporte, y si tiene o no valor referencial
SELECT 	@dettranS = c.dettrans,
	@dettranC = c.dettranc,
	@tc = c.tipcam52, 
	@tot_fac = c.SubTot52+c.IGVTot52,
	@num_cert = c.numcer52,
	@porc_igv = c.porigv52
       
FROM ddcabcom52 c (NOLOCK) 
WHERE numcom52 = @NUMFAC

SET @aplica = 0
SET @val_ref_calc = 0



--Si es SIN valor referencial, verificar si el total facturado es mayor a S/400
--de ser así, indicar que debe figurar glosa fija NUNCA FIGURA MONTO A DETRAER
IF @dettranS = 'S'
BEGIN
	IF (@tot_fac * @tc) > 400
	BEGIN
		SELECT @valor_referencial = 1
	END
	ELSE
	BEGIN
		SELECT @valor_referencial = 0
	END

  --01042004 Calculo Detraccion para concepto Carga Suelta


/*    If Exists ( select 1 
                from DDDetCom53 d
                where codcon51 like 'TRACS%' and numcom52 = @NUMFAC )
    Begin
            if @DEPOSI='A'
	    begin
	       select @Peso = pescer13/1000  from ddceradu13 (NOLOCK) where numcer13 = @num_cert 
	    end
	
	    if @DEPOSI='S'
	    begin
	       select @Peso = pestot74/1000  from ddcersim74 (NOLOCK) where numcer74 = @num_cert 
	    end
	    
            select @VALREF = VALREF from DDSERVIC52 where concep51 = 'TRACS' and deposi52 = @DEPOSI and servic52 = 'TRACS001'  
	
	    if @peso < 7 
	      SET @valor_referencial =  0.04 * @tot_fac  --Caso 2.-  Si la carga es inferior a 7 T, se multiplica el peso máximo que carga un camión (10 Ton) que depende de los ejes  por el factor S/. 12.92  .  
	    else
	      SET @valor_referencial = @Peso * @VALREF --Caso 1.-   Cuando la carga supera las aprox. 7  T, se multiplica la cantidad de toneladas por el factor S/. 12.92.  Se multiplica el peso * el factor 
    End*/
END


IF @dettranC = 'S'
BEGIN
	--Ubicando información del número de viajes
	IF @DEPOSI = 'S'
	BEGIN
		SELECT @num_sol = numsol62
		FROM DDCerSim74 (NOLOCK)
		WHERE numcer74 = @num_cert	
	END

	IF @DEPOSI = 'A'
	BEGIN
		SELECT @num_sol = numsol10 
		FROM ddceradu13 (NOLOCK)
		WHERE numcer13 = @num_cert
	END
	
	SELECT @tot_viajes = count(*) 
	FROM ddticket01 (NOLOCK)
	WHERE docaut01 = @num_sol and tipope01 = 'D'

	--Verificando item por item para encontrar el V.R. por cada servicio
	DECLARE c_items CURSOR FOR 
	SELECT codcon51, valcon53 * (1 + @porc_igv), isnull(valref,0)
	FROM   DDDetCom53 (NOLOCK)  INNER JOIN DDSERVIC52 (NOLOCK) ON DDDetCom53.codcon51 = DDSERVIC52.SERVIC52
	WHERE  numcom52 = @NUMFAC and DEPOSI52 = @DEPOSI
	ORDER BY codcon51

	OPEN c_items

	FETCH NEXT FROM c_items 
	INTO @servicio, @val_fac, @val_ref

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Si el valor facturado supera los S/ 400 APLICA
		IF (@val_fac * @tc) > 400
		BEGIN
			SET @aplica = @aplica + 1
		END
		ELSE -- Si el valor referencial supera los S/ 400 APLICA
		IF (@val_ref * @tot_viajes) > 400
		BEGIN
			SET @aplica = @aplica + 1
		END

		SET @val_ref_calc = @val_ref_calc + (@val_ref * @tot_viajes)

		FETCH NEXT FROM c_items 
   		INTO @servicio, @val_fac, @val_ref
	END

	CLOSE c_items
	DEALLOCATE c_items

	IF @aplica > 0
	BEGIN
		SELECT @valor_referencial = @val_ref_calc
	END
	ELSE
	BEGIN
		SELECT @valor_referencial = 0	 
			
	END
	
END

If Exists ( select 1 
              from DDDetCom53 d
              where codcon51 like 'TRACS%' and numcom52 = @NUMFAC )
    Begin
            if @DEPOSI='A'
	    begin
	       select @Peso = pescer13/1000  from ddceradu13 (NOLOCK) where numcer13 = @num_cert 
	    end
	
	    if @DEPOSI='S'
	    begin
	       select @Peso = pestot74/1000  from ddcersim74 (NOLOCK) where numcer74 = @num_cert 
	    end
	    
            select @VALREF = VALREF from DDSERVIC52 where concep51 = 'TRACS' and deposi52 = @DEPOSI and servic52 = 'TRACS001'  
				
	    if @peso < 7 
	     SET @valor_referencial =  0.04 * @tot_fac  --Caso 2.-  Si la carga es inferior a 7 T, se multiplica el peso máximo que carga un camión (10 Ton) que depende de los ejes  por el factor S/. 12.92  .  
 	    else
	     SET @valor_referencial = @Peso * @VALREF --Caso 1.-   Cuando la carga supera las aprox. 7  T, se multiplica la cantidad de toneladas por el factor S/. 12.92.  Se multiplica el peso * el factor 
   End

--rdelacuba 11/05/2007: Modificar inner join con dqnavier08 por left join
if @DEPOSI='A'
begin
  Select a.numsol10,c.codnav08,desnav08=d.desnav08+'     VIAJE : '+numvia10,
	 ValRef = @valor_referencial
  From ddceradu13 a Inner Join ddcabcom52 b on a.numcer13=b.numcer52
  Inner Join ddsoladu10 c on a.numsol10=c.numsol10
  left Join descarga..dqnavier08 d on c.codnav08=d.codnav08 
  where  b.flgval52='1' and b.numcom52=@NUMFAC
end
if @DEPOSI='S'
begin
  Select numsol10=a.numsol62,c.codnav08,desnav08=d.desnav08+'     VIAJE : '+numvia62,
	 ValRef = @valor_referencial
  From DDCerSim74 a Inner Join ddcabcom52 b on a.numcer74=b.numcer52
  Inner Join ddsolsim62 c on a.numsol62=c.numsol62
  left Join descarga..dqnavier08 d on c.codnav08=d.codnav08 
  where b.flgval52='1' and b.numcom52=@NUMFAC
end

END







GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDENRETIRO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_ORDENRETIRO    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_ORDENRETIRO]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select NUMDOC=substring(b.numret18,1,1)+'-'+substring(b.numret18,2,6),FECEMI=b.fecusu18,USU=b.nomusu18,IMP=b.flgemi18 
From ddduides16 a,DRRetAdu18 b,Ddduidep11 c 
where a.numdui16=b.numdui16 and a.numdui11=c.numdui11 and 
b.flgval18='1' and c.numsol10=@DEPOSI+@NUMSOL
order by b.numret18
ELSE
Select NUMDOC=substring(a.numret75,1,1)+'-'+substring(a.numret75,2,6),FECEMI=a.fecusu75,USU=a.nomusu75,IMP=a.flgemi75
From DDRetSim75 a,DDCerSim74 b 
where a.numcer74=b.numcer74 and 
a.flgval75='1' and b.flgval74='1' and 
b.numsol62=@DEPOSI+@NUMSOL
order by a.numret75
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDENRETIRO_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CG_ADU_ORDENRETIRO_SOLICITUD    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_ORDENRETIRO_SOLICITUD]
@ORDRET CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A'
Select c.numsol10 from ddduides16 a,DRRetAdu18 b,Ddduidep11 c 
where a.numdui16=b.numdui16 and a.numdui11=c.numdui11 and 
b.flgval18='1' and b.numret18=@DEPOSI+@ORDRET
else
Select numsol10=b.numsol62 from DDRetSim75 a,DDCerSim74 b
where a.numcer74=b.numcer74 and a.flgval75='1' and b.flgval74='1' and 
a.numret75=@DEPOSI+@ORDRET
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDENSERVICIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_ORDENSERVICIO    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_ORDENSERVICIO]
@NUMSOL CHAR(6),
@DEP_CER VARCHAR(10)

AS

Declare @NUMCER VARCHAR(9)
Declare @DEPOSI VARCHAR(9)

Select @NUMCER=substring(@DEP_CER,2,9)
Select @DEPOSI=Substring(@DEP_CER,1,1)

if @DEPOSI='A' 
Select distinct NUMDOC=b.numord58,FECEMI=b.fecusu58,USU=b.nomusu58,IMP=b.flgemi58
From DDOrdSer58 b 
where b.flgval58='1' and 
b.numsol58=@DEPOSI+@NUMSOL
Union
Select NUMDOC=b.numord58,FECEMI=b.fecusu58,USU=b.nomusu58,IMP=b.flgemi58 
From ddceradu13 a,DDOrdSer58 b 
where a.numcer13=b.numcer58 and b.flgval58='1' and 
a.numcer13=@NUMCER
order by b.numord58
else
Select distinct NUMDOC=b.numord58,FECEMI=b.fecusu58,USU=b.nomusu58,IMP=b.flgemi58   
From DDOrdSer58 b 
where b.flgval58='1' and 
b.numsol58=@DEPOSI+@NUMSOL
Union
Select NUMDOC=b.numord58,FECEMI=b.fecusu58,USU=b.nomusu58,IMP=b.flgemi58 
From DDCerSim74 a,DDOrdSer58 b 
where a.numcer74=b.numcer58 and b.flgval58='1' and 
a.numcer74=@NUMCER
order by b.numord58
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDENSERVICIO_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CG_ADU_ORDENSERVICIO_SOLICITUD    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_ORDENSERVICIO_SOLICITUD]
@ORDSER CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A'
Select a.numsol10 from ddceradu13 a,DDOrdSer58 b 
where a.numcer13=b.numcer58 and b.flgval58='1' and 
b.numord58=@ORDSER
else
Select numsol10=a.numsol62 from DDcersim74 a,DDOrdSer58 b 
where a.numcer74=b.numcer58 and b.flgval58='1' and 
b.numord58=@ORDSER
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDRET_DUADES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_ORDRET_DUADES    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_ORDRET_DUADES]
@DUADES CHAR(18),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select NUMDOC=substring(numret18,1,1)+'-'+substring(numret18,2,6),FECEMI=fecusu18,USU=nomusu18,IMP=flgemi18 
From DRRetAdu18
where flgval18='1' and 
numdui16=substring(@DUADES,1,3)+substring(@DUADES,5,2)+substring(@DUADES,8,2)+
substring(@DUADES,11,6)+substring(@DUADES,18,1)
order by numret18
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_RECEPCION]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_RECEPCION    Script Date: 08-09-2002 08:44:03 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_RECEPCION]	
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

Select NUMDOC=substring(numrec69,1,1)+'-'+substring(numrec69,2,6),FECEMI=fecusu69,USU=nomusu69,IMP=flgemi69 
From DDRecMer69
where flgval69='1' and numsol62=@DEPOSI+@NUMSOL
order by numrec69
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_SOLDEP_SOLDEP]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CG_ADU_SOLDEP_SOLDEP    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_SOLDEP_SOLDEP]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select numsol10 from DDSOLADU10
where numsol10=@DEPOSI+@NUMSOL
else
Select numsol10=numsol62 from DDSolSim62
where numsol62=@DEPOSI+@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_SOLICITUD    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_SOLICITUD]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select NUMDOC=substring(numsol10,1,1)+'-'+substring(numsol10,2,6),FECEMI=fecusu10,USU=nomusu10,IMP=flgemi10 
From DDSOLADU10 
where numsol10=@DEPOSI+@NUMSOL and flgval10='1'
order by numsol10
else
Select NUMDOC=substring(numsol62,1,1)+'-'+substring(numsol62,2,6),FECEMI=fecusu62,USU=nomusu62,IMP=flgemi62
From DDSOLSIM62 
where numsol62=@DEPOSI+@NUMSOL and flgval62='1'
order by numsol62
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_TICKETD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_TICKETD    Script Date: 08-09-2002 08:44:08 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_TICKETD]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

Select NUMDOC=numtkt01,FECEMI=fecusu01,USU=nomusu01,IMP=case when flgman01='1'  then '2' else '1' end
from DDTICKET01 
where tipope01='D' and docaut01=@DEPOSI+@NUMSOL
order by numtkt01
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_TICKETD_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CG_ADU_TICKETD_SOLICITUD]  
@NUMTKT CHAR(8)  
AS  
  
Select  
a.*,numsol10=a.docaut01,NombreC=b.nombre,NombreA=c.nombre,d.desemb06,e.numctr65,e.tamctr65  
From   
DDTICKET01 a 
inner join AAclientesAA b on (a.tipcli02=b.claseabc and a.codcli02=b.contribuy)
inner join DQEMBALA06   d on (a.codemb06=d.codemb06)
left  join AAclientesAA c on (a.codage19=c.cliente )
left  join DDCTRDEP65   e on (a.numtkt01=e.numtkt01)  
Where  
a.numtkt01=@NUMTKT and a.tipope01='D'   
order by a.numtkt01
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_TICKETR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_TICKETR    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_TICKETR]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select NUMDOC=d.numtkt01,FECEMI=d.fecusu01,USU=d.nomusu01,IMP=case when flgman01='1'  then '2' else '1' end
From ddduides16 a,DRRetAdu18 b,Ddduidep11 c,DDTicket01 d 
Where a.numdui16=b.numdui16 and a.numdui11=c.numdui11 and 
d.docaut01=b.numret18 and b.flgval18='1' and 
c.numsol10=@DEPOSI+@NUMSOL
order by d.numtkt01
else
Select NUMDOC=b.numtkt01,FECEMI=b.fecusu01,USU=b.nomusu01,IMP=case when flgman01='1'  then '2' else '1' end
From DDRetSim75 a,DDTicket01 b,DDCersim74 c
Where b.docaut01=a.numret75 and a.numcer74=c.numcer74 and 
a.flgval75='1' and c.flgval74='1' and 
c.numsol62=@DEPOSI+@NUMSOL
order by b.numtkt01
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_TICKETR_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CG_ADU_TICKETR_SOLICITUD    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_TICKETR_SOLICITUD]
@NUMTKT CHAR(8),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A'
Select c.numsol10 
From ddduides16 a,DRRetAdu18 b,Ddduidep11 c,DDTicket01 d 
Where a.numdui16=b.numdui16 and a.numdui11=c.numdui11 and 
d.docaut01=b.numret18 and b.flgval18='1' and d.tipope01='R' and 
d.numtkt01=@NUMTKT
else
Select numsol10=c.numsol62
From DDRetSim75 a,DDTicket01 b,DDCerSim74 c 
Where b.docaut01=a.numret75 and a.numcer74=c.numcer74 and b.tipope01='R' and 
a.flgval75='1' and c.flgval74='1' and 
b.numtkt01=@NUMTKT
GO
/****** Object:  StoredProcedure [dbo].[CONSULTA_DE_TICKET_BUSCAR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[CONSULTA_DE_TICKET_BUSCAR]
@ORDEN char(2) -- T ticket, P placa, F fecha


AS
declare 
@Select_1 varchar(255),@Select_2 varchar(255),@Select_3 varchar(255),@Select_4 varchar(255),@Select_5 varchar(255),@Select_6 varchar(255),@Select_7 varchar(255),
@From_6 varchar(255),
@Where_7 varchar(255),
@Order_8 varchar(255)

Select @Select_1="Select a.*,tipdep01=Case When (left(a.docaut01,1)='A') Then 'ADU' ELSE 'SIM' End,"
Select @Select_2="DesOpe01=Case When (a.tipope01='D') Then 'DEP' ELSE 'RET' End,DesMer01=Case When (a.tipmer01='M') Then "
Select @Select_3="'SOBRE CAMION' When (a.tipmer01='C') Then 'EN CONTENEDOR' When (a.tipmer01='V') Then 'VEHICULO' End,"
Select @Select_4="DocAut01=SubString(a.docaut01,2,7),fecing01=Convert(varchar(20),"
Select @Select_5="a.fecing01,103)+' '+substring(Convert(varchar(20),a.fecing01,100),13,7),"
Select @Select_6="fecsal01=Convert(varchar(20),a.fecsal01,103)+' '+substring(Convert(varchar(20),a.fecsal01,100),13,7)," 
Select @Select_7="pesnet01=Case When (a.tipope01='D') then (a.pesnet01 - a.tarcon01) Else (a.pesnet01) End,b.nombre "
Select @From_6="From DDTicket01 a,AAClientesAA b "
Select @Where_7="Where a.tipcli02=b.claseabc and a.CodCli02=b.contribuy and a.tipest01='S' "

if @ORDEN='OT' Select @Order_8="Order by a.numtkt01 "
if @ORDEN='OP' Select @Order_8="Order by a.numpla01 "
if @ORDEN='OF' Select @Order_8="Order by a.fecing01 "

EXEC (@Select_1+@Select_2+@Select_3+@Select_4+@Select_5+@Select_6+@Select_7+@From_6+@Where_7+@Order_8)
GO
/****** Object:  StoredProcedure [dbo].[CORRELATIVO_DE_ENTREGA_DE_MERCADERIAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[CORRELATIVO_DE_ENTREGA_DE_MERCADERIAS] 
@DEP char(1),
@FECINI char(8),
@FECFIN char(8)
AS

if @DEP='A'
Select 
a.nument79,a.fecent79,a.numcer13,a.numdui11,a.numret75,b.tipcli02,b.codcli02,c.nombre,
a.bultot79,a.codemb06,a.flgval79,a.flgemi79,
TITULO='CORRELATIVO DE ENTREGAS DE MERCADERIA EMITIDAS - DEPOSITO ADUANERO',
SUBTITULO='DESDE EL : ' + right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4) + 
                     ' HASTA EL  : ' + right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
REPORTE='CorrelativoEM.rpt', FECHA=getdate()
From ddentmer79 a 
Inner Join ddceradu13 b on a.numcer13=b.numcer13
Inner Join aaclientesaa c on b.tipcli02=c.claseabc and b.codcli02=c.contribuy
Where 
a.flgval79='1' and left(a.nument79,1)='A' and b.flgval13='1' and
convert(char(8),a.fecent79,112) between @FECINI and @FECFIN
Order by a.nument79

if @DEP='S'
Select 
a.nument79,a.fecent79,a.numcer13,a.numdui11,a.numret75,b.tipcli02,b.codcli02,c.nombre,
a.bultot79,a.codemb06,a.flgval79,a.flgemi79,
TITULO='CORRELATIVO DE ENTREGAS DE MERCADERIA EMITIDAS - DEPOSITO SIMPLE',
SUBTITULO='DESDE EL : ' + right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4) + 
                     ' HASTA EL  : ' + right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
REPORTE='CorrelativoEM.rpt', FECHA=getdate()
From ddentmer79 a 
Inner Join ddcersim74 b on a.numcer13=b.numcer74
Inner Join aaclientesaa c on b.tipcli02=c.claseabc and b.codcli02=c.contribuy
Where 
a.flgval79='1' and left(a.nument79,1)='S' and b.flgval74='1' and
convert(char(8),a.fecent79,112) between @FECINI and @FECFIN
Order by a.nument79
GO
/****** Object:  StoredProcedure [dbo].[CORRELATIVO_DE_ORDENES_DE_RETIRO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[CORRELATIVO_DE_ORDENES_DE_RETIRO] 
@DEP char(1),
@FECINI char(8),
@FECFIN char(8)
AS

if @DEP='A'
SELECT DEP='A',ORDEN=substring(a.numret18,2,6),EMISION=a.fecusu18,CERTIFICADO=substring(g.numcer13,2,6)+'-'+substring(g.numcer13,8,2),
               DUA_DEPOSITO=substring(b.numdui11,1,3)+'-'+substring(b.numdui11,4,2)+'-'+substring(b.numdui11,6,2)+'-'+substring(b.numdui11,8,6),
               DUA_DESPACHO=substring(a.numdui16,1,3)+'-'+substring(a.numdui16,4,2)+'-'+substring(a.numdui16,6,2)+'-'+substring(a.numdui16,8,6)+'-'+substring(a.numdui16,14,1),
               CLIENTE=substring(i.nombre,1,30),BULTOS=convert(decimal(15,2),b.numbul16),CIF=convert(decimal(15,2),b.valcif16),
	  SALDO_BUL=(b.numbul16-b.bulent16),SALDO_CIF=(b.valcif16-b.cifent16),EMITIDA=a.flgemi18,
	  TITULO='CORRELATIVO DE ORDENES DE RETIRO EMITIDAS - DEPOSITO ADUANERO',
	    SUBTITULO='DESDE EL : ' + right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4) + 
              	             ' HASTA EL  : ' + right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
	    REPORTE='CorrelativoOR.rpt', FECHA=getdate(),USUARIO=a.nomusu18
FROM DRRetAdu18 a 
    inner join DDDuiDes16 b on a.numdui16 = b.numdui16	
    inner join DDDuiDep11 g on b.numdui11 = g.numdui11 
    inner join DDSolAdu10 h on g.numsol10 = h.numsol10
    inner join AAClientesAA i on h.codcli02 = i.contribuy
Where convert(char(8),a.fecusu18,112) between @FECINI and @FECFIN and a.flgval18='1'
Order by a.numret18

if @DEP='S'
SELECT DEP='S',ORDEN=substring(a.numret75,2,6),EMISION=a.fecusu75,CERTIFICADO=substring(a.numcer74,2,6),
                 DUA_DEPOSITO='',DUA_DESPACHO='',
                 CLIENTE=substring(c.nombre,1,30),BULTOS=convert(decimal(15,2),a.bultot75),CIF=convert(decimal(15,2),a.pretot75),
	    SALDO_BUL=convert(int,(a.bultot75-bulret75)),SALDO_CIF=(a.pretot75-a.preret75),EMITIDA=a.flgemi75,
	    TITULO='CORRELATIVO DE ORDENES DE RETIRO EMITIDAS - DEPOSITO SIMPLE',
	    SUBTITULO='DESDE EL : ' + right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4) + 
	                          ' HASTA EL  : ' + right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
	    REPORTE='CorrelativoOR.rpt', FECHA=getdate(),USUARIO=a.nomusu75
From DDRETSIM75 a
    Inner Join DDCERSIM74 b ON b.numcer74=a.numcer74
    Inner Join AACLIENTESAA c ON c.claseabc=b.tipcli02 and c.contribuy=b.codcli02
Where convert(char(8),fecusu75,112) between @FECINI and @FECFIN and a.flgval75='1'
Order by a.numret75



GO
/****** Object:  StoredProcedure [dbo].[CORRELATIVO_DE_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CORRELATIVO_DE_SOLICITUD]
@DEP char(1),
@FECINI char(8),
@FECFIN char(8)
AS

if @DEP='A'
Select 
    SOLICITUD=a.numsol10,EMISION=a.fecusu10,DUA_DEPOSITO=a.numdui10,CLIENTE=b.nombre,BULTOS=a.numbul10,RECEPCION=c.numrec69,
    CERTIFICADO=d.numcer13,EMITIDA=a.flgemi10,
    TITULO='CORRELATIVO DE SOLICITUDES - DEPOSITO ADUANERO',
    SUBTITULO='DESDE EL : ' + right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4) + 
                          ' HASTA EL  : ' + right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
    REPORTE='CorrelativoSOL.rpt', FECHA=getdate(),USUARIO=a.nomusu10 , de20=a.de20 , de40=a.de40 , suelta= a.cgsuelta10 ,
    (select fecReg   from DDSerDep12 , DDDuiDep11 
      where DDDuiDep11.numdui11 = DDSerDep12.numdui11
        AND DDDuiDep11.numsol10 = DDSerDep12.numsol10
        AND DDDuiDep11.totser11 = DDSerDep12.numser12
        AND DDDuiDep11.numsol10 = a.numsol10) as  FECREG,
    t.numctr65 as Contenedor, --13072007 / rtello / Detalle contenedor
    t.tamctr65 as tamactr, a.faccom10 as FactComer, pestot10 as PesoTot --13072007 / rtello /Factura Comercial
From 
    ddsoladu10 a
    Inner Join AAclientesAA b ON b.contribuy=a.codcli02
    left Join ddrecmer69 c ON c.numsol62=a.numsol10 and c.flgval69='1'
    left Join ddceradu13 d ON d.numsol10=a.numsol10 and d.flgval13='1'
    left Join DDCtrDep65 t on a.numsol10 = t.numsol62

Where 
    convert(char(8),a.fecusu10,112) between @FECINI and @FECFIN and 
    a.flgval10='1'  
Order by a.numsol10

if @DEP='S'
Select 
    SOLICITUD=a.numsol62,EMISION=a.fecusu62,DUA_DEPOSITO=a.numdui11,CLIENTE=b.nombre,BULTOS=a.bultot62,RECEPCION=c.numrec69,
    CERTIFICADO=d.numcer74,EMITIDA=a.flgemi62,
    TITULO='CORRELATIVO DE SOLICITUDES - DEPOSITO SIMPLE',
    SUBTITULO='DESDE EL : ' + right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4) + 
                          ' HASTA EL  : ' + right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
    REPORTE='CorrelativoSOL.rpt', FECHA=getdate(),USUARIO=a.nomusu62 , de20=a.de20 , de40=a.de40 , suelta= a.cgsuelta10 , null as FECREG ,
    t.numctr65 as Contenedor, --13072007 / rtello / Detalle contenedor
    t.tamctr65 as tamactr, a.factcomer as FactComer, pestot62 as PesoTot --13072007 / rtello /Factura Comercial
From 
    ddsolsim62 a
    Inner Join AAclientesAA b ON b.contribuy=a.codcli02
    left Join ddrecmer69 c ON c.numsol62=a.numsol62 and c.flgval69='1'
    left Join ddcersim74 d ON d.numsol62=a.numsol62 and d.flgval74='1'
    left Join DDCtrDep65 t on a.numsol62 = t.numsol62 
Where 
    convert(char(8),a.fecusu62,112) between @FECINI and @FECFIN and 
    a.flgval62='1'  
Order by a.numsol62






GO
/****** Object:  StoredProcedure [dbo].[DAT_ADI_CTR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE  [dbo].[DAT_ADI_CTR] 
@NUMTKT varchar(8)
AS
Select distinct a.nrotkt28,a.codcon63,b.nrotar63,b.codtam09 
From 
terminal..drblcont15 a inner join terminal..ddcontar63 b on 
a.navvia11=b.navvia11 and a.codcon63=b.codcon63
Where a.nrotkt28 =@NUMTKT
GO
/****** Object:  StoredProcedure [dbo].[DAT_GEN_CTR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[DAT_GEN_CTR]
@NUMTKT varchar(8)
AS

Select 
nropla18,pesbrt18,pestar18,pesnet18,fecsal18,codemb06,bulret18 
From terminal..ddticket18 
Where nrotkt18=@NUMTKT
GO
/****** Object:  StoredProcedure [dbo].[DH_EnviaAlertas_Attach]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DH_EnviaAlertas_Attach]           
@msg varchar (500),              
@asunto varchar(100),          
@archivo varchar(150),          
@TO varchar(255),          
@cc varchar(255)          
as              
              
exec master.dbo.xp_smtp_sendmail                    
     @FROM = 'aneptunia@neptunia.com.pe',                
     @FROM_NAME = 'Neptunia Servicio de Alertas',               
     @TO    = @TO,                
     @CC    = @cc,           
     --@BCC   = 'aneptunia@neptunia.com.pe',                
     @subject  = @asunto,                
     @message  =  @msg,                
     @type   = 'text/html',            
     @attachment  = @archivo,            
     @server    = 'correo.neptunia.com.pe'           
GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp003]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.dt_verstamp003    Script Date: 08-09-2002 08:44:04 PM ******/
/*
**	This proc exists only to version distribution of data package storage format
*/
ALTER PROCEDURE [dbo].[dt_verstamp003]
as
	return (0)

GO
/****** Object:  StoredProcedure [dbo].[FAC_ObtenerDatosFacturaElectronica]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[FAC_ObtenerDatosFacturaElectronica] -- '0150042858','S' 
(  
 @NUMFAC CHAR(10),
 @DEPOSI CHAR(1)
)  
AS   
BEGIN  
 Declare @GlosaAutorizacionSunat varchar(max)
 
 SELECT @GlosaAutorizacionSunat = descripcion FROM [dbo].[Glosas]
 WHERE ident_Glosa = 1
 
 SELECT
 @GlosaAutorizacionSunat AS GlosaAutorizacionSunat
 ,PrefixFE + Left(numcom52,3) + '-' + Right(numcom52,7) as PreSerNum
 ,codcom50 
 ,numcom52	
 ,PrefixFE	
 ,PDF417	
 ,ValorResumen	
 ,OperaGratuita	
 ,OperaExonerada	
 ,OperaInafecta	
 ,OperaGravada	
 ,TotalDscto	
 ,TotalIgv	
 ,ImporteTotal AS ImporteTotal
 from FAC_FacturaElectronica_SAS  
 WHERE numcom52 = @NUMFAC  
END

GO
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_INGRESOS_ADU_AM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.HORAS_EXTRAS_INGRESOS_ADU_AM    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[HORAS_EXTRAS_INGRESOS_ADU_AM]
@FECINI VARCHAR(14),
@FECFIN VARCHAR(14),
@NUMCER VARCHAR(9)
AS

Select 
b.numtkt01, b.fecsal01
From 
DDCerAdu13 a, DDTicket01 b
Where 
a.numsol10=b.docaut01 and b.tipope01='D' and b.horext01='1' and 

b.fecsal01>@FECINI and b.fecsal01<@FECFIN and 
a.numcer13=@NUMCER and b.codcom50 is null 
Order by b.fecsal01 DESC
--convert(varchar(5),b.fecsal01,114)<'08:30' and
GO
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_INGRESOS_ADU_PM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.HORAS_EXTRAS_INGRESOS_ADU_PM    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[HORAS_EXTRAS_INGRESOS_ADU_PM]
@FECINI VARCHAR(14),
@FECFIN VARCHAR(14),
@NUMCER VARCHAR(9)
AS

Select 
b.numtkt01, b.fecsal01
From 
DDCerAdu13 a, DDTicket01 b
Where 
a.numsol10=b.docaut01 and b.tipope01='D' and b.horext01='1' and 

b.fecsal01>@FECINI and b.fecsal01<@FECFIN and 
convert(varchar(5),b.fecsal01,114)>'17:00' and 
a.numcer13=@NUMCER and b.codcom50 is null 
Order by b.fecsal01 DESC
GO
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_INGRESOS_SIM_AM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.HORAS_EXTRAS_INGRESOS_SIM_AM    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[HORAS_EXTRAS_INGRESOS_SIM_AM]
@FECINI VARCHAR(14),
@FECFIN VARCHAR(14),
@NUMCER VARCHAR(7)
AS

Select b.numtkt01, b.fecsal01
From DDCerSim74 a, DDTicket01 b
Where a.numsol62=b.docaut01 and b.tipope01='D' and b.horext01='1' and 

b.fecsal01>@FECINI and b.fecsal01<@FECFIN and 
a.numcer74=@NUMCER and b.codcom50 is null 
Order by b.fecsal01 DESC
--convert(varchar(5),b.fecsal01,114)<'08:30' and
GO
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_INGRESOS_SIM_PM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.HORAS_EXTRAS_INGRESOS_SIM_PM    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[HORAS_EXTRAS_INGRESOS_SIM_PM]
@FECINI VARCHAR(14),
@FECFIN VARCHAR(14),
@NUMCER VARCHAR(7)
AS

Select b.numtkt01, b.fecsal01
From DDCerSim74 a, DDTicket01 b
Where a.numsol62=b.docaut01 and b.tipope01='D' and b.horext01='1' and 

b.fecsal01>@FECINI and b.fecsal01<@FECFIN and 
convert(varchar(5),b.fecsal01,114)>'17:00' and 
a.numcer74=@NUMCER and b.codcom50 is null 
Order by b.fecsal01 DESC
GO
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_SALIDAS_AM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.HORAS_EXTRAS_SALIDAS_AM    Script Date: 08-09-2002 08:44:08 PM ******/
ALTER PROCEDURE [dbo].[HORAS_EXTRAS_SALIDAS_AM]
@FECINI VARCHAR(14),
@FECFIN VARCHAR(14),
@NUMCER VARCHAR(9)
AS

Select 
b.numtkt01,b.fecsal01 
From 
DDEntMer79 a,DDticket01 b
Where 
a.nument79=b.numgui01 and b.tipope01='R' and b.horext01='1' and 
b.fecsal01>@FECINI and b.fecsal01<@FECFIN and 
a.numcer13=@NUMCER and b.codcom50 is null
Order by b.fecsal01 DESC
--convert(varchar(5),b.fecsal01,114)<'08:30' and
GO
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_SALIDAS_PM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.HORAS_EXTRAS_SALIDAS_PM    Script Date: 08-09-2002 08:44:08 PM ******/
ALTER PROCEDURE [dbo].[HORAS_EXTRAS_SALIDAS_PM]
@FECINI VARCHAR(14),
@FECFIN VARCHAR(14),
@NUMCER VARCHAR(9)
AS

Select nomdia=DAtename(dw,b.fecsal01),
b.numtkt01,b.fecsal01 
From 
DDEntMer79 a,DDticket01 b
Where a.numcer13=@NUMCER and
a.nument79=b.numgui01 and b.tipope01='R' and b.horext01='1' and 
b.fecsal01>@FECINI and b.fecsal01<@FECFIN and 
convert(varchar(5),b.fecsal01,114)>'17:00' and
b.codcom50 is null
Order by b.fecsal01 DESC
GO
/****** Object:  StoredProcedure [dbo].[insertar_Detalleticket]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertar_Detalleticket]  
@numtkt01 varchar(8),  
@numrec69 varchar(7),  
@NumSer70 varchar(20),  
@Bultos integer,  
@PesoUnit decimal (12,2),  
@PesoTotal decimal(12,2),  
@PesoTata decimal(12,2),
@PesoNeto decimal (12,2),
@UsuarioReg varchar(30)  
as  
insert into DDTicket02  
(  
numtkt01,  
numrec69,  
NumSer70,  
Bultos,  
PesoUnit,  
PesoTotal,  
fechaReg,  
PesoTata,
PesoNeto,
UsuarioReg  
)  
values   
(  
@numtkt01,  
@numrec69,  
@NumSer70,  
@Bultos,  
@PesoUnit,  
@PesoTotal,  
getdate(),  
@PesoTata,
@PesoNeto,
@UsuarioReg  
)  
return 0  



GO
/****** Object:  StoredProcedure [dbo].[INSERTAR_USER_SAAWEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[INSERTAR_USER_SAAWEB]
@cuenta varchar(50),
@password varchar(50),
@razonsocial varchar(50),
@emailAduana varchar(50),
@emailContactos varchar(50),
@nombreAduana varchar(50)
AS

INSERT INTO [Depositos].[dbo].[DINFOSUSERSAAWEB]
           ([cuenta]
           ,[password]
           ,[razonsocial]
           ,[emailAduana]
           ,[emailContactos]
           ,[nombreAduana])
     VALUES
           (@cuenta , @password , @razonsocial , @emailAduana , @emailContactos , @nombreAduana)



GO
/****** Object:  StoredProcedure [dbo].[INTERFACE_ADU_CABEC]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[INTERFACE_ADU_CABEC]
@TIPDOC CHAR(2),
@NUMDOC CHAR(10),
@TIPDEP char(1)
AS

Declare @FACESP char(1)
Declare @SUBTOT decimal(15,2)
Declare @IGVTOT decimal(15,2)
DECLARE @PREFIXFE   VARCHAR(4)

SET @PREFIXFE = ''
SELECT @PREFIXFE = ISNULL(PrefixFE,'')
  FROM FAC_FacturaElectronica_SAS
  WHERE numcom52 = @NUMDOC
  AND codcom50 = @TIPDOC 
  
Select @SUBTOT=sum(subtot52),@IGVTOT=sum(igvtot52) from ddcabcom52 Where codcom50=@TIPDOC and numcom52=@NUMDOC

Select @FACESP=facesp52 from ddcabcom52 Where codcom50=@TIPDOC and numcom52=@NUMDOC
if @FACESP='N'
Begin
	IF @TIPDEP='A'
	BEGIN
	    Select a.*,ruc_age_adu=d.contribuy,nom_age_adu=d.nombre,nom_cliente=e.nombre
	    ,@PREFIXFE AS PREFIJOFE
	    From ddcabcom52 a,ddceradu13 b,ddsoladu10 c,aaclientesaa d,aaclientesaa e 
	    Where codcom50=@TIPDOC and numcom52=@NUMDOC and a.numcer52=b.numcer13 and 
	    b.numsol10=c.numsol10 and c.codage19=d.Cliente and 
	    a.tipcli02=e.claseabc and a.codcli02=e.contribuy
	END
	
	IF @TIPDEP='S'
	BEGIN
	    Select a.*,nom_cliente=e.nombre,
	    ruc_age_adu=case when b.codage19='' then 
	        '00000000099' 
	    else 	
	        (Select contribuy from aaclientesaa where cliente=b.codage19 and cliente<>'')
	    end,
	    nom_age_adu=case when b.codage19='' then 
	        '' 
	    else 	
	        (Select nombre from aaclientesaa where cliente=b.codage19 and cliente<>'')
	    end
	    ,@PREFIXFE AS PREFIJOFE
	    From ddcabcom52 a, ddcersim74 b,aaclientesaa e 
	    Where a.codcom50=@TIPDOC and a.numcom52=@NUMDOC and a.numcer52=b.numcer74 and 
	    a.tipcli02=e.claseabc and a.codcli02=e.contribuy
	END 
	
	IF @TIPDEP=''
	BEGIN
	    Select a.*,ruc_age_adu='00000000099',nom_age_adu='',nom_cliente=e.nombre
	    ,@PREFIXFE AS PREFIJOFE
	    From ddcabcom52 a,aaclientesaa e 
	    Where codcom50=@TIPDOC and numcom52=@NUMDOC and  
	    a.tipcli02=e.claseabc and a.codcli02=e.contribuy
	END
End

if @FACESP='S'
Begin
	IF @TIPDEP='A'
	BEGIN
	    Select distinct numcer52,numcom52,feccom52,docdes52,nomdes52,SUBTOT52=@SUBTOT,IGVTOT52=@IGVTOT,codcom50,codcli02,ruc_age_adu='00000000099',nom_age_adu='',nom_cliente=nomdes52,Detrac52,TIPMON52
	    ,@PREFIXFE AS PREFIJOFE
	    From ddcabcom52 
	    Where codcom50=@TIPDOC and numcom52=@NUMDOC 
	END
	
	IF @TIPDEP='S'
	BEGIN
	    Select distinct numcer52,numcom52,feccom52,docdes52,nomdes52,SUBTOT52=@SUBTOT,IGVTOT52=@IGVTOT,codcom50,codcli02,ruc_age_adu='00000000099',nom_age_adu='',nom_cliente=nomdes52,Detrac52,TIPMON52
	    ,@PREFIXFE AS PREFIJOFE
	    From ddcabcom52 
	    Where codcom50=@TIPDOC and numcom52=@NUMDOC 
	END 
End

GO
/****** Object:  StoredProcedure [dbo].[INTERFACE_ADU_DETAL]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[INTERFACE_ADU_DETAL]
@TIPDOC CHAR(2),
@NUMDOC CHAR(10),
@TIPDEP CHAR(1),
@CODMON CHAR(1)
AS

DECLARE @indicador tinyint

IF @TIPDEP='A'
Begin 
	Select a.*,codsbd03 = case when @CODMON = 'D' then isnull(b.codsbd03,0) else isnull(b.codsbd03s,0) end,b.flguni51,b.descon51,b.cencos51,b.sucimp51
	From DDDetCom53 a, DQConCom51 b 
	Where codcom50=@TIPDOC and numcom52=@NUMDOC and substring(a.codcon51,1,5)=b.codcon51
End 

IF @TIPDEP='S'
Begin 
        --rdelacuba 21/08/2007: Identificar si la solicitud debe facturarse como simple normal (0) o CD (1)
	SELECT @indicador = isnull(cdis62,0) 
	from DDcabCom52 d (nolock)INNER JOIN DDCerSim74 c (NOLOCK) ON d.numcer52 = c.numcer74
				  INNER JOIN DDSolSim62 s (NOLOCK) ON c.numsol62 = s.numsol62
	WHERE codcom50=@TIPDOC and numcom52=@NUMDOC

	IF @indicador = 1
	BEGIN
		Select a.*,codsbd03 = case when @CODMON = 'D' then b.codsbd03 else b.codsbd03s end,b.flguni51,b.descon51,cencos51=b.cencosCD51,sucimp51=b.sucimpCD51 
		From DDDetCom53 a, DQConCom51 b 
		Where codcom50=@TIPDOC and numcom52=@NUMDOC and substring(a.codcon51,1,5)=b.codcon51
	END
	ELSE
	BEGIN
		Select a.*,codsbd03 = case when @CODMON = 'D' then b.codsbd03 else b.codsbd03s end,b.flguni51,b.descon51,cencos51=b.cencosS51,sucimp51=b.sucimpS51 
		From DDDetCom53 a, DQConCom51 b 
		Where codcom50=@TIPDOC and numcom52=@NUMDOC and substring(a.codcon51,1,5)=b.codcon51
	END
End



GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL0]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[REPORTE_ABANDONO_LEGAL0] 
@FECINI char(8),
@FECFIN char(8),
@CODDEP char(4)
AS

DECLARE @ldBulEnt decimal(15,3),@ldCifEnt decimal(15,3),@ldPesEnt decimal(15,3)
DECLARE @ldBulDes decimal(15,3), @ldCifDes decimal(15,3), @ldPesDes decimal(15,3)
DECLARE @ldBulSld decimal(15,3)

--Print 'Borrando Tabla Temporal del Abandono Legal'
Delete DTCaeAba93

--Print 'Borrando Tabla Temporal de Salidas Aduaneras'
Delete DTSalAdu35

--Print 'Inserto todas las salidas hasta la fecha final'
Insert DTSalAdu35(numdui35,bulent35,cifent35,hostid35) EXEC REPORTE_ABANDONO_LEGAL1 @FECFIN

--Print 'Calculo la suma de las Entregas de Mercadería por DUA de Despacho'
DECLARE @TEMP_1 table (NUMDUI16 varchar(14) PRIMARY KEY CLUSTERED WITH  FILLFACTOR = 85,PESBRU79 decimal(15,3),BULTOT79 decimal(15,3),PRETOT79 decimal(15,3))
Insert into @TEMP_1
Select a.numdui16,SUM(a.pesbru79), SUM(a.bultot79),SUM(a.pretot79+a.cuadep79)
From DDEntMer79 a
Inner Join DDTicket01 b on b.numgui01=a.nument79
Where b.tipope01='R' and a.flgval79='1' and left(a.nument79,1)='A' and convert(char(8),b.fecsal01,112)<=@FECFIN
Group by a.numdui16

--Print 'Selecciono todas las DUAS de despacho '
DECLARE @TEMP_2 table (NUMDUI11 varchar(13),NUMDUI16 varchar(14) ,NUMBUL16 decimal(15,3),VALCIF16 decimal(15,3),PESBRU16 decimal(15,3))
Insert into @TEMP_2
Select numdui11,numdui16,numbul16,valcif16,pesbru16 From DDDUiDes16 
Where CONVERT(CHAR(8),fecusu16,112)<=@FECFIN
Order by numdui11,numdui16

--Print 'Abriendo el Cursor 1'
DECLARE @NUMDUI11 varchar(13),@FECDUI11 smalldatetime,@NUMMAN10 varchar(15), @CODADU02 varchar(10),@CONEMB10 varchar(30),@PRIING69 smalldatetime,@TIPCAM11 decimal(10,3)
DECLARE @VALCIF11 decimal(15,3),@ABALEG11 smalldatetime,@DESMER10 varchar(100), @NUMBUL11 decimal(10,3),@CODEMB06 varchar(3),@PESNET69 int, @CONSIGNATARIO varchar(100)
Print 'Selecciono todas las DUAs de Depósito que tengan fecha de abandono legal entre la fecha inicial y fecha final'
DECLARE CURSOR_1 CURSOR
KEYSET
FOR Select * from fn_r_abandono_legal_1 (@FECINI,@FECFIN) Order By numdui11

OPEN CURSOR_1
FETCH NEXT FROM CURSOR_1 INTO 
@NUMDUI11,@FECDUI11,@NUMMAN10,@CODADU02,@CONEMB10,@PRIING69,@TIPCAM11,@VALCIF11,@ABALEG11,@DESMER10,@NUMBUL11,@CODEMB06,@PESNET69,@CONSIGNATARIO
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		Select @ldBulDes = 0, @ldCifDes = 0, @ldPesDes = 0

--		Print 'Abriendo el Cursor 2 para la DUA de Deposito :' + @NUMDUI11
		DECLARE @NUMDUI16 varchar(14),@NUMBUL16 int,@VALCIF16 decimal(15,3), @PESBRU16 int
		DECLARE CURSOR_2 CURSOR
		KEYSET FOR Select numdui16,numbul16,valcif16,pesbru16 from @TEMP_2 where numdui11=@NUMDUI11

		OPEN CURSOR_2
		FETCH NEXT FROM CURSOR_2 INTO @NUMDUI16,@NUMBUL16,@VALCIF16,@PESBRU16
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
--				Print 'DUAs de Despacho :' + @NUMDUI16
				Select @ldBulEnt = 0, @ldCifEnt = 0, @ldPesEnt = 0
				Select @ldPesEnt=PESBRU79,@ldBulEnt=BULTOT79,@ldCifEnt=PRETOT79 from @TEMP_1 Where numdui16=@NUMDUI16
		                    	IF @NUMBUL16 - @ldBulEnt > 0
				BEGIN
		                        		Select @ldBulDes = @ldBulDes + @NUMBUL16
		                        		Select @ldCifDes = @ldCifDes + @VALCIF16
		                        		Select @ldPesDes = @ldPesDes + @PESBRU16
				END
		                    	ELSE
				BEGIN
		                        		Select @ldBulDes = @ldBulDes + @ldBulEnt
		                        		Select @ldCifDes = @ldCifDes + @ldCifEnt
		                        		Select @ldPesDes = @ldPesDes + @ldPesEnt
				END
			END
			FETCH NEXT FROM CURSOR_2 INTO @NUMDUI16,@NUMBUL16,@VALCIF16,@PESBRU16
		END
--		Print 'Cerrando el Cursor 2'
		CLOSE CURSOR_2
		DEALLOCATE CURSOR_2
		
		Select @ldBulSld = @NUMBUL11 - @ldBulDes

		IF @ldBulSld>0
		BEGIN
--                		Print 'Dua Grabada :' + @NUMDUI11
			Insert DTCaeAba93 (adudep93,anodep93,numdep93,
			fecdep93,coddep93,anoman93,numman93,codter93,codpue93,conemb93,fecing93,fecaba93,desmer93,buling93,tipbul93,pesing93,cifdol93,cifsol93,numdui93,consignatario) VALUES (
			Left(@NUMDUI11, 3),substring(@NUMDUI11, 4, 2),Right(@NUMDUI11,6),convert(char(8),@FECDUI11,112),@CODDEP,substring(@NUMMAN10, 6, 2),
			Right(@NUMMAN10, 5),case when Left(@NUMMAN10, 3) = '118' then '' else Right(@NUMMAN10, 4) end,@CODADU02,
                        		@CONEMB10,convert(char(8),@PRIING69,112),convert(char(8),@ABALEG11,112),@DESMER10,@ldBulSld,@CODEMB06,
                        		@PESNET69-@ldPesDes,@VALCIF11-@ldCifDes,(@VALCIF11-@ldCifDes)*@TIPCAM11,@NUMDUI11,@CONSIGNATARIO)
		END

	END
	FETCH NEXT FROM CURSOR_1 INTO 
	@NUMDUI11,@FECDUI11,@NUMMAN10,@CODADU02,@CONEMB10,@PRIING69,@TIPCAM11,@VALCIF11,@ABALEG11,@DESMER10,@NUMBUL11,@CODEMB06,@PESNET69 ,@CONSIGNATARIO
END
--Print 'Cerrando el Cursor 1'
CLOSE CURSOR_1
DEALLOCATE CURSOR_1
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL0_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[REPORTE_ABANDONO_LEGAL0_NEW] @FECINI CHAR(8)
	,@FECFIN CHAR(8)
	,@CODDEP CHAR(4)
AS
DECLARE @ldBulEnt DECIMAL(15, 3)
	,@ldCifEnt DECIMAL(15, 3)
	,@ldPesEnt DECIMAL(15, 3)
	,@ldBulEntUC DECIMAL(15,3)
DECLARE @ldBulDes DECIMAL(15, 3)
	,@ldCifDes DECIMAL(15, 3)
	,@ldPesDes DECIMAL(15, 3)
	,@ldBulDesUC DECIMAL(15,3)
DECLARE @ldBulSld DECIMAL(15, 3)
	,@ldBulSldUC DECIMAL(15,3)

--Print 'Borrando Tabla Temporal del Abandono Legal'  
DELETE DTCaeAba93

--Print 'Borrando Tabla Temporal de Salidas Aduaneras'  
DELETE DTSalAdu35

--Print 'Inserto todas las salidas hasta la fecha final'  
INSERT DTSalAdu35 (
	numdui35
	,bulent35
	,cifent35
	,hostid35
	)
EXEC REPORTE_ABANDONO_LEGAL1 @FECFIN

--Print 'Calculo la suma de las Entregas de Mercadería por DUA de Despacho'  
DECLARE @TEMP_1 TABLE (
	NUMDUI16 VARCHAR(14) PRIMARY KEY CLUSTERED WITH FILLFACTOR = 85
	,PESBRU79 DECIMAL(15, 3)
	,BULTOT79 DECIMAL(15, 3)
	,PRETOT79 DECIMAL(15, 3)
	,BULTOT12 DECIMAL(15,3)
	)

INSERT INTO @TEMP_1
SELECT a.numdui16
	,SUM(a.pesbru79)
	,SUM(a.bultot79)
	,SUM(a.pretot79 + a.cuadep79)
	,SUM(ISNULL(bultot12,0))
FROM DDEntMer79 a
INNER JOIN DDTicket01 b ON b.numgui01 = a.nument79
WHERE b.tipope01 = 'R'
	AND a.flgval79 = '1'
	AND left(a.nument79, 1) = 'A'
	AND convert(CHAR(8), b.fecsal01, 112) <= @FECFIN
GROUP BY a.numdui16

--Print 'Selecciono todas las DUAS de despacho '  
DECLARE @TEMP_2 TABLE (
	NUMDUI11 VARCHAR(13)
	,NUMDUI16 VARCHAR(14)
	,NUMBUL16 DECIMAL(15, 3)
	,VALCIF16 DECIMAL(15, 3)
	,PESBRU16 DECIMAL(15, 3)
	,NUMBUL12 DECIMAL(15,3)
	)

INSERT INTO @TEMP_2
SELECT a.numdui11
	,a.numdui16
	,a.numbul16
	,a.valcif16
	,a.pesbru16
	,(select SUM(ISNULL(zz.unidad12,0)) from DDSerDes17 zz where zz.numdui16 = a.numdui16)
FROM DDDUiDes16 a
WHERE CONVERT(CHAR(8), a.fecusu16, 112) <= @FECFIN
ORDER BY a.numdui11
	,a.numdui16

--Print 'Abriendo el Cursor 1'  
DECLARE @NUMDUI11 VARCHAR(13)
	,@FECDUI11 SMALLDATETIME
	,@NUMMAN10 VARCHAR(15)
	,@CODADU02 VARCHAR(10)
	,@CONEMB10 VARCHAR(30)
	,@PRIING69 SMALLDATETIME
	,@TIPCAM11 DECIMAL(10, 3)
DECLARE @VALCIF11 DECIMAL(15, 3)
	,@ABALEG11 SMALLDATETIME
	,@DESMER10 VARCHAR(100)
	,@NUMBUL11 DECIMAL(10, 3)
	,@CODEMB06 VARCHAR(3)
	,@PESNET69 INT
	,@CONSIGNATARIO VARCHAR(100)
	,@NUMBUL12UC DECIMAL(15,3)

PRINT 'Selecciono todas las DUAs de Depósito que tengan fecha de abandono legal entre la fecha inicial y fecha final'

DECLARE CURSOR_1 CURSOR KEYSET
FOR
SELECT *
FROM fn_r_abandono_legal_1_NEW(@FECINI, @FECFIN)
ORDER BY numdui11 --@NUMBUL11

OPEN CURSOR_1

FETCH NEXT
FROM CURSOR_1
INTO @NUMDUI11
	,@FECDUI11
	,@NUMMAN10
	,@CODADU02
	,@CONEMB10
	,@PRIING69
	,@TIPCAM11
	,@VALCIF11
	,@ABALEG11
	,@DESMER10
	,@NUMBUL11
	,@CODEMB06
	,@PESNET69
	,@CONSIGNATARIO
	,@NUMBUL12UC

WHILE (@@fetch_status <> - 1)
BEGIN
	IF (@@fetch_status <> - 2)
	BEGIN
		SELECT @ldBulDes = 0
			,@ldCifDes = 0
			,@ldPesDes = 0
			,@ldBulDesUC = 0

		--  Print 'Abriendo el Cursor 2 para la DUA de Deposito :' + @NUMDUI11  
		DECLARE @NUMDUI16 VARCHAR(14)
			,@NUMBUL16 INT
			,@VALCIF16 DECIMAL(15, 3)
			,@PESBRU16 INT
			,@NUMBUL12 DECIMAL(15,3)

		DECLARE CURSOR_2 CURSOR KEYSET
		FOR
		SELECT numdui16
			,numbul16
			,valcif16
			,pesbru16
			,NUMBUL12
		FROM @TEMP_2
		WHERE numdui11 = @NUMDUI11

		OPEN CURSOR_2

		FETCH NEXT
		FROM CURSOR_2
		INTO @NUMDUI16
			,@NUMBUL16
			,@VALCIF16
			,@PESBRU16
			,@NUMBUL12

		WHILE (@@fetch_status <> - 1)
		BEGIN
			IF (@@fetch_status <> - 2)
			BEGIN
				--    Print 'DUAs de Despacho :' + @NUMDUI16  
				SELECT @ldBulEnt = 0
					,@ldCifEnt = 0
					,@ldPesEnt = 0
					,@ldBulEntUC = 0

				SELECT @ldPesEnt = PESBRU79
					,@ldBulEnt = BULTOT79
					,@ldCifEnt = PRETOT79
					,@ldBulEntUC = BULTOT12
				FROM @TEMP_1
				WHERE numdui16 = @NUMDUI16

				IF @NUMBUL16 - @ldBulEnt > 0
				BEGIN
					SELECT @ldBulDes = @ldBulDes + @NUMBUL16

					SELECT @ldCifDes = @ldCifDes + @VALCIF16

					SELECT @ldPesDes = @ldPesDes + @PESBRU16
				END
				ELSE
				BEGIN
					SELECT @ldBulDes = @ldBulDes + @ldBulEnt

					SELECT @ldCifDes = @ldCifDes + @ldCifEnt

					SELECT @ldPesDes = @ldPesDes + @ldPesEnt
				END
				
				--//CARGA UC
				IF @NUMBUL12 - @ldBulEntUC > 0
				BEGIN
					SELECT @ldBulDesUC = @ldBulDesUC + @NUMBUL12
				END
				ELSE
				BEGIN
					SELECT @ldBulDesUC = @ldBulDesUC + @ldBulEntUC
				END
				--//
			END

			FETCH NEXT
			FROM CURSOR_2
			INTO @NUMDUI16
				,@NUMBUL16
				,@VALCIF16
				,@PESBRU16
				,@NUMBUL12
		END

		--  Print 'Cerrando el Cursor 2'  
		CLOSE CURSOR_2

		DEALLOCATE CURSOR_2

		SELECT @ldBulSld = @NUMBUL11 - @ldBulDes
		SELECT @ldBulSldUC = @NUMBUL12UC - @ldBulDesUC

		IF @ldBulSld > 0
		BEGIN
			--                  Print 'Dua Grabada :' + @NUMDUI11  
			INSERT DTCaeAba93_NEW (
				adudep93
				,anodep93
				,numdep93
				,fecdep93
				,coddep93
				,anoman93
				,numman93
				,codter93
				,codpue93
				,conemb93
				,fecing93
				,fecaba93
				,desmer93
				,buling93
				,tipbul93
				,pesing93
				,cifdol93
				,cifsol93
				,numdui93
				,consignatario
				,buling12UC
				)
			VALUES (
				Left(@NUMDUI11, 3)
				,substring(@NUMDUI11, 4, 2)
				,Right(@NUMDUI11, 6)
				,convert(CHAR(8), @FECDUI11, 112)
				,@CODDEP
				,substring(@NUMMAN10, 6, 2)
				,Right(@NUMMAN10, 5)
				,CASE 
					WHEN Left(@NUMMAN10, 3) = '118'
						THEN ''
					ELSE Right(@NUMMAN10, 4)
					END
				,@CODADU02
				,@CONEMB10
				,convert(CHAR(8), @PRIING69, 112)
				,convert(CHAR(8), @ABALEG11, 112)
				,@DESMER10
				,@ldBulSld
				,@CODEMB06
				,@PESNET69 - @ldPesDes
				,@VALCIF11 - @ldCifDes
				,(@VALCIF11 - @ldCifDes) * @TIPCAM11
				,@NUMDUI11
				,@CONSIGNATARIO
				,@ldBulSldUC
				)
		END
	END

	FETCH NEXT
	FROM CURSOR_1
	INTO @NUMDUI11
		,@FECDUI11
		,@NUMMAN10
		,@CODADU02
		,@CONEMB10
		,@PRIING69
		,@TIPCAM11
		,@VALCIF11
		,@ABALEG11
		,@DESMER10
		,@NUMBUL11
		,@CODEMB06
		,@PESNET69
		,@CONSIGNATARIO
		,@NUMBUL12UC
END --Print 'Cerrando el Cursor 1'  

CLOSE CURSOR_1

DEALLOCATE CURSOR_1

GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_ABANDONO_LEGAL1]
@FECFIN CHAR(8)
AS


Select 
a.numdui11,bultot79=SUM(a.bultot79+a.cuadep79),0,'' 
From DDEntMer79 a
Inner Join DDTicket01 b on a.nument79=b.numgui01
Where 
a.flgval79='1' and b.tipope01='R' and SUBSTRING(a.nument79,1,1)='A' and convert(char(8),b.fecsal01,112)<=@FECFIN
group by a.numdui11
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[REPORTE_ABANDONO_LEGAL2]
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS

Select 
a.numdui11,a.fecdui11,b.numman10,d.codadu02,b.conemb10,c.priing69,a.tipcam11,a.valcif11,
a.abaleg11,b.desmer10,a.numbul11,a.codemb06,c.pesnet69
From DDDUiDep11 a
Inner Join DDSolAdu10 b on b.numsol10=a.numsol10 
Inner Join DDRecMer69 c on c.numsol62=b.numsol10
Inner Join Descarga..DQPuerto02 d on d.codpue02=b.codpue03
Where 
CONVERT(CHAR(8),a.abaleg11,112) between @FECINI and @FECFIN and --a.numbul11<>a.bulent11 AND --ojo con la ultima condicion 03/07/2003
c.flgval69='1' and c.flgemi69='1'
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL3]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_ABANDONO_LEGAL3]
@NUMDUI VARCHAR(13),
@FECFIN CHAR(8)
AS

Select * From DDDUiDes16 
Where numdui11=@NUMDUI and CONVERT(CHAR(8),fecusu16,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL4]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_ABANDONO_LEGAL4]
@NUMDUI CHAR(14),
@FECFIN CHAR(8)
AS

Select pesbru=SUM(a.pesbru79), bultot=SUM(a.bultot79),pretot79=SUM(a.pretot79+a.cuadep79)
From DDEntMer79 a 
Inner Join DDTicket01 b on b.numgui01=a.nument79
Where 
b.tipope01='R' and a.flgval79='1' and 
a.numdui16=@NUMDUI and CONVERT(CHAR(8),b.fecsal01,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ING_CLI_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_ING_CLI_ADU]
@TIPCLI CHAR(1),
@CODCLI VARCHAR(11),
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS

Select 
a.numcer13,a.numdui11,a.tipcli02,a.codcli02,d.nombre,c.priing69,a.numbul13,b.codemb06,b.desmer10,a.cifcer13 
From 
DDCerAdu13 a,DDSolAdu10 b,DDRecMer69 c,AAClientesAA d 
Where 
a.numsol10=b.numsol10 and b.numsol10=c.numsol62 and a.tipcli02=d.claseabc and a.codcli02=d.contribuy  and 
a.flgval13='1' and c.flgval69='1' and c.flgemi69='1' and 
a.tipcli02=@TIPCLI and a.codcli02=@CODCLI and 
CONVERT(CHAR(8),c.priing69,112) between @FECINI AND @FECFIN

GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ING_CLI_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_ING_CLI_SIM]
@TIPCLI CHAR(1),
@CODCLI VARCHAR(11),
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS

Select 
a.numcer74,a.numcer74,c.TIPCLI02,c.CODCLI02,d.nombre,b.priing69,b.bultot69,b.codemb06,
c.desmer62,b.pretot69 
From 
DDCerSim74 a,DDRecMer69 b,DDSolSim62 c,AAClientesAA d 
Where 
b.numsol62=a.numsol62 and b.numsol62=c.numsol62 and a.flgval74='1' and b.flgval69='1' and 
b.flgemi69='1' and a.tipcli02=d.claseabc and a.codcli02=d.contribuy and c.tipcli02=@TIPCLI and 
c.codcli02=@CODCLI and CONVERT(CHAR(8),b.priing69,112) between @FECINI and @FECFIN
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL1]
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS

Select 
* 
From 
DVLevAba94 
Where CONVERT(CHAR(8),fecusu16,112) BETWEEN @FECINI AND @FECFIN
Order by numdui11,numdui16
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL1_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL1_NEW] @FECINI CHAR(8)
	,@FECFIN CHAR(8)
AS
SELECT *
FROM DVLevAba94_NEW
WHERE CONVERT(CHAR(8), fecusu16, 112) BETWEEN @FECINI
		AND @FECFIN
ORDER BY numdui11
	,numdui16

GO
/****** Object:  StoredProcedure [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL2]
@NUMDUI VARCHAR(13),
@FECFIN CHAR(8)

AS

Select 
numbul=SUM(numbul16), CIF=SUM(valcif16) 
From 
DDDuiDes16 
Where 
numdui11=@NUMDUI and fecusu16<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL3]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL3]
@NUMDUI VARCHAR(14),
@FECFIN CHAR(8)
AS

Select 
pesbru=SUM(a.pesbru79),bultot=SUM(a.bultot79),pretot79=SUM(a.pretot79+a.cuadep79) 
From 
DDEntMer79 a,DDTicket01 b 
Where 
a.nument79=b.numgui01 and b.tipope01='R' and a.flgval79='1' and 
a.numdui16=@NUMDUI and b.fecsal01<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL3_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL3_NEW] @NUMDUI VARCHAR(14)
	,@FECFIN CHAR(8)
AS
SELECT pesbru = SUM(a.pesbru79)
	,bultot = SUM(a.bultot79)
	,pretot79 = SUM(a.pretot79 + a.cuadep79)
	,bultot12 = SUM(ISNULL(a.bultot12,0))
FROM DDEntMer79 a
	,DDTicket01 b
WHERE a.nument79 = b.numgui01
	AND b.tipope01 = 'R'
	AND a.flgval79 = '1'
	AND a.numdui16 = @NUMDUI
	AND b.fecsal01 <= @FECFIN


GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ORR_PEN_POR_CLI_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_ORR_PEN_POR_CLI_ADU]
@TIPCLI CHAR(1),
@CODCLI VARCHAR (11)
AS
Select 
a.numret18,a.fecret18,a.numdui16,a.tipdoc55,a.codrep77,c.nomrep77,a.obsret18,b.tipcli02,b.codcli02,d.nombre,b.codage19,f.nombre,
bulsld=b.numbul16-b.bulent16,cifsld=b.valcif16-b.cifent16,e.desmer10,b.numdui11,b.numcer13 
From 
DRRetAdu18 a,DDDuiDes16 b,DDCerAdu13 g,DDSolAdu10 e,DQMaeRep77 c,AAClientesAA d,AAClientesAA f 
Where 
a.numdui16=b.numdui16 and b.numcer13=g.numcer13 and g.numsol10=e.numsol10 and b.numbul16-b.bulent16>0 and 
a.flgval18='1' and a.flgemi18='1' and a.codrep77=c.codrep11 and b.tipcli02=d.claseabc and b.codcli02=d.contribuy and b.CodAge19=f.cliente and 
b.tipcli02=@TIPCLI and b.codcli02=@CODCLI
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ORR_PEN_POR_CLI_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[REPORTE_ORR_PEN_POR_CLI_SIM]    
@TIPCLI CHAR(1),    
@CODCLI VARCHAR(11)    
    
AS    
Select     
numret18=a.numret75,fecret18=a.fecret75,numdui16='',a.tipdoc55,a.codrep77,c.nomrep77,obsret18=a.obsret75,b.tipcli02,b.codcli02,d.nombre,    
b.codage19,f.nombre,bulsld=a.bultot75-a.bulret75,cifsld=a.pretot75-a.preret75,e.desmer62,numdui11='',numcer13=a.numcer74     
From     
DDRetSim75 a  
inner join DDCerSim74 b on (a.numcer74=b.numcer74)  
inner join DQMaeRep77 c on (a.codrep77=c.codrep11)  
inner join AAClientesAA d on (b.tipcli02=d.claseabc and b.codcli02=d.contribuy)  
inner join DDSolSim62 e on (b.numsol62=e.numsol62)  
left  join AAClientesAA f  on (b.codage19=f.cliente and b.codage19 <> '')   
Where     
a.bultot75-a.bulret75>0 and   
a.flgval75='1' and   
a.flgemi75='1' and     
b.tipcli02=@TIPCLI and b.codcli02=@CODCLI  
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ORR_PEN_TOD_CLI_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_ORR_PEN_TOD_CLI_ADU]

AS
Select 
a.numret18,a.fecret18,a.numdui16,a.tipdoc55,a.codrep77,c.nomrep77,a.obsret18,b.tipcli02,b.codcli02,d.nombre,b.codage19,f.nombre,
bulsld=b.numbul16-b.bulent16,cifsld=b.valcif16-b.cifent16,e.desmer10,b.numdui11,b.numcer13 
From 
DRRetAdu18 a,DDDuiDes16 b,DDCerAdu13 g,DDSolAdu10 e,DQMaeRep77 c,AAClientesAA d,AAClientesAA f 
Where 
a.numdui16=b.numdui16 and b.numcer13=g.numcer13 and g.numsol10=e.numsol10 and b.numbul16-b.bulent16>0 and 
a.flgval18='1' and a.flgemi18='1' and a.codrep77=c.codrep11 and b.tipcli02=d.claseabc and b.codcli02=d.contribuy and b.CodAge19=f.cliente 


GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ORR_PEN_TOD_CLI_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[REPORTE_ORR_PEN_TOD_CLI_SIM]    
AS    
Select     
numret18=a.numret75,fecret18=a.fecret75,numdui16='',a.tipdoc55,a.codrep77,c.nomrep77,obsret18=a.obsret75,b.tipcli02,b.codcli02,d.nombre,    
b.codage19,f.nombre,bulsld=a.bultot75-a.bulret75,cifsld=a.pretot75-a.preret75,e.desmer62,numdui11='',numcer13=a.numcer74     
From     
DDRetSim75 a  
 inner join DDCerSim74 b on (a.numcer74=b.numcer74)  
 inner join DQMaeRep77 c on (a.codrep77=c.codrep11)  
 inner join AAClientesAA d on (b.tipcli02=d.claseabc and b.codcli02=d.contribuy )  
 inner join DDSolSim62 e on (b.numsol62=e.numsol62)  
 left join AAClientesAA f  on (b.codage19=f.cliente and b.codage19 <> '')   
Where     
 a.bultot75-a.bulret75>0 and   
a.flgval75='1' and a.flgemi75='1'  

GO
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_ING_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_POR_DEPOSITO_ING_ADU]
@ALMAN CHAR(1),
@FECHA CHAR(8)
AS

Select 
c.numcer13,c.numdui11,c.numsol10,a.numrec69,b.tipcli02,b.codcli02,e.nombre,a.priing69,a.bultot69,
a.codemb06,b.desmer10,a.pesnet69,c.valcif11,c.tipcam11 
From 
DDRecMer69 a,DDAlmExp99 d,DDSolAdu10 b,DDDuiDep11 c,AAClientesAA e 
Where 
d.codalm99=@ALMAN and convert(char(8),a.priing69,112)<=@FECHA and
a.flgval69='1' and a.flgemi69='1' and a.numsol62=b.numsol10 and b.tipcli02=e.claseabc and b.codcli02=e.contribuy and 
b.numsol10=c.numsol10 and a.numsol62=d.numsol99
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_ING_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_POR_DEPOSITO_ING_SIM]
@DEPO CHAR(1),
@FECHA CHAR(8)
AS

Select 
a.numcer74,null,a.numsol62,b.numrec69,c.tipcli02,c.codcli02,d.nombre,b.priing69,b.bultot69,b.codemb06,c.desmer62,b.pesnet69,b.pretot69,0 
From 
DDCerSim74 a,DDRecMer69 b,DDSolSim62 c,AAClientesAA d,DDAlmExp99 e 
Where 
a.numsol62=b.numsol62 and b.numsol62=c.numsol62 and a.tipcli02=d.claseabc and a.codcli02=d.contribuy and a.flgval74='1' and b.flgval69='1' and 
b.flgemi69='1' and c.numsol62=e.numsol99 and e.codalm99=@DEPO and b.priing69<=@FECHA
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_ING2_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_POR_DEPOSITO_ING2_SIM]
@DEPO CHAR(1),
@FECHA CHAR(8)
AS

Select 
null, null, c.numsol62, b.numrec69,c.tipcli02,c.codcli02,d.nombre,b.priing69,b.bultot69,b.codemb06,c.desmer62,b.pesnet69,b.pretot69, 0 
From 
DDRecMer69 b, DDSolSim62 c,AAClientesAA d, DDAlmExp99 e
Where 
b.numsol62=c.numsol62 and b.flgval69='1' and b.flgemi69='1' and c.tipcli02=d.claseabc and c.codcli02=d.contribuy and 
c.numsol62=e.numsol99 and c.flgcer62='0' and e.codalm99=@DEPO and b.priing69<=@FECHA

GO
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_SAL_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_POR_DEPOSITO_SAL_ADU]
@DEPO CHAR(1),
@FECHA CHAR(8)
AS

Select 
null,a.numdui11,bultot=SUM(bultot79),pretot=SUM(pretot79+cuadep79),pesbru=SUM(pesbru79) 
From 
DDEntMer79 a,DDTicket01 b,DDAlmExp99 c 
Where 
c.codalm99=@DEPO and convert(char(8),b.fecsal01,112)<=@FECHA and 
SUBSTRING(a.numcer13,1,1)='A' and a.nument79=b.numgui01 and a.flgval79='1' and b.tipope01='R' and a.numdui11=c.numdui11
group by a.numdui11
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_SAL_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_POR_DEPOSITO_SAL_SIM]
@DEPO CHAR(1),
@FECHA CHAR(8)

AS

Select 
numcer13,null,bultot=SUM(bultot79),pretot=SUM(pretot79+cuadep79),pesbru=SUM(pesbru79) 
From 
DDEntMer79 a,DDTicket01 b,DDAlmExp99 c 
Where 
SUBSTRING(a.numcer13,1,1)='S' and a.nument79=b.numgui01 and a.flgval79='1' and b.tipope01='R' and 
a.numcer13=c.numcer99 and c.codalm99=@DEPO and b.fecsal01<=@FECHA
Group by numcer13

GO
/****** Object:  StoredProcedure [dbo].[REPORTE_SAL_CLI_ADU1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_SAL_CLI_ADU1] 
@TIPCLI CHAR(8),
@CODCLI VARCHAR(11),
@FECFIN CHAR(8)

AS

Select 
a.numcer13,a.numdui11,a.tipcli02,a.codcli02,d.nombre,c.priing69,a.numbul13,b.codemb06,b.desmer10,a.cifcer13 
From 
DDCerAdu13 a,DDSolAdu10 b,DDRecMer69 c,AAClientesAA d 
Where 
a.numsol10=b.numsol10 and b.numsol10=c.numsol62 and a.tipcli02=d.claseabc and a.codcli02=d.contribuy and 
a.flgval13='1' and c.flgval69='1' and c.flgemi69='1' and 
a.tipcli02=@TIPCLI and a.codcli02=@CODCLI and CONVERT(CHAR(8),c.priing69,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_SAL_CLI_ADU2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_SAL_CLI_ADU2]
@TIPCLI CHAR(8),
@CODCLI VARCHAR(11),
@FECINI CHAR(8),
@FECFIN CHAR(8)

AS
Select 
a.numcer13,bultot79=SUM(a.bultot79),pretot79=SUM(a.pretot79+a.cuadep79) 
From 
DDEntMer79 a,DDTicket01 b,DDCerAdu13 c 
Where 
a.Numtkt01=b.Numtkt01 And a.numcer13=c.numcer13 and 
c.tipcli02=@TIPCLI and c.codcli02=@CODCLI and
CONVERT(CHAR(8),b.fecsal01,112) BETWEEN @FECINI AND @FECFIN
Group by a.numcer13


GO
/****** Object:  StoredProcedure [dbo].[REPORTE_SAL_CLI_SIM1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_SAL_CLI_SIM1] 
@TIPCLI CHAR(8),
@CODCLI VARCHAR(11),
@FECFIN CHAR(8)

AS

Select 
a.numcer74,a.numcer74,c.tipcli02,c.codcli02,d.nombre,b.priing69,b.bultot69,b.codemb06,c.desmer62,b.pretot69
From 
DDCerSim74 a,DDRecMer69 b,DDSolSim62 c,AAClientesAA d 
Where 
b.numsol62=a.numsol62 and b.numsol62=c.numsol62 and a.flgval74='1' and b.flgval69='1' and b.flgemi69='1' and 
a.tipcli02=d.claseabc and a.codcli02=d.contribuy and c.tipcli02=@TIPCLI and c.codcli02=@CODCLI and 
CONVERT(CHAR(8),b.priing69,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_SAL_CLI_SIM2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_SAL_CLI_SIM2]
@TIPCLI CHAR(8),
@CODCLI VARCHAR(11),
@FECINI CHAR(8),
@FECFIN CHAR(8)

AS

Select 
a.numcer13,bultot79=SUM(a.bultot79),pretot79=SUM(a.pretot79+a.cuadep79) 
From 
DDEntMer79 a,DDTicket01 b,DDCerSim74 c 
Where 
a.Numtkt01=b.Numtkt01 And a.numcer13=c.numcer74 and 
c.tipcli02=@TIPCLI and c.codcli02=@CODCLI  AND 
CONVERT(CHAR(8),b.fecsal01,112) BETWEEN @FECINI AND @FECFIN
Group by a.numcer13
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_SLD_CLI_ADU1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[REPORTE_SLD_CLI_ADU1]  
@TIPCLI CHAR(1),  
@CODCLI VARCHAR(11),  
@FECFIN CHAR(8)  
  
AS  
Select   
a.numcer13,a.numdui11,a.tipcli02,a.codcli02,d.nombre,c.priing69,a.numbul13,b.codemb06,b.desmer10,a.cifcer13   
From   
DDCerAdu13 a,DDSolAdu10 b,DDRecMer69 c,AAClientesAA d   
Where   
a.numsol10=b.numsol10 and b.numsol10=c.numsol62 and a.tipcli02=d.claseabc and a.codcli02=d.contribuy and   
a.flgval13='1' and c.flgval69='1' and c.flgemi69='1' and   
a.tipcli02=@TIPCLI and a.codcli02=@CODCLI and CONVERT(CHAR(8),c.priing69,112)<=@FECFIN
and a.numdui11 not in ('1181070002971','1181070003520','1181070004167')
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_SLD_CLI_ADU2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_SLD_CLI_ADU2]
@TIPCLI CHAR(1),
@CODCLI VARCHAR(11),
@FECFIN CHAR(8)

AS
Select 
a.numcer13,bultot79=SUM(a.bultot79),pretot79=SUM(a.pretot79+a.cuadep79) 
From 
DDEntMer79 a,DDTicket01 b,DDCerAdu13 c 
where 
a.Numtkt01=b.Numtkt01 And a.numcer13=c.numcer13 and 
CONVERT(CHAR(8),b.fecsal01,112)<=@FECFIN and c.tipcli02=@TIPCLI and c.codcli02=@CODCLI
Group by a.numcer13
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_SLD_CLI_SIM1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_SLD_CLI_SIM1]
@TIPCLI CHAR(1),
@CODCLI VARCHAR(11),
@FECFIN CHAR(8)

AS
Select 
a.numcer74,a.numcer74,c.tipcli02,c.codcli02,d.nombre,b.priing69,b.bultot69,b.codemb06,c.desmer62,b.pretot69
From 
DDCerSim74 a,DDRecMer69 b,DDSolSim62 c,AAClientesAA d 
Where 
b.numsol62=a.numsol62 and b.numsol62=c.numsol62 and a.flgval74='1' and b.flgval69='1' and b.flgemi69='1' and 
a.tipcli02=d.claseabc and a.codcli02=d.contribuy and c.tipcli02=@TIPCLI and c.codcli02=@CODCLI and 
CONVERT(CHAR(8),b.priing69,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_SLD_CLI_SIM2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[REPORTE_SLD_CLI_SIM2]
@TIPCLI CHAR(1),
@CODCLI VARCHAR(11),
@FECFIN CHAR(8)

AS
Select 
a.numcer13,bultot79=SUM(a.bultot79),pretot79=SUM(a.pretot79+a.cuadep79) 
From 
DDEntMer79 a,DDTicket01 b,DDCerSim74 c 
Where 
a.Numtkt01=b.Numtkt01 And a.numcer13=c.numcer74 and 
CONVERT(CHAR(8),b.fecsal01,112)<=@FECFIN and c.tipcli02=@TIPCLI and c.codcli02=@CODCLI
Group by a.numcer13
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_CERTIFICADOS_FACTURAR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.ROCKY_CERTIFICADOS_FACTURAR    Script Date: 08-09-2002 08:44:04 PM ******/
ALTER PROCEDURE [dbo].[ROCKY_CERTIFICADOS_FACTURAR]
AS


Select distinct substring(a.numcer52,1,1),a.numcer52,a.nomcli52
from DTCabCom52 a, DTDetCom53 b
where a.numcer52=b.numcer52
Order by substring(a.numcer52,1,1),a.nomcli52,a.numcer52
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_CONTROLAR_ALMAN]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ROCKY_CONTROLAR_ALMAN]
@TIPDEP char(1),
@TIPMER VARCHAR(5),
@CODEMB varchar(3),
@COBALM char(1)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Select * 
From 
DDSERVIC52 
Where 
DEPOSI52=@TIPDEP and 
(TIPMER72=@TIPMER or TIPMER72='TODOS') and (CODEMB06=@CODEMB or CODEMB06='TDO') and 
APLICA52=@COBALM and VISIBLE52='S' and STATUS52='A' and
(CONCEP51='ALMAN' OR CONCEP51 = 'ALMVE')

GO
/****** Object:  StoredProcedure [dbo].[ROCKY_CONTROLAR_GASAD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.ROCKY_CONTROLAR_GASAD    Script Date: 08-09-2002 08:44:04 PM ******/
ALTER PROCEDURE [dbo].[ROCKY_CONTROLAR_GASAD]
@TIPDEP char(1),
@TIPMER VARCHAR(5),
@CODEMB varchar(3)
AS

Select * 
From 
DDSERVIC52 
Where 
DEPOSI52=@TIPDEP and 
(TIPMER72=@TIPMER or TIPMER72='TODOS') and (CODEMB06=@CODEMB or CODEMB06='TDO') and 
VISIBLE52='S' and STATUS52='A' and
CONCEP51='GASAD'
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_CONTROLAR_SEGCA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.ROCKY_CONTROLAR_SEGCA    Script Date: 08-09-2002 08:44:04 PM ******/
ALTER PROCEDURE [dbo].[ROCKY_CONTROLAR_SEGCA]
@TIPDEP char(1),
@TIPMER VARCHAR(5),
@CODEMB varchar(3)
AS


Select * 
From 
DDSERVIC52 
Where 
DEPOSI52=@TIPDEP and 
(TIPMER72=@TIPMER or TIPMER72='TODOS') and (CODEMB06=@CODEMB or CODEMB06='TDO') and 
VISIBLE52='S' and STATUS52='A' and
CONCEP51='SEGCA'
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_CONTROLAR_TARIFAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.ROCKY_CONTROLAR_TARIFAS    Script Date: 08-09-2002 08:44:08 PM ******/
ALTER PROCEDURE [dbo].[ROCKY_CONTROLAR_TARIFAS]
AS


Select 
distinct numcer=a.numcer13,numsol=a.numsol10,numper=a.perfac13,tipmer=b.tipmer72,
codemb=b.codemb06,segnep=c.segnep10,cobalm=c.cobalm10,feccer=a.feccer13
From 
DDCerAdu13 a,DDserdep12 b,DDSolAdu10 c 
Where 
a.numsol10=b.numsol10 and a.numsol10=c.numsol10 and 
a.flgval13='1' and a.flgfac13='1' and a.finser13='0' and a.flstfa13='N' and a.flgtar13='2'
union all
Select 
distinct numcer=a.numcer74,numsol=a.numsol62,numper=a.perfac74,tipmer=b.tipmer72,
codemb=b.codemb06,segnep=c.segnep62,cobalm=c.cobalm62,feccer=a.feccer74
From 
DDCerSim74 a,DDDSoSim67 b,DDSolSim62 c 
Where 
a.numsol62=b.numsol62 and a.numsol62=c.numsol62 and 
a.flgval74='1' and a.flgfac74='1' and a.finser74='0' and a.flstfa74='N' and a.flgtar74='2'
Order by 1,4,5
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_DESCUADRES_EM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[ROCKY_DESCUADRES_EM]
AS


Select nument79,fecent79,numret75,numcer13,numdui11,cuadep79
from ddentmer79 (nolock)
where cuadep79<>0 and flgval79='1' and e_mail79='N' 
Order by nument79
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_DESCUADRES_EM_1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[ROCKY_DESCUADRES_EM_1]
AS


Update ddentmer79 set e_mail79='S' 
where cuadep79<>0 and flgval79='1' and e_mail79='N'
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_DESTINATARIOS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.ROCKY_DESTINATARIOS    Script Date: 08-09-2002 08:44:05 PM ******/
ALTER PROCEDURE [dbo].[ROCKY_DESTINATARIOS]
@DOC CHAR(3)
AS

if @DOC='CER'
    Select distinct USUARI01 from DDMENUES01 
    Where 
    (KEYFOR01 in ('*') or USUARI01 in ('epalomino','kramirez','jsaldarriaga')) and
    sistem01='SIDA' and USUARI01 not in ('SIDA','SIDAB')
if @DOC = 'ENM'
    Select distinct USUARI01 from DDMENUES01 
    Where 
    (KEYFOR01 in ('*') or USUARI01 in ('epalomino','kramirez','jsaldarriaga')) and
    sistem01='SIDA' and USUARI01 not in ('SIDA','SIDAB')
if @DOC = 'FCE'
    Select distinct USUARI01 from DDMENUES01 
    Where 
    KEYFOR01 in ('*','A0062_ID') and substring(CADENA01,3,1)='1' and
    sistem01='SIDA' and USUARI01 not in ('SIDA','SIDAB') 
if @DOC = 'SOL' --Para envio de Email cuando se genera nueva solicitud y el cliente tiene deuda vencida. hvega - 14/11/2003
    Select distinct USUARI01 from DDMENUES01 
    Where 
    KEYFOR01 in ('*','A00815_ID') and 
    sistem01='SIDA' and USUARI01 not in ('SIDA','SIDAB','jruiz','rmendoza')
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_EMAIL_SOLICITUD_DEPOSITO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[ROCKY_EMAIL_SOLICITUD_DEPOSITO]

AS


Select SOLICITUD=numsol10,FECHA=fecsol10,CLIENTE=codcli02
From ddsoladu10 where flgval10='1' and e_mail10='N' 
UNION ALL
Select SOLICITUD=numsol62,FECHA=fecsol62,CLIENTE=codcli02
From ddsolsim62 where flgval62='1' and e_mail62='N' 
Order by 1
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_ENTREGA_DE_MERCADERIA_ADUANERA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[ROCKY_ENTREGA_DE_MERCADERIA_ADUANERA]

AS

Select NRO_ENTREGA_MERCADERIA=d.nument79, FECHA_ENTREGA_MERCADERIA=d.fecent79, NRO_ORDEN_RETIRO=a.numret18, FECHA_ORDEN_RETIRO=a.fecret18,  RUC=b.codcli02, 
RAZON_SOCIAL=c.nombre, BULTOS=d.bultot79, PESO=d.pesbru79, COD_EMBALAJE=d.codemb06, 
EMBALAJE=e.desemb06,FECHA_INGRESO_CAMION=f.fecing01, FECHA_SALIDA_CAMION=f.fecsal01, TIPO=case when f.flgman01=1 then 'MANUAL' else 'AUTOMATICO' end, USUARIO=f.nomusu01
From drretadu18 a
Inner Join ddduides16 b 	on b.numdui16=a.numdui16
Inner Join AACLIENTESAA c 	on c.contribuy=b.codcli02
Inner Join ddentmer79 d		on d.numret75=a.numret18 and d.flgval79=1
Inner Join dqembala06 e		on e.codemb06=d.codemb06
Inner Join DDTICKET01 f		on f.numtkt01=d.numtkt01
Where a.flgval18=1 and a.fecret18>='20040101'
Order by d.nument79 desc
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_ENTREGA_DE_MERCADERIA_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[ROCKY_ENTREGA_DE_MERCADERIA_SIMPLE]

AS

Select NRO_ENTREGA_MERCADERIA=d.nument79, FECHA_ENTREGA_MERCADERIA=d.fecent79, NRO_ORDEN_RETIRO=a.numret75, FECHA_ORDEN_RETIRO=a.fecret75,  
RUC=b.codcli02, RAZON_SOCIAL=c.nombre, BULTOS=d.bultot79, PESO=d.pesbru79, COD_EMBALAJE=d.codemb06, 
EMBALAJE=e.desemb06, FECHA_INGRESO_CAMION=f.fecing01, FECHA_SALIDA_CAMION=f.fecsal01, TIPO=case when f.flgman01=1 then 'MANUAL' else 'AUTOMATICO' end, USUARIO=f.nomusu01
From DDRetSim75 a
Inner Join DDCerSim74 b 	on b.numcer74=a.numcer74
Inner Join AACLIENTESAA c 	on c.contribuy=b.codcli02
Inner Join ddentmer79 d		on d.numret75=a.numret75 and d.flgval79=1
Inner Join dqembala06 e		on e.codemb06=d.codemb06
Inner Join DDTICKET01 f		on f.numtkt01=d.numtkt01
Where a.flgval75=1 and a.fecret75>='20040101'
Order by d.nument79 desc
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_RANKING_CIF]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SIG_RANKING_CIF    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[ROCKY_RANKING_CIF]
@FECINI CHAR(8),
@FECFIN CHAR(8),
@TIPDEP CHAR(1)
AS

if @TIPDEP='A'
    Select 
    c.nombre,total=sum(a.valcif11),desde=@FECINI,hasta=@FECFIN,fecha=getdate(),
    reporte="cif.rpt",titulo="DEPOSITO ADUANERO : BASADO EN DUA´S DE DEPOSITO"
    From ddduidep11 a, ddsoladu10 b,aaclientesaa c
    Where 
    convert(char(8),a.fecdui11,112) between @FECINI and @FECFIN and b.flgval10='1' and 
    a.numsol10=b.numsol10 and b.tipcli02=c.claseabc and b.codcli02=c.contribuy
    Group by c.nombre
    order by 2 desc
else
    Select 
    c.nombre,total=sum(a.pretot62),desde=@FECINI,hasta=@FECFIN,fecha=getdate(),
    reporte="cif.rpt",titulo="DEPOSITO SIMPLE : BASADO EN SOLICITUDES DE DEPOSITO" 
    From ddsolsim62 a,aaclientesaa c
    Where 
    convert(char(8),a.fecsol62,112) between @FECINI and @FECFIN and a.flgval62='1' and 
    a.tipcli02=c.claseabc and a.codcli02=c.contribuy
    Group by c.nombre
    order by 2 desc
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_RANKING_FACTURACION]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_RANKING_FACTURACION    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                                 

 ALTER PROCEDURE  [dbo].[ROCKY_RANKING_FACTURACION] 
                                                                                                                                                                                                                  
@FECINI CHAR(8),
                                                                                                                                                                                                                                             
@FECFIN CHAR(8)
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTURAPRO Where Usuario=user_name()
                                                                                                                                                                                                         
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(subtot52+igvtot52)
                                                                                                                                                                                                                          
From ddcabcom52 a,aaclientesaa b
                                                                                                                                                                                                                             
where 
                                                                                                                                                                                                                                                       
convert(char(8),feccom52,112) between @FECINI and @FECFIN and flgval52='1' and 
                                                                                                                                                                              
tipcli02=claseabc and codcli02=contribuy
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
exec NPT9_bd_nept.dbo.ROCKY_RANKING_FACTURACION_PROY @FECINI,@FECFIN
                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
Update SIG_FACTURAPRO set nombre=b.nombre
                                                                                                                                                                                                                    
from SIG_FACTURAPRO a, aaclientesaa b
                                                                                                                                                                                                                        
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),
                                                                                                                                                                         
REPORTE= 'facturacion.rpt'
                                                                                                                                                                                                                                    
From SIG_FACTURAPRO

                                                                                                                                                                                                                                         
Where Usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
Order by 2 desc                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[Saldos_AcerosArequipa]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Saldos_AcerosArequipa]                             
 as                                
 DECLARE @Message  varchar(20), @rc   int,                                
 @ASUNTO varchar(200),                        
 @PARA varchar(500),                        
 @ESTADOOK char(1),                        
 @msg varchar (1000),                      
 @crlf varchar(100)                      
                      
 --exec sp_EjecutarDTS 'Saldos_AceroArequipa'              
DECLARE @destinatario NVARCHAR(MAX);  
SET @destinatario = N'crivera@aasa.com.pe; fgaldos@aasa.com.pe; jchilqui@aasa.com.pe; alorenze@aasa.com.pe; ifernand@aasa.com.pe;'  
+ N' jtorrebl@aasa.com.pe; gderutte@aasa.com.pe; mgeldres@aasa.com.pe; vvigo@aasa.com.pe; lcastro@aasa.com.pe; jsotomay@aasa.com.pe;'  
+ N' wpaucar@aasa.com.pe; depautorizado@neptunia.com.pe; Nadienka.franco@neptunia.com.pe; msaavedr@aasa.com.pe; jtunque@aasa.com.pe;'  
+ N' azapata@aasa.com.pe; almapc2002@hotmail.com;'   
--+ N' al.porras@neptunia.com.pe; almapc2002@hotmail.com';                     
    exec @rc = master.dbo.xp_smtp_sendmail                                
    @FROM   = N'aneptunia@neptunia.com.pe',                              
    @FROM_NAME  = N'TIForwarders',  
 --@TO   = N'evelyn.vera@neptunia.com.pe ',     
 @TO = @destinatario,                         
    @priority  = N'NORMAL',                                
    @subject  = N'SALDOS ACEROS AREQUIPA',                                
    @message  = N'SALDOS ACEROS AREQUIPA',                                
    @messagefile  = N'',                                
    @type   = N'text/plain',                                
    @attachment  = N'\\neptunia1\dtsenvios\Saldos\Saldos_AcerosArequipa.XLS',                                
    @attachments  = N'',                                
    @codepage  = 0,                                
    @server   = N'correo.neptunia.com.pe'   
  
  
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[SearchAllTables]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SearchAllTables]
(
@SearchStr nvarchar(100)
)
AS
BEGIN

CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

SET NOCOUNT ON

DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
SET  @TableName = ''
SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')

WHILE @TableName IS NOT NULL
BEGIN
SET @ColumnName = ''
SET @TableName = 
(
SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
AND QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
AND OBJECTPROPERTY(
OBJECT_ID(
QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
), 'IsMSShipped'
       ) = 0
)

WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
BEGIN
SET @ColumnName =
(
SELECT MIN(QUOTENAME(COLUMN_NAME))
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@TableName, 2)
AND TABLE_NAME = PARSENAME(@TableName, 1)
AND DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
AND QUOTENAME(COLUMN_NAME) > @ColumnName
)

IF @ColumnName IS NOT NULL
BEGIN
INSERT INTO #Results
EXEC
(
'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
FROM ' + @TableName + ' (NOLOCK) ' +
' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
)
END
END 
END

SELECT ColumnName, ColumnValue FROM #Results
END

GO
/****** Object:  StoredProcedure [dbo].[SIG_CONTENEDORES_CLIENTE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIG_CONTENEDORES_CLIENTE]
@ANIO as char(4)
AS

--Borra toda la informacion de las Facturas Generadas Automaticamente
Update dddetcom53 set cantid53=0, tamctr53=0, numuni54=0
from ddcabcom52 a, dddetcom53 b
where a.codcom50=b.codcom50 and a.numcom52=b.numcom52 and a.tipcom52<>0
--Actuliza los datos sobre Contenedores pero solo de las facturas Automaticas.
Update dddetcom53 set cantid53=b.cantid59, tamctr53=b.tamctr59, numuni54=b.numuni54
from dddetcom53 a, DDDOrSer59 b, ddordser58 c, ddcabcom52 d
where a.codcom50=b.codcom50 and a.numcom52=b.numcom52 and a.codcon51=b.codcon51 and 
b.numuni54='1' and c.numord58=b.numord58 and c.flgval58='1' and  
a.codcom50=d.codcom50 and a.numcom52=d.numcom52 and d.tipcom52<>0

Select CLIENTE=substring(c.nombre,1,30),
CTR20_ENE=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=1 then b.cantid53 else 0 end),
CTR40_ENE=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=1 then b.cantid53 else 0 end),
CTR20_FEB=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=2 then b.cantid53 else 0 end),
CTR40_FEB=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=2 then b.cantid53 else 0 end),
CTR20_MAR=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=3 then b.cantid53 else 0 end),
CTR40_MAR=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=3 then b.cantid53 else 0 end),
CTR20_ABR=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=4 then b.cantid53 else 0 end),
CTR40_ABR=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=4 then b.cantid53 else 0 end),
CTR20_MAY=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=5 then b.cantid53 else 0 end),
CTR40_MAY=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=5 then b.cantid53 else 0 end),
CTR20_JUN=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=6 then b.cantid53 else 0 end),
CTR40_JUN=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=6 then b.cantid53 else 0 end),
CTR20_JUL=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=7 then b.cantid53 else 0 end),
CTR40_JUL=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=7 then b.cantid53 else 0 end),
CTR20_AGO=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=8 then b.cantid53 else 0 end),
CTR40_AGO=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=8 then b.cantid53 else 0 end),
CTR20_SET=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=9 then b.cantid53 else 0 end),
CTR40_SET=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=9 then b.cantid53 else 0 end),
CTR20_OCT=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=10 then b.cantid53 else 0 end),
CTR40_OCT=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=10 then b.cantid53 else 0 end),
CTR20_NOV=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=11 then b.cantid53 else 0 end),
CTR40_NOV=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=11 then b.cantid53 else 0 end),
CTR20_DIC=sum(case when b.tamctr53=1 and DATEPART(m,a.feccom52)=12 then b.cantid53 else 0 end),
CTR40_DIC=sum(case when b.tamctr53=2 and DATEPART(m,a.feccom52)=12 then b.cantid53 else 0 end),
CTR_TOT_20=sum(case when b.tamctr53=1 then b.cantid53 else 0 end),
CTR_TOT_40=sum(case when b.tamctr53=2 then b.cantid53 else 0 end),
TITULO='ESTADISTICA GENERAL CONTENEDORES POR CLIENTE (EN IMPLEMENTACION)' ,ANIO='DEL AÑO : ' +@ANIO,
FECHA=getdate(),REPORTE="contenedores_cliente.rpt",CONFIABLE='Confiable 100% = a partir de 01/01/2003'
From ddcabcom52 a 
Inner Join dddetcom53 b ON a.codcom50=b.codcom50 and a.numcom52=b.numcom52
Inner Join aaclientesaa c ON a.tipcli02=c.claseabc and a.codcli02=c.contribuy
Where 
a.flgval52='1' and b.numuni54='1' and 
DATEPART(yyyy,a.feccom52)=@ANIO
Group by c.nombre
Order by c.nombre
GO
/****** Object:  StoredProcedure [dbo].[SIG_CONTENEDORES_MENSUAL]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIG_CONTENEDORES_MENSUAL]
@DEPO as char(1),
@SERV as varchar(8),
@ANIO AS INTEGER
AS

if @DEPO='A' 
	Select NUM_MES=datepart(month,a.feccom52),NOM_MES=datename(month,a.feccom52),b.codcon51,SERVICO='SERVICIO : '+b.codcon51+' - '+c.desser52,
    	CTR_DE_20=sum(case when b.tamctr53=1 then b.cantid53 else 0 end),CTR_DE_40=sum(case when b.tamctr53=2 then b.cantid53 else 0 end),
	TITULO='ESTADISTICA DE CONTENEDORES - DEPOSITO AUTORIZADO' ,ANIO='DEL AÑO : ' +CONVERT(VARCHAR(4),@ANIO),
	FECHA=getdate(),REPORTE="contenedores_mensual.rpt",CONFIABLE='Confiable 100% = a partir de 18/09/2002'
    	From ddcabcom52 a, dddetcom53 b, ddservic52 c
    	Where a.codcom50=b.codcom50 and a.numcom52=b.numcom52 and a.flgval52='1' and
    	b.codcon51=c.servic52 and left(a.numcer52,1)=@DEPO and c.deposi52=@DEPO and 
    	b.numuni54=1 and datepart(year,a.feccom52)=@ANIO and b.codcon51=@SERV
	group by datepart(month,a.feccom52),datename(month,a.feccom52),b.codcon51,c.desser52
	order by datepart(month,a.feccom52),datename(month,a.feccom52),c.desser52
else
	Select NUM_MES=datepart(month,a.feccom52),NOM_MES=datename(month,a.feccom52),	b.codcon51,SERVICO='SERVICIO : '+b.codcon51+' - '+c.desser52,
	CTR_DE_20=sum(case when b.tamctr53=1 then b.cantid53 else 0 end),CTR_DE_40=sum(case when b.tamctr53=2 then b.cantid53 else 0 end),
	TITULO='ESTADISTICA DE CONTENEDORES - DEPOSITO SIMPLE' ,ANIO='DEL AÑO : ' +CONVERT(VARCHAR(4),@ANIO),
	FECHA=getdate(),REPORTE="contenedores_mensual.rpt",CONFIABLE='Confiable 100% = a partir de 18/09/2002'
	From ddcabcom52 a, dddetcom53 b, ddservic52 c
	Where a.codcom50=b.codcom50 and a.numcom52=b.numcom52 and a.flgval52='1' and
	b.codcon51=c.servic52 and (left(a.numcer52,1)=@DEPO or left(a.numcer52,1)='') and c.deposi52=@DEPO and 
	b.numuni54=1 and datepart(year,a.feccom52)=@ANIO and b.codcon51=@SERV
	group by datepart(month,a.feccom52),datename(month,a.feccom52),b.codcon51,c.desser52
	order by datepart(month,a.feccom52),datename(month,a.feccom52),c.desser52
GO
/****** Object:  StoredProcedure [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE]     
                                                                                                                                                                                                            
@RUC varchar(11),    
                                                                                                                                                                                                                                        
@DEUVEN char(2),    
                                                                                                                                                                                                                                         
@TICKET char(2)=null    
                                                                                                                                                                                                                                     
AS    
                                                                                                                                                                                                                                                       
    
                                                                                                                                                                                                                                                         
Declare @USERID as varchar(20)    
                                                                                                                                                                                                                           
Declare @AUTORIZACION as char(2)    
                                                                                                                                                                                                                         
Select @USERID=user_name()    
                                                                                                                                                                                                                               
    
                                                                                                                                                                                                                                                         
--====================================================    
                                                                                                                                                                                                   
--====OJO: SI HAY EMERGENCIA: ACTIVAS ESTE BLOQUE====    
                                                                                                                                                                                                    
--====================================================    
                                                                                                                                                                                                   
/*    
                                                                                                                                                                                                                                                       
Select '','','','','','','','','','','','','','','','','','','','','' from aaclientesaa where 1=2    
                                                                                                                                                        
Return 0    
                                                                                                                                                                                                                                                 
*/    
                                                                                                                                                                                                                                                       
  
                                                                                                                                                                                                                                                           
--/*    
                                                                                                                                                                                                                                                     
--********************************************************************    
                                                                                                                                                                                   
--****Tengo que verificar si ya tiene Autorizacion de Ingreso    
                                                                                                                                                                                            
--********************************************************************    
                                                                                                                                                                                   
if exists (Select * from ddautdoc16 where contribuy=@RUC and convert(char(8),FECINI16,112)=convert(char(8),getdate(),112))    
                                                                                                                               
 Select @AUTORIZACION='SI'    
                                                                                                                                                                                                                               
else    
                                                                                                                                                                                                                                                     
 Select @AUTORIZACION='NO'    
                                                                                                                                                                                                                               
    
                                                                                                                                                                                                                                                         
--(RO) - Es utilizado por los sistemas ROCKY para consultar la deuda vencida de un cliente.    
                                                                                                                                                              
--          Con esta linea es posible consultar la deuda vencida sin importar los horarios de atencion    
                                                                                                                                                   
--          y con la consulta realizada se procede a enviar los correos electronicos en el momento que el     
                                                                                                                                               
--          cliente es atendido por primera vez en un dia especifico.    
                                                                                                                                                                                    
--(SI) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda vencida de un cliente    
                                                                                                                                                         
--        Con esta linea es posible consultar la deuda solo en los horarios de atencion.    
                                                                                                                                                                 
--===========================================================================    
                                                                                                                                                                            
EXEC NPT9_DATAWAREHOUSE.DBO.SIG_DEUDA_PENDIENTE_CLIENTE @RUC,@DEUVEN,'TAIM',@USERID,@AUTORIZACION,@TICKET    
                                                                                                                                              
    
                                                                                                                                                                                                                                                         
--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.    
                                                                                                                                                     
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia    
                                                                                                                                  
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.    
                                                                                                                                                               
--===========================================================================    
                                                                                                                                                                            
if @DEUVEN='NO' EXEC NPT9_DATAWAREHOUSE.DBO.SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'  
                                                                                                                                                                     
--*/                                                                                                                                                                                                                                                           
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE_NEW]
                                                                                                                                                                                                           
@RUC varchar(11),
                                                                                                                                                                                                                                            
@DEUVEN char(2)
                                                                                                                                                                                                                                              
AS
                                                                                                                                                                                                                                                           
Declare @USERID as varchar(20)
                                                                                                                                                                                                                               
Declare @AUTORIZACION as char(2)
                                                                                                                                                                                                                             
Select @USERID=user_name()
                                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
--********************************************************************
                                                                                                                                                                                       
--****Tengo que verificar si ya tiene Autorizacion de Ingreso
                                                                                                                                                                                                
--********************************************************************
                                                                                                                                                                                       
if exists (Select * from ddautdoc16 where contribuy=@RUC and convert(char(8),FECINI16,112)=convert(char(8),getdate(),112))
                                                                                                                                   
	Select @AUTORIZACION='SI'
                                                                                                                                                                                                                                   
else
                                                                                                                                                                                                                                                         
	Select @AUTORIZACION='NO'
                                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
--(RO) - Es utilizado por los sistemas ROCKY para consultar la deuda vencida de un cliente.
                                                                                                                                                                  
--          Con esta linea es posible consultar la deuda vencida sin importar los horarios de atencion
                                                                                                                                                       
--          y con la consulta realizada se procede a enviar los correos electronicos en el momento que el 
                                                                                                                                                   
--          cliente es atendido por primera vez en un dia especifico.
                                                                                                                                                                                        
--(SI) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda vencida de un cliente
                                                                                                                                                             
--        Con esta linea es posible consultar la deuda solo en los horarios de atencion.
                                                                                                                                                                     
--===========================================================================
                                                                                                                                                                                
EXEC NPT9_BD_NEPT.DBO.SIG_DEUDA_PENDIENTE_CLIENTE_NEW @RUC,@DEUVEN,'CLDA',@USERID,@AUTORIZACION
                                                                                                                                                            

                                                                                                                                                                                                                                                             
--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.
                                                                                                                                                         
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia
                                                                                                                                      
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.
                                                                                                                                                                   
--===========================================================================
                                                                                                                                                                                
if @DEUVEN='NO' EXEC NPT9_BD_NEPT.DBO.SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_ESTACIONALIDAD_CLIENTES    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                             

GO
/****** Object:  StoredProcedure [dbo].[SIG_ESTACIONALIDAD_CIF]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SIG_ESTACIONALIDAD_CIF    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[SIG_ESTACIONALIDAD_CIF]
@ANIO CHAR(8),
@DEPO CHAR(1)
AS
if @DEPO='A'
    Select c.nombre,
    ENE=SUM(case when DATEPART(month,a.fecdui11)=1 then a.valcif11 else 0 end),
    FEB=SUM(case when DATEPART(month,a.fecdui11)=2 then a.valcif11 else 0 end),
    MAR=SUM(case when DATEPART(month,a.fecdui11)=3 then a.valcif11 else 0 end),
    ABR=SUM(case when DATEPART(month,a.fecdui11)=4 then a.valcif11 else 0 end),
    MAY=SUM(case when DATEPART(month,a.fecdui11)=5 then a.valcif11 else 0 end),
    JUN=SUM(case when DATEPART(month,a.fecdui11)=6 then a.valcif11 else 0 end),
    JUL=SUM(case when DATEPART(month,a.fecdui11)=7 then a.valcif11 else 0 end),
    AGO=SUM(case when DATEPART(month,a.fecdui11)=8 then a.valcif11 else 0 end),
    SEP=SUM(case when DATEPART(month,a.fecdui11)=9 then a.valcif11 else 0 end),
    OCT=SUM(case when DATEPART(month,a.fecdui11)=10 then a.valcif11 else 0 end),
    NOV=SUM(case when DATEPART(month,a.fecdui11)=11 then a.valcif11 else 0 end),
    DIC=SUM(case when DATEPART(month,a.fecdui11)=12 then a.valcif11 else 0 end),
    TOT=SUM(a.valcif11),anio=@ANIO,fecha=getdate(),reporte="estacionalidad_cif.rpt",
    titulo="DEPOSITO ADUANERO : BASADO EN DUA´S DE DEPOSITO" 
    From ddduidep11 a, ddsoladu10 b,aaclientesaa c
    Where 
    datepart(year,a.fecdui11)=convert(int,@ANIO) and a.numsol10=b.numsol10 and 
    b.flgval10='1' and b.tipcli02=c.claseabc and b.codcli02=c.contribuy
    Group by c.nombre
    order by 14 desc
else
    Select c.nombre,
    ENE=SUM(case when DATEPART(month,a.fecsol62)=1 then a.pretot62 else 0 end),
    FEB=SUM(case when DATEPART(month,a.fecsol62)=2 then a.pretot62 else 0 end),
    MAR=SUM(case when DATEPART(month,a.fecsol62)=3 then a.pretot62 else 0 end),
    ABR=SUM(case when DATEPART(month,a.fecsol62)=4 then a.pretot62 else 0 end),
    MAY=SUM(case when DATEPART(month,a.fecsol62)=5 then a.pretot62 else 0 end),
    JUN=SUM(case when DATEPART(month,a.fecsol62)=6 then a.pretot62 else 0 end),
    JUL=SUM(case when DATEPART(month,a.fecsol62)=7 then a.pretot62 else 0 end),
    AGO=SUM(case when DATEPART(month,a.fecsol62)=8 then a.pretot62 else 0 end),
    SEP=SUM(case when DATEPART(month,a.fecsol62)=9 then a.pretot62 else 0 end),
    OCT=SUM(case when DATEPART(month,a.fecsol62)=10 then a.pretot62 else 0 end),
    NOV=SUM(case when DATEPART(month,a.fecsol62)=11 then a.pretot62 else 0 end),
    DIC=SUM(case when DATEPART(month,a.fecsol62)=12 then a.pretot62 else 0 end),
    TOT=SUM(a.pretot62),anio=@ANIO,fecha=getdate(),reporte="estacionalidad_cif.rpt",
    titulo="DEPOSITO SIMPLE : BASADO EN SOLICITUDES DE DEPOSITO" 
    From ddsolsim62 a,aaclientesaa c
    Where 
    datepart(year,a.fecsol62)=convert(int,@ANIO) and a.flgval62='1' and 
    a.tipcli02=c.claseabc and a.codcli02=c.contribuy
    Group by c.nombre    
    order by 14 desc
GO
/****** Object:  StoredProcedure [dbo].[SIG_ESTACIONALIDAD_CLIENTES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIG_ESTACIONALIDAD_CLIENTES] 
                                                                                                                                                                                                                
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTESTAPRO where usuario=user_name()
                                                                                                                                                                                                        
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, a.feccom52)=1 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.feccom52)=2 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.feccom52)=3 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=4 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=5 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=6 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=7 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=8 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=9 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=10 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                             
case when DATEPART(month, a.feccom52)=11 then a.subtot52+a.igvtot52 else 0 end, 

                                                                                                                                                                            
case when DATEPART(month, a.feccom52)=12 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                              
a.subtot52+a.igvtot52
                                                                                                                                                                                                                                        
From ddcabcom52 a, aaclientesaa b
                                                                                                                                                                                                                            
where DATEPART(year, a.feccom52)=convert(int,@ANIO) and a.flgval52='1' and 
                                                                                                                                                                                  
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
exec NPT9_bd_nept.DBO.SIG_ESTACIONALIDAD_CLIENTES_PR @ANIO
                                                                                                                                                                                                 

                                                                                                                                                                                                                                                             
Update SIG_FACTESTAPRO set nombre=b.nombre
                                                                                                                                                                                                                   
from SIG_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
                                                                                                                                                                                                     
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'
                                                                                                                                                                            

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
                                                                                                                                                        
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep), OCT=sum(oct), NOV=sum(nov),DIC=sum(dic),TOT=sum(total),
                                                                                                                                                                
anio=@ANIO,fecha=getdate(),reporte= 'estacionalidad_factura.rpt'
                                                                                                                                                                                              
From SIG_FACTESTAPRO
                                                                                                                                                                                                                                         
where usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
order by 14 desc                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_ESTACIONALIDAD_CLIENTES_PR    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                          

GO
/****** Object:  StoredProcedure [dbo].[SIG_ESTACIONALIDAD_CLIENTES_PR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIG_ESTACIONALIDAD_CLIENTES_PR]
                                                                                                                                                                                                              
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTESTAPRO where usuario=user_name()
                                                                                                                                                                                                        
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, a.feccom52)=1 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.feccom52)=2 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.feccom52)=3 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=4 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=5 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=6 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=7 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=8 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=9 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.feccom52)=10 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                             
case when DATEPART(month, a.feccom52)=11 then a.subtot52+a.igvtot52 else 0 end, 

                                                                                                                                                                            
case when DATEPART(month, a.feccom52)=12 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                              
a.subtot52+a.igvtot52
                                                                                                                                                                                                                                        
From ddcabcom52 a, aaclientesaa b
                                                                                                                                                                                                                            
where DATEPART(year, a.feccom52)=convert(int,@ANIO) and a.flgval52='1' and 
                                                                                                                                                                                  
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
--FACTURACION POR REALIZAR SEGUN CERTIFICADOS POR FACTURAR
                                                                                                                                                                                                   
--========================================================
                                                                                                                                                                                                   
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, getdate())=1 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                                
case when DATEPART(month, getdate())=2 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                                
case when DATEPART(month, getdate())=3 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=4 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=5 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=6 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=7 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=8 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=9 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                               
case when DATEPART(month, getdate())=10 then a.subtot52+a.igvtot52 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, getdate())=11 then a.subtot52+a.igvtot52 else 0 end, 

                                                                                                                                                                             
case when DATEPART(month, getdate())=12 then a.subtot52+a.igvtot52 else 0 end,
                                                                                                                                                                               
a.subtot52+a.igvtot52
                                                                                                                                                                                                                                        
From dtcabcom52 a, aaclientesaa b
                                                                                                                                                                                                                            
where a.tipcli52=b.claseabc and a.codcli52=b.contribuy
                                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
exec NPT9_bd_nept.DBO.SIG_ESTACIONALIDAD_CLIENTES_PR @ANIO
                                                                                                                                                                                                 

                                                                                                                                                                                                                                                             
Update SIG_FACTESTAPRO set nombre=b.nombre
                                                                                                                                                                                                                   
from SIG_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
                                                                                                                                                                                                     
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'
                                                                                                                                                                            

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
                                                                                                                                                                 
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep),OCT=sum(oct),NOV=sum(nov),DIC=sum(dic),TOTAL=sum(total),
                                                                                                                                                              
anio=@ANIO,fecha=getdate(),reporte= 'estacionalidad_factura_proyectada.rpt'
                                                                                                                                                                                   
From SIG_FACTESTAPRO
                                                                                                                                                                                                                                         
where usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
order by 14 desc                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_RANKING_FACTURACION_PROY    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                            

GO
/****** Object:  StoredProcedure [dbo].[SIG_ESTADISTICA_DE_ESTANCIA_POR_DEPOSITO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIG_ESTADISTICA_DE_ESTANCIA_POR_DEPOSITO]
--@TIPDEP CHAR(1),
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS

Select 
d.numtkt01,d.docaut01,d.numgui01,Minutos=datediff(n,d.fecing01,d.fecsal01),d.fecing01,d.fecsal01,
d.numbul01,d.codemb06,d.pesbru01,tipdep=d.tipcli02,coddep=d.codcli02,nomdep=f.nombre,d.nomusu01,
TITULO='ESTADISTICA DE ESTANCIA DEL CLIENTE EN EL DEPOSITO PARA DEPOSITO' ,
ANIO='DESDE : ' +right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'     HASTA : ' +right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
FECHA=getdate(),REPORTE="Estancia_Depositos.rpt"
From DDTicket01 d,AAClientesAA f
Where 
convert(char(8),d.fecing01,112) between @FECINI and @FECFIN and 
d.tipope01='D' and d.flgman01='0' and 
d.tipcli02=f.claseabc and d.codcli02=f.contribuy
Order by d.docaut01
GO
/****** Object:  StoredProcedure [dbo].[SIG_ESTADISTICA_DE_ESTANCIA_POR_RETIRO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIG_ESTADISTICA_DE_ESTANCIA_POR_RETIRO]
--@TIPDEP CHAR(1),
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS

--if @TIPDEP='A'
Select 
d.numtkt01,a.numret75,a.nument79,Minutos=datediff(n,d.fecing01,d.fecsal01),d.fecing01,d.fecsal01,
a.bultot79,a.codemb06,a.pesbru79,tipdep=h.tipcli02,coddep=h.codcli02,nomdep=f.nombre,d.nomusu01,
TITULO='ESTADISTICA DE ESTANCIA DEL CLIENTE EN EL DEPOSITO PARA RETIRO' ,
ANIO='DESDE : ' +right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'     HASTA : ' +right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
FECHA=getdate(),REPORTE="Estancia_Retiros.rpt"
From DDEntMer79 a,DDDuiDes16 c,DDTicket01 d,DDDuiDep11 e,AAClientesAA f,DDSolAdu10 h 
Where 
convert(char(8),d.fecsal01,112) between @FECINI and @FECFIN and 
a.numdui16=c.numdui16 and a.nument79=d.numgui01 and d.tipope01='R' and d.flgman01='0' and 
a.numdui11=e.numdui11 and e.numsol10=h.numsol10 and 
h.tipcli02=f.claseabc and h.codcli02=f.contribuy
--else
UNION ALL
Select 
d.numtkt01,a.numret75,a.nument79,Minutos=datediff(n,d.fecing01,d.fecsal01),d.fecing01,d.fecsal01,
a.bultot79,a.codemb06,a.pesbru79,tipdep=c.tipcli02,coddep=c.codcli02,nomdep=f.nombre,d.nomusu01,
TITULO='ESTADISTICA DE ESTANCIA DEL CLIENTE EN EL DEPOSITO PARA RETIRO' ,
ANIO='DESDE : ' +right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'     HASTA : ' +right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
FECHA=getdate(),REPORTE="Estancia_Retiros.rpt"
From DDEntMer79 a,DDRetSim75 b,DDCerSim74 c,DDTicket01 d,DDSolSim62 e,AAClientesAA f 
Where 
convert(char(8),d.fecsal01,112) between @FECINI and @FECFIN and 
a.numret75=b.numret75 and b.numcer74=c.numcer74 and a.nument79=d.numgui01 and 
d.tipope01='R' and d.flgman01='0' and c.numsol62=e.numsol62 And c.CODCLI02=f.contribuy
Order by a.nument79
GO
/****** Object:  StoredProcedure [dbo].[SIG_RANKING_FACTURACION_PROY]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIG_RANKING_FACTURACION_PROY] 
                                                                                                                                                                                                               
@FECINI CHAR(8),
                                                                                                                                                                                                                                             
@FECFIN CHAR(8)
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTURAPRO Where Usuario=user_name()
                                                                                                                                                                                                         
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(subtot52+igvtot52)
                                                                                                                                                                                                                          
From ddcabcom52 a,aaclientesaa b
                                                                                                                                                                                                                             
where 
                                                                                                                                                                                                                                                       
convert(char(8),feccom52,112) between @FECINI and @FECFIN and flgval52='1' and 
                                                                                                                                                                              
tipcli02=claseabc and codcli02=contribuy
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
--FACTURACION POR REALIZAR SEGUN CERTIFICADOS POR FACTURAR
                                                                                                                                                                                                   
--========================================================
                                                                                                                                                                                                   
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(subtot52+igvtot52)
                                                                                                                                                                                                                          
From dtcabcom52 a,aaclientesaa b
                                                                                                                                                                                                                             
where tipcli52=claseabc and codcli52=contribuy
                                                                                                                                                                                                               

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
exec NPT9_bd_nept.DBO.SIG_RANKING_FACTURACION_PROY @FECINI,@FECFIN
                                                                                                                                                                                         

                                                                                                                                                                                                                                                             
Update SIG_FACTURAPRO set nombre=b.nombre
                                                                                                                                                                                                                    
from SIG_FACTURAPRO a, aaclientesaa b
                                                                                                                                                                                                                        
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),REPORTE= 'facturacion_proyectada.rpt'
                                                                                                                                     
From SIG_FACTURAPRO

                                                                                                                                                                                                                                         
Where Usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
Order by 2 desc                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SIG_SIP_ESTACIONALIDAD_CLIENTES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIG_SIP_ESTACIONALIDAD_CLIENTES] 
                                                                                                                                                                                                            
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTESTAPRO where usuario=user_name()
                                                                                                                                                                                                        
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, a.fecemi52)=1 then a.totcob58+0 else 0 end,
                                                                                                                                                                                        
case when DATEPART(month, a.fecemi52)=2 then a.totcob58+0 else 0 end,
                                                                                                                                                                                        
case when DATEPART(month, a.fecemi52)=3 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=4 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=5 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=6 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=7 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=8 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=9 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                       
case when DATEPART(month, a.fecemi52)=10 then a.totcob58+0 else 0 end, 
                                                                                                                                                                                      
case when DATEPART(month, a.fecemi52)=11 then a.totcob58+0 else 0 end, 

                                                                                                                                                                                     
case when DATEPART(month, a.fecemi52)=12 then a.totcob58+0 else 0 end,
                                                                                                                                                                                       
a.totcob58+0
                                                                                                                                                                                                                                                 
From pdordser58 a, aaclientesaa b
                                                                                                                                                                                                                            
where DATEPART(year, a.fecemi52)=convert(int,@ANIO) and a.flgval58='1' and 
                                                                                                                                                                                  
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=============================================================
                                                                                                                                                                                              
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
exec NPT9_bd_nept.DBO.SIG_SIP_ESTACIONALIDAD_CLIENTES_PR @ANIO
                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Update SIG_FACTESTAPRO set nombre=b.nombre
                                                                                                                                                                                                                   
from SIG_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
                                                                                                                                                                                                     
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'
                                                                                                                                                                            

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
                                                                                                                                                        
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep),OCT=sum(oct),NOV=sum(nov),DIC=sum(dic),TOT=sum(total),
                                                                                                                                                                
anio=@ANIO,fecha=getdate(),reporte= 'estacionalidad_factura.rpt'
                                                                                                                                                                                              
From SIG_FACTESTAPRO
                                                                                                                                                                                                                                         
where usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
order by 14 desc                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SIG_SIP_RANKING_FACTURACION]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIG_SIP_RANKING_FACTURACION] 
                                                                                                                                                                                                                
@FECINI CHAR(8),
                                                                                                                                                                                                                                             
@FECFIN CHAR(8)
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACTURAPRO Where Usuario=user_name()
                                                                                                                                                                                                         
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(totser58)
                                                                                                                                                                                                                                   
From pdordser58 a,aaclientesaa b
                                                                                                                                                                                                                             
where 
                                                                                                                                                                                                                                                       
convert(char(8),fecemi52,112) between @FECINI and @FECFIN and flgval58='1' and 
                                                                                                                                                                              
tipcli02=claseabc and codcli02=contribuy
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
exec NPT9_bd_nept.DBO.SIG_SIP_RANKING_FACTURACION_PROY @FECINI,@FECFIN
                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
Update SIG_FACTURAPRO set nombre=b.nombre
                                                                                                                                                                                                                    
from SIG_FACTURAPRO a, aaclientesaa b
                                                                                                                                                                                                                        
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),
                                                                                                                                                                         
REPORTE= 'facturacion.rpt'
                                                                                                                                                                                                                                    
From SIG_FACTURAPRO

                                                                                                                                                                                                                                         
Where Usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
Order by 2 desc                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_TOTAL_MENSUAL_FACTURACION    Script Date: 08-09-2002 08:44:09 PM ******/
                                                                                                                                           

GO
/****** Object:  StoredProcedure [dbo].[SIG_TOTAL_MENSUAL_CIF]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SIG_TOTAL_MENSUAL_CIF    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[SIG_TOTAL_MENSUAL_CIF]
@ANIO char(4),
@TIPDEP CHAR(1)

AS

if @TIPDEP='A'
    Select 
    NUM_MES=datepart(month,a.fecdui11),NOM_MES=datename(month,a.fecdui11),TOTAL=sum(a.valcif11),
    anio=@ANIO,fecha=getdate(),reporte="cif_mensual.rpt",
    titulo="DEPOSITO ADUANERO : BASADO EN DUA´S DE DEPOSITO"
    From ddduidep11 a, ddsoladu10 b
    where datepart(year,a.fecdui11)=convert(int,@anio) and 
    a.numsol10=b.numsol10 and b.flgval10='1'
    group by datepart(month,a.fecdui11),datename(month,a.fecdui11)
    order by 1
else
    Select 
    NUM_MES=datepart(month,a.fecsol62),NOM_MES=datename(month,a.fecsol62),TOTAL=sum(a.pretot62),
    anio=@ANIO,fecha=getdate(),reporte="cif_mensual.rpt",
    titulo="DEPOSITO SIMPLE : BASADO EN SOLICITUDES DE DEPOSITO"
    From ddsolsim62 a
    where datepart(year,a.fecsol62)=convert(int,@anio) and a.flgval62='1'
    group by datepart(month,a.fecsol62),datename(month,a.fecsol62)
    order by 1
GO
/****** Object:  StoredProcedure [dbo].[SIG_TOTAL_MENSUAL_FAC_PROY]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIG_TOTAL_MENSUAL_FAC_PROY]
                                                                                                                                                                                                                  
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACMENPRO where usuario=user_name()
                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
Select 
                                                                                                                                                                                                                                                      
datepart(month,feccom52),datename(month,feccom52),(subtot52+igvtot52)
                                                                                                                                                                                        
From ddcabcom52
                                                                                                                                                                                                                                              
where datepart(year,feccom52)=convert(int,@anio) and flgval52='1'
                                                                                                                                                                                            

                                                                                                                                                                                                                                                             
--FACTURACION POR REALIZAR SEGUN CERTIFICADOS POR FACTURAR
                                                                                                                                                                                                   
--========================================================
                                                                                                                                                                                                   
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
Select 
                                                                                                                                                                                                                                                      
datepart(month,getdate()),datename(month,getdate()),(subtot52+igvtot52)
                                                                                                                                                                                      
From dtcabcom52
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
EXEC NPT9_BD_NEPT.DBO.SIG_TOTAL_MENSUAL_FAC_PROY @ANIO
                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select 
                                                                                                                                                                                                                                                      
NUMMES,NOMMES,TOTAL=sum(TOTAL),anio=@ANIO,fecha=getdate(),reporte= 'facturacion_mensual_proyectada.rpt'
                                                                                                                                                       
From SIG_FACMENPRO
                                                                                                                                                                                                                                           
where usuario=user_name()
                                                                                                                                                                                                                                    
group by NUMMES,NOMMES
                                                                                                                                                                                                                                       
order by NUMMES                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SIG_TOTAL_MENSUAL_FACTURACION]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIG_TOTAL_MENSUAL_FACTURACION]
                                                                                                                                                                                                               
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIG_FACMENPRO where usuario=user_name()
                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
Select 
                                                                                                                                                                                                                                                      
datepart(month,feccom52),datename(month,feccom52),(subtot52+igvtot52)
                                                                                                                                                                                        
From ddcabcom52
                                                                                                                                                                                                                                              
where datepart(year,feccom52)=convert(int,@anio) and flgval52='1'
                                                                                                                                                                                            

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
EXEC NPT9_BD_NEPT.DBO.SIG_TOTAL_MENSUAL_FAC_PROY @ANIO
                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select NUM_MES=NUMMES,NOM_MES=NOMMES,TOTAL=sum(TOTAL),anio=@ANIO,fecha=getdate(),
                                                                                                                                                                            
reporte= 'facturacion_mensual.rpt'
                                                                                                                                                                                                                            
From SIG_FACMENPRO
                                                                                                                                                                                                                                           
where usuario=user_name()
                                                                                                                                                                                                                                    
group by NUMMES,NOMMES
                                                                                                                                                                                                                                       
order by NUMMES                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/****** Object:  Stored Procedure dbo.SIG_TOTAL_MENSUAL_FAC_PROY    Script Date: 08-09-2002 08:44:08 PM ******/
                                                                                                                                              

GO
/****** Object:  StoredProcedure [dbo].[SIP_CONSULTAR_DOCUMENTO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SIP_CONSULTAR_DOCUMENTO]
@NUMORD VARCHAR(10)
AS

Select a.*,NombreC=b.nombre
From PDOrdSer58 a,AAClientesAA b
Where a.numcom52=@NUMORD and a.tipcli02=b.claseabc and a.codcli02=b.contribuy
GO
/****** Object:  StoredProcedure [dbo].[SIP_CONSULTAR_ORDSER]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIP_CONSULTAR_ORDSER]
@NUMORD CHAR(6)
AS

Select a.*,NombreC=b.nombre
From PDOrdSer58 a,AAClientesAA b
Where a.numord58=@NUMORD and a.tipcli02=b.claseabc and a.codcli02=b.contribuy
GO
/****** Object:  StoredProcedure [dbo].[SIP_ESTACIONALIDAD_CLIENTES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIP_ESTACIONALIDAD_CLIENTES] 
                                                                                                                                                                                                                
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIP_FACTESTAPRO where usuario=user_name()
                                                                                                                                                                                                        
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIP_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
Select b.nombre,
                                                                                                                                                                                                                                             
case when DATEPART(month, a.fecemi52)=1 then a.totcob58+a.totigv58 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.fecemi52)=2 then a.totcob58+a.totigv58 else 0 end,
                                                                                                                                                                               
case when DATEPART(month, a.fecemi52)=3 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=4 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=5 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=6 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=7 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=8 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=9 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                              
case when DATEPART(month, a.fecemi52)=10 then a.totcob58+a.totigv58 else 0 end, 
                                                                                                                                                                             
case when DATEPART(month, a.fecemi52)=11 then a.totcob58+a.totigv58 else 0 end, 

                                                                                                                                                                            
case when DATEPART(month, a.fecemi52)=12 then a.totcob58+a.totigv58 else 0 end,
                                                                                                                                                                              
a.totcob58+a.totigv58
                                                                                                                                                                                                                                        
From PDORDSER58 a, aaclientesaa b
                                                                                                                                                                                                                            
where DATEPART(year, a.fecemi52)=convert(int,@ANIO) and 
                                                                                                                                                                                                     
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
/*
                                                                                                                                                                                                                                                           
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
Insert into SIG_FACTESTAPRO (NOMBRE,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC,TOTAL)
                                                                                                                                                                   
exec NPT9_bd_nept..SIG_ESTACIONALIDAD_CLIENTES_PR @ANIO
                                                                                                                                                                                                 
*/
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Update SIP_FACTESTAPRO set nombre=b.nombre
                                                                                                                                                                                                                   
from SIP_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
                                                                                                                                                                                                     
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'
                                                                                                                                                                            

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
                                                                                                                                                        
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep),OCT=sum(oct),NOV=sum(nov),DIC=sum(dic),TOT=sum(total),
                                                                                                                                                                
anio=@ANIO,fecha=getdate(),reporte='estacionalidad_factura.rpt'
                                                                                                                                                                                              
From SIP_FACTESTAPRO
                                                                                                                                                                                                                                         
where usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
order by 14 desc                                                                                                                                                                                                                                               
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SIP_IMPRIMIR_FACTURA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIP_IMPRIMIR_FACTURA] 
@NUMORD varchar(6),
@FECLAR varchar(255),
@MONTEX varchar(255)
AS

Select a.*,b.*,c.nombre,c.direccion,d.AFEIGV52,d.DESSER52,
e.desnav08,
FECLAR=@FECLAR,MONTEX=@MONTEX
From PDORDSER58 a
Inner Join PDDORSER59 b on a.numord58=b.numord58
Inner Join AACLIENTESAA c on a.tipcli02=c.claseabc and a.codcli02=c.contribuy
Inner Join PDSERVIC52 d on b.codcon51=d.SERVIC52
Inner Join terminal..DQNAVIER08 e on a.navord58=e.codnav08
where a.flgeje58='1' and a.numord58=@NUMORD
GO
/****** Object:  StoredProcedure [dbo].[SIP_IMPRIMIR_ORDEN_DE_SERVICIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SIP_IMPRIMIR_ORDEN_DE_SERVICIO] 
@NUMORD VARCHAR(6)
AS

Select a.*,
b.codcon51,b.valser59,b.valcob59,b.igvser59,b.numcom52,b.uniser59,b.numuni54,f.UNIMED54,
b.cantid59,b.fecini59,b.fecfin59,b.horast59,
b.tipalq59,b.codalq59,NomAlq=(Select nombre from AACLIENTESAA where contribuy=b.codalq59),
c.nombre,c.direccion,c.TELEFONO1,c.TELEFONO2,d.AFEIGV52,d.DESSER52,e.desnav08,
g.desmue60,h.desmaq61
From PDORDSER58 a
Inner Join PDDORSER59 b on a.numord58=b.numord58
Inner Join AACLIENTESAA c on a.tipcli02=c.claseabc and a.codcli02=c.contribuy
Inner Join PDSERVIC52 d on b.codcon51=d.SERVIC52
Inner Join terminal..dqnavier08 e on a.navord58=e.codnav08
Inner Join PDUNIMED54 f on b.numuni54=f.NUMUNI54
Inner Join  PDMUELLE60 g on a.muelle58=g.MUELLE60
Inner Join PDMAQUIN61 h on  b.maquin59=h.codmaq61
where a.numord58=@NUMORD
GO
/****** Object:  StoredProcedure [dbo].[SIP_INTERFACE_ADU_CABEC]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIP_INTERFACE_ADU_CABEC]
@NUMDOC CHAR(10)
AS

Select a.*,ruc_age_adu='00000000099',nom_age_adu='',nom_cliente=b.nombre,
MONAFE=(Select coalesce(sum(valcob59),0) from pddorser59 where numord58=a.numord58 and coalesce(igvser59,0)>0),
MONINA=(Select coalesce(sum(valcob59),0) from pddorser59 where numord58=a.numord58 and coalesce(igvser59,0)=0)
From PDORDSER58 a
Inner Join AACLIENTESAA b on a.tipcli02=b.claseabc and a.codcli02=b.contribuy
Where a.numcom52=@NUMDOC
GO
/****** Object:  StoredProcedure [dbo].[SIP_INTERFACE_ADU_DETAL]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIP_INTERFACE_ADU_DETAL]
@NUMDOC CHAR(10)
AS

Select a.*,b.codsbd03,b.flguni51,b.descon51,b.cencos51,b.sucimp51
From PDDORSER59 a, PQConCom51 b, PDordser58 c
Where c.numcom52=@NUMDOC and substring(a.codcon51,1,5)=b.codcon51 and a.numord58=c.numord58
GO
/****** Object:  StoredProcedure [dbo].[SIP_RANKING_FACTURACION]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIP_RANKING_FACTURACION] 
                                                                                                                                                                                                                    
@FECINI CHAR(8),
                                                                                                                                                                                                                                             
@FECFIN CHAR(8)
                                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIP_FACTURAPRO Where Usuario=user_name()
                                                                                                                                                                                                         
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
Insert into SIP_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                    
Select b.nombre,(a.totcob58+a.totigv58)
                                                                                                                                                                                                                      
From pdordser58 a,aaclientesaa b
                                                                                                                                                                                                                             
where 
                                                                                                                                                                                                                                                       
convert(char(8),fecemi52,112) between @FECINI and @FECFIN and 
                                                                                                                                                                                               
tipcli02=claseabc and codcli02=contribuy
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                    
--=======================================================
                                                                                                                                                                                                    
--Insert into SIP_FACTURAPRO (NOMBRE,TOTAL)
                                                                                                                                                                                                                  
--exec NPT9_bd_nept.DBO.SIP_RANKING_FACTURACION_PROY @FECINI,@FECFIN
                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
Update SIP_FACTURAPRO set nombre=b.nombre
                                                                                                                                                                                                                    
from SIP_FACTURAPRO a, aaclientesaa b
                                                                                                                                                                                                                        
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'
                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),
                                                                                                                                                                         
REPORTE= 'facturacion.rpt'
                                                                                                                                                                                                                                    
From SIP_FACTURAPRO

                                                                                                                                                                                                                                         
Where Usuario=user_name()
                                                                                                                                                                                                                                    
group by nombre
                                                                                                                                                                                                                                              
Order by 2 desc                                                                                                                                                                                                                                                
----                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[SIP_RESUMEN_CONCEPTOS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIP_RESUMEN_CONCEPTOS]
@CODCOM CHAR(2),
@NUMSER CHAR(3),
@FECINI CHAR(8),
@FECFIN CHAR(8),
@CONDIC CHAR(1),
@TIPCLI CHAR(1),
@CODCLI VARCHAR(11)
AS


if @CONDIC='0' 
Select 
    descon53=e.descon51,c.numcom52,docdes52=c.codcli02,d.nombre,valcon53=a.valcob59,
    DOLARES=convert(decimal(15,2),a.valcob59),
    SOLES=a.igvser59,numcer52=c.numord58,e.descon51
    From 
    Pddorser59 a,PDORDSER58 c,AAClientesAA d,PQCONCOM51 e
    Where 
    a.numord58=c.numord58 and c.flgval58='1' and c.flgemi58='1' and 
    c.tipcli02=d.claseabc and c.codcli02=d.contribuy and 
    convert(char(8),c.fecemi52,112) between @FECINI and @FECFIN and substring(c.numcom52,1,3)=@NUMSER and 
    left(a.codcon51,5)=e.codcon51
    Order by 
    descon53,d.nombre,c.numcom52
else
    Select 
    descon53=e.descon51,c.numcom52,docdes52=c.codcli02,d.nombre,valcon53=a.valcob59,
    DOLARES=convert(decimal(15,2),a.valcob59),
    SOLES=a.igvser59,numcer52=c.numord58,e.descon51
    From 
    Pddorser59 a,PDORDSER58 c,AAClientesAA d,PQCONCOM51 e
    Where 
     a.numord58=c.numord58 and c.flgval58='1' and c.flgemi58='1' and 
    c.tipcli02=d.claseabc and c.codcli02=d.contribuy and 
    convert(char(8),c.fecemi52,112) between @FECINI and @FECFIN and 
    substring(c.numcom52,1,3)=@NUMSER and left(a.codcon51,5)=e.codcon51 and
    c.tipcli02=@TIPCLI and c.codcli02=@CODCLI
    Order by 
    descon53,d.nombre,c.numcom52
GO
/****** Object:  StoredProcedure [dbo].[SIP_TAR_TARIFARIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIP_TAR_TARIFARIO] AS

Select 
a.CONCEP51,b.DESCON51,a.SERVIC52,a.DESSER52,
a.TARIFA52,a.STATUS52,DESSTA52=case when a.STATUS52='A' then 'ACTIVA' else 'INACTIVA' end,FECHA=GETDATE()
From Pdservic52 a, PQCONCOM51 b
Where 
a.CONCEP51=b.CODCON51 and a.VISIBLE52='S' and b.visible51='S'
Order by b.DESCON51,a.DESSER52
GO
/****** Object:  StoredProcedure [dbo].[SIP_TOTAL_MENSUAL_FACTURACION]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE  [dbo].[SIP_TOTAL_MENSUAL_FACTURACION]
                                                                                                                                                                                                               
@ANIO CHAR(4)
                                                                                                                                                                                                                                                
AS
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Delete from SIP_FACMENPRO where usuario=user_name()
                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
--FACTURACION REALIZADA
                                                                                                                                                                                                                                      
--=====================
                                                                                                                                                                                                                                      
INSERT INTO SIP_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
Select 
                                                                                                                                                                                                                                                      
datepart(month,fecemi52),datename(month,fecemi52),(totcob58+totigv58)
                                                                                                                                                                                        
From PDORDSER58
                                                                                                                                                                                                                                              
where datepart(year,fecemi52)=convert(int,@anio) 
                                                                                                                                                                                                            

                                                                                                                                                                                                                                                             
/*--NOTAS DE CREDITO TRAIDAS REMOTAMENTE DESDE ULTRAGESTION
                                                                                                                                                                                                  
--=======================================================
                                                                                                                                                                                                    
INSERT INTO SIG_FACMENPRO (NUMMES,NOMMES,TOTAL)
                                                                                                                                                                                                              
EXEC NPT9_BD_NEPT..SIG_TOTAL_MENSUAL_FAC_PROY @ANIO
                                                                                                                                                                                                     
*/
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Select NUM_MES=NUMMES,NOM_MES=NOMMES,TOTAL=sum(TOTAL),anio=@ANIO,fecha=getdate(),
                                                                                                                                                                            
reporte= 'facturacion_mensual.rpt'
                                                                                                                                                                                                                            
From SIP_FACMENPRO
                                                                                                                                                                                                                                           
where usuario=user_name()
                                                                                                                                                                                                                                    
group by NUMMES,NOMMES
                                                                                                                                                                                                                                       
order by NUMMES                                                                                                                                                                                                                                                

GO
/****** Object:  StoredProcedure [dbo].[SP_ABOCARFEC]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ABOCARFEC    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_ABOCARFEC]
@FECINI CHAR(8),
@FECFIN CHAR(8),
@TIPCLIE VARCHAR(1),
@CLIENTE VARCHAR(11)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Select 
a.tipdes52,a.docdes52,a.codcom50,a.numcom52,fecope=a.feccom52,total=a.subtot52+a.igvtot52,
tipo="C",signo=-1,b.descom50,c.nombre
From ddcabcom52 a,DQCOMPAG51 b,AAClientesAA c
Where 
a.FlgEmi52='1' and a.FlgVal52 = '1' and 
a.tipdes52=@TIPCLIE and (a.docdes52=@CLIENTE or a.docdes52=substring(@CLIENTE,3,8)) and 
convert(char(8),a.feccom52,112) between @FECINI and @FECFIN and 
a.codcom50=b.codcom50 and (a.docdes52=c.CONTRIBUY or a.docdes52=c.catcliente)
Union all
Select 
a.tipdes52,a.docdes52,b.codcom50,b.numcom52,fecope=a.fecpag56,total=b.monpag57*-1,tipo="A",
signo=+1,c.descom50,d.nombre
From 
ddpagos56 a,ddPagCom57 b,DQCOMPAG51 c,AAClientesAA d
Where 
a.NroPag56=b.NroPag56 and 
a.tipdes52=@TIPCLIE and (a.docdes52=@CLIENTE or a.docdes52=substring(@CLIENTE,3,8)) and 
convert(char(8),a.fecpag56,112) between @FECINI and @FECFIN and 
b.codcom50=c.codcom50 and (a.docdes52=d.CONTRIBUY or a.docdes52=d.catcliente)
GO
/****** Object:  StoredProcedure [dbo].[SP_ABONOCLIE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ABONOCLIE]  
@FECINI CHAR(8),  
@FECFIN CHAR(8),  
@TIPCLIE CHAR(1),  
@CLIENTE VARCHAR(11)  
AS  
  
  
Select   
a.tipdes52,a.docdes52,a.fecpag56,a.nropag56,c.destip48,b.nomban49,a.nrodoc56,a.monpag56,d.nombre  
From   
ddpagos56 a
inner join dqtippag48 c on (a.codtip48=c.codtip48)
inner join AAClientesAA d  on (a.docdes52=d.contribuy or a.docdes52=d.catcliente)
left  join DQBANCOS49 b on (a.codban49=b.codban49 )
Where   
a.tipdes52=@TIPCLIE and (a.docdes52=@CLIENTE or a.docdes52=substring(@CLIENTE,3,8)) and   
(convert(char(8),a.fecpag56,112)>=@FECINI and convert(char(8),a.fecpag56,112)<=@FECFIN)    

GO
/****** Object:  StoredProcedure [dbo].[SP_ActaApertura_Ins]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ActaApertura_Ins]
       @NumSol    char( 7 ),
       @CodUbi    Char( 9 ),
       @NomTra    varchar( 50 ),
       @PlaVeh    varchar( 10 ),
       @NroDocSal varchar( 15 ),
       @FecSalTer datetime ,
       @HorSalTer datetime ,
       @PesTotSal decimal( 10, 2 ) ,
       @FecTer    datetime,
       @HorTer    datetime,
       @ObsAct    varchar( 100 ),
       @ClaBul	   char( 3 ),
       @NomUsu    varchar( 15 ),
       @FlgEmi    char( 1 )
AS 

SET NOCOUNT ON

Declare @NumNue Char( 7 )
Declare @Numero Numeric( 7 )

SELECT @Numero = ISNULL( MAX( NumActa ), 0 ) 
FROM   DDACTAPER11

SET    @NumNue = Right( '0000000' + RTrim( LTrim( Convert( Char( 7 ), @Numero + 1 ) ) ), 7 )

INSERT INTO DDACTAPER11 
       ( NumActa, NumSol,  NomTra,  PlaVeh,  NroDocSal,  FecSalTer,  HorSalTer,  PesTotSal, 
         FecTer,  HorTer,  ObsAct,  ClaBul,  FecUsu11, NomUsu11,  FlgEmi11, CodUbi  ) 
VALUES ( @NumNue, @NumSol, @NomTra, @PlaVeh, @NroDocSal, @FecSalTer, @HorSalTer, @PesTotSal, 
         @FecTer, @HorTer, @ObsAct, @ClaBul, getDate(), @NomUsu,  @FlgEmi,  @CodUbi )

SELECT @NumNue as NroActa

SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[SP_ActaInventario_Ins]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC SP_ActaInventario_Ins 'A004577','20070709','EJEMPLO 01'

ALTER PROCEDURE [dbo].[SP_ActaInventario_Ins]
       @NumSol  char( 7 ),
       @FecAct  datetime ,
       @ObsAct  varchar( 300 ),
       @NomUsu    varchar( 15 ),
       @FlgAbi    char( 1 ),
       @FlgMal    char( 1 ),
       @FlgRec    char( 1 ),
       @FlgFal    char( 1 ),
       @FlgSob    char( 1 ),
       @FlgEmi    char( 1 )
AS 

SET NOCOUNT ON

Declare @NumNue Char( 7 )
Declare @Numero Numeric( 7 )

SELECT @Numero = ISNULL( MAX( NumActa ), 0 ) 
FROM   DDACTAINV13

SET    @NumNue = Right( '0000000' + RTrim( LTrim( Convert( Char( 7 ), @Numero + 1 ) ) ), 7 )

INSERT INTO DDACTAINV13 
       ( NumActa,    NumSol,      FecActa,     ObsAct,      NomUsu13, FlgEmi13,
         FlgAbierto, FlgMalaCond, FlgReconoci, FlgFaltante, FlgSobrante ) 
VALUES ( @NumNue,    @NumSol,     @FecAct,     @ObsAct,     @NomUsu,  @FlgEmi,
         @FlgAbi,    @FlgMal,     @FlgRec,     @FlgFal,     @FlgSob   )

SELECT @NumNue as NroActa

SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[SP_Actualiza_Acta_Aper_Det]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Actualiza_Acta_Aper_Det]
       @NumActa   Char( 7  ),
       @CodCon04  Char( 11 ),
       @PrecOrig  Char( 15 ),
       @PrecAdu   Char( 15 ),
       @NroBulRec Decimal( 10, 2 ),
       @NroBulFal Decimal( 10, 2 ),
       @NroBulSob Decimal( 10, 2 )
As

SET NOCOUNT ON

If Exists( SELECT NumActa From DDACTAPERDET12 Where NumActa = @NumActa And CodCon04 = @CodCon04 ) Begin
   Update DDACTAPERDET12
   Set PrecOrig = @PrecOrig, 
       PrecAdu  = @PrecAdu,
       NroBulRec = @NroBulRec,
       NroBulFal = @NroBulFal,
       NroBulSob = @NroBulSob
   Where NumActa = @NumActa And CodCon04 = @CodCon04 
End
Else Begin
   Insert Into DDACTAPERDET12
          ( NumActa,  CodCon04,  PrecOrig,  PrecAdu,  NroBulRec,  NroBulFal,  NroBulSob )
   Values ( @NumActa, @CodCon04, @PrecOrig, @PrecAdu, @NroBulRec, @NroBulFal, @NroBulSob )
End

SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZA_NRO_RETIRO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ACTUALIZA_NRO_RETIRO]    
@NroServicio varchar(10),      
@idCarrito varchar(7)      
as      
BEGIN    
  
  /*SET @NroOrdRetiro = 'S' + right('000000' + convert(varchar(6),@NroOrdRetiro) ,6)    
  
  UPDATE Logistica.dbo.CA_OrdenServicio    
     SET NroOrdRet = @NroOrdRetiro    
   WHERE NroServicioIntegral = @NroServicio   
  
  UPDATE Terminal.dbo.ssi_orden  
     SET ord_retiro = @NroOrdRetiro,  
         numDua   = null  
   WHERE Ord_codigo = @NroServicio*/

  UPDATE OrdRetiroCarrito
   SET NROServicio = @NroServicio
  where IdOrd = @idCarrito
    
END 


GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZA_NRO_RETIROADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ACTUALIZA_NRO_RETIROADU]      
@NroServicio varchar(10),        
@NroOrdRetiro varchar(7)        
as        
BEGIN      
 -- SET @NroOrdRetiro = 'S' + right('000000' + convert(varchar(6),@NroOrdRetiro) ,6)      
    
  /*UPDATE Logistica.dbo.CA_OrdenServicio      
     SET NroOrdRet = @NroOrdRetiro      
   WHERE NroServicioIntegral = @NroServicio     
    
  UPDATE Terminal.dbo.ssi_orden    
     SET ord_retiro = @NroOrdRetiro,    
         numDua   = null    
   WHERE Ord_codigo = @NroServicio  */
  
   UPDATE  OrdRetiroCarrito
     SET NroSErvicio = @NroServicio
   WHERE IdOrd = @NroOrdRetiro
      
END 



GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizaMontosDUA_DESPACHO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ActualizaMontosDUA_DESPACHO]  
(  
@numcer13 char(9),  
@numser12 char(4),  
@buldes14 int,  
@pesdes14 decimal(9,3),  
@fobdes14 decimal(9,3),  
@fledes14 decimal(9,3),  
@segdes14 decimal(9,3)  
)  
AS  
BEGIN  

--|FML 15-04-2015
--|OBTENER NRO BULTOS A RETIRAAR DE MANERA CORRECTA
--DECLARE @bulret INT

--select @bulret=numbul17 
--from DDSerDes17 with (nolock) 
--where numcer13=@numcer13 AND numser17=@numser12
--|  

UPDATE DDDCeAdu14 SET buldes14 = buldes14 + @buldes14, pesdes14 = pesdes14 + @pesdes14, fobdes14 = fobdes14 + @fobdes14,   
    fledes14 = fledes14 + @fledes14, segdes14 = segdes14 + @segdes14   
WHERE numcer13 = @numcer13   
  and numser12 = @numser12  
  
END 
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizaMontosDUA_DESPACHO_Servicios]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ActualizaMontosDUA_DESPACHO_Servicios]  
(  
@numdui11 char(13),  
@numser12 varchar(4),  
@buldes12 decimal(9,3),  
@pesdes12 decimal(9,3),  
@fobdes12 decimal(9,3)  
)  
AS  
BEGIN  

--|FML 15-04-2015
--|OBTENER NRO BULTOS A RETIRAAR DE MANERA CORRECTA
--DECLARE @bulret INT

--select @bulret=numbul17 
--from DDSerDes17 with (nolock) 
--where numdui16=@numdui11 AND numser17=@numser12
--|  
  
UPDATE DDSerDep12 SET   
    buldes12=buldes12+@buldes12, pesdes12=pesdes12+@pesdes12, fobdes12=fobdes12+@fobdes12  
WHERE numdui11=@numdui11   
  and numser12=@numser12  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_MERCADERIA_EN_ALMACEN]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_MERCADERIA_EN_ALMACEN]
@TIPDEP char(1),
@NUMCER varchar(9),
@NUMSER varchar(20),
@CODUBI varchar(9),
@NUMORD varchar(7),
@PREUNI decimal(15,3),
@NUMSOL varchar(7),
@DUIDES varchar(14),
@SERDES varchar(20),
@DUIDEP varchar(13)
AS
Declare 
@NUMBUL decimal(15,3),
@PREENT decimal(15,3),
@NUMBUL2 decimal(15,3),
@PREENT2 decimal(15,3),
@NUMBUL3 decimal(15,3),
@PREENT3 decimal(15,3)


Select @NUMBUL=coalesce(sum(b.numbul80),0),@PREENT=coalesce(sum(b.preent80),0)
From DDentmer79 a
Inner Join DDDEnMer80 b on a.nument79=b.nument79
Where a.numcer13=@NUMCER and numser70=@NUMSER and a.flgval79='1'

Update DDMerAlm73 set bulret73=@NUMBUL Where numcer73=@NUMCER and numser70=@NUMSER and codubi71=@CODUBI

if @TIPDEP='S'
Begin
	Select @NUMBUL2=coalesce(sum(b.numbul80),0),@PREENT2=coalesce(sum(b.preent80),0)
	From ddentmer79 a
	Inner Join dddenmer80 b on a.nument79=b.nument79
	Where a.numcer13=@NUMCER and b.numser70=@NUMSER and a.numret75=@NUMORD and a.flgval79='1'

	Update DDDReSim76 set bulret76=@NUMBUL2,preret76=@PREENT2 Where numret75=@NUMORD and numser67=@NUMSER
	Update DDDSoSim67 set bulent67=@NUMBUL,preent67=@PREENT Where numsol62=@NUMSOL and numser67=@NUMSER
End

if @TIPDEP='A'
Begin
	Select @NUMBUL3=coalesce(sum(b.numbul80),0),@PREENT3=coalesce(sum(b.preent80),0)
	From ddentmer79 a
	Inner Join dddenmer80 b on a.nument79=b.nument79
	where a.numcer13=@NUMCER and b.numser70=@NUMSER and a.numdui16=@DUIDES and a.flgval79='1'

	Update DDSerDes17 set bulent17=@NUMBUL3,cifent17=@PREENT3 Where numdui16=@DUIDES and numser12=@NUMSER
	
	Select @NUMBUL3=coalesce(sum(b.numbul80),0),@PREENT3=coalesce(sum(b.preent80),0)
	From ddentmer79 a
	Inner Join dddenmer80 b on a.nument79=b.nument79
	where a.numcer13=@NUMCER and b.numser70=@NUMSER and a.numdui11=@DUIDEP and a.flgval79='1'

	Update DDDCeAdu14 set bulent14=@NUMBUL3,cifent14=@PREENT3 Where numcer13=@NUMCER and numdui11=@DUIDEP and numser12=@NUMSER
	
	Select @NUMBUL3=coalesce(sum(b.numbul80),0),@PREENT3=coalesce(sum(b.preent80),0)
	From ddentmer79 a
	Inner Join dddenmer80 b on a.nument79=b.nument79
	where a.numdui11=@DUIDEP and b.numser70=@NUMSER and a.flgval79='1'

	Update DDSerDep12 set bulent12=@NUMBUL3,cifent12=@PREENT3 Where numdui11=@DUIDEP and numser12=@NUMSER
End
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_MERCADERIA_EN_ALMACEN_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_MERCADERIA_EN_ALMACEN_NEW] @TIPDEP CHAR(1)
	,@NUMCER VARCHAR(9)
	,@NUMSER VARCHAR(20)
	,@CODUBI VARCHAR(9)
	,@NUMORD VARCHAR(7)
	,@PREUNI DECIMAL(15, 3)
	,@NUMSOL VARCHAR(7)
	,@DUIDES VARCHAR(14)
	,@SERDES VARCHAR(20)
	,@DUIDEP VARCHAR(13)
AS
DECLARE @NUMBUL DECIMAL(15, 3)
	,@NUMBULUC DECIMAL(15, 3)
	,@PREENT DECIMAL(15, 3)
	,@NUMBUL2 DECIMAL(15, 3)
	,@PREENT2 DECIMAL(15, 3)
	,@NUMBUL3 DECIMAL(15, 3)
	,@NUMBUL3UC DECIMAL(15, 3)
	,@PREENT3 DECIMAL(15, 3)

SELECT @NUMBUL = coalesce(sum(b.numbul80), 0)
	,@PREENT = coalesce(sum(b.preent80), 0)
	,@NUMBULUC = coalesce(sum(b.numbul12), 0)
FROM DDentmer79 a
INNER JOIN DDDEnMer80 b ON a.nument79 = b.nument79
WHERE a.numcer13 = @NUMCER
	AND numser70 = @NUMSER
	AND a.flgval79 = '1'

UPDATE DDMerAlm73
SET bulret73 = @NUMBUL
,bulret12 = @NUMBULUC
WHERE numcer73 = @NUMCER
	AND numser70 = @NUMSER
	AND codubi71 = @CODUBI

IF @TIPDEP = 'S'
BEGIN
	SELECT @NUMBUL2 = coalesce(sum(b.numbul80), 0)
		,@PREENT2 = coalesce(sum(b.preent80), 0)
	FROM ddentmer79 a
	INNER JOIN dddenmer80 b ON a.nument79 = b.nument79
	WHERE a.numcer13 = @NUMCER
		AND b.numser70 = @NUMSER
		AND a.numret75 = @NUMORD
		AND a.flgval79 = '1'

	UPDATE DDDReSim76
	SET bulret76 = @NUMBUL2
		,preret76 = @PREENT2
	WHERE numret75 = @NUMORD
		AND numser67 = @NUMSER

	UPDATE DDDSoSim67
	SET bulent67 = @NUMBUL
		,preent67 = @PREENT
	WHERE numsol62 = @NUMSOL
		AND numser67 = @NUMSER
END

IF @TIPDEP = 'A'
BEGIN
	SELECT @NUMBUL3 = coalesce(sum(b.numbul80), 0)
		,@PREENT3 = coalesce(sum(b.preent80), 0)
		,@NUMBUL3UC = coalesce(sum(b.numbul12), 0)
	FROM ddentmer79 a
	INNER JOIN dddenmer80 b ON a.nument79 = b.nument79
	WHERE a.numcer13 = @NUMCER
		AND b.numser70 = @NUMSER
		AND a.numdui16 = @DUIDES
		AND a.flgval79 = '1'

	UPDATE DDSerDes17
	SET bulent17 = @NUMBUL3
		,cifent17 = @PREENT3
		,bulent12 = @NUMBUL3UC
	WHERE numdui16 = @DUIDES
		AND numser12 = @NUMSER

	SELECT @NUMBUL3 = coalesce(sum(b.numbul80), 0)
		,@PREENT3 = coalesce(sum(b.preent80), 0)
		,@NUMBUL3UC = coalesce(sum(b.numbul12), 0)
	FROM ddentmer79 a
	INNER JOIN dddenmer80 b ON a.nument79 = b.nument79
	WHERE a.numcer13 = @NUMCER
		AND b.numser70 = @NUMSER
		AND a.numdui11 = @DUIDEP
		AND a.flgval79 = '1'

	UPDATE DDDCeAdu14
	SET bulent14 = @NUMBUL3
		,cifent14 = @PREENT3
		,bulent12 = @NUMBUL3UC
	WHERE numcer13 = @NUMCER
		AND numdui11 = @DUIDEP
		AND numser12 = @NUMSER

	SELECT @NUMBUL3 = coalesce(sum(b.numbul80), 0)
		,@PREENT3 = coalesce(sum(b.preent80), 0)
	FROM ddentmer79 a
	INNER JOIN dddenmer80 b ON a.nument79 = b.nument79
	WHERE a.numdui11 = @DUIDEP
		AND b.numser70 = @NUMSER
		AND a.flgval79 = '1'

	UPDATE DDSerDep12
	SET bulent12 = @NUMBUL3
		,cifent12 = @PREENT3
	WHERE numdui11 = @DUIDEP
		AND numser12 = @NUMSER
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_OrdRetiroAduanaWeb]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_OrdRetiroAduanaWeb]
@idOrd  varchar(10),
@pDua   varchar(20) ,
@pSerie varchar(5) ,
@Certifi varchar(20)
As

begin
  UPDATE  OrdRetiroAduanaWeb
   SET DuaDespacho = @pDua,
       Estado      = 'P',  --Aprobado
       fechaConf   = getdate()
 WHERE IdOrd = @idOrd
    AND numser12 = @pSerie
    AND numcer13 = @Certifi 
return 0
end

GO
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_OrdretiroClienteWeb]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ACTUALIZAR_OrdretiroClienteWeb]
@idOrd  varchar(10),
@NroOrde   varchar(20) ,
@pSerie varchar(5) ,
@Certifi varchar(20)
As

begin
  UPDATE  OrdRetiroAduanaWeb
   SET  OrdRetiro   = @NroOrde      
 WHERE IdOrd = @idOrd
    AND numser12 = @pSerie
    AND numcer13 = @Certifi 
return 0
end

GO
/****** Object:  StoredProcedure [dbo].[SP_ALERTA_SALIDA_CARGA_CLIENTE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ALERTA_SALIDA_CARGA_CLIENTE]        
AS            
            
DECLARE @ASUNTO varchar(200)            
DECLARE @PARA varchar(500)            
DECLARE @CC varchar(500)            
DECLARE @sDescri VarChar(100)        
DECLARE @NomFWD varchar(500)          
DECLARE @sSiEnvio int        
DECLARE @sCont int        
DECLARE @sContRuc int        
        
DECLARE @strama varchar (500)                             
DECLARE @msg varchar (8000)            
        
BEGIN        
 set @PARA = 'carmen.rivadeneira@neptunia.com.pe; giovana.sandoval@neptunia.com.pe; ofuentes@sucdenperu.com.pe; jscudellari@sucdenperu.com.pe; vnavarro@sudazucar.com.pe; jhuallpa@sucdenperu.com.pe'        
 --set @PARA = 'al.porras@neptunia.com.pe'        
 --set @PARA = 'jesus.leiva@neptunia.com.pe'        
 set @ASUNTO = 'Informe diario de cargas Sucden'          
 set @msg=''        
 --set @msg= 'TICKET     CERTIFICADO         FECHA INGRESO  FECHA SALIDA      EMB CANTID   CLIENTE                             DESCRIPCION' + char(13)        
 set @msg= 'TICKET     CERTIFICADO    FECHA INGRESO             FECHA SALIDA              EMB CANTID   CLIENTE                        DESCRIPCION' + char(13)        
 set @msg= @msg + '-----------------------------------------------------------------------------------------------------------------------------------------------------------------' + char(13)        
        
/*        
 set @msg='        
 <html>        
 <body>        
 <p style="font-family: Courier new; font-size: x-small">' +        
  @msg + char(13) +'        
 </body>        
 </html>'        
        
*/        
        
        
 /*set @sCont=0         
 DECLARE cursor_Ctrs CURSOR for                     
 select numtkt01 + ' ' + cast(numcer74 as char(15)) + ' ' +        
 cast(fecing01 as char(17))+ ' ' + cast(fecsal01 as char(17)) + ' ' +         
 codemb06 + ' ' + bultos + ' ' + cast(obsret75 as char(35)) + ' ' + desmer62        
 from DVRETMER01 order by numcer74 */      
     
 set @sCont=0         
 DECLARE cursor_Ctrs CURSOR for                     
 select numtkt01 + '   ' +       
 case when len(convert(char,numcer74))= 14 then convert(char,numcer74) else convert(char,convert(char,numcer74) + space(14 - len(convert(char,numcer74)))) end      
 + ' ' +      
 convert(char(24),fecing01,13)+ '  ' + convert(char(24),fecsal01,13) + '  ' +         
 codemb06 + ' ' +       
 case when len(convert(char,bultos)) = 8 then convert(char(8),bultos) else convert(char(8),convert(char,bultos) + space(8- len(convert(char,bultos)))) end      
 + ' ' +       
 case when len(convert(char,obsret75))= 30 then convert(char,obsret75) else convert(char,convert(char,obsret75) + space(30 - len(convert(char,obsret75)))) end       
 + ' ' + desmer62        
 from DVRETMER01 order by numcer74     
      
  OPEN cursor_Ctrs        
  FETCH NEXT FROM cursor_Ctrs        
  INTO @sTrama        
                         
  WHILE @@FETCH_STATUS = 0                    
  BEGIN             
   set @msg=@msg + @sTrama + char(13)        
   set @sCont=@sCont+1        
   FETCH NEXT FROM cursor_Ctrs        
   INTO @sTrama        
  end                    
  CLOSE cursor_Ctrs        
  DEALLOCATE cursor_Ctrs        
        
 set @msg= @msg + '-----------------------------------------------------------------------------------------------------------------------------------------------------------------'        
        
        
 if @sCont>0         
  begin         
        
    Execute master.dbo.xp_smtp_sendmail          
    @FROM   = 'TIForwarders@neptunia.com.pe',          
    @TO   = @PARA,          
    @message = @msg ,        
    @subject = @ASUNTO,          
    --@type = 'text/html',        
    @server = 'correo.neptunia.com.pe'        
  end        
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_ANULAR_ORDEN_WEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ANULAR_ORDEN_WEB]
@ruc varchar(20),
@nroServicio varchar (20)
as
update ordRetiroCarrito
SET Estado = 'A'
Where NroServicio = @nroServicio
and   Contribuy = @ruc
return 0
GO
/****** Object:  StoredProcedure [dbo].[SP_ASIGNAR_CONTENEDOR_ADUANERO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_ASIGNAR_CONTENEDOR_ADUANERO    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_ASIGNAR_CONTENEDOR_ADUANERO]
@NUMSOL CHAR(7) 
AS

Select a.fecsol10,a.codcli02,b.nombre,a.flgval10,a.flgtar10,a.flgctr10,a.flgcer10
From DDSolAdu10 a,aaclientesaa b
where a.tipcli02=b.claseabc and a.codcli02=b.contribuy and
a.numsol10=@NumSol
GO
/****** Object:  StoredProcedure [dbo].[SP_ASIGNAR_CONTENEDOR_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_ASIGNAR_CONTENEDOR_SIMPLE    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_ASIGNAR_CONTENEDOR_SIMPLE]
@NUMSOL CHAR(8)
AS

Select a.fecsol62,a.codcli02,b.nombre,a.flgval62,a.flgtar62,a.flgctr62,a.flgcer62
From DDSolSim62 a,AACLIENTESAA b
Where a.tipcli02=b.claseabc and a.codcli02=b.contribuy and
a.numsol62=@NumSol
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_ADU1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_BALANZA_ADU1    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_BALANZA_ADU1]
@NUMSOL CHAR(7)
AS

Select a.*,b.nombre
From DDSolAdu10 a,AAClientesAA b 
Where a.codcli02=b.contribuy and a.numsol10=@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_ADU2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_BALANZA_ADU2    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[SP_BALANZA_ADU2]
@NUMORD CHAR(7)
AS

Select a.fecret18,a.flgval18,a.flgemi18,b.codage19,b.tipcli02,b.codcli02,
c.nombre
From DRRetAdu18 a,DDDuiDes16 b,AAClientesAA c
Where a.numdui16=b.numdui16 and 
b.tipcli02=c.claseabc and b.codcli02=c.contribuy and
a.numret18=@NUMORD
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_ENTREGA_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_BALANZA_ENTREGA_ADU    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[SP_BALANZA_ENTREGA_ADU]
@NUMENT CHAR(7)
AS

Select 
a.numret75,a.numdui16,a.numdui11,a.numcer13,c.codage19,c.tipcli02,c.codcli02,d.nombre,
a.numpla79,a.numtkt01,a.bultot79,a.codemb06,a.flgval79,a.flgemi79,a.ultcer79
From 
DDEntMer79 a,DRRetAdu18 b,DDDuiDes16 c,AAClientesAA d
Where 
a.numret75=b.numret18 and b.numdui16=c.numdui16 and 
c.tipcli02=d.claseabc and c.codcli02=d.contribuy and
a.nument79=@NUMENT
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_ENTREGA_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_BALANZA_ENTREGA_SIM    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_BALANZA_ENTREGA_SIM]
@NUMENT CHAR(7)
AS

Select 
a.numret75,c.numsol62,b.numcer74,b.codage19,c.tipcli02,c.codcli02,d.nombre,a.numpla79,a.numtkt01,
a.bultot79,a.codemb06,a.flgemi79,a.flgval79,a.ultcer79
From 
DDEntMer79 a,DDRetSim75 b,DDCerSim74 c,AAClientesAA d
Where 
a.nument79=@NUMENT and a.numret75=b.numret75 and b.numcer74=c.numcer74 And 
c.tipcli02=d.claseabc and c.CodCli02=d.Contribuy
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_SIM1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_BALANZA_SIM1    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_BALANZA_SIM1]
@NUMSOL CHAR(7)
AS

Select a.*,b.nombre
From DDSolSim62 a,AAClientesAA b
Where a.codcli02=b.contribuy and a.numsol62=@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_SIM2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_BALANZA_SIM2    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_BALANZA_SIM2]
@NUMORD CHAR(7)
AS

Select a.fecret75,a.flgval75,a.flgemi75,a.codage19,b.tipcli02,b.codcli02,c.contribuy,c.nombre
From DDRetSim75 a,DDCerSim74 b,AAClientesAA c
Where a.numcer74= b.numcer74 and
b.tipcli02=c.claseabc and b.codcli02=c.contribuy and
a.numret75=@NUMORD
GO
/****** Object:  StoredProcedure [dbo].[SP_Borrar_IMAGEN]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Borrar_IMAGEN]

@NroId varchar(10),
@archivo varchar(200)
AS

Begin

Delete from DRUTADUA where  path = @archivo 

END


GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCA_OTDESPACHO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_BUSCA_OTDESPACHO]    
@OT VARCHAR(8)    
AS    
BEGIN    
SET NOCOUNT ON;    
	 --|SETEO DE VARIABLES    
	 SET @OT=LTRIM(RTRIM(@OT))    
	 --|    
	 DECLARE @ICOUNT VARCHAR(250)    
	 SELECT @ICOUNT=COUNT(*)    
	 FROM DDPLAREC32 WITH (NOLOCK)    
	 WHERE NRO_PLAREC32=@OT    
	     
	 IF @ICOUNT=0    
	 BEGIN    
	  SELECT 'La OT ingresada no se encuentra Registrada' as 'MENSAJE'    
	  RETURN;    
	 END    
	     
	 DECLARE @STATUS VARCHAR(50)    
	 SELECT @STATUS=CASE WHEN A.FLGREC32='R' THEN 'REGISTRADO'      
						 WHEN A.FLGREC32='P' THEN 'PENDIENTE'      
					     WHEN A.FLGREC32='F' THEN 'FINALIZADO' 
					     WHEN A.FLGREC32='A' THEN 'ANULADO'              
					     END      	                 
	 FROM         
	 DDPLAREC32 A WITH (NOLOCK)        
	 LEFT JOIN DDORDSER58 C WITH (NOLOCK) ON C.numord58=A.numord58      
	 WHERE A.NRO_PLAREC32=@OT    
	     
	 IF LTRIM(RTRIM(@STATUS))<>'FINALIZADO'    
	 BEGIN    
	  SELECT 'La OT se encuentra en estado: ' + @STATUS + ', Para registrar el Despacho debe estar en estado FINALIZADO' as 'MENSAJE'    
	  RETURN;    
	 END    
	     
	 SELECT     
	 '' AS 'MENSAJE',    
	 D.CLASEABC,    
	 D.CONTRIBUY,LTRIM(RTRIM(D.NOMBRE)) AS NOMBRE,    
	 TIPOUNIDAD=CASE WHEN ISNULL(A.TIPOUNIDAD,'')='' 
					 THEN ISNULL(B.TIPOUNIDAD33,'')
					 ELSE A.TIPOUNIDAD
					 END
	 ,A.NUMORD58,    
	 ISNULL(C.NRO_PLAREC32,'') AS DATO,    
	 C.FECALLEG32,    
	 C.FECSAL32,    
	 ISNULL(C.STAT_FAC_GUIA32,'') AS STAT_FAC_GUIA32,    
	 ISNULL(C.RESPON32,'') AS RESPON32,    
	 ISNULL(C.OBSERVACION32,'') AS OBSERVACION32,    
	 ISNULL(C.UNIDADES_VUELTA32,0) AS UNIDADES_VUELTA32,    
	 ISNULL(C.TIP_DEVO32,'') AS TIP_DEVO32,    
	 ISNULL(C.MOT_DEVO32,'') AS MOT_DEVO32,    
	 ISNULL(C.OTD32,'') AS OTD32,    
	 ISNULL(C.RES_OTD32,'') AS RES_OTD32,    
	 ISNULL(C.OBSER_OTD32,'') AS OBSER_OTD32,  
	 ISNULL(C.OBSERVDATO32,'') AS OBSERVDATO32    
	 FROM DDPLAREC32 A WITH (NOLOCK)    
	 LEFT JOIN DDDETREC33 B WITH (NOLOCK) ON A.ID_PLAREC32=B.ID_PLAREC32    
	 LEFT JOIN DDSTADESP32 C WITH (NOLOCK) ON A.NRO_PLAREC32=C.NRO_PLAREC32    
	 INNER JOIN AACLIENTESAA D WITH (NOLOCK)  ON A.CODCLIENTE=D.CONTRIBUY    
	 WHERE A.NRO_PLAREC32=@OT    
	     
SET NOCOUNT OFF;    
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_DESCUENTOS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_BUSCAR_DESCUENTOS    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[SP_BUSCAR_DESCUENTOS]
@NUMCER VARCHAR(9)
AS

Select * from DDDesCer52
where numcer52=@NUMCER and codcom50=''
GO
/****** Object:  StoredProcedure [dbo].[SP_CA_CompletaVerifica]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[SP_CA_CompletaVerifica]
@Par_Cliente int,
@Par_Proceso varchar(1),
@Par_TipoFactura varchar(1)
AS
BEGIN
Declare @ValorMinimo decimal(19,4), @Result int
Declare @TipoCambio decimal(19,4), @PeriodoFin datetime

create table #ta_servicio 
(Servicio int,
Nombre varchar(255) null,
CodigoServicio varchar(5) null,
FlagTransporte varchar(1) null,
FlagDetraccion varchar(1) null,
FlagIgv varchar(1) null,
FlagAlmacenaje varchar(1) null,
Estado varchar(1) null,
FlagCamionaje varchar(1) null,
flagdetractransporte varchar(1) null)

insert into #ta_servicio
select * from ta_servicio

create table #vista_tipo_cambio
(fecha_cambio varchar(10),
tipo_moneda_origen varchar(3) null,
tipo_moneda_destino varchar(3) null,
tipo_cambio int null,
factor_cambio decimal(19,4) null)

insert into #vista_tipo_cambio
select * from vista_tipo_cambio

begin transaction
--save transaction t_general

--Obtenemos los datos del acuerdo
select @ValorMinimo = valorminimo, @PeriodoFin = finvigencia from ta_acuerdo where persona = @Par_Cliente

IF @@Error <> 0 
begin
	--ROLLBACK transaction t_general
	rollback transaction
	return -1
end

if isnull(@ValorMinimo, 0) = 0 
  begin
	set @ValorMinimo = 0
  end

--Se obtiene el tipo de cambio
select @TipoCambio = factor_cambio
from #vista_tipo_cambio
where tipo_moneda_destino = 'DOL' 
and convert(datetime,fecha_cambio, 111) = convert(datetime, convert(varchar,@PeriodoFin, 112), 112)


IF @@RowCount = 0
	set @TipoCambio = 1


exec @Result = SP_CA_CompletaSubtotales @Par_Cliente, @TipoCambio, @Par_Proceso, @Par_TipoFactura
IF @Result <> 0 
begin
	--ROLLBACK transaction t_general
	rollback transaction
	return -1
end

exec @Result = SP_CA_VerificarMinimoFactura @Par_Cliente, @ValorMinimo, @Par_Proceso, @Par_TipoFactura
IF @Result <> 0 
begin
	--ROLLBACK transaction t_general
	rollback transaction
	return - 1
end

COMMIT transaction

END

GO
/****** Object:  StoredProcedure [dbo].[SP_CALCULA_PRODUC_NO_NACIONAL]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CALCULA_PRODUC_NO_NACIONAL]  
@numCert varchar(20),  
@Ruc  varchar(20),  
@NameProd varchar(200)  
  
AS  
Begin  
DECLARE  
 @contribuy varchar(20),  
 @numdui11 varchar(20),  
 @numcer13 varchar(10),  
 @feccer13 datetime ,  
 @numser12 varchar(10),  
 @numbul14 int ,  
 @bulent14 int ,  
 @sldBul   int ,  
 @codemb06 varchar(5),   
 @desmer14 varchar(200),  
 @cantidaNacional int  
  
   
  
BEGIN  TRANSACTION
  
/*drop table #serie_Disp   
drop table #Reporte    
drop table #Nacional*/

 /*create table serie_Disp  
 (  
    serie varchar(4),  
    ruc   varchar(12),  
    numcer varchar(11)  
 )  

  create table Nacional  
 (  
    Deposito   varchar(20),   
    certificado varchar(10) ,  
    serie varchar(4),       
    Nacional int,  
    codemb06 varchar(5) ,     
    desmer17 varchar(200)  
     
 )  
  
  create table Reporte  
 (  
    contribuy varchar(20),  
    numdui11 varchar(30),  
    numcer13 varchar(10),  
    feccer13 datetime,  
    numser12 varchar(4),  
    numbul14 int,  
    bulent14 int,  
    sldBul int,  
    codemb06 varchar(10),  
    desmer14 varchar(200),   
    Nacional int  ,
    NoNacional int
     
 )  */
 
 Delete From Reporte  where contribuy = @Ruc

 insert into serie_Disp  
       Select serie= b.numser12, ruc = @Ruc , Certificado = a.numcer13  
	 From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d           
	 Where           
	  a.numcer13=b.numcer13 and   
	  a.numsol10=c.numsol10 and   
	  b.numser12=c.numser12 and   
	  a.numbul13-a.bulent13>=0 and   
	  b.numbul14-b.bulent14>0 and           
	  a.tipcli02=d.claseabc and a.codcli02=d.contribuy   
	 and a.codcli02=@Ruc and flgval13 = 1       
	 AND (a.numcer13 = @numCert or '0' = @numCert) --like  'A00540900%'     
	 order by a.numcer13, a.obscer13   

  
 insert into Nacional  
 select numdui11, numcer13 , numser12,sum(numbul17),codemb06,desmer17   
        from DDSerDes17 d, serie_Disp s where d.numdui16 in (  
  Select a.numdui16  
  From   
  DRRetAdu18 a,DDDuiDes16 b,DDCerAdu13 g,DDSolAdu10 e,DQMaeRep77 c,AAClientesAA d,AAClientesAA f   
  Where   
  a.numdui16=b.numdui16 and b.numcer13=g.numcer13 and g.numsol10=e.numsol10    
  and a.flgval18='1' and a.flgemi18='1' and a.codrep77=c.codrep11 and b.tipcli02=d.claseabc and b.codcli02=d.contribuy and b.CodAge19=f.cliente   
                and b.tipcli02=4 and b.codcli02=  @Ruc   
  and (b.numcer13 = @numCert or '0' = @numCert) )  
                and s.serie = d.numser12  
                and s.numcer =  d.numcer13  
        group by   numdui11,numcer13 , numser12, codemb06, desmer17    
  
   
  
  --select * from #Nacional  
  --select * from #Reporte  
    
    DECLARE  C_DISP_X_NACIONALIZAR CURSOR FOR   
     Select d.contribuy,a.numdui11,a.numcer13,a.feccer13,b.numser12,b.numbul14,b.bulent14, sldbul=b.numbul14-b.bulent14,  
            c.codemb06,b.desmer14          
 From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d           
 Where           
 a.numcer13=b.numcer13 and   
 a.numsol10=c.numsol10 and   
 b.numser12=c.numser12 and   
 a.numbul13-a.bulent13>=0 and   
 b.numbul14-b.bulent14>0 and           
 a.tipcli02=d.claseabc and a.codcli02=d.contribuy --and a.tipcli02=@TIPCLI     
 and a.codcli02= @Ruc and flgval13 = 1       
 AND (a.numcer13 = @numCert  or '0' =  @numCert)  
        and desmer14 like '%' + @NameProd +'%'   
 order by a.numcer13, a.obscer13   
  
  
   OPEN C_DISP_X_NACIONALIZAR   
   Fetch Next From C_DISP_X_NACIONALIZAR into @contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14  
   While @@FETCH_STATUS = 0  
   Begin   
  print 'Entro Cursos'  
       SET @cantidaNacional = 0  
       select @cantidaNacional = isnull(Nacional ,0)  
         from Nacional   
        where serie =  @numser12 and certificado = @numcer13  
  
    if @numbul14 - @cantidaNacional > 0
     insert into Reporte values(@contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14 , @cantidaNacional - @bulent14 ,@numbul14 - @cantidaNacional )  

    
   Fetch Next From  C_DISP_X_NACIONALIZAR into @contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14  
   End  
   Close C_DISP_X_NACIONALIZAR  
   deallocate C_DISP_X_NACIONALIZAR  
    
  
  
  Delete from  serie_Disp     
  Delete from  Nacional  
   Select numdui11 , Numcer13, CONVERT(varchar,Feccer13,103) as Feccer13, numser12,numbul14,bulent14,codemb06,desmer14,Nacional,NoNacional  from  Reporte  where contribuy = @Ruc

     if @@error <> 0
	begin
		rollback transaction
		return -1
	end
	commit transaction
END

GO
/****** Object:  StoredProcedure [dbo].[SP_CALCULA_PRODUC_NO_NACIONAL_SAA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CALCULA_PRODUC_NO_NACIONAL_SAA]  
@numCert varchar(20),  
@Ruc  varchar(20),  
@NameProd varchar(200)  ,
@DuaDeposito varchar(200) ,
@Ordenar varchar(200)
  
AS  
Begin  
DECLARE  
 @contribuy varchar(20),  
 @numdui11 varchar(20),  
 @numcer13 varchar(10),  
 @feccer13 datetime ,  
 @numser12 varchar(10),  
 @numbul14 int ,  
 @bulent14 int ,  
 @sldBul   int ,  
 @codemb06 varchar(5),   
 @desmer14 varchar(200),  
 @cantidaNacional int  
  
   
  
BEGIN  TRANSACTION
  
/*drop table #serie_Disp   
drop table #Reporte    
drop table #Nacional*/

 /*create table serie_Disp  
 (  
    serie varchar(4),  
    ruc   varchar(12),  
    numcer varchar(11)  
 )  

  create table Nacional  
 (  
    Deposito   varchar(20),   
    certificado varchar(10) ,  
    serie varchar(4),       
    Nacional int,  
    codemb06 varchar(5) ,     
    desmer17 varchar(200)  
     
 )  
  
  create table Reporte  
 (  
    contribuy varchar(20),  
    numdui11 varchar(30),  
    numcer13 varchar(10),  
    feccer13 datetime,  
    numser12 varchar(4),  
    numbul14 int,  
    bulent14 int,  
    sldBul int,  
    codemb06 varchar(10),  
    desmer14 varchar(200),   
    Nacional int  ,
    NoNacional int
     
 )  */
 
if @Ordenar = ''
  SET @Ordenar = 1

 Delete From Reporte  where contribuy = @Ruc

 insert into serie_Disp  
       Select serie= b.numser12, ruc = @Ruc , Certificado = a.numcer13  
	 From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d           
	 Where           
	  a.numcer13=b.numcer13 and   
	  a.numsol10=c.numsol10 and   
	  b.numser12=c.numser12 and   
	  a.numbul13-a.bulent13>=0 and   
	  b.numbul14-b.bulent14>0 and           
	  a.tipcli02=d.claseabc and a.codcli02=d.contribuy   
	 and a.codcli02=@Ruc and flgval13 = 1       
         AND (a.numcer13 like '%' + @numCert + '%') --like  'A00540900%'     
	-- AND (a.numcer13 = @numCert or '0' = @numCert) --like  'A00540900%'     
       AND a.feccer13 > '20081010'
	 order by a.numcer13, a.obscer13   

  
 insert into Nacional  
 select numdui11, numcer13 , numser12,sum(numbul17),codemb06,desmer17   
        from DDSerDes17 d, serie_Disp s where d.numdui16 in (  
  Select a.numdui16  
  From   
  DRRetAdu18 a,DDDuiDes16 b,DDCerAdu13 g,DDSolAdu10 e,DQMaeRep77 c,AAClientesAA d,AAClientesAA f   
  Where   
  a.numdui16=b.numdui16 and b.numcer13=g.numcer13 and g.numsol10=e.numsol10    
  AND g.feccer13 > '20081010'
  and a.flgval18='1' and a.flgemi18='1' and a.codrep77=c.codrep11 and b.tipcli02=d.claseabc and b.codcli02=d.contribuy and b.CodAge19=f.cliente   
                and b.tipcli02=4 and b.codcli02=  @Ruc   
  and (b.numcer13  like '%' + @numCert + '%') )  
                and s.serie = d.numser12  
                and s.numcer =  d.numcer13 
  and d.numdui11 like  '%' + @DuaDeposito + '%'    --N13052009 RTELLO           

        group by   numdui11,numcer13 , numser12, codemb06, desmer17    
  
   
  
  --select * from #Nacional  
  --select * from #Reporte  
    
    DECLARE  C_DISP_X_NACIONALIZAR CURSOR FOR   
     Select d.contribuy,a.numdui11,a.numcer13,a.feccer13,b.numser12,b.numbul14,b.bulent14, sldbul=b.numbul14-b.bulent14,  
            c.codemb06,b.desmer14          
 From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d           
 Where           
 a.numcer13=b.numcer13 and   
 a.numsol10=c.numsol10 and   
 b.numser12=c.numser12 and   
 a.numbul13-a.bulent13>=0 and   
 b.numbul14-b.bulent14>0 and           
 a.tipcli02=d.claseabc and a.codcli02=d.contribuy --and a.tipcli02=@TIPCLI     
 and a.codcli02= @Ruc and flgval13 = 1       
 AND (a.numcer13 like '%' + @numCert + '%')  
        and desmer14 like '%' + @NameProd +'%'   
 AND a.numdui11 like '%' + @DuaDeposito + '%' --N13052009 RTELLO
 AND a.feccer13 > '20081010'
 order by a.numcer13, a.obscer13   
  
  
   OPEN C_DISP_X_NACIONALIZAR   
   Fetch Next From C_DISP_X_NACIONALIZAR into @contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14  
   While @@FETCH_STATUS = 0  
   Begin   
  print 'Entro Cursos'  
       SET @cantidaNacional = 0  
       select @cantidaNacional = isnull(Nacional ,0)  
         from Nacional   
        where serie =  @numser12 and certificado = @numcer13  
  
    if @numbul14 - @cantidaNacional > 0
     insert into Reporte values(@contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14 , @cantidaNacional - @bulent14 ,@numbul14 - @cantidaNacional )  

    
   Fetch Next From  C_DISP_X_NACIONALIZAR into @contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14  
   End  
   Close C_DISP_X_NACIONALIZAR  
   deallocate C_DISP_X_NACIONALIZAR  
    
  
  
  Delete from  serie_Disp     
  Delete from  Nacional  
   --Select numdui11 , Numcer13, CONVERT(varchar,Feccer13,103) as Feccer13, numser12,numbul14,bulent14,codemb06,desmer14,Nacional,NoNacional  from  Reporte  where contribuy = @Ruc
 
  exec ('Select Numcer13 + numser12 as ID ,numdui11 , Numcer13, Feccer13,numser12,numbul14,bulent14,codemb06,desmer14,Nacional,NoNacional,contribuy  from  Reporte  where contribuy = ' + @Ruc + ' order by ' + @Ordenar)
    if @@error <> 0
	begin
		rollback transaction
		return -1
	end
	commit transaction
END  
  





GO
/****** Object:  StoredProcedure [dbo].[SP_CALCULA_PRODUC_NO_NACIONAL1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CALCULA_PRODUC_NO_NACIONAL1]  
@numCert varchar(20),  
@Ruc  varchar(20),  
@NameProd varchar(200)  ,
@DuaDeposito varchar(200)
  
AS  
Begin  
DECLARE  
 @contribuy varchar(20),  
 @numdui11 varchar(20),  
 @numcer13 varchar(10),  
 @feccer13 datetime ,  
 @numser12 varchar(10),  
 @numbul14 int ,  
 @bulent14 int ,  
 @sldBul   int ,  
 @codemb06 varchar(5),   
 @desmer14 varchar(200),  
 @cantidaNacional int  
  
   
  
BEGIN  TRANSACTION
  
/*drop table #serie_Disp   
drop table #Reporte    
drop table #Nacional*/

 /*create table serie_Disp  
 (  
    serie varchar(4),  
    ruc   varchar(12),  
    numcer varchar(11)  
 )  

  create table Nacional  
 (  
    Deposito   varchar(20),   
    certificado varchar(10) ,  
    serie varchar(4),       
    Nacional int,  
    codemb06 varchar(5) ,     
    desmer17 varchar(200)  
     
 )  
  
  create table Reporte  
 (  
    contribuy varchar(20),  
    numdui11 varchar(30),  
    numcer13 varchar(10),  
    feccer13 datetime,  
    numser12 varchar(4),  
    numbul14 int,  
    bulent14 int,  
    sldBul int,  
    codemb06 varchar(10),  
    desmer14 varchar(200),   
    Nacional int  ,
    NoNacional int
     
 )  */
 
 Delete From Reporte  where contribuy = @Ruc

 insert into serie_Disp  
       Select serie= b.numser12, ruc = @Ruc , Certificado = a.numcer13  
	 From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d           
	 Where           
	  a.numcer13=b.numcer13 and   
	  a.numsol10=c.numsol10 and   
	  b.numser12=c.numser12 and   
	  a.numbul13-a.bulent13>=0 and   
	  b.numbul14-b.bulent14>0 and           
	  a.tipcli02=d.claseabc and a.codcli02=d.contribuy   
	 and a.codcli02=@Ruc and flgval13 = 1       
         AND (a.numcer13 like '%' + @numCert + '%') --like  'A00540900%'     
	-- AND (a.numcer13 = @numCert or '0' = @numCert) --like  'A00540900%'     
	 order by a.numcer13, a.obscer13   

  
 insert into Nacional  
 select numdui11, numcer13 , numser12,sum(numbul17),codemb06,desmer17   
        from DDSerDes17 d, serie_Disp s where d.numdui16 in (  
  Select a.numdui16  
  From   
  DRRetAdu18 a,DDDuiDes16 b,DDCerAdu13 g,DDSolAdu10 e,DQMaeRep77 c,AAClientesAA d,AAClientesAA f   
  Where   
  a.numdui16=b.numdui16 and b.numcer13=g.numcer13 and g.numsol10=e.numsol10    
  and a.flgval18='1' and a.flgemi18='1' and a.codrep77=c.codrep11 and b.tipcli02=d.claseabc and b.codcli02=d.contribuy and b.CodAge19=f.cliente   
                and b.tipcli02=4 and b.codcli02=  @Ruc   
  and (b.numcer13  like '%' + @numCert + '%') )  
                and s.serie = d.numser12  
                and s.numcer =  d.numcer13 
  and d.numdui11 like  '%' + @DuaDeposito + '%'    --N13052009 RTELLO           
        group by   numdui11,numcer13 , numser12, codemb06, desmer17    
  
   
  
  --select * from #Nacional  
  --select * from #Reporte  
    
    DECLARE  C_DISP_X_NACIONALIZAR CURSOR FOR   
     Select d.contribuy,a.numdui11,a.numcer13,a.feccer13,b.numser12,b.numbul14,b.bulent14, sldbul=b.numbul14-b.bulent14,  
            c.codemb06,b.desmer14          
 From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d           
 Where           
 a.numcer13=b.numcer13 and   
 a.numsol10=c.numsol10 and   
 b.numser12=c.numser12 and   
 a.numbul13-a.bulent13>=0 and   
 b.numbul14-b.bulent14>0 and           
 a.tipcli02=d.claseabc and a.codcli02=d.contribuy --and a.tipcli02=@TIPCLI     
 and a.codcli02= @Ruc and flgval13 = 1       
 AND (a.numcer13 like '%' + @numCert + '%')  
        and desmer14 like '%' + @NameProd +'%'   
 AND a.numdui11 like '%' + @DuaDeposito + '%' --N13052009 RTELLO
 order by a.numcer13, a.obscer13   
  
  
   OPEN C_DISP_X_NACIONALIZAR   
   Fetch Next From C_DISP_X_NACIONALIZAR into @contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14  
   While @@FETCH_STATUS = 0  
   Begin   
  print 'Entro Cursos'  
       SET @cantidaNacional = 0  
       select @cantidaNacional = isnull(Nacional ,0)  
         from Nacional   
        where serie =  @numser12 and certificado = @numcer13  
  
    if @numbul14 - @cantidaNacional > 0
     insert into Reporte values(@contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14 , @cantidaNacional - @bulent14 ,@numbul14 - @cantidaNacional )  

    
   Fetch Next From  C_DISP_X_NACIONALIZAR into @contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14  
   End  
   Close C_DISP_X_NACIONALIZAR  
   deallocate C_DISP_X_NACIONALIZAR  
    
  
  
  Delete from  serie_Disp     
  Delete from  Nacional  
   Select numdui11 , Numcer13, CONVERT(varchar,Feccer13,103) as Feccer13, numser12,numbul14,bulent14,codemb06,desmer14,Nacional,NoNacional  from  Reporte  where contribuy = @Ruc

     if @@error <> 0
	begin
		rollback transaction
		return -1
	end
	commit transaction
END  
  











GO
/****** Object:  StoredProcedure [dbo].[SP_CALCULA_PRODUC_REPORT]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CALCULA_PRODUC_REPORT]
@RUC varchar(20)
AS
Begin
Select numdui11 , Numcer13, CONVERT(varchar,Feccer13,103) as Feccer13, numser12,numbul14,bulent14,codemb06,desmer14,Nacional,NoNacional,contribuy 
from  Reporte  where contribuy =  @Ruc
End

GO
/****** Object:  StoredProcedure [dbo].[sp_cancelacion]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_cancelacion]  
  @fec_i varchar(8),  
  @fec_f varchar(8)  
  
as  
  
/********* Para cancelaciones *********/    
  
/****** Para la cuenta 104 *****/  
  
select nropag56='', codsbd03=d.codsbd03, coddoc07='', codmon30=b.tipmon56, fecmov12=getdate(), codcue01= d.codcue01, serdoc12= '',  
numdoc12= '', codcco06='', codcco07='', desmov12= '', nrocan04='', codana02='',    
impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,3),a.monpag57)) else sum(convert(decimal(15,3),(a.monpag57*b.tipcam56))) end,  
impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,3),a.monpag57)) else 0.00 end,   
ticadi12= 0.000, descan04= '', tipaut12 = '',  
sistem12='D', flagdh12 = 'D', flglei12='N', fecven12=''   
into #tmp010011  
from 
ddpagcom57 a (nolock)  
inner join ddpagos56 b (nolock) on (a.nropag56=b.nropag56)  
inner join ddcabcom52 c (nolock) on (a.numcom52=c.numcom52)  
inner join drbancos49 d (nolock) on (d.codcta50=b.codcta50) 
left  join dqclient02 f (nolock) on (c.codcli02=f.codcli02)   
where  
(b.flglei56='N')  
and (b.fecpag56 >= @fec_i   
and b.fecpag56 < @fec_f)   
group by d.codsbd03, d.codcue01, b.tipmon56  
if @@error <> 0 GOTO E_Select_Error  
  
/****** para la cuenta 12 ******/    
select codsbd03=d.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56,   
codcue01= g.codcue01, serdoc12= substring(c.numcom52,1,3), numdoc12=substring(c.numcom52,4,7),  codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01',   
impmna12= case when b.tipmon56 = 'S' then convert(decimal(15,3),sum(a.monpag57)) else convert(decimal(15,3),sum(a.monpag57*b.tipcam56)) end,  
impmex12= case when b.tipmon56 = 'D' then convert(decimal(15,3),sum(a.monpag57)) else 0.000 end,  
ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,3),b.tipcam56) else 0.000 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',  
sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='', b.nropag56  
into #tmp010012  
from 
ddpagcom57 a (nolock)   
inner join ddpagos56  b (nolock) on (a.nropag56=b.nropag56) 
inner join ddcabcom52 c (nolock) on (a.numcom52=c.numcom52)  
inner join drbancos49 d (nolock) on (b.codcta50=d.codcta50 and b.tipmon56=d.tipmon49) 
inner join crtipdoc02 e (nolock) on  (c.codcom50=e.codtip02)  
inner join crconcep01 g (nolock) on (b.tipmon56=g.codcon14)  
left  join dqclient02 f (nolock) on (c.codcli02=f.codcli02)  
where 
(e.tipapp02='D')  
and (b.flglei56='N')  
and (b.fecpag56 >= @fec_i  
and b.fecpag56 < @fec_f)  
and ( tipapp01='D')  
group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,  
c.docdes52, b.tipcam56, g.codcue01, b.nropag56   
if @@error <> 0 GOTO E_Select_Error   
  
  
begin transaction  
    
INSERT INTO CDMOVIMI15  
(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12 from #tmp010011   
if @@error <> 0 GOTO E_General_Error  
  
INSERT INTO CDMOVIMI15  
(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)   
select codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12 from #tmp010012   
if @@error <> 0 GOTO E_General_Error  
  
update ddpagos56 set flglei56='S' where nropag56 in (select nropag56 from #tmp010012)   
if @@error <> 0 GOTO E_General_Error  
  
commit transaction  
return 0  
  
E_General_Error:   
raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror  
rollback transaction  
return 2  
  
E_Select_Error:  
raiserror('No se pudo crear la tabla temporal',1,2) with seterror  
return 2
  


  
  



GO
/****** Object:  StoredProcedure [dbo].[sp_cancelacion2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/****** Object:  Stored Procedure dbo.sp_cancelacion2    Script Date: 08-09-2002 08:44:06 PM ******/  
ALTER PROCEDURE [dbo].[sp_cancelacion2]  
  @fec_i varchar(8),  
  @fec_f varchar(8),  
  @fec_s varchar(8)  
  
as  
  
/********* Para cancelaciones *********/    
  
/****** Para la cuenta 104 *****/  
  
select nropag56='', codsbd03=d.codsbd03, coddoc07='', codmon30=b.tipmon56, fecmov12=getdate(), codcue01= d.codcue01, serdoc12= '',  
numdoc12= '', codcco06='', codcco07='', desmov12= '', nrocan04='', codana02='',    
impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),a.monpag57)) else sum(convert(decimal(15,2),(a.monpag57*b.tipcam56))) end,  
impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,   
ticadi12= 0.00, descan04= '', tipaut12 = '',  
sistem12='D', flagdh12 = 'D', flglei12='N', fecven12=''   
into #tmp010011  
from 
ddpagcom57 a (nolock)  
inner join  ddpagos56 b (nolock) on (a.nropag56=b.nropag56)
inner join ddcabcom52 c (nolock) on (a.numcom52=c.numcom52)  
inner join dqctadep50 d (nolock) on (d.codcta50=b.codcta50) 
left  join dqclient02 f (nolock) on (c.codcli02=f.codcli02)  
where   
(b.codtip48<>'07')  
and (b.flglei56='N')  
and (b.fecpag56 >= @fec_i   
and b.fecpag56 < @fec_f)  
and (c.feccom52 >= @fec_s)   
group by d.codsbd03, d.codcue01, b.tipmon56  
if @@error <> 0 GOTO E_Select_Error  
  
/****** para la cuenta 12 ******/    
select codsbd03=d.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56,   
codcue01= g.codcue01, serdoc12= substring(c.numcom52,1,3), numdoc12=substring(c.numcom52,4,7),  codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01',   
impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),a.monpag57)) else convert(decimal(15,2),sum(a.monpag57*b.tipcam56)) end,  
impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,  
ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,2),b.tipcam56) else 0.00 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',  
sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='', b.nropag56  
into #tmp010012  
from 
ddpagcom57 a (nolock)   
inner join ddpagos56  b (nolock) on (a.nropag56=b.nropag56)  
inner join ddcabcom52 c (nolock) on (a.numcom52=c.numcom52) 
inner join dqctadep50 d (nolock) on (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)  
inner join dqcompag50 e (nolock) on (c.codcom50=e.codcom50)  
inner join dqconcom51 g (nolock) on (b.tipmon56=g.codcon51)  
left  join dqclient02 f (nolock) on (c.codcli02=f.codcli02) 
   
where   
(b.codtip48<>'07')   
and (b.flglei56='N')  
and (b.fecpag56 >= @fec_i  
and b.fecpag56 < @fec_f)  
and (c.feccom52 >= @fec_s)  
group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,   
c.docdes52, b.tipcam56, g.codcue01, b.nropag56   
if @@error <> 0 GOTO E_Select_Error   
  
begin transaction  
  
INSERT INTO CDMOVIMI15  
(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12 from #tmp010011   
if @@error <> 0 GOTO E_General_Error  
  
INSERT INTO CDMOVIMI15  
(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)   
select codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12 from #tmp010012   
if @@error <> 0 GOTO E_General_Error  
  
update ddpagos56 set flglei56='S' where nropag56 in (select nropag56 from #tmp010012)   
if @@error <> 0 GOTO E_General_Error  
  
commit transaction  return 0  
  
E_General_Error:   
raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror  
rollback transaction  
return 2  
  
E_Select_Error:  
raiserror('No se pudo crear la tabla temporal',1,2) with seterror   
return 2
GO
/****** Object:  StoredProcedure [dbo].[sp_cancelacion3]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
/****** Object:  Stored Procedure dbo.sp_cancelacion3    Script Date: 08-09-2002 08:44:06 PM ******/  
ALTER PROCEDURE [dbo].[sp_cancelacion3]  
  @fec_i varchar(8),  
  @fec_f varchar(8),  
  @fec_s varchar(8)  
  
as  
  
/********* Para cancelaciones *********/    
  
/****** Para la cuenta 104 *****/  
  
select codsbd03=d.codsbd03, coddoc07=case when b.codtip48 in ('07','04') then h.coddoc07 else '' end, codmon30=b.tipmon56, fecmov12=getdate(),  
codcue01= case when b.codtip48 in ('07','04') then g.codcue01 else d.codcue01 end, serdoc12= '',   
numdoc12=case when b.codtip48 in ('07','04') then b.nrodoc56 else '' end,  codcco06= '', codcco07='', desmov12='', nrocan04='', codana02='',   
impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),a.monpag57)) else convert(decimal(15,2),sum(a.monpag57*b.tipcam56)) end,  
impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,  
ticadi12= 0.00, descan04='', tipaut12 = '',  
sistem12='D', flagdh12 = 'D', flglei12='N', fecven12='', b.nropag56, b.codcta50  
into #tmp010011  
from 
ddpagcom57 a (nolock)   
inner join ddpagos56 b (nolock) on (a.nropag56=b.nropag56) 
inner join ddcabcom52 c (nolock) on (a.numcom52=c.numcom52) 
inner join dqctadep50 d (nolock) on (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)  
inner join dqtippag48 h (nolock) on (b.codtip48=h.codtip48) 
inner join dqcompag50 e (nolock) on (c.codcom50=e.codcom50) 
left  join dqclient02 f (nolock) on (c.codcli02=f.codcli02) 
left  join dqconcom51 g (nolock) on (g.codcon51='NOTAS')   
where (b.flglei56='N')  
and (b.codtip48 not in ('07','04') or a.numcom52 in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 not in ('07','04')  
and b.numcom52 in (select b.numcom52  
FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 in ('07','04'))  
GROUP BY B.NUMCOM52))    
 
and (b.fecpag56 >= @fec_i  
and b.fecpag56 < @fec_f)  
and (c.feccom52 >= @fec_s)  
group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,   
c.docdes52, b.tipcam56, b.nropag56, b.codcta50, g.codcue01, b.codtip48, h.coddoc07, a.numcom52,  
b.nrodoc56   
if @@error <> 0 GOTO E_Select_Error  
  
  
/****** para la cuenta 46 ******/  
  
select codsbd03=d.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56,   
codcue01= g.codcue01, serdoc12= '', numdoc12=b.nrodoc56,  codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01',   
impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),a.monpag57)) else convert(decimal(15,2),sum(a.monpag57*b.tipcam56)) end,  
impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,  
ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,2),b.tipcam56) else 0.00 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',  
sistem12='D', flagdh12 = 'D', flglei12='N', fecven12='', b.nropag56  
into #tmp010012  
from 
ddpagcom57 a (nolock)   
inner join ddpagos56  b (nolock) on (a.nropag56=b.nropag56)  
inner join dqctadep50 d (nolock) on (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50) 
inner join dqtippag48 e (nolock) on (b.codtip48=e.codtip48)  
inner join ddcabcom52 c (nolock) on (a.numcom52=c.numcom52)  
left  join dqclient02 f (nolock) on (c.codcli02=f.codcli02)   
inner join dqconcom51 g (nolock) on (b.tipmon56=g.codcon51) 
where  (b.codtip48 in ('07','04') and a.numcom52 not in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 not in ('07','04')  
and b.numcom52 in (select b.numcom52  
FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 in ('07','04'))  
GROUP BY B.NUMCOM52))   
and (b.flglei56='N')  
and (b.fecpag56 >= @fec_i  
and b.fecpag56 < @fec_f)  
and (c.feccom52 >= @fec_s)  
group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, b.nrodoc56,   
c.docdes52, b.tipcam56, g.codcue01, b.nropag56   
if @@error <> 0 GOTO E_Select_Error  
  
/****** para la cuenta 12 de la 46 ******/    
select codsbd03=g.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56,   
codcue01= g.codcue01, serdoc12= substring(c.numcom52,1,3), numdoc12=substring(c.numcom52,4,7),  codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01',   
impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),(a.monpag57/b.tipcam56)*c.tipcam52)) else convert(decimal(15,2),sum(a.monpag57*c.tipcam52)) end,  
impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,  
ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,2),c.tipcam52) else 0.00 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',  
sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='', b.nropag56, b.codcta50  
into #tmp010013  
from 
ddpagcom57 a (nolock)   
	inner join ddpagos56 b (nolock) on (a.nropag56=b.nropag56) 
	inner join ddcabcom52 c (nolock) on (a.numcom52=c.numcom52) 
	inner join dqctadep50 d (nolock) on (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)  
	inner join dqtippag48 e (nolock) on (a.codcom50=e.codtip48)  
	inner join dqconcom51 g (nolock) on (b.tipmon56=g.codcon51)  
	left  join dqclient02 f (nolock) on (c.codcli02=f.codcli02) 
where (b.codtip48 in ('07','04') and a.numcom52 not in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 not in ('07','04')   
and b.numcom52 in (select b.numcom52  
FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 in ('07','04'))  
GROUP BY B.NUMCOM52))    
and (b.flglei56='N')  
and (b.fecpag56 >= @fec_i  
and b.fecpag56 < @fec_f)  
 
and (c.feccom52 >= @fec_s)  
group by g.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,   
c.docdes52, c.tipcam52, g.codcue01, b.nropag56, b.codcta50   
if @@error <> 0 GOTO E_Select_Error   
  
/****** para la cuenta 12 sin la 46 ******/    
select codsbd03=g.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56,   
codcue01= g.codcue01, serdoc12= substring(c.numcom52,1,3), numdoc12=substring(c.numcom52,4,7),  codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01',   
impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),(a.monpag57/b.tipcam56)*c.tipcam52)) else convert(decimal(15,2),sum(a.monpag57*c.tipcam52)) end,  
impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,  
ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,2),c.tipcam52) else 0.00 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',  
sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='', b.nropag56, b.codcta50  
into #tmp010014  
from 
ddpagcom57 a (nolock)   
inner join ddpagos56 b (nolock) on (a.nropag56=b.nropag56) 
inner join dqctadep50 d (nolock) on (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)  
inner join ddcabcom52 c (nolock) on (a.numcom52=c.numcom52) 
inner join dqcompag50 e (nolock) on (c.codcom50=e.codcom50)  
left  join dqclient02 f (nolock) on (c.codcli02=f.codcli02) 
where  
(b.codtip48 not in ('07','04') or a.numcom52 in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 not in ('07','04')  
and b.numcom52 in (select b.numcom52  
FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 in ('07','04'))  
GROUP BY B.NUMCOM52))   

and (b.flglei56='N')  
and (b.fecpag56 >= @fec_i  
and b.fecpag56 < @fec_f)  

and (c.feccom52 >= @fec_s)  
group by g.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,  c.docdes52, c.tipcam52, g.codcue01, b.nropag56, b.codcta50   
if @@error <> 0 GOTO E_Select_Error  
  
  
/***** Para la Diferencia de Cambio de la 46 ***********/  
  
select codsbd03=d.codsbd03, coddoc07='', codmon30='S', fecmov12=getdate(),   
codcue01= '', serdoc12= '', numdoc12='',  codcco06= '', codcco07='', desmov12='', nrocan04='', codana02='',   
impmna12= case when b.tipmon56='S' then sum(convert(decimal(15,2),a.monpag57) - convert(decimal(15,2),(a.monpag57/b.tipcam56)*c.tipcam52))  
else sum(convert(decimal(15,2),a.monpag57*b.tipcam56) - convert(decimal(15,2),a.monpag57*c.tipcam52)) end,   
impmex12= 0.00, ticadi12= 0.00, descan04='', tipaut12 = '',  
sistem12='D', flagdh12 = case when (sum(convert(decimal(15,2),a.monpag57*b.tipcam56))-sum(convert(decimal(15,2),a.monpag57*c.tipcam52))) > 0 then 'H' else 'D' end,   
flglei12='N', fecven12=getdate(), b.nropag56, b.codcta50,   
concepto=case when (sum(convert(decimal(15,2),a.monpag57*b.tipcam56))-sum(convert(decimal(15,2),a.monpag57*c.tipcam52))) > 0 then 'GANDC' else 'PERDC' end   
into #tmp010015  
from ddpagcom57 a (nolock),   
ddpagos56 b (nolock),  
ddcabcom52 c (nolock),  
dqctadep50 d (nolock),  
dqtippag48 e (nolock),  
dqclient02 f (nolock),  
dqconcom51 g (nolock)   
where (b.nropag56=a.nropag56)  
and (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)   
and (a.numcom52=c.numcom52)  and (a.codcom50=e.codtip48)  
and (b.codtip48 in ('07','04') and a.numcom52 not in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 not in ('07','04')   
and b.numcom52 in (select b.numcom52  
FROM DDPAGOS56 A 
left join DDPAGCOM57 B on (c.codcli02=f.codcli02)   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 in ('07','04'))  
GROUP BY B.NUMCOM52))   
/*and (b.tipmon56='D')*/  
and (b.flglei56='N')  
and (b.fecpag56 >= @fec_i  
and b.fecpag56 < @fec_f)  
and (b.tipmon56=g.codcon51)  
and (c.feccom52 >= @fec_s)  
group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,   
c.docdes52, c.tipcam52, g.codcue01, b.nropag56, b.codcta50, b.tipcam56   
  
  
/***** Para la Diferencia de Cambio sin la 46 ***********/  
  
select codsbd03=d.codsbd03, coddoc07='', codmon30='S', fecmov12=getdate(),   
codcue01= '', serdoc12= '', numdoc12='',  codcco06= '', codcco07='', desmov12='', nrocan04='', codana02='',   
impmna12= case when b.tipmon56='S' then sum(convert(decimal(15,2),a.monpag57) - convert(decimal(15,2),(a.monpag57/b.tipcam56)*c.tipcam52))  
else sum(convert(decimal(15,2),a.monpag57*b.tipcam56) - convert(decimal(15,2),a.monpag57*c.tipcam52)) end,  
impmex12= 0.00, ticadi12= 0.00, descan04='', tipaut12 = '',  
sistem12='D', flagdh12 = case when (sum(convert(decimal(15,2),a.monpag57*b.tipcam56))-sum(convert(decimal(15,2),a.monpag57*c.tipcam52))) > 0 then 'H' else 'D' end,   
flglei12='N', fecven12=getdate(), b.nropag56, b.codcta50,   
concepto=case when (sum(convert(decimal(15,2),a.monpag57*b.tipcam56))-sum(convert(decimal(15,2),a.monpag57*c.tipcam52))) > 0 then 'GANDC' else 'PERDC' end    
into #tmp010016  
from ddpagcom57 a (nolock),   
ddpagos56 b (nolock),   
ddcabcom52 c (nolock),  
dqctadep50 d (nolock),  
dqcompag50 e (nolock),  
dqclient02 f (nolock),  
dqconcom51 g (nolock)   
where (b.nropag56=a.nropag56)  
and (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)   
and (a.numcom52=c.numcom52)   
and (a.codcom50=e.codcom50)  
and (b.codtip48 not in ('07','04') or a.numcom52 in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B   
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 not in ('07','04')   
and b.numcom52 in (select b.numcom52  
FROM DDPAGOS56 A 
left join DDPAGCOM57 B  on (c.codcli02=f.codcli02) 
WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f  
and a.codtip48 in ('07','04'))  
GROUP BY B.NUMCOM52))   
/*and (b.tipmon56='D')*/  
and (b.flglei56='N')  
and (b.fecpag56 >= @fec_i  
and b.fecpag56 < @fec_f)  
and (b.tipmon56=g.codcon51)  
and (c.feccom52 >= @fec_s)  
group by d.codsbd03, b.fecpag56, f.nomcli02, b.nropag56, b.codcta50, b.tipmon56   
  
  
begin transaction   
  
/* INSERTO LA 10 */  
INSERT INTO CDMOVIMI15  
(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)    
select codsbd03=b.codsbd03, a.coddoc07, a.codmon30, fecmov12= getdate(), a.codcue01, a.serdoc12, a.numdoc12, codcco06='', codcco07='', desmov12='', nrocan04='', codana02='', impmna12=sum(a.impmna12), impmex12=sum(a.impmex12), ticadi12=0.00, descan04='', 
tipaut12='', a.sistem12, a.flagdh12, a.flglei12, fecven12=''   
from #tmp010011 a, dqctadep50 b  
where (a.codcta50=b.codcta50 and a.codmon30=b.moncta50)  
group by b.codsbd03, codmon30, a.codcue01, sistem12, flagdh12, flglei12, a.coddoc07, a.serdoc12, a.numdoc12  
if @@error <> 0 GOTO E_General_Error  
  
   
/* INSERTO LA 46 */   
INSERT INTO CDMOVIMI15  
(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)   
select codsbd03=b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12, a.numdoc12, codcco06='', 
codcco07='', a.desmov12, a.nrocan04, a.codana02, a.impmna12, a.impmex12, ticadi12=0.00, a.descan04, tipaut12='', a.sistem12, 
a.flagdh12, a.flglei12, fecven12=''   
from #tmp010012 a, dqconcom51 b  
where b.codcon51='CANJE'  
  
  
/* INSERTO LA 12 DE LA 46 */  
INSERT INTO CDMOVIMI15  
(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)   
select codsbd03=b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.codcue01, a.serdoc12, a.numdoc12, a.codcco06, a.codcco07, a.desmov12, a.nrocan04, a.codana02, a.impmna12, a.impmex12, a.ticadi12, a.descan04, a.tipaut12, a.sistem12, a.flagdh12, a.flglei12,
 a.fecven12   
from #tmp010013 a, dqconcom51 b  
where b.codcon51='CANJE'  
if @@error <> 0 GOTO E_General_Error  
   
  
/* INSERTO LA 12 SIN LA 46 */  
INSERT INTO CDMOVIMI15   
(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)   
select codsbd03=b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.codcue01, a.serdoc12, a.numdoc12, a.codcco06, a.codcco07, a.desmov12, a.nrocan04, a.codana02, a.impmna12, a.impmex12, a.ticadi12, a.descan04, a.tipaut12, a.sistem12, a.flagdh12, a.flglei12,
 a.fecven12   
from #tmp010014 a, dqctadep50 b  
where (a.codcta50=b.codcta50 and a.codmon30=b.moncta50)  
if @@error <> 0 GOTO E_General_Error  
  
/* INSERTO LA DIFERENCIA DE CAMBIO DE LA 46*/  
INSERT INTO CDMOVIMI15    
(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)   
select codsbd03=b.codsbd03, coddoc07='', a.codmon30, a.fecmov12, codcue01=c.codcue01, serdoc12='', numdoc12='', codcco06='', codcco07='', desmov12='DIFERENCIA DE CAMBIO', nrocan04='', codana02='', sum(a.impmna12), a.impmex12, a.ticadi12, descan04='', 
tipaut12='', a.sistem12, a.flagdh12, a.flglei12, a.fecven12   
from #tmp010015 a, dqconcom51 b, dqconcom51 c  
where b.codcon51='CANJE' and c.codcon51=a.concepto  
group by b.codsbd03, a.codmon30, a.fecmov12, c.codcue01, a.impmex12, a.ticadi12, a.sistem12, a.flagdh12, a.flglei12, a.fecven12  
/*where b.codcon51=a.concepto*/   
if @@error <> 0 GOTO E_General_Error  
  
/* INSERTO LA DIFERENCIA DE CAMBIO SIN LA 46*/  
INSERT INTO CDMOVIMI15   
(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)   
select a.codsbd03, coddoc07='', a.codmon30, a.fecmov12, codcue01=b.codcue01, serdoc12='', numdoc12='', codcco06='', codcco07='', desmov12='DIFERENCIA DE CAMBIO', nrocan04='', codana02='', sum(a.impmna12), a.impmex12, a.ticadi12, descan04='', tipaut12='', 
a.sistem12, a.flagdh12, a.flglei12, a.fecven12   
from #tmp010016 a, dqconcom51 b  
where b.codcon51=a.concepto  
group by a.codsbd03, a.codmon30, a.fecmov12, b.codcue01, a.impmex12, a.ticadi12, a.sistem12, a.flagdh12, a.flglei12, a.fecven12  
if @@error <> 0 GOTO E_General_Error  
  
update ddpagos56 set flglei56='S' where nropag56 in (select nropag56 from #tmp010013)    
if @@error <> 0 GOTO E_General_Error  
  
update ddpagos56 set flglei56='S' where nropag56 in (select nropag56 from #tmp010014)   
if @@error <> 0 GOTO E_General_Error  
  
commit transaction   
return 0  
  
E_General_Error:   
raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror  
rollback transaction   
return 2  
  
E_Select_Error:  
raiserror('No se pudo crear la tabla temporal',1,2) with seterror    
return 2
GO
/****** Object:  StoredProcedure [dbo].[SP_CARGA_IMAGEN]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CARGA_IMAGEN]

@NroId varchar(10)

AS

Begin

Select * from DRUTADUA where NroId = @NroId

END

GO
/****** Object:  StoredProcedure [dbo].[SP_CARGA_SUELTA_X_SOL_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CARGA_SUELTA_X_SOL_ADU]
@NUMSOL CHAR(6)
AS

SELECT
a.numsol10,a.fecsol10,a.numdui10,a.desmer10,
b.claseabc,b.contribuy,b.nombre,
c.numtkt01,c.fecing01,c.fecsal01,c.pesbru01,c.pestar01,c.pesnet01,c.numbul01,c.codemb06,c.numpla01, c.numcha01
From 
DDTICKET01 c,DDSOLADU10 a,AAClientesAA b
WHERE
a.numsol10='A'+@NUMSOL and a.numsol10=c.docaut01 and c.tipope01='D' and 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy


GO
/****** Object:  StoredProcedure [dbo].[SP_CARGA_SUELTA_X_SOL_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_CARGA_SUELTA_X_SOL_SIM    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_CARGA_SUELTA_X_SOL_SIM]
@NUMSOL CHAR(6)
AS

SELECT  
a.numsol62,a.fecsol62,a.desmer62,
b.claseabc,b.contribuy,b.nombre,
c.numtkt01,c.fecing01,c.fecsal01,c.pesbru01,c.pestar01,c.pesnet01,c.numbul01,c.codemb06,c.numpla01
From 
DDTICKET01 c,DDSolSim62 a,AAClientesAA b
WHERE
a.numsol62='S'+@NUMSOL and a.numsol62=c.docaut01 and c.tipope01='D' and 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
GO
/****** Object:  StoredProcedure [dbo].[SP_CER_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_CER_ADU    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[SP_CER_ADU]
@NUMCER CHAR(9)
AS


Select 
a.feccer13,a.numsol10,b.fecsol10,b.cobalm10,a.numdui11,c.fecdui11,a.tipcli02,a.codcli02,NombreC=d.nombre,
b.codage19,NombreA=e.nombre,a.numbul13,a.pescer13,a.fobcer13,a.flecer13,a.segcer13,a.cifcer13,
a.obscer13,a.flgval13,a.ticlfa13,a.coclfa13,a.flstfa13
From 
DDCerAdu13 a,DDSolAdu10 b,DDDuiDep11 c,AAclientesAA d,AACLIENTESAA e
Where 
a.numsol10=b.numsol10 and a.numsol10=c.numsol10 and 
a.tipcli02=d.claseabc and a.codcli02=d.contribuy and 
b.CodAge19=e.cliente And a.numcer13=@NUMCER
GO
/****** Object:  StoredProcedure [dbo].[SP_CER_DEP_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_CER_DEP_SIM    Script Date: 08-09-2002 08:44:12 PM ******/      
ALTER PROCEDURE [dbo].[SP_CER_DEP_SIM]      
@NUMCER VARCHAR(8)      
AS      
      
Select       
a.*,numsol10=a.numsol62, c.cobalm62, c.fecsol62,NombreC=b.nombre, c.bultot62, NombreA= d.nombre  
From       
DDCerSim74 a     
inner join AAClientesAA b on (a.codcli02=b.contribuy)    
inner join DDSolSim62 c on (a.numsol62=c.numsol62)    
left join AAClientesAA d on (a.codage19=d.cliente and a.codage19 <> '')     
Where a.numcer74= @NUMCER 
GO
/****** Object:  StoredProcedure [dbo].[sp_ComboTip_Estado]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ComboTip_Estado]
AS
BEGIN
	declare @tabletemp table
	(
	estado varchar(25)
	)
	
	insert into @tabletemp(estado)
	SELECT 'TODOS' AS 'ESTADO'
	
	insert into @tabletemp(estado)
	SELECT 'REGISTRADO' AS 'ESTADO'
	
	insert into @tabletemp(estado)
	SELECT 'PENDIENTE' AS 'ESTADO'
	
	insert into @tabletemp(estado)
	SELECT 'FINALIZADO' AS 'ESTADO'
	
	insert into @tabletemp(estado)
	SELECT 'ANULADO' AS 'ESTADO'
	
	select LTRIM(rtrim(estado)) as estado from @tabletemp

END
GO
/****** Object:  StoredProcedure [dbo].[sp_ComboTip_Estado_Exportable]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ComboTip_Estado_Exportable]  
AS  
BEGIN  
 declare @tabletemp table  
 (  
 estado varchar(25)  
 )  
   
 insert into @tabletemp(estado)  
 SELECT 'TODOS' AS 'ESTADO'  
   
 insert into @tabletemp(estado)  
 SELECT 'ACTIVO' AS 'ESTADO'  
   
 insert into @tabletemp(estado)  
 SELECT 'ANULADO' AS 'ESTADO'  
   
 insert into @tabletemp(estado)  
 SELECT 'FACTURADO' AS 'ESTADO'  
   
 select LTRIM(rtrim(estado)) as estado from @tabletemp  
  
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ComboTip_OT]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_ComboTip_OT]
AS
BEGIN
SET NOCOUNT ON;
	SELECT 'SOL' AS 'dato'
	UNION 
	SELECT 'DOL' AS 'dato'
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPCANEL]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_COMPCANEL    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_COMPCANEL]
@FECINI CHAR(8),
@FECFIN CHAR(8),
@TIPCLIE VARCHAR(1),
@CLIENTE VARCHAR(11)
AS

/*Validos Cancelados*/
Select 
a.TipCli02,a.Codcli02,a.tipdes52,a.docdes52,a.CodCom50,a.NumCom52, 
a.FecCom52,a.numcer52,a.numper52,a.iniper52,a.finper52,Total=a.SubTot52+a.IGVTot52, 
Abono=a.SubTot52+a.IGVTot52,Debe=(a.SubTot52+a.IGVTot52)-a.monpag52,a.feccan52,a.ultpag52,Estado='CANCELADO',b.nombre
From 
ddcabcom52 a,AAClientesAA b
Where 
a.FlgEmi52='1' and a.FlgVal52 = '1' and a.FlgCan52='1' and 
(a.docdes52=b.contribuy or a.docdes52=b.catcliente) and 
(convert(char(8),a.feccan52,112) between @FECINI and @FECFIN) and 
a.tipdes52=@TIPCLIE and (a.docdes52=@CLIENTE or a.docdes52=substring(@CLIENTE,3,8))
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPENPAG]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_COMPENPAG    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_COMPENPAG]
@FECINI CHAR(8),
@FECFIN CHAR(8),
@TIPCLIE VARCHAR(1),
@CLIENTE VARCHAR(11)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
/*Validos sin Cancelar*/
Select 
a.TipCli02,a.Codcli02,a.tipdes52,a.docdes52,a.CodCom50,a.NumCom52,a.FecCom52,a.numcer52,
a.numper52,a.iniper52,a.finper52,Total=a.SubTot52+a.IGVTot52,Abono=a.MonPag52,
Debe=a.SubTot52+a.IGVTot52-a.MonPag52,a.feccan52,a.ultpag52,Estado="PENDIENTE",b.nombre
From 
DDCABCOM52 a,AAClientesAA b
Where 
a.FlgEmi52='1' and a.FlgVal52 = '1' and a.FlgCan52='0' and 
(a.docdes52=b.contribuy or a.docdes52=b.catcliente) and
(convert(char(8),a.feccom52,112)>=@FECINI and convert(char(8),a.feccom52,112)<=@FECFIN) and 
a.tipdes52=@TIPCLIE and (a.docdes52=@CLIENTE or a.docdes52=substring(@CLIENTE,3,8))
GO
/****** Object:  StoredProcedure [dbo].[SP_COMPENPAGTOD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_COMPENPAGTOD    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_COMPENPAGTOD]
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
/*Validos sin Cancelar*/
Select 
a.TipCli02,a.Codcli02,a.tipdes52,a.docdes52,a.CodCom50,a.NumCom52,a.FecCom52,a.numcer52,
a.numper52,a.iniper52,a.finper52,Total=a.SubTot52+a.IGVTot52,Abono=a.MonPag52,
Debe=a.SubTot52+a.IGVTot52-a.MonPag52,a.feccan52,a.ultpag52,Estado="PENDIENTE",b.nombre
From 
DDCABCOM52 a,AAClientesAA b
Where a.FlgEmi52='1' and a.FlgVal52 = '1' and a.FlgCan52='0' and 
(a.docdes52=b.contribuy or a.docdes52=b.catcliente) and
(convert(char(8),a.feccom52,112)>=@FECINI and convert(char(8),a.feccom52,112)<=@FECFIN)
GO
/****** Object:  StoredProcedure [dbo].[SP_CONS_OT_SAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONS_OT_SAS]    
@OT VARCHAR(8)    
AS    
BEGIN    
SET NOCOUNT ON;     
	 SELECT C.CLASEABC,C.NOMBRE,    
	 A.*,  
	 ISNULL(A.PESO,0) AS PESO1,    
	 ISNULL(A.VOLUMEN,0) AS VOLUMEN1,    
	 ISNULL(VALORIZADO,0) AS VALORIZADO1,    
	 ISNULL(B.NRO_VUELTA33,0) AS NRO_VUELTA33,    
	 ISNULL(B.TRANSPORTE33,'') AS TRANSPORTE33,    
	 ISNULL(B.PLACA33,'') AS PLACA33,    
	 ISNULL(B.CAPACIDAD33,0) AS CAPACIDAD33,    
	 ISNULL(B.FECCARGUIO33,GETDATE()) AS FECCARGUIO33,    
	 ISNULL(B.CUSTODIA33,'NO') AS CUSTODIA33,    
	 ISNULL(B.COSTCUST33,0) AS COSTCUST33,    
	 ISNULL(B.CUADRILLA33,'NO') AS CUADRILLA33,    
	 ISNULL(B.CANTCUADR33,0) AS CANTCUADR33,    
	 ISNULL(B.COSTCUADR33,0) AS COSTCUADR33,
	 ISNULL(B.TIPOUNIDAD33,'') AS TIPOUNIDAD33,
	 ISNULL(B.CAPACIDADM33,0) AS CAPACIDADM33,
	 ISNULL(B.OBSERVACION33,'') AS OBSERVACION33    
	 FROM DDPLAREC32 A WITH (NOLOCK)    
	 LEFT JOIN DDDETREC33 B WITH (NOLOCK) ON A.ID_PLAREC32=B.ID_PLAREC32    
	 LEFT JOIN AACLIENTESAA C WITH (NOLOCK) ON A.CODCLIENTE=C.CONTRIBUY    
	 WHERE A.NRO_PLAREC32=@OT    
SET NOCOUNT OFF;    
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_FACTURA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_FACTURA]   
@TIPCOM CHAR(2),  
@NUMCOM CHAR(10)  
AS  
Select   
a.*,b.nombre   
From   
DDCabCom52 a 
left join AAClientesAA b on (a.tipcli02=b.claseabc and a.codcli02=b.contribuy)  
Where     
a.codcom50=@TIPCOM and a.numcom52=@NUMCOM
  

GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_FACTURA_DETALLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_FACTURA_DETALLE] 
@TIPCOM CHAR(2),
@NUMCOM CHAR(10)
AS

DECLARE @tip_dep char(1)

SELECT @tip_dep = substring(numcer52,1,1)
FROM ddcabcom52 (NOLOCK)
WHERE codcom50=@TIPCOM and numcom52=@NUMCOM

--rdelacuba 27/11/2006: Considerar que las facturas automáticas (por GG) no maneja tipo de depósito
IF EXISTS(SELECT * FROM DDDetCom53 a (NOLOCK) WHERE a.codcom50=@TIPCOM and a.numcom52=@NUMCOM and a.codcon51 in ('ALMAN','SEGCA','SEEXT','GASAD','ALMVE'))
BEGIN

--rdelacuba 02/11/2006: Se incluye detracción de transporte
Select a.*,b.*,c.*,
DETRACCION=(Select distinct Detrac52 from ddcabcom52 where codcom50=@TIPCOM and numcom52=@NUMCOM),
DETTRANS=e.dettrans,
VALREF=isnull(d.valref,0)
From DDDetCom53 a, DDUNIMED54 b, DDTAMCTR55 c,ddservic52 d, DQCONCOM51 e
Where a.codcom50=@TIPCOM and a.numcom52=@NUMCOM and 
a.numuni54=b.numuni54 and a.tamctr53=c.codtam55 and 
a.codcon51 = d.SERVIC52 and d.CONCEP51 = e.codcon51

END
ELSE
BEGIN

Select a.*,b.*,c.*,
DETRACCION=(Select distinct Detrac52 from ddcabcom52 where codcom50=@TIPCOM and numcom52=@NUMCOM),
DETTRANS=e.dettrans,
VALREF=isnull(d.valref,0)
From DDDetCom53 a, DDUNIMED54 b, DDTAMCTR55 c,ddservic52 d, DQCONCOM51 e
Where a.codcom50=@TIPCOM and a.numcom52=@NUMCOM and 
a.numuni54=b.numuni54 and a.tamctr53=c.codtam55 and 
a.codcon51 = d.SERVIC52 and d.CONCEP51 = e.codcon51
and d.DEPOSI52 = @tip_dep

END

GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETADU_WEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDEN_RETADU_WEB]    
@NUMORD varchar(50),    
@DUA varchar(200),  
@RUC varchar(11),    
@Tipo int  ,
@DuaDespacho varchar(50)  
AS    
    
IF @NUMORD = ''     
Begin    
 SET @NUMORD = 0    
End    
    
IF @Tipo = 10    
begin
/*
Select d.claseabc,d.contribuy,d.nombre,a.numdui11,a.numcer13,a.feccer13,b.numser12,b.numbul14,b.bulent14,sldbul=b.numbul14-b.bulent14,c.codemb06,b.desmer14      
From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d       
Where       
a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and a.numbul13-a.bulent13>=0 and b.numbul14-b.bulent14>0 and       
a.tipcli02=d.claseabc and a.codcli02=d.contribuy and a.tipcli02=4 and a.codcli02='20515112554' and flgval13 = 1    
order by a.numcer13, b.numser12   */

select numdui16 as duaDespacho, 
       numser12 as Serie , --Serie Deposito
       numcer13 as Numcer,
       numdui11 as duaDeposito, 
       CAST(numbul17 as Integer) as bultos, -- Bultos Ingresados
       codemb06 as Tipo,       
       desmer17 as Producto ,
       CAST(bulent17 as Integer) as Entregados ,-- Bultos Entregados Mercaderia
       CAST(numbul17 -  bulent17 as Integer) as Disponibles -- bultos Disponibles      
   from DDSerDes17 where numdui16 in (
	 Select a.numdui16 
	 From     
	  DRRetAdu18 a,DDDuiDes16 b,AAClientesAA d,DQMaeRep77 e,AAClientesAA f,DDDuiDep11 g,DDSolAdu10 h,     
	  DDRecMer69 l    
	 Where     
	 --(a.numret18= isnull(@NUMORD,'0') or '0' = isnull(@NUMORD,'0')) and     
	  a.numdui16=b.numdui16 and b.codage19=d.cliente and a.codrep77=e.codrep11 and    
	  b.tipcli02=f.claseabc and b.codcli02=f.contribuy and     
	  f.contribuy = @RUC and    
	  b.numdui11 = g.numdui11 and g.numsol10 = h.numsol10 and     
	  h.numsol10 = l.numsol62 and l.flgval69 = '1'          
)  and numbul17 -  bulent17> 0 and desmer17 like '%'+ @DUA +'%' 
   and numcer13 like '%' +  @NUMORD  + '%'
   and numdui11 like '%' + @DuaDespacho + '%'
--group by numdui16, numser12 ,numcer13 , numdui11 ,  codemb06 , desmer17 

--select * from DDSerDes17 where numcer13 = 'A00562500'
/*
BEGIN    
  Select     
  a.numret18 as numOrd,     
  a.fecret18 as FechaReg,    
  b.numcer13 as Numcer,    
                CASE a.flgval18    
                 when '1' then 'Registrada'    
                 when '0' then 'Anulada' end as Estado,    
  --b.codage19 as CodiAge,    
  --d.nombre   as NombreE,    
  '-' as Tipo,    
  --e.nomrep77 as NombreRepre,    
  '-' as Numsol,    
  --b.tipcli02 as TipoCli,    
  b.codcli02 as CodCli,    
  f.nombre as Nombre,    
  '0' as preTotal,    
  a.obsret18 as Obse,    
  (select obscer13 from DDcerAdu13 where numcer13 = b.numcer13) as NombreCert,    
  a.numdui16 as DuaDespacho,    
  b.numdui11 as DuaDeposito    
 From     
  DRRetAdu18 a,DDDuiDes16 b,AAClientesAA d,DQMaeRep77 e,AAClientesAA f,DDDuiDep11 g,DDSolAdu10 h,     
  DDRecMer69 l    
 Where     
  (a.numret18= isnull(@NUMORD,'0') or '0' = isnull(@NUMORD,'0')) and     
  a.numdui16=b.numdui16 and b.codage19=d.cliente and a.codrep77=e.codrep11 and    
  b.tipcli02=f.claseabc and b.codcli02=f.contribuy and     
  f.contribuy = @RUC and    
  b.numdui11 = g.numdui11 and g.numsol10 = h.numsol10 and     
  h.numsol10 = l.numsol62 and l.flgval69 = '1'  and  
  a.numdui16 in (select numdui16 from DDserDes17 where desmer17 like '%'+ @DUA + '%')  
 Order by DuaDespacho desc    */
    
END    
  

GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETADU_WEB_SAA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDEN_RETADU_WEB_SAA]    
@NUMORD varchar(50),    
@DUA varchar(200),  
@RUC varchar(11),    
@Tipo int  ,
@DuaDespacho varchar(50),
@Orden varchar (100)
AS    

CREATE TABLE #Tempor  (
   -- ID  int  not null primary key identity(1,1),
    numdui16 varchar(100) ,
    numser12 varchar(100) , 
    numcer13 varchar(100) ,
    numdui11 varchar(100) ,
    numbul17  int  ,
    codemb06 varchar(100) ,
    desmer17 varchar(255) ,
    bulent17  int,
    Disponibles int,
    FechaCert datetime
)     

INSERT INTO #Tempor
select  d.numdui11 as numdui16,
        d.numser12  as numser12 , dc.numcer13  as numcer13, d.numdui11 as numdui11,
        dc.numbul14 as numbul17 ,   --Bultos Ingresados
        c.codemb06 as codemb06, --Embalaje
        dc.desmer14 as desmer17,  -- Mercaderia
        dc.bulent14 as bulent17, --Bultos entregados
        CAST(dc.numbul14-dc.bulent14 as Integer) as Disponibles
      --, CAST(dc.numbul14 - sum(d.numbul17) as Integer) as Disponibles
      , a.feccer13 as FechaCert
  from 
       DDCERADU13 AS a 
       INNER JOIN DDDCEADU14 AS dc ON a.numcer13=dc.numcer13
       INNER JOIN DDSERDEP12 AS c ON dc.numser12=c.numser12 AND a.numsol10=c.numsol10
       INNER JOIN DDSerDes17 AS d ON d.numcer13 = dc.numcer13 AND d.numser12 = dc.numser12
       INNER JOIN AAClientesAA AS e ON a.tipcli02=e.claseabc AND a.codcli02=e.contribuy 
 WHERE
       a.numbul13-a.bulent13>0 and --dc.buldes14 - d.numbul17>0 and
       a.codcli02=@RUC
      and dc.desmer14 like '%' + @DUA +'%' 
      and a.numcer13 like '%' +  @NUMORD  + '%'
      and a.numdui11 like '%' + @DuaDespacho +'%'  
      and dc.numbul14-dc.bulent14>0   
group by d.numdui11, d.numser12 , dc.numcer13 , d.numdui11 ,dc.numbul14, c.codemb06,dc.desmer14,dc.bulent14, CAST(dc.numbul14-dc.bulent14 as Integer), a.feccer13
--HAVING  (CAST(dc.numbul14 - sum(d.numbul17) as Integer) > 0)

SELECT (numcer13 + numser12) as ID ,* 
FROM    #Tempor
 Order by 
   CASE WHEN @Orden = 'ProductName'THEN desmer17 END asc,
   CASE WHEN @Orden = 'ProductName DESC'THEN desmer17 END desc,
   CASE WHEN @Orden = 'Tipo' THEN codemb06 END asc,
   CASE WHEN @Orden = 'Tipo DESC' THEN codemb06 END desc,
   CASE WHEN @Orden = 'Certificado' THEN numcer13 END asc,
   CASE WHEN @Orden = 'Certificado DESC' THEN numcer13 END desc,
   CASE WHEN @Orden = 'DuaDeposito' THEN numdui11 END asc,
   CASE WHEN @Orden = 'DuaDeposito DESC' THEN numdui11 END desc, 
   CASE WHEN @Orden = 'Bul_Ingresado' THEN CAST(numbul17 as Integer) END asc,
   CASE WHEN @Orden = 'Bul_Ingresado DESC' THEN CAST(numbul17 as Integer) END desc, 
   CASE WHEN @Orden = 'Bul_Despacho' THEN CAST(bulent17 as Integer) END asc,
   CASE WHEN @Orden = 'Bul_Despacho DESC' THEN CAST(bulent17 as Integer) END desc, 
   CASE WHEN @Orden = 'Bul_Disponibles' THEN CAST(numbul17 -  bulent17 as Integer) END asc,
   CASE WHEN @Orden = 'Bul_Disponibles DESC' THEN CAST(numbul17 -  bulent17 as Integer) END desc,
   CASE WHEN @Orden = '' THEN desmer17 END asc



/*
From DDCERADU13 AS a 
INNER JOIN DDDCEADU14 AS b ON a.numcer13=b.numcer13
INNER JOIN DDSERDEP12 AS c ON b.numser12=c.numser12 AND a.numsol10=c.numsol10
INNER JOIN AAClientesAA AS d ON a.tipcli02=d.claseabc AND a.codcli02=d.contribuy 
Where     
a.numbul13-a.bulent13>0 and b.numbul14-b.bulent14>0 and a.tipcli02=4 
and a.codcli02=@RUC and flgval13 = 1  
and b.desmer14 like '%' + @DUA +'%' 
and a.numcer13 like '%' +  @NUMORD  + '%'
and  a.numdui11 like '%' + @DuaDespacho +'%' 
And  Exists (select 1 from DDSerDes17 da where a.numcer13 = da.numcer13 and da.numser12 = c.numser12 and da.numbul17 = b.bulent14 and
            Exists(select 1 from ddduides16 dd where dd.numdui16 =  da.numdui16 and dd.numcer13 = a.numcer13))

select
       z.numdui16 as numdui16, 
       z.numser12 as numser12 , --Serie Deposito
       z.numcer13 as numcer13,
       z.numdui11 as numdui11, 
       z.numbul17 as numbul17, -- Bultos Ingresados
       z.codemb06 as codemb06,       
       z.desmer17 as desmer17 , 
       z.bulent17 as bulent17 ,-- Bultos Entregados Mercaderia
       CAST(z.numbul17 -  z.bulent17 as Integer) as Disponibles, -- bultos Disponibles      
       (select x.feccer13 from ddceradu13 x where x.numcer13 = z.numcer13) as FechaCert
   from DDSerDes17 z where numdui16 in (
	 Select a.numdui16 
	 From     
	  DRRetAdu18 a,DDDuiDes16 b,AAClientesAA d,DQMaeRep77 e,AAClientesAA f,DDDuiDep11 g,DDSolAdu10 h,     
	  DDRecMer69 l    
	 Where     	
	  a.numdui16=b.numdui16 and b.codage19=d.cliente and a.codrep77=e.codrep11 and    
	  b.tipcli02=f.claseabc and b.codcli02=f.contribuy and     
	  f.contribuy = @RUC and    
	  b.numdui11 = g.numdui11 and g.numsol10 = h.numsol10 and     
	  h.numsol10 = l.numsol62 and l.flgval69 = 1          
)  and z.numbul17 -  z.bulent17> 0 and z.desmer17 like '%' + @DUA +'%' 
   and z.numcer13 like '%' +  @NUMORD  + '%'
   and z.numdui11 like '%' + @DuaDespacho  

*/




GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETADU_WEB_SAA_REPORT]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDEN_RETADU_WEB_SAA_REPORT]    
@NUMORD varchar(50),    
@DUA varchar(200),  
@RUC varchar(11),    
@Tipo int  ,
@DuaDespacho varchar(50),
@Orden varchar (100)
AS    


Select 
a.numdui11 as numdui16,
b.numser12 as numser12,
a.numcer13 as numcer13,
a.numdui11 as numdui11,
b.numbul14 as numbul17, --Bultos Ingresados
c.codemb06 as codemb06, --Embalaje
b.desmer14 as desmer17, -- Mercaderia
b.bulent14 as bulent17, --Bultos Entregados
CAST(b.numbul14-b.bulent14 as Integer) as Disponibles,
a.feccer13 as FechaCert
From DDCERADU13 AS a 
INNER JOIN DDDCEADU14 AS b ON a.numcer13=b.numcer13
INNER JOIN DDSERDEP12 AS c ON b.numser12=c.numser12 AND a.numsol10=c.numsol10
INNER JOIN AAClientesAA AS d ON a.tipcli02=d.claseabc AND a.codcli02=d.contribuy 
Where     
a.numbul13-a.bulent13>0 and b.numbul14-b.bulent14>0 and a.tipcli02=4 
and a.codcli02=@RUC and flgval13 = 1  
and b.desmer14 like '%' + @DUA +'%' 
and a.numcer13 like '%' +  @NUMORD  + '%'
and  a.numdui11 like '%' + @DuaDespacho +'%' 










GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETIRO_ADUANA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDEN_RETIRO_ADUANA]    
@NUMORD CHAR(7)    
AS    
    
/*Select @NUMORD as NumRet , a.numser17 as Serie ,a.numbul17 as Bulto ,a.codemb06 as Tipo  ,a.desmer17 as Descr ,a.valfob17 as Total     
From DDSerDes17 a where numdui16 in (select numdui16 from drretadu18 where numret18 = @NUMORD )  */  
     
select IdOrd, duaDespacho as numRet,duaDeposito as deposito ,numcer13 as certificado, numser12 as serie, codemb06 as Tipo, 
desmer14 as Producto, cantidad as [Bulto a Despachar]
from OrdRetiroCarrito where idOrd = @numord  

GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETIRO_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDEN_RETIRO_SIMPLE]  
@NUMORD CHAR(7)    
  
AS    
select idOrd as IdOrd ,
       numcer13 as certificado, 
       numser12 as serie, 
       codemb06 as Tipo,
       desmer14 as Producto, 
       cantidad as [Bulto a Despachar]       
from OrdRetiroCarrito where idOrd = @numord  


GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETSIM_WEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDEN_RETSIM_WEB]    
@NUMORD varchar(50),    
@DUA varchar(200),  
@RUC varchar(11),    
@Tipo int    ,
@DuaDespacho varchar(50)

AS    
    
/*IF @NUMORD = ''     
Begin    
 SET @NUMORD = 0    
End    */
    
IF @Tipo = 11  --DUA Sipmple    
begin  
Select  
       d.contribuy,d.nombre,         
       a.numcer74 as Numcer,  
       convert(varchar,a.feccer74,103)  as Fecha,  
       b.numser67 as Serie ,  
       CAST(b.bulrec67 as Integer)as numbul,  
       CAST(b.bulent67 as Integer)as bultos,  
       sldbul= CAST(b.bulrec67-b.bulent67 as INTEGER),  
       b.codemb06 as Tipo,  
       b.desmer67 as descr         
From DDCerSim74 a  
Inner Join DDDSoSim67 b on a.numsol62=b.numsol62  
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy  
Where a.bultot74-a.bulent74>0 and b.bulrec67-b.bulent67>0 and a.flgval74=1 
      --and a.numcer74=@NUMCER and a.codcli02=@CODCLI  
      and b.desmer67 like '%'+ @DUA +'%'
      and a.numcer74 like '%' + @NUMORD + '%'
      and a.codCli02 = @RUC   
end  

/*BEGIN    
    
      Select     
  a.numret75 as numOrd,    
  a.fecret75 as FechaReg,    
  a.numcer74 as Numcer,    
                CASE a.flgval75     
                      when '1' then 'Registrada'    
                      when '0' then 'Anulado'    
                end as  Estado,    
  --a.codage19 as CodiAge,    
  --e.nombre as NombreE,    
  a.tipdoc55 as Tipo,    
  --d.nomrep77 as NombreRepre,    
  b.numsol62 as NumSol,    
  --b.tipcli02 as TipoCli,     
  b.codcli02 as CodCli,    
  c.nombre as Nombre,    
  a.pretot75 as preTotal,    
  a.obsret75 as Obse,    
  (select obscer74 from DDCerSim74 where numcer74 = a.numcer74) as NombreCert,    
                '-' as DuaDespacho,    
  '-' as DuaDeposito    
 From     
  DDRetSim75 a,DDCerSim74 b,AAClientesAA c,DQMaeRep77 d,AAClientesAA e,DDrecmer69 f    
 Where     
  (a.numret75 = isnull(@NUMORD,'0') or '0' = isnull(@NUMORD,'0'))    
  and b.codCli02 = @RUC AND    
  a.codrep77=d.codrep11 and b.tipcli02=c.claseabc and     
  b.codcli02=c.contribuy and     
  a.numcer74=b.numcer74 and b.flgval74='1' and     
  b.numsol62=f.numsol62 and f.flgval69='1' and     
  a.numcer74=b.numcer74 and a.codage19*=e.cliente and e.cliente<>''  and  
  b.numsol62 in (select numsol62 from  DDDSoSim67 where desmer67 like '%'+ @DUA +'%')   
 order by fecret75 desc    
END   */ 
  















GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETSIM_WEB_SAA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDEN_RETSIM_WEB_SAA]    
@NUMORD varchar(50),    
@DUA varchar(200),  
@RUC varchar(11),    
@Tipo int    ,
@DuaDespacho varchar(50),
@Orden varchar (100)
AS    
    
CREATE TABLE #Tempor  (
   -- ID  int  not null primary key identity(1,1),
    ID varchar(100),
    contribuy varchar(100) ,
    nombre varchar(100) , 
    numcer13 varchar(100) ,
    Fecha varchar(100) ,
    numser12  varchar(100)  ,
    numbul17 int ,
    bulent17 int ,    
    Disponibles int,
    codemb06 varchar(100),
    desmer17 varchar(255),
    numdui16 varchar(100),
    FechaCert datetime
)

INSERT INTO #Tempor
Select a.numcer74 + b.numser67,
       d.contribuy,
       d.nombre,         
       a.numcer74,  
       convert(varchar,a.feccer74,103)  as Fecha,  
       b.numser67 as Serie ,  
       b.bulrec67 ,  
       b.bulent67 ,  --entregados
       Disponibles = CAST(b.bulrec67-b.bulent67 as INTEGER),  
       b.codemb06 ,  
       b.desmer67 ,
       '' as duaDeposito,
       (select feccer74 from ddcersim74 where numcer74 = a.numcer74) as FechaCert        
From DDCerSim74 a  
Inner Join DDDSoSim67 b on a.numsol62=b.numsol62  
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy  
Where a.bultot74-a.bulent74>0 and b.bulrec67-b.bulent67>0 and a.flgval74=1 
      --and a.numcer74=@NUMCER and a.codcli02=@CODCLI  
      and b.desmer67 like '%'+ @DUA +'%'
      and a.numcer74 like '%' + @NUMORD + '%'
      and a.codCli02 = @RUC   

select * from #Tempor
Order by 
   CASE WHEN @Orden = 'ProductName'THEN  desmer17 END asc,
   CASE WHEN @Orden = 'ProductName DESC'THEN  desmer17 END desc,
   CASE WHEN @Orden = 'Tipo' THEN codemb06 END asc,
   CASE WHEN @Orden = 'Tipo DESC' THEN codemb06 END desc,
   CASE WHEN @Orden = 'Certificado' THEN numcer13 END asc,
   CASE WHEN @Orden = 'Certificado DESC' THEN numcer13 END desc,
   CASE WHEN @Orden = 'NroSerie' THEN numser12 END asc,
   CASE WHEN @Orden = 'NroSerie DESC' THEN numser12 END desc,   
   CASE WHEN @Orden = 'Bul_Ingresado' THEN CAST(numbul17 as Integer) END asc,
   CASE WHEN @Orden = 'Bul_Ingresado DESC' THEN CAST(numbul17 as Integer) END desc, 
   CASE WHEN @Orden = 'Bul_Despacho' THEN CAST(bulent17 as Integer) END asc,
   CASE WHEN @Orden = 'Bul_Despacho DESC' THEN CAST(bulent17 as Integer) END desc, 
   CASE WHEN @Orden = 'Bul_Disponibles' THEN CAST(numbul17-bulent17 as INTEGER) END asc,
   CASE WHEN @Orden = 'Bul_Disponibles DESC' THEN CAST(numbul17-bulent17 as INTEGER) END desc,
   CASE WHEN @Orden = '' THEN desmer17 END asc










GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETSIM_WEB_SAA_REPORT]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDEN_RETSIM_WEB_SAA_REPORT]    
@NUMORD varchar(50),    
@DUA varchar(200),  
@RUC varchar(11),    
@Tipo int    ,
@DuaDespacho varchar(50),
@Orden varchar (100)
AS    
    
Select a.numcer74 + b.numser67,
       d.contribuy,
       d.nombre,         
       a.numcer74,  
       convert(varchar,a.feccer74,103)  as Fecha,  
       b.numser67 as Serie ,  
       b.bulrec67 ,  
       b.bulent67 ,  --entregados
       Disponibles = CAST(b.bulrec67-b.bulent67 as INTEGER),  
       b.codemb06 ,  
       b.desmer67 ,
       '' as duaDeposito,
       (select feccer74 from ddcersim74 where numcer74 = a.numcer74) as FechaCert        
From DDCerSim74 a  
Inner Join DDDSoSim67 b on a.numsol62=b.numsol62  
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy  
Where a.bultot74-a.bulent74>0 and b.bulrec67-b.bulent67>0 and a.flgval74=1 
      --and a.numcer74=@NUMCER and a.codcli02=@CODCLI  
      and b.desmer67 like '%'+ @DUA +'%'
      and a.numcer74 like '%' + @NUMORD + '%'
      and a.codCli02 = @RUC   




GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDRET_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_CONSULTA_ORDRET_ADU    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDRET_ADU] @ORDRET CHAR(7)
AS
SELECT a.*
	,b.numdui11
	,b.fecdui16
	,b.tipcli02
	,b.codcli02
	,b.codage19
	,NombreA = d.nombre
	,e.nomrep77
	,b.numbul16
	,b.pesbru16
	,b.valfob16
	,b.valfle16
	,b.valcif16
	,b.valseg16
	,NombreC = f.nombre
	,l.codubi71
	,DEPOSITANTE = h.codcli02
	,l.codemb06
FROM DRRetAdu18 a
	,DDDuiDes16 b
	,AAClientesAA d
	,DQMaeRep77 e
	,AAClientesAA f
	,DDDuiDep11 g
	,DDSolAdu10 h
	,DDRecMer69 l
WHERE a.numret18 = @ORDRET
	AND a.numdui16 = b.numdui16
	AND b.codage19 = d.cliente
	AND a.codrep77 = e.codrep11
	AND b.tipcli02 = f.claseabc
	AND b.codcli02 = f.contribuy
	AND b.numdui11 = g.numdui11
	AND g.numsol10 = h.numsol10
	AND h.numsol10 = l.numsol62
	AND l.flgval69 = '1'

GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTA_SOLICITUD]
@NUMSOL CHAR(7)
AS


Select 
a.*,NombreC=b.nombre,NombreA=c.nombre,d.desemb06,NombreT=e.Nombre,f.despai07,g.despue02,
h.desnav08,i.codalm99,j.desalm99,isnull(de20,'') as  de20c ,isnull(de40,'') as de40c,isnull(cgsuelta10,'0') as cgsuelta10c
From
DDSolAdu10 a,AAClientesAA b,AAClientesAA c,DQEmbala06 d,
AAClientesAA e,Descarga..DQPAISES07 f,Descarga..DQPUERTO02 g,
Descarga..DQNAVIER08 h,DDAlmExp99 i,DQAlmDep99 j
Where 
a.numsol10=@NUMSOL and 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.codage19=c.cliente and a.codemb06=d.codemb06 and a.CodEmp04=e.contribuy and
a.codpai07=f.codpai07 and a.codpue03=g.codpue02 and a.codnav08=h.codnav08 and 
a.numsol10=i.numsol99 and i.codalm99=j.codalm99


GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_DATOS_DAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_DATOS_DAS]    
 @NumSolicitud AS VARCHAR(7)    
AS    
--DECLARE @NumSolicitud AS VARCHAR(7)    
DECLARE @FechaOperacion AS DATETIME    
    
--SET @NumSolicitud = '009261'    
    
SELECT @FechaOperacion = Min(T.fecing01)    
  FROM DDSolAdu10 A    
  LEFT JOIN DDTICKET01 T ON T.docaut01 = A.NumSol10     
 WHERE A.NumSol10  = @NumSolicitud    
   AND T.tipope01='D'     
   AND T.tipest01='S'     
-- AND T.numgui01=null     
    
SELECT NumMan10    
     , NumoManifiesto = right(A.NumMan10,5)    
 , AnnoManifiesto = substring(A.NumMan10,4,4)    
     , NumDocumentoTransporte = conemb10    
     , AnnoDAM = substring(numdui10,4,2), NumDAM = right(A.numdui10,6), AduanaDAM =left(A.numdui10,3)    
     , NumDUA = numdui10    
     , FechaOperacion = @FechaOperacion   
  FROM DDSolAdu10 A    
 WHERE A.NumSol10 = @NumSolicitud    
    
SELECT IdEquipamiento = numctr65     
     , NumPlaca = ISNULL(numpla01,'NO REGISTRADO')--(SELECT numpla01 FROM DDTICKET01 where docaut01 = @NumSolicitud and numtkt01 = D.numtkt01)    
     , IdPrecinto = 'A34443/P54343/M34545'    
     , CondicionPrecinto = '1/1/2'    
     , EntidadPrecinto = 'ENTIDAD/ENTIDAD/ENTIDAD'  
  FROM DDCtrDep65 D    
  LEFT JOIN DDTICKET01 T ON T.docaut01 = D.NumSol62 AND T.numtkt01 = D.numtkt01    
 WHERE D.NumSol62 = @NumSolicitud    
    
SELECT NumChasis = T.numcha01  
     , NumBultos = T.numbul01  
     , NroContenedor = D.numctr65  
  FROM DDTICKET01 T   
  LEFT JOIN  DDCtrDep65 D ON T.docaut01 = D.NumSol62 AND T.numtkt01 = D.numtkt01    
 WHERE T.docaut01  = @NumSolicitud    
   AND T.tipope01='D'     
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_DETALLE_OR_S]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_DETALLE_OR_S]
@NUMORD VARCHAR(7),
@NUMSOL VARCHAR(7)
AS


Select a.numser67, a.bultot76, b. codemb06, b.desmer67, a.pretot76 
From DDDReSim76 a
Inner Join DDDSoSim67 b on a.NumSer67 = b.NumSer67
Where a.numret75=@NUMORD and b.numsol62=@NUMSOL
Order by a.numser67
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_DOCUMENTOS_AUTORIZADOS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_DOCUMENTOS_AUTORIZADOS]  
@FECINI char(8),  
@FECFIN char(8),  
@CONTRYBUY varchar(11)  
AS  
  
DECLARE @TITULO as varchar(255)  
DECLARE @SUBTITULO as varchar(255)  

SET @FECINI='20150101'
SET @FECFIN=CONVERT(varchar(8),getdate(),112)
  
Select @TITULO='AUTORIZACIONES DE DESPACHO DE MERCADERIA'  
Select @SUBTITULO='FECHA DE REGISTRO DESDE : ' + right(@FECINI,2) + '/' + substring(@FECINI,5,2) + '/' + left(@FECINI,4) + '   HASTA : ' + right(@FECFIN,2) + '/' + substring(@FECFIN,5,2) + '/' + left(@FECFIN,4)  
  
  
if @CONTRYBUY='hvega'  
Select a.FECINI16,a.contribuy,b.nombre,a.OBSERV16,a.userid16,a.FECUSU16,TITULO=@TITULO,SUBTITULO=@SUBTITULO,FECHA=getdate()  
From DDAUTDOC16 a  
Inner Join AACLIENTESAA b on a.contribuy=b.contribuy  
Where convert(char(8),a.FECUSU16,112) between @FECINI and @FECFIN  
Order by b.nombre,a.FECUSU16  
  
if @CONTRYBUY<>'hvega'  
Select a.FECINI16,a.contribuy,b.nombre,a.OBSERV16,a.userid16,a.FECUSU16,TITULO=@TITULO,SUBTITULO=@SUBTITULO,FECHA=getdate()  
From DDAUTDOC16 a  
Inner Join AACLIENTESAA b on a.contribuy=b.contribuy  
Where convert(char(8),a.FECUSU16,112) between @FECINI and @FECFIN and a.contribuy=@CONTRYBUY  
Order by b.nombre,a.FECUSU16
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_DUADES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_DUADES] @NUMDES CHAR(14)
AS
DECLARE @totunid int

SET @totunid = (
		SELECT isnull(sum(unidad12), 0)
		FROM DDSerDes17
		WHERE NumDui16 = @NUMDES
		)

SELECT a.*
	,NombreC = b.nombre
	,NombreA = c.nombre
	,unidad12 = @totunid
FROM DDDuiDes16 a
	,AAclientesAA b
	,AAclientesAA c
WHERE a.tipcli02 = b.claseabc
	AND a.codcli02 = b.contribuy
	AND a.codage19 = c.cliente
	AND a.NumDui16 = @NUMDES
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_DUADES_BK]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_DUADES_BK]  
@NUMDES CHAR(14)  
AS  
  
Select   
a.*,NombreC=b.nombre,NombreA=c.nombre  
From   
DDDuiDes16 a,AAclientesAA b,AAclientesAA c  
Where   
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and   
a.codage19=c.cliente and a.NumDui16=@NUMDES

GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ENTREGA_ADUANERA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CONSULTAR_ENTREGA_ADUANERA    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_CONSULTAR_ENTREGA_ADUANERA]
@NUMENT CHAR(7)
AS

Select
a.fecent79,a.numret75,b.fecret18,c.codage19,NombreA=f.nombre,c.tipcli02,c.codcli02,
NombreC=d.nombre,a.tipdoc55,a.codrep77,e.nomrep77,a.codemb06,a.numpla79,a.flgval79,
a.flgemi79,a.obsent79,g.obscer13 ,a.pesbal79
From
DDEntMer79 a,DRRetAdu18 b,DDDuiDes16 c,AAClientesAA d,DQMaeRep77 e,
AAClientesAA f,DDCerAdu13 g
Where 
a.nument79=@NUMENT and
a.numret75=b.numret18 and b.numdui16=c.numdui16 and c.numcer13=g.numcer13 and 
c.tipcli02=d.claseabc and c.codcli02=d.contribuy and 
c.codage19=f.cliente and a.codrep77=e.codrep11
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ENTREGA_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_ENTREGA_SIMPLE]    
@NUMENT CHAR(7)    
AS    
    
Select     
a.fecent79,a.numret75,b.fecret75,c.numsol62,c.obscer74,b.codage19,NombreA=f.nombre,    
c.tipcli02,c.codcli02,NombreC=d.nombre,a.tipdoc55,a.codrep77,e.nomrep77,a.codemb06,    
a.numpla79,a.flgval79,a.flgemi79,a.obsent79,a.pesbal79    
From     
DDEntMer79 a  
inner join DDRetSim75 b on (a.numret75=b.numret75)  
inner join DDCerSim74 c on (b.numcer74=c.numcer74)  
inner join AAClientesAA d on (c.tipcli02=d.claseabc and c.codcli02=d.contribuy)  
inner join DQMaeRep77 e on (a.codrep77=e.codrep11)   
left  join AAClientesAA f on (b.codage19=f.cliente and c.codage19 <> '')    
Where     
a.nument79= @NUMENT  
GO
/****** Object:  StoredProcedure [dbo].[sp_Consultar_FechasContabiliza]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--|SERVIDOR: NEPTUNIA1
--|BD: DEPOSITOS

ALTER PROCEDURE [dbo].[sp_Consultar_FechasContabiliza]  
@controlversion char(1)=''
--,@version varchar(1)  
as  
declare   
@FeciniUltra char(8),  
@FecfinUltra char(8),  
@FecIniOfisis char(8),  
@FecFinOfisis char(8)  
  
select @FeciniUltra = convert(char(8), Fecini00, 112),   
@FecfinUltra = convert(char(8), fecfin00, 112)   
from  terminal.dbo.FIC_CONTA00  
where codfic00 = 'UL'  
  
  
select @FecIniOfisis = convert(char(8), Fecini00, 112),   
@FecFinOfisis = convert(char(8), fecfin00, 112)   
from  terminal.dbo.FIC_CONTA00  
where codfic00 = 'OF'  
  
select @FeciniUltra as FeciniUltra,   
@FecfinUltra as FecfinUltra,   
@FecIniOfisis as FecIniOfisis,   
@FecFinOfisis as FecFinOfisis  
return 0  
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_OR_SERVICIO_X_ORRETIRO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_OR_SERVICIO_X_ORRETIRO]  
@NUMORD VARCHAR(7)  
AS  
  
select ORD_CODIGO as ORD_SERVICIO,  
       ser_fechaIni as FechaIni,
       isnull(Convert(varchar(5),ser_fechaIni,108),'')as Hora ,  
       cal_CodigoIni as Zona1,  
       ser_referenciaIni as Direcc1 ,  
       cal_codigoFin as Zona2,  
       ser_referenciaFin as Direcc2,  
       (select  d.desote04  
          from dqotrter04 d  
            where  d.flag04=1 and d.codote04 = ssi_orden_servicio.cal_CodigoIni) as ZonaDesc1,  
       (select s.Cal_Descripcion from ssi_calles s  
     where s.cal_codigo = ssi_orden_servicio.cal_codigoFin  
    AND s.CAL_ESTADO <>'I' and s.cal_observacion is not null) as ZonaDesc2  
 from ssi_orden_servicio   
where ord_codigo in (Select ord_codigo from ssi_orden where ord_retiro = @NUMORD )  
and ser_codigo = '00004'  





GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ORDSER_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_ORDSER_ADU]
@NUMORD CHAR(6)
AS

Select 
a.*,NombreC=b.nombre,NombreA=c.nombre,ORDOT1 = isnull(a.ORDOT,0)
From 
DDOrdSer58 a,AAClientesAA b,AAClientesAA c
Where 
a.numord58=@NUMORD and 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
and a.codage19=c.cliente

GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ORDSER_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_ORDSER_SIM]    
@NUMORD CHAR(6)    
AS    
    
Select     
a.*, c.contribuy,NombreC=c.nombre, d.cliente,NombreA=d.nombre,ORDOT1 = isnull(a.ORDOT,0)    
From     
DDOrdSer58 a  
inner join AAClientesAA c on (a.tipcli02=c.claseabc and a.codcli02=c.contribuy)  
left  join AAClientesAA d on (a.codage19=d.cliente and a.codage19 <> '')   
Where     
a.numord58=@NUMORD

GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_SALDO_POR_RETIRAR_S]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_SALDO_POR_RETIRAR_S]
@NUMSOL varchar(7)

AS

Select numser67, bulsld67=bulrec67-bulret67, bulblo67, codemb06, desmer67 , preuni67, presld67=pretot67-preret67 
From DDDSoSim67 
where numsol62=@NUMSOL and bulrec67-bulret67>0
Order by numser67
GO
/****** Object:  StoredProcedure [dbo].[SP_CONTENEDOR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CONTENEDOR    Script Date: 08-09-2002 08:44:06 PM ******/
ALTER PROCEDURE [dbo].[SP_CONTENEDOR]
@NUMCON VARCHAR(11)
AS

Select *,numsol10=numsol62 from DDCtrDep65
Where numctr65=@NUMCON
GO
/****** Object:  StoredProcedure [dbo].[SP_CONTENEDORES_X_SOL_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CONTENEDORES_X_SOL_ADU    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_CONTENEDORES_X_SOL_ADU]
@NUMSOL CHAR(6)
AS

Select
a.numsol10,a.fecsol10,a.numdui10,b.numctr65,b.tamctr65,b.numtkt01,c.claseabc,c.contribuy,
c.nombre,d.numpla01,d.pesbru01,d.pestar01,d.pesnet01,d.tarcon01,d.fecing01,d.fecsal01
From 
DDSOLADU10 a,DDCTRDEP65 b,DESCARGA..AACLIENTESAA c,DDTICKET01 d
Where
a.numsol10=b.numsol62 and b.numsol62='A'+@NUMSOL and
a.tipcli02=c.claseabc and a.codcli02=c.contribuy and 
b.numtkt01=d.numtkt01 and a.flgval10='1'
GO
/****** Object:  StoredProcedure [dbo].[SP_CONTENEDORES_X_SOL_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_CONTENEDORES_X_SOL_SIM    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_CONTENEDORES_X_SOL_SIM]
@NUMSOL CHAR(6)
AS

Select
a.numsol62,a.fecsol62,b.numctr65,b.tamctr65,b.numtkt01,c.claseabc,c.contribuy,
c.nombre,d.numpla01,d.pesbru01,d.pestar01,d.pesnet01,d.tarcon01,d.fecing01,d.fecsal01
From 
DDSOLSIM62 a,DDCTRDEP65 b,AACLIENTESAA c,DDTICKET01 d
Where
a.numsol62=b.numsol62 and b.numsol62='S'+@NUMSOL and
a.tipcli02=c.claseabc and a.codcli02=c.contribuy and 
b.numtkt01=d.numtkt01
GO
/****** Object:  StoredProcedure [dbo].[SP_CONTROL_LIMPIA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CONTROL_LIMPIA    Script Date: 08-09-2002 08:44:06 PM ******/
ALTER PROCEDURE [dbo].[SP_CONTROL_LIMPIA]
@codcli char(8),
@tipcli char(1)
as
delete from dtwsacli100 
where codcli100 = @codcli and tipcli100= @tipcli
GO
/****** Object:  StoredProcedure [dbo].[SP_CONTROL_SALIDA2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CONTROL_SALIDA2    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_CONTROL_SALIDA2]
@tipcli char(1),
@codcli char(8),
@numcer char(9), 
@priing char(8)
as
Insert DTWSaCli100 
Select  a.numcer13, tipcli=@tipcli, codcli=@codcli, 
bulent=SUM(a.bultot79), cifent=SUM(a.pretot79+a.cuadep79) 
From Ddentmer79 a, ddticket01 b 
where a.numtkt01=b.numtkt01 and a.flgval79='1' 
and a.numcer13=@numcer and  
fecsal01< @priing group by numcer13
GO
/****** Object:  StoredProcedure [dbo].[sp_crear_Orden_Retiro_Simple]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_crear_Orden_Retiro_Simple]    
@NUMORD int, -- Numero Orden de Retiro    
@numcer varchar(9), --Certificado S0000    
@usuario nvarchar(15),    
@mtoRetiro decimal(15,3),   --Cantidad de Retiro    
@preUni decimal(15,3), -- Precio unitario    
@numser varchar(20), -- Numero de Serie    
@NUMSOL varchar(7) ,
@NroCarrito varchar(7)   
as    
    
Declare @mtoSaldoSubTotal decimal(15,3)    
Declare @numOrdstr varchar(7)    
BEGIN    
SET @mtoSaldoSubTotal = 0.00    
    
  select @NUMSOL = numsol62 from DDCerSim74 where numcer74 = @numcer
    

SET @numOrdstr = 'S' + right('000000' + convert(varchar(6),@NUMORD) ,6)  


IF NOT EXISTS ( SELECT 1 FROM DDDRESIM76 a Inner Join DDDSoSim67 b on a.NumSer67 = b.NumSer67    
              Where a.numret75=@numOrdstr and b.numsol62=@NUMSOL)    
 BEGIN    
   
 Insert DDRetSim75 (numret75,fecret75,numcer74,codage19,tipdoc55,codrep77,bultot75,pretot75,nument75,    
                    bulret75,preret75,obsret75,flgval75,flgemi75,nomusu75,fecusu75,numvig75)     
 values          ( @numOrdstr,getdate(),@numcer, '','','0000', 0, 0, 0,    
             0, 0,'','1','0',@usuario, getdate(),1)    
    
 INSERT INTO DDVIGSIM75 (NUMRET75) VALUES (@numOrdstr)     
 END    
    
   print 'ingreso1'  
select @preUni = preuni67 from dddsosim67 where numsol62 = @NUMSOL and numser67 = @numser

SET @mtoSaldoSubTotal = @mtoRetiro * @preUni    
   print 'ingreso2'  
Insert DDDReSim76(numret75, numser67, bultot76, pretot76, bulret76, preret76)     
values (@numOrdstr, @numser, @mtoRetiro, @mtoSaldoSubTotal, 0, 0)    
  
  print 'ingreso3' 
Update DDDSoSim67 set   
   bulret67=bulret67 + @mtoRetiro,   
   preret67=preret67+ @mtoSaldoSubTotal  
where numsol62     = @NUMSOL  
      and numser67 = @numser  
    
/**/    
print 'ingreso4' 
Update OrdRetiroCarrito 
  SET NumOrd = @numOrdstr
WHERE idOrd = @NroCarrito
  AND numser12 = @numser
  AND numcer13 =  @numcer  

END    
  




GO
/****** Object:  StoredProcedure [dbo].[SP_CUADRAR_ENTREGA_MERCADERIA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CUADRAR_ENTREGA_MERCADERIA] @lsnumdep varchar(13)
AS

DECLARE
@GetCuaDep decimal(15,3),
@totser11 int,
@numbul11 decimal(15,3),
@valcif11 decimal(15,3),
@totser12 int,
@bulent12 decimal(15,3),
@cifent12 decimal(15,3),
@totxpesar int


/********************************************************************************************
FECHA : 30/10/2003 10:08 AM
POR : Héctor Vega
Motivo : Realiza el cuadre del Saldo Cif entre la DUA de Deposito y la suma
	de los montos de las Entregas de Mercaderia realizadas para esa
	DUA de Deposito.
Observaciones :
No valido si la DUA de Deposito existe puesto que se supone que para haber
llegado hasta este punto ya se realizaron operaciones anteriores con la
DUA de Deposito, es decir ya tiene que existir de todas maneras.
*********************************************************************************************/

Select @GetCuaDep = 0
--Obtiene los Importes de la DUA de Deposito
Select @totser11=totser11,@numbul11=numbul11,@valcif11=valcif11 from DDDuiDep11 Where numdui11=@lsnumdep

--Obtiene el nmero de series depositadas
Select @totser12=count(*) From DDSerDep12 Where numdui11=@lsnumdep 
    
--Obtiene los Montos de lo entregado
Select @bulent12=coalesce(sum(b.numbul80),0),@cifent12=coalesce(sum(b.preent80),0)
From DDentmer79 a, dddenmer80 b
where a.nument79=b.nument79 and a.numdui11=@lsnumdep and a.flgval79='1'

--rdelacuba 07/03/2007
--Por tema de despachos de endosos con más de 1 entrega pendientes verificar que sólo quede una pendiente
select @totxpesar = count(*)
FROM DDentmer79
where numdui11=@lsnumdep and ultcer79 = 1 and numtkt01 is null

If (@totser11 = @totser12) And (@numbul11 = @bulent12) And (@totxpesar = 1)
	Select @GetCuaDep = @valcif11 - @cifent12
else
	Select @GetCuaDep=0

Select GetCuaDep=@GetCuaDep

GO
/****** Object:  StoredProcedure [dbo].[SP_CUADRAR_ENTREGA_MERCADERIA_TKT_AUTOMATICO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_CUADRAR_ENTREGA_MERCADERIA_TKT_AUTOMATICO] @lsnumdep VARCHAR(13)
AS
DECLARE @GetCuaDep DECIMAL(15, 3)
	,@totser11 INT
	,@numbul11 DECIMAL(15, 3)
	,@valcif11 DECIMAL(15, 3)
	,@totser12 INT
	,@bulent12 DECIMAL(15, 3)
	,@cifent12 DECIMAL(15, 3)
	,@totxpesar INT

/********************************************************************************************  
FECHA : 30/10/2003 10:08 AM  
POR : Héctor Vega  
Motivo : Realiza el cuadre del Saldo Cif entre la DUA de Deposito y la suma  
 de los montos de las Entregas de Mercaderia realizadas para esa  
 DUA de Deposito.  
Observaciones :  
No valido si la DUA de Deposito existe puesto que se supone que para haber  
llegado hasta este punto ya se realizaron operaciones anteriores con la  
DUA de Deposito, es decir ya tiene que existir de todas maneras.  
*********************************************************************************************/
SELECT @GetCuaDep = 0

--Obtiene los Importes de la DUA de Deposito  
SELECT @totser11 = totser11
	,@numbul11 = numbul11
	,@valcif11 = valcif11
FROM DDDuiDep11
WHERE numdui11 = @lsnumdep

--Obtiene el nmero de series depositadas  
SELECT @totser12 = count(*)
FROM DDSerDep12
WHERE numdui11 = @lsnumdep

--Obtiene los Montos de lo entregado  
SELECT @bulent12 = coalesce(sum(b.numbul80), 0)
	,@cifent12 = coalesce(sum(b.preent80), 0)
FROM DDentmer79 a
	,dddenmer80 b
WHERE a.nument79 = b.nument79
	AND a.numdui11 = @lsnumdep
	AND a.flgval79 = '1'

--rdelacuba 07/03/2007  
--Por tema de despachos de endosos con más de 1 entrega pendientes verificar que sólo quede una pendiente  
SELECT @totxpesar = count(*)
FROM DDentmer79
WHERE numdui11 = @lsnumdep
	AND ultcer79 = 1
	--AND numtkt01 IS NULL

IF (@totser11 = @totser12)
	AND (@numbul11 = @bulent12)
	AND (@totxpesar = 1)
	SELECT @GetCuaDep = @valcif11 - @cifent12
ELSE
	SELECT @GetCuaDep = 0

SELECT GetCuaDep = @GetCuaDep

GO
/****** Object:  StoredProcedure [dbo].[sp_Delete_Cliente_CRM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Delete_Cliente_CRM]  
@TipoDocumento char(1),   
@Contribuy varchar(11),  
@Msg_Error  varchar(500) output,            
@Msg_Valor  int output         
as  
begin  
  
	if (@Contribuy is null) or (@Contribuy = '')            
	 begin            
	  set @Msg_Error = 'Documento ingresado no es correcto, Favor de verificar.'            
	  Select @Msg_Error               
	 Select @Msg_Valor             
	 return             
	 end   

 declare @TipoDocumento_Val char(1)  
 select @TipoDocumento_Val = CodTipDoc from TIPODOCUMENTO_CRM where CodTipDocEqui = @TipoDocumento  
  
 if @TipoDocumento_Val is null            
 begin            
  set @Msg_Error = 'Tipo de Documento ingresado no se encuentra registrado, Favor de verificar.'            
  Select @Msg_Error                Select @Msg_Valor             
 return               
 end  
  
 declare @Existe int  
 select @Existe = count(*) from aaclientesaa where contribuy = @Contribuy  
 print @Existe  
  
 if @Existe = 0  
 begin  
  set @Msg_Error = 'Cliente no se encuentra registrado. Favor de verificar'  
	set @Msg_Valor = 0
  return   
 end  
   
 if @Existe > 0   
 begin  
  Delete from AACLIENTESAA   
  where CLASEABC = @TipoDocumento and CONTRIBUY = @Contribuy  
    
  set @Msg_Error = 'Cliente ha sido eliminado correctamente.'  
  set @Msg_Valor = 1 
 end  
  
 return   
end  
GO
/****** Object:  StoredProcedure [dbo].[sp_Deposito_Manifiesto_Elimina_Bl]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Deposito_Manifiesto_Elimina_Bl] 
@NumMan char(5), 
@anyo char(4), 
@BlHijo varchar(25)
as
delete DMENVADU01 where ANNO=@anyo and NUME_MC=@NumMan and NUMCON=@BlHijo
GO
/****** Object:  StoredProcedure [dbo].[sp_Deposito_Manifiesto_Genera_Bl]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Deposito_Manifiesto_Genera_Bl]
@anyo char(4),@NumMan char(5), @NumTer char(4),
@BlMadre char(25), @BlHijo char(25), @PtoOri char(5),
@CtrMan int, @CtrRec int, @BulMan int, @BulRec int,
@BulBue int, @BulFal int, @PesMan decimal(12,2),
@PesRec decimal (12,2), @PesFal decimal(12,2),
@PesSob decimal (12,2), @PesTar decimal(12,2),
@Consig varchar(40), @Marcas varchar(60),
@Descrip varchar(70), @PueDesca char(5),
@PueDesti char(5), @ActInv char(5), @AnyoInv char(4),
@Entrega char(8), @HorEnt char(5),@NroDet char(3),
@DocIng char(6), @FecDes char(8), @HorDes char(5),
@FlgHij char(1)
as
insert DMENVADU01 
(
ANNO, NUME_MC, CODI_TERM, NUMCONM, NUMCON, PUER_EMBAR,
CANT_EMPA, CANT_REMPA, CANT_BULTO, CANT_BRECI,
CANT_BBUEN, CANT_BFALT, TPESO_TMAN,TPESO_RECI,
TPESO_FALT, TPESO_SOBR, TPESO_TARA, CONSIGNA,
MARNUM, DESCRIP, PUER_DESCA, PUER_DESTI,
NUMACTMEST,ANOACTMEST,NUMDET,NRODOCIN)
values
(
@anyo ,@NumMan, @NumTer, @BlMadre, @BlHijo, @PtoOri,
@CtrMan, @CtrRec, @BulMan, @BulRec,
@BulBue, @BulFal, @PesMan, @PesRec, 
@PesFal, @PesSob, @PesTar, @Consig, 
@Marcas, @Descrip, @PueDesca, @PueDesti, 
@ActInv, @AnyoInv, @NroDet,@DocIng
)

update DMENVADU01 set 
CANT_BMALE=CANT_BRECI-CANT_BBUEN, CANT_BSOBR=CANT_BULTO-CANT_BRECI,
TPESO_BUEN=TPESO_RECI, TPESO_MALE=0,
--TPESO_BRUT=TPESO_TARA+TPESO_RECI,
TPESO_BRUT=TPESO_TMAN,
FECING= @Entrega+ ' ' + @HorEnt,
FEC_DESCA=@FecDes+ ' ' + @HorDes
where
ANNO=@anyo and NUME_MC=@NumMan and NUMCON=@BlHijo

if @FlgHij ='1'
update DMENVADU01 set FLG_MASTER_CON_H='1' where
NUMCONM=NUMCON and
ANNO=@anyo and NUME_MC=@NumMan and NUMCONM=@BlMadre 


GO
/****** Object:  StoredProcedure [dbo].[sp_Deposito_Manifiesto_Modifica_Bl]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Deposito_Manifiesto_Modifica_Bl]
@anyo char(4),@NumMan char(5), @NumTer char(4),
@BlMadre char(25), @BlHijo char(25), @PtoOri char(5),
@CtrMan int, @CtrRec int, @BulMan int, @BulRec int,
@BulBue int, @BulFal int, @PesMan decimal(12,2),
@PesRec decimal (12,2), @PesFal decimal(12,2),
@PesSob decimal (12,2), @PesTar decimal(12,2),
@Consig varchar(40), @Marcas varchar(60),
@Descrip varchar(70), @PueDesca char(5),
@PueDesti char(5), @ActInv char(5), @AnyoInv char(4),
@Entrega char(8), @HorEnt char(5),@NroDet char(3),
@DocIng char(6), @FecDes char(8), @HorDes char(5)

as

update DMENVADU01 
set PUER_EMBAR=@PtoOri,
CANT_EMPA=@CtrMan, CANT_REMPA=@CtrRec, 
CANT_BULTO=@BulMan, CANT_BRECI=@BulRec,
CANT_BBUEN=@BulBue, CANT_BFALT=@BulFal, 
TPESO_TMAN=@PesMan,TPESO_RECI=@PesRec,
TPESO_FALT=@PesFal, TPESO_SOBR=@PesSob, 
TPESO_TARA=@PesTar, CONSIGNA=@Consig,
MARNUM=@Marcas, DESCRIP=@Descrip, 
PUER_DESCA=@PueDesca, PUER_DESTI=@PueDesti,
NUMACTMEST=@ActInv,ANOACTMEST=@AnyoInv,
NUMDET=@NroDet,NRODOCIN=@DocIng
where
ANNO=@anyo and NUME_MC=@NumMan and NUMCON=@BlHijo

update DMENVADU01 set 
CANT_BMALE=CANT_BRECI-CANT_BBUEN, CANT_BSOBR=CANT_BULTO-CANT_BRECI,
TPESO_BUEN=TPESO_RECI, TPESO_MALE=0,
--TPESO_BRUT=TPESO_TARA+TPESO_RECI,
TPESO_BRUT=TPESO_TMAN,
FECING= @Entrega+ ' ' + @HorEnt,
FEC_DESCA=@FecDes+ ' ' + @HorDes
where
ANNO=@anyo and NUME_MC=@NumMan and NUMCON=@BlHijo
GO
/****** Object:  StoredProcedure [dbo].[sp_Depot_Balanza_Genera_Tkt_Manual]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[sp_Depot_Balanza_Genera_Tkt_Manual]      
@tipope01 char(1),
@tipest01 char(1),
@tipmer01 char(1),
@docaut01 varchar(7),
@numgui01 varchar(7),
@fecing01 smalldatetime,
@fecsal01 smalldatetime,
@pesbru01 int,
@pestar01 int,
@pesnet01 int,
@tarcon01 int,
@numpla01 varchar(6),
@numbul01 int,
@codemb06 varchar(3),
@numcha01 varchar(20),
@tipcli02 char(1),
@codcli02 varchar(11),
@codage19 varchar(4),
@nomusu01 varchar(15),
@fecusu01 smalldatetime,
@flgdes01 char(1),
@flgman01 char(1),
@tktter01 varchar(8),
@tarct101 int,
@tarct201 int
as      
declare @numtkt01 char(8)      
set nocount on      
SELECT @numtkt01=RIGHT('00000000' + CONVERT(VARCHAR(8), contkt01), 8) FROM DCTicket01      
UPDATE DCTicket01  SET  contkt01 = contkt01 + 1          

set @tipest01='S'


begin tran      
Insert DDTicket01 (
numtkt01,tipope01,tipest01,tipmer01,docaut01,numgui01,fecing01,fecsal01,pesbru01,
pestar01,pesnet01,tarcon01,numpla01,numbul01,codemb06,numcha01,tipcli02,codcli02,
codage19,nomusu01,fecusu01,flgdes01,flgman01,tktter01,tarct101,tarct201) values (
@numtkt01,@tipope01,@tipest01,@tipmer01,@docaut01,@numgui01,@fecing01,@fecsal01,@pesbru01,
@pestar01,@pesnet01,@tarcon01,@numpla01,@numbul01,@codemb06,@numcha01,@tipcli02,@codcli02,
@codage19,@nomusu01,@fecusu01,@flgdes01,@flgman01,@tktter01,@tarct101,@tarct201
)
IF @@ERROR <> 0       
 begin     
  rollback tran    
  return -1    
 end     

commit tran      
select @numtkt01
GO
/****** Object:  StoredProcedure [dbo].[SP_DETALLE_CERTIFICADO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_DETALLE_CERTIFICADO    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_DETALLE_CERTIFICADO]
@NUMCER varchar(11)
AS

if substring(@NUMCER,1,1)='A'
    Select 
    a.numser12,numbul12=a.numbul14,b.codemb06,b.tipmer72,b.parara12,desmer12=a.desmer14,
    a.valtar14,valfob=b.valfob12,valfle=b.valfle12,valseg=b.valseg12,a.unidad12,a.tipuni12 
    From 
    DDDCeAdu14 a,DDSerDep12 b 
    Where a.numdui11=b.numdui11 And a.NumSer12=b.NumSer12 and 
    a.numcer13=@NUMCER
    Order by a.numser12
else
    Select 
    numser67,numbul67,bulrec67,codemb06,tipmer72,desmer67,preuni67,pretot67,valtar67 
    From 
    DDDSoSim67 
    Where NumSol62=@NUMCER
    Order by numser67
GO
/****** Object:  StoredProcedure [dbo].[SP_DETALLE_ORDEN_RETIRO_EN_ENTREGA_MERCADERIA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_DETALLE_ORDEN_RETIRO_EN_ENTREGA_MERCADERIA] @DUIDES VARCHAR(14)
AS
SELECT a.numdui11
	,a.numcer13
	,a.numser12
	,a.numser17
	,a.numbul17
	,SldOrd17 = a.numbul17 - (
		SELECT coalesce(sum(d.numbul80), 0)
		FROM ddentmer79 c
		INNER JOIN DDDEnMer80 d ON c.nument79 = d.nument79
		WHERE c.NumDui16 = @DUIDES
			AND c.flgval79 = 1
			AND d.numser70 = a.numser12
		)
	,a.codemb06
	,a.desmer17
	,a.cifuni17
	,sldcif17 = a.valcif17 - (
		SELECT coalesce(sum(preent80), 0)
		FROM ddentmer79 c
		INNER JOIN DDDEnMer80 d ON c.nument79 = d.nument79
		WHERE c.NumDui16 = @DUIDES
			AND c.flgval79 = 1
			AND d.numser70 = a.numser12
		)
	,a.unidad12
	,a.tipuni12
	,SldAlm14 = b.numbul14 - (
		SELECT coalesce(sum(d.numbul80), 0)
		FROM ddentmer79 c
		INNER JOIN DDDEnMer80 d ON c.nument79 = d.nument79
		WHERE c.NumDui16 = @DUIDES
			AND c.flgval79 = 1
			AND d.numser70 = a.numser12
		)
	,b.bulblo14
	,SldOrd17UC = a.unidad12 - (
		SELECT coalesce(sum(d.numbul12), 0)
		FROM ddentmer79 c
		INNER JOIN DDDEnMer80 d ON c.nument79 = d.nument79
		WHERE c.NumDui16 = @DUIDES
			AND c.flgval79 = 1
			AND d.numser70 = a.numser12
		)
	,SldAlm14UC = b.unidad12 - (
		SELECT coalesce(sum(d.numbul12), 0)
		FROM ddentmer79 c
		INNER JOIN DDDEnMer80 d ON c.nument79 = d.nument79
		WHERE c.NumDui16 = @DUIDES
			AND c.flgval79 = 1
			AND d.numser70 = a.numser12
		)
FROM DDSerDes17 a
INNER JOIN DDDCeAdu14 b ON a.numdui11 = b.numdui11
	AND a.numser12 = b.numser12
WHERE a.valcif17 - (
		SELECT coalesce(sum(preent80), 0)
		FROM ddentmer79 c
		INNER JOIN DDDEnMer80 d ON c.nument79 = d.nument79
		WHERE c.NumDui16 = @DUIDES
			AND c.flgval79 = 1
			AND d.numser70 = a.numser12
		) > 0
	AND a.NumDui16 = @DUIDES
ORDER BY numser17

GO
/****** Object:  StoredProcedure [dbo].[SP_DEUDA_PENDIENTE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_DEUDA_PENDIENTE    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_DEUDA_PENDIENTE]
@CODCLI VARCHAR(11)
AS

Select b.contribuy,a.feccom52,a.numcom52,pendiente=(a.subtot52+a.igvtot52)-a.monpag52 
From ddcabcom52 a,aaclientesaa b
where 
a.flgval52='1' and a.flgcan52='0' and 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
b.contribuy=@CODCLI
order by a.numcom52
GO
/****** Object:  StoredProcedure [dbo].[SP_DIRECCION_ZONA_WEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_DIRECCION_ZONA_WEB]   
@RUC varchar(20)  
as    
select 'Codigo' = cal_Codigo   
      ,'Direccion' = Direccion  
from DIRECCION_DISTRITO_ZONAS  
where (RUC = @RUC or '0' = @RUC) 


GO
/****** Object:  StoredProcedure [dbo].[SP_DISTRITOS_ZONA_WEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_DISTRITOS_ZONA_WEB] 
@calCod int
as  
select 'Codigo' = cal_Codigo 
      ,'Distrito' = distrito
from DISTRITO_ZONAS
where (cal_codigo = @calCod or 0 = @calCod)







GO
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTOS_AUTORIZADOS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_DOCUMENTOS_AUTORIZADOS]

AS


Select a.CONTRIBUY,b.nombre,FECINI16=convert(varchar(10),a.FECINI16,103),a.userid16,a.fecusu16,a.OBSERV16     
From ddautdoc16 a
Left Join AAclientesAA b on a.contribuy=b.contribuy
Order by fecusu16 desc,b.nombre
GO
/****** Object:  StoredProcedure [dbo].[SP_DUADES_ORDRET_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_DUADES_ORDRET_ADU] @DUIDES CHAR(14)
AS
SELECT a.*
	,NombreA = c.nombre
	,NombreC = b.nombre
	,e.codubi71
	,e.codemb06
FROM DDDuiDes16 a(NOLOCK)
	,AAClientesAA b(NOLOCK)
	,AAClientesAA c(NOLOCK)
	,DDceradu13 d(NOLOCK)
	,DDrecmer69 e(NOLOCK)
WHERE a.NumDui16 = @DUIDES
	AND a.codage19 = c.cliente
	AND a.tipcli02 = b.claseabc
	AND a.codcli02 = b.contribuy
	AND a.numcer13 = d.numcer13
	AND d.flgval13 = '1'
	AND d.numsol10 = e.numsol62
	AND e.flgval69 = '1'

GO
/****** Object:  StoredProcedure [dbo].[SP_DUIDEP_DUIDEP]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_DUIDEP_DUIDEP]      
@NUMDEP CHAR(13)      
AS      
      
--Select a.*,b.*,c.*,NombreC=c.nombre,d.*,NombreA=d.nombre      
--From DDDuiDep11 a,DDSolAdu10 b,AAClientesAA c,AAClientesAA d      
--Where a.numsol10=b.numsol10 and      
--b.tipcli02=c.claseabc and b.codcli02=c.contribuy and      
--b.codage19=d.cliente and a.NumDui11=@NUMDEP    
    
declare @unidad decimal(10,2)    
select @unidad = isnull(sum(unidad12),0)    
from DDDuiDep11 a    
inner join DDSerDep12 b on a.numsol10 = b. numsol10    
where  a.NumDui11=@NUMDEP    
      
Select a.*,b.*,c.*,NombreC=c.nombre,d.*,NombreA=d.nombre,Unidad=@unidad,
case when a.unidad11 is null then @unidad else a.unidad11 end as unidad11 
From DDDuiDep11 a,DDSolAdu10 b,AAClientesAA c,AAClientesAA d      
Where a.numsol10=b.numsol10 and      
b.tipcli02=c.claseabc and b.codcli02=c.contribuy and      
b.codage19=d.cliente and a.NumDui11=@NUMDEP
GO
/****** Object:  StoredProcedure [dbo].[sp_EjecutarDTS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_EjecutarDTS](@Paquete varchar(500) )   
As   
  
   declare @Sql varchar(8000)   
  
--   Set @Sql = 'dtsrun /s (Neptunia30) /u(sa) /p(neptunia) /n ' + @Paquete  
  
   set @Sql = 'dtsrun /s (local) /e /n ' + @Paquete  
  
   exec master.dbo.xp_cmdshell @Sql  
GO
/****** Object:  StoredProcedure [dbo].[SP_EliminaCarrito]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EliminaCarrito]
	@idCarrito	int,	
        @Numcer  varchar(10),
        @Serie   varchar(4)
as
	Delete from OrdRetiroCarrito
	where IdOrd = @idCarrito
         and numcer13 = @Numcer
         and numser12 = @Serie

GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_ADUANA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_CORREO_ADUANA]        
@AgenteOrd varchar (4000),        
@Titulo varchar (200)        
AS        
Declare        
@message      varchar(4000),        
@rc        int        
Begin        
        
        
        set @message = @AgenteOrd        
         
         
        
       exec @rc = master.dbo.xp_smtp_sendmail        
                       @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',        
                       @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',        
                       @TO                 = N'juan.noel@neptunia.com.pe;wilder.perez@neptunia.com.pe;gerardo.salinas@neptunia.com.pe;alfredo.viayrada@neptunia.com.pe;augusto.erazo@neptunia.com.pe;adeposito@neptunia.com.pe',        
                       @CC                 = N'miguel.benites@neptunia.com.pe;carmen.rivadeneira@neptunia.com.pe',        
                       @BCC                = N'josue.alzamora@neptunia.com.pe',        
                       @priority           = N'NORMAL',        
                       @subject            = @titulo,        
                       @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,        
                       @messagefile        = N'',        
                       @type               = N'text/Html',        
                       @attachment         = N'',        
                       @attachments        = N'',        
                       @codepage           = 0,        
                       @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'        
        
        
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_ADUANA_NO_TRA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_CORREO_ADUANA_NO_TRA]          
@AgenteOrd varchar (4000),          
@Titulo varchar(100)          
AS          
Declare          
@message      varchar(4000),          
@rc        int          
Begin          
          
          
  set @message = @AgenteOrd          
                          
                          
          
             exec @rc = master.dbo.xp_smtp_sendmail          
              @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',                                                                        
              @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',          
              @TO                 = N'juan.noel@neptunia.com.pe;wilder.perez@neptunia.com.pe;gerardo.salinas@neptunia.com.pe;alfredo.viayrada@neptunia.com.pe;augusto.erazo@neptunia.com.pe;adeposito@neptunia.com.pe',          
               @replyto            = N'al.porras@neptunia.com.pe',          
               @CC                 = N'carmen.rivadeneira@neptunia.com.pe;miguel.benites@neptunia.com.pe;edwin.pascual@neptunia.com.pe;rosa.latorre@neptunia.com.pe;juan.esquen@neptunia.com.pe',          
               @BCC                = N'josue.alzamora@neptunia.com.pe',          
               @priority           = N'NORMAL',          
               @subject            = @Titulo,          
               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,          
               @messagefile        = N'',          
               @type               = N'text/Html',          
               @attachment         = N'',          
               @attachments        = N'',          
               @codepage           = 0,          
               @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'          
          
          
END    
    
  
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_ANULA_ORDEN]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_CORREO_ANULA_ORDEN]      
@AgenteOrd varchar (4000),      
@nroOrden varchar (200)      
AS      
Declare      
@message      varchar(4000),      
@rc        int      
Begin      
      
      
       set @message = 'Orden de Servicio Cancelada'      
      
       exec @rc = master.dbo.xp_smtp_sendmail      
                       @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',      
                       @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',      
                       @TO                = N'al.porras@neptunia.com.pe',      
                       @replyto           = N'al.porras@neptunia.com.pe',      
                       @CC                 = N'al.porras@neptunia.com.pe',      
                       --@BCC              = N'al.porras@gruponeptunia.com',      
                       @priority           = N'NORMAL',      
                       @subject            = 'NRO.ORDEN DE SERVICIO CANCELADA',      
                       @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,      
                       @messagefile        = N'',      
                       @type               = N'text/Html',      
                       @attachment         = N'',      
                       @attachments        = N'',      
                       @codepage           = 0,      
                       @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'      
      
      
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_CORREO_CLIENTE]        
@AgenteOrd varchar (4000),        
@correoCliente varchar(500),        
@asunto varchar(100)        
AS        
Declare        
@titulo    varchar(1000),        
@message      varchar(4000),        
@rc        int        
Begin        
        
        
        set @message = @AgenteOrd        
         
 set @titulo ='CARGA NACIONALIZADA ' + @asunto                                         
        
                                               exec @rc = master.dbo.xp_smtp_sendmail        
                                                               @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',        
                                                               @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',        
                                                               @TO                 = @correoCliente,--@correoCliente, --N        
                                                               @replyto            = N'josue.alzamora@neptunia.com.pe',--@correoCliente,--'rtello@neptunia.com.pe;waniya@neptunia.com.pe',        
                                                               @CC                 = N'carmen.rivadeneira@neptunia.com.pe;juan.esquen@neptunia.com.pe',        
                                                               @BCC                = N'',        
                                                               @priority           = N'NORMAL',        
                                                               @subject            = @titulo,        
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,        
                                                               @messagefile        = N'',        
                                                               @type               = N'text/Html',        
                                                               @attachment         = N'',        
                                                               @attachments        = N'',        
                                                               @codepage           = 0,        
                                                               @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'        
        
        
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE_CONDEUDA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_CORREO_CLIENTE_CONDEUDA]            
@ruc varchar (20),            
@NUMORD int,            
@MESSDEUDA varchar (500),            
@correo varchar(3000)            
AS            
Declare            
@message      varchar(4000),            
@titulo varchar(100),            
@rc        int,            
@razon varchar(300)            
Begin            
            
select @razon = razonsocial from dinfosuserSAAWEB where cuenta = @ruc            
            
        set @message = 'Estimado Usuario. <br> Cliente ' + @ruc + ' '+ @razon + ' tiene una orden de Retiro creada por el sistema Servicio Logístico Web <br><br>' + convert(varchar,@NUMORD) +'<br><table width=80% border=1><tr bgcolor=#DBE3EA><td>PRODUCTO<
  
    
      
        
          
/td><td>TIPO</td><td>CERTIFICADO</td><td>SERIE</td><td>DESPACHAR</td> </tr>' + @correo + '</table><br><br>' + @MESSDEUDA            
             
     set @titulo = 'ORDEN RETIRO ' + convert(varchar,@NUMORD)            
            
                                               exec @rc = master.dbo.xp_smtp_sendmail            
                                                               @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',            
                                                               @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',            
                                                               @TO                = N'nadienka.franco@neptunia.com.pe;alan.avalos@neptunia.com.pe;manuel.cairo@neptunia.com.pe;',            
                                                               @replyto            = N'',            
                                                               @CC                 = N'carmen.rivadeneira@neptunia.com.pe;juan.esquen@neptunia.com.pe;Depautorizado@neptunia.com.pe',            
                                                               @BCC                = N'josue.alzamora@neptunia.com.pe',            
                                                               @priority           = N'NORMAL',            
                                                               @subject            = @titulo ,            
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,            
                                                               @messagefile        = N'',            
                                                               @type               = N'text/Html',            
                                                               @attachment         = N'',            
                                                               @attachments        = N'',            
                                                               @codepage           = 0,            
                                                               @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'            
            
            
END      
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE_DESPACHAR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_CORREO_CLIENTE_DESPACHAR]        
@AgenteOrd varchar (4000),        
@Ruc varchar(20),        
@asunto varchar(100)        
AS        
Declare        
@titulo    varchar(1000),        
@message      varchar(4000),        
@rc        int,        
@email varchar(1000)        
Begin        
        
Select @email = emailContactos  from dinfosusersaaweb where cuenta = @ruc;        
        
        set @message = @AgenteOrd        
         
 set @titulo =  @asunto  + '/ DESPACHO NEPTUNIA'                                       
        
                                               exec @rc = master.dbo.xp_smtp_sendmail        
                                                               @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',        
                                                               @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',        
                                                               @TO                 = @email,        
                                                               @replyto            = N'',        
                                                               @CC                 = N'carmen.rivadeneira@neptunia.com.pe;juan.esquen@neptunia.com.pe',        
                                                               @BCC                = N'josue.alzamora@neptunia.com.pe',        
                                                               @priority           = N'NORMAL',        
                                                               @subject            = @titulo,        
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,        
                                                               @messagefile        = N'',        
                                                               @type               = N'text/Html',        
                                                               @attachment         = N'',        
                                                               @attachments        = N'',        
                                                               @codepage           = 0,        
                                                               @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'        
        
        
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE_DUA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_CORREO_CLIENTE_DUA]      
@AgenteOrd varchar (4000),      
@nroSoli   varchar(100)      
AS      
Declare      
@titulo    varchar(1000),      
@correoCliente varchar(400),      
@message      varchar(4000),      
@ruc varchar(20),      
@razon varchar(200),      
@rc        int      
Begin      
--@correoCliente=      
      
Select distinct @ruc = a.contribuy from OrdRetiroAduanaWeb a where a.idOrd = @nroSoli      
      
      
update OrdRetiroAduanaWeb      
SET Estado = 'A'      
Where idOrd = @nroSoli      
      
select @correoCliente = emailContactos  , @razon = razonsocial from DINFOSUSERSAAWEB  where cuenta = @ruc      
      
      
        set @message = @AgenteOrd      
       
 set @titulo ='CARGA NACIONALIZADA / ' + @razon                                         
      
                                               exec @rc = master.dbo.xp_smtp_sendmail      
                                                               @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',      
                                                               @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',      
                                                               @TO                 = @correoCliente,      
                                                               @replyto            = N'josue.alzamora@neptunia.com.pe',      
                                                               @CC                 = N'wendy.aniya@neptunia.com.pe;carmen.rivadeneira@neptunia.com.pe;lita.souza-ferreira@neptunia.com.pe',      
                                                               @BCC                = N'',      
                                                               @priority           = N'NORMAL',      
                                                               @subject            = @titulo,      
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,      
                                                               @messagefile        = N'',      
                                                               @type               = N'text/Html',      
                                                               @attachment         = N'',      
                                                               @attachments        = N'',      
                                                               @codepage           = 0,      
                                                               @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'      
      
      
END  
    
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE_PRUEBA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_CORREO_CLIENTE_PRUEBA]      
@AgenteOrd varchar (4000),      
@correoCliente varchar(500),      
@asunto varchar(100)      
AS      
Declare      
@titulo    varchar(1000),      
@message      varchar(4000),      
@rc        int      
Begin      
      
      
        set @message = @AgenteOrd      
       
 set @titulo ='CARGA NACIONALIZADA ' + @asunto                                       
      
                                               exec @rc = master.dbo.xp_smtp_sendmail      
                                                               @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',      
                                                               @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',      
                                                               @TO                 = @correoCliente,--@correoCliente, --N      
                                                               @replyto            = N'josue.alzamora@neptunia.com.pe',--@correoCliente,--'rtello@neptunia.com.pe;waniya@neptunia.com.pe',      
                                                               @CC                 = N'josue.alzamora@neptunia.com.pe',      
                                                               @BCC                = N'',      
                                                               @priority           = N'NORMAL',      
                                                               @subject            = @titulo,      
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,      
                                                               @messagefile        = N'',      
                                                               @type               = N'text/Html',      
                                                               @attachment         = N'',      
                                                               @attachments        = N'',      
                                                               @codepage           = 0,      
                                                               @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'      
      
      
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_OPERACIONES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_CORREO_OPERACIONES]      
@AgenteOrd varchar (4000),      
@NroId varchar(10)      
      
AS      
Declare      
@titulo    varchar(1000),      
@message   varchar(4000),      
@rc        int,      
@strCabecera varchar(2000),      
@pieCabecera varchar(2000),      
@path varchar(200),      
@ruta varchar(2000),@archivo varchar(100),      
@razon varchar(200)      
Begin      
      
select @razon = razonsocial        
from dinfosusersaaweb where cuenta in (      
Select distinct contribuy  from  ordRetiroAduanaWeb where idOrd = @NroId )      
      
set @strCabecera = '<font face=arial size=3>Estimado usuario  <br> Se a realizado una nueva nacionalización de carga ' + @razon + '<br><br> Ingrese al siguiente enlace http://www.aduanet.gob.pe y valide la DUA <br><table width=70% border=1><tr bgcolor=#DB
  
    
      
E3EA><td>NUMID</td><td>RUC</td><td>CERTIFICADO</td><td>SERIE</td><td>PRODUCTO</td><td>TIPO</td><td>CANTIDAD</td><td>DUA.DESPACHO</td> </tr>'      
set @pieCabecera = '</table></font><br><font face=arial size=3>verifique la DUA y proceda a su registro en el sistema SAS<br><a href=http://www.neptunia.com.pe/Serviciologistico/Nacional/confirma.aspx?pageAlm=n&NroAduana='+ @NroId      
 +'>No olvidar que una vez generada la orden retiro debe registrarla</a> </font><br><br> Atentamente <br>Servicio Logístico Neptunia'      
      
set @ruta = ''      
      
      
      
Declare Path_cursor cursor for      
 Select Archivo from drutadua where nroid = @NroId and estado = 'A'      
Open Path_cursor      
      
Fetch Next From Path_cursor into @archivo      
While @@Fetch_Status = 0      
Begin      
   Set @path = '\\neptunia16\Portal\web\Serviciologistico\Uploads\' +  @archivo + ';'      
   Set @ruta = @ruta + @path       
  print  @ruta      
 Fetch Next From Path_cursor into @archivo      
End      
Close Path_cursor      
 deallocate Path_cursor      
set  @AgenteOrd = @strCabecera +  @AgenteOrd + @pieCabecera      
        set @message = @AgenteOrd      
       
 set @titulo ='CREAR ORDEN DE RETIRO / ' +  @razon                                        
      
                                               exec @rc = master.dbo.xp_smtp_sendmail      
                                                               @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',      
                                                               @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',      
                                                               @TO                 = N'nadienka.franco@neptunia.com.pe',--@mailclie, --N'MyFriend@HisDomain.com',      
                                                               @replyto            = N'',      
                                                               @CC                 = N'carmen.rivadeneira@neptunia.com.pe',      
                                                               @BCC                = N'',      
                                                               @priority           = N'NORMAL',      
                                                               @subject            = @titulo,      
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,      
                                                               @messagefile        = N'',      
                                                               @type               = N'text/Html',      
                                                               @attachment         = N'',      
                                                               @attachments        = @ruta,      
                                                               @codepage           = 0,      
                                                               @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'      
      
      
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_DISTRIBUCCION]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ENVIAR_DISTRIBUCCION]      
@AgenteOrd varchar (4000),      
@Titulo   varchar(200)      
AS      
Declare      
@message      varchar(4000),      
@rc        int      
Begin      
      
      
        set @message = @AgenteOrd      
       
       
      
               exec @rc = master.dbo.xp_smtp_sendmail      
                               @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',      
                               @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',      
                               @TO                 = N'fernando.fernandez@neptunia.com.pe;miguel.orderique@neptunia.com.pe;miguel.estrada@neptunia.com.pe',--@mailclie, --N'MyFriend@HisDomain.com',      
                               @replyto            = N'',      
                               @CC                 = N'wendy.aniya@neptunia.com.pe;lita.souza-ferreira@neptunia.com.pe;carmen.rivadeneira@neptunia.com.pe',      
                               @BCC                = N'josue.alzamora@neptunia.com.pe',      
                               @priority           = N'NORMAL',      
                               @subject            = @titulo,      
                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,      
                               @messagefile        = N'',      
                               @type               = N'text/Html',      
                               @attachment         = N'',      
                               @attachments        = N'',      
                               @codepage           = 0,      
                               @server             = N'correo.neptunia.com.pe'--N'mail.mydomain.com'      
      
      
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_ESTCOMEMI]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ESTCOMEMI    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_ESTCOMEMI]
@FECINI CHAR(8),
@FECFIN CHAR(8),
@TIPCLIE CHAR(1),
@CLIENTE VARCHAR(11)
AS

/*Validos sin Cancelar*/
Select a.TipCli02,a.Codcli02,a.tipdes52,a.docdes52,a.CodCom50,a.NumCom52,a.FecCom52,a.numcer52,
a.numper52,a.iniper52,a.finper52,Total=a.SubTot52+a.IGVTot52,Abono=a.MonPag52,
Debe=a.SubTot52+a.IGVTot52-a.MonPag52,a.feccan52,a.ultpag52,Estado="PENDIENTE",b.nombre
From DDCABCOM52 a,AAClientesAA b
Where a.FlgEmi52='1' and a.FlgVal52 = '1' and a.FlgCan52='0' and 
a.tipdes52=b.claseabc and (a.docdes52=b.contribuy or a.docdes52=b.catcliente) and
(convert(char(8),a.feccom52,112) between @FECINI and @FECFIN) and 
a.tipdes52=@TIPCLIE and (a.docdes52=@CLIENTE or a.docdes52=substring(@cliente,3,8))
Union all
/*Validos Cancelados*/
Select a.TipCli02,a.Codcli02,a.tipdes52,a.docdes52,a.CodCom50,a.NumCom52, 
a.FecCom52,a.numcer52,a.numper52,a.iniper52,a.finper52,Total=a.SubTot52+a.IGVTot52, 
Abono=a.SubTot52+a.IGVTot52,Debe=0,a.feccan52,a.ultpag52,Estado="CANCELADO",b.nombre
From ddcabcom52 a,AAClientesAA b
Where a.FlgEmi52='1' and a.FlgVal52 = '1' and a.FlgCan52='1' and 
a.tipdes52=b.claseabc and (a.docdes52=b.contribuy or a.docdes52=b.catcliente) and 
(convert(char(8),a.feccom52,112) between @FECINI and @FECFIN) and 
a.tipdes52=@TIPCLIE and (a.docdes52=@CLIENTE or a.docdes52=substring(@cliente,3,8))
GO
/****** Object:  StoredProcedure [dbo].[sp_ExisteRango]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_ExisteRango    Script Date: 08-09-2002 08:44:04 PM ******/
ALTER PROCEDURE [dbo].[sp_ExisteRango]
	@TablaB varchar(50),
	@CampoB varchar(50),
	@FechaIni varchar(8),
	@FechaFin varchar(8)
As
	Execute("Select * from " + @TablaB + " where CONVERT(varchar(8), " + @CampoB + ",112)" + " between '" + @FechaIni + "' and '" + @FechaFin + "'")
GO
/****** Object:  StoredProcedure [dbo].[SP_EXPORTEXCEL_OT]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_EXPORTEXCEL_OT]
@ESTADO VARCHAR(25),
@CODCLIENTE VARCHAR(11),
@CODSERV VARCHAR(11)
AS    
BEGIN    
SET NOCOUNT ON;   
	 
	 SET @ESTADO=LTRIM(RTRIM(@ESTADO))
	 SET @CODCLIENTE=LTRIM(RTRIM(@CODCLIENTE))
	 SET @CODSERV=LTRIM(RTRIM(@CODSERV))
	 
	 DECLARE @FLGESTADO VARCHAR(1)
	 --SET @ESTADO=SUBSTRING(@ESTADO,1,1)
	 IF @ESTADO='TODOS'
	 BEGIN
		SET @FLGESTADO=''
	 END
	 IF @ESTADO='ACTIVO'
	 BEGIN
		SET @FLGESTADO='F'
	 END
	 IF @ESTADO='ANULADO'
	 BEGIN
		SET @FLGESTADO='A'
	 END
	 IF @ESTADO='FACTURADO'
	 BEGIN
		SET @FLGESTADO='U'
	 END
	 
	 DECLARE @SELECT VARCHAR(3000)
	 DECLARE @WHERE VARCHAR(500)
	 
	 SET @SELECT='  
	 SELECT DISTINCT 
	 ESTADO=CASE WHEN A.flgval58=''1'' AND ISNULL(B.numcom52,'''')='''' THEN ''ACTIVO''
				 WHEN A.flgval58=''0'' THEN ''ANULADO''
				 WHEN A.flgval58=''1'' AND ISNULL(B.numcom52,'''')<>'''' THEN ''FACTURADO''
				 END
	 ,A.numord58 AS ORDENSERV
	 ,A.fecord58 AS EMISION
	 ,A.numcer58 AS CERTIFICADO
	 ,ISNULL(B.numcom52,'''') AS NROFACT
	 ,E.CODCLIENTE AS CODCLIENTE
	 ,LTRIM(RTRIM(G.NOMBRE)) AS RAZONSOCIAL
	 ,C.SERVIC52 AS SERVICIO
	 ,C.DESSER52 AS CONCEPTO
	 ,B.uniser59 AS CANTIDAD
	 ,MONEDA=CASE WHEN D.TIPMON54=''S'' 
				  THEN ''SOLES''
				  ELSE ''DOLARES''
				  END
	 ,B.valcob59 AS COSTO
	 ,(B.valcob59 * B.uniser59) AS COSTOTOTAL
	 ,LTRIM(RTRIM(ISNULL(E.CONSIG32,''''))) AS CONSIGNATARIO
	 ,TIPOUNIDAD=CASE WHEN ISNULL(E.TIPOUNIDAD,'''')=''''
					  THEN F.TIPOUNIDAD33
					  ELSE E.TIPOUNIDAD
					  END
	 ,ISNULL(f.CAPACIDAD33,0) AS CAPACUNIDKG
	 ,ISNULL(f.CAPACIDADM33,0) AS CAPACUNIDM3
	 ,ISNULL(F.PLACA33,'''') AS PLACA
	 ,ISNULL(F.TRANSPORTE33,'''') AS CONDUCTOR
	 ,ISNULL(E.FECDESPACHO,'''') AS FECDESPACHO
	 ,ISNULL(E.FECCITA,'''') AS HORACITA
	 ,ISNULL(E.FACTURA,'''') AS FACTURA
	 ,ISNULL(E.GUIA,'''') AS GUIA
	 ,ISNULL(E.UNIDADES,'''') AS CANTUNIDAD
	 ,ISNULL(E.BULTO,'''') AS CANTBULTOS
	 ,ISNULL(E.PESO,0) AS PESO
	 ,ISNULL(E.VOLUMEN,0) AS VOLUMEN
	 ,ISNULL(E.PALETA,'''') AS PALETA
	 ,ISNULL(E.VALORIZADO,0) AS VALORIZADOCARGA
	 ,ISNULL(E.DIRECCION,'''') AS DIRECCION
	 ,ISNULL(E.ZONA,'''') AS ZONA
	 ,ISNULL(H.FECALLEG32,''19990101'') AS FECHALLEGADA
	 ,ISNULL(H.FECSAL32,''19990101'') AS FECHASALIDA
	 ,ISNULL(H.OBSER_OTD32,'''') AS OBSERVACION
	 ,E.NRO_PLAREC32 
	 FROM DDOrdSer58 A WITH (NOLOCK)  
	 INNER JOIN DDDOrSer59 B WITH (NOLOCK) ON A.numord58=B.numord58
	 INNER JOIN SERVICIOS_ORS_SER C WITH (NOLOCK) ON (B.codcon51=C.SERVIC52 AND C.TARIFA52=B.valser59) OR (B.codcon51=C.SERVIC52 AND C.TARIFA52S=B.valser59)
	 INNER JOIN DDPLAREC32 E WITH (NOLOCK) ON A.numord58=E.NUMORD58
	 INNER JOIN DDCLIMON54 D WITH (NOLOCK) ON E.CODCLIENTE=D.CODCLI54 AND A.tipcli02=D.TIPCLI54
	 INNER JOIN DDDETREC33 F WITH (NOLOCK) ON E.ID_PLAREC32=F.ID_PLAREC32
	 INNER JOIN AACLIENTESAA G WITH (NOLOCK) ON A.tipcli02=G.CLASEABC AND E.CODCLIENTE=G.CONTRIBUY
	 LEFT JOIN DDSTADESP32 H WITH (NOLOCK) ON E.NRO_PLAREC32=H.NRO_PLAREC32 '
	 
	 SET @WHERE=' 
	 WHERE E.CODCLIENTE LIKE ' + '''' + '%' + @CODCLIENTE + '%' + '''' + ' AND C.SERVIC52 LIKE ' + '''' + '%' + @CODSERV + '%' + ''''
	 
	 IF @FLGESTADO='U'
	 BEGIN
		SET @WHERE = @WHERE + ' AND ISNULL(B.numcom52,'''')<>'''' '
	 END
	 IF @FLGESTADO='F' OR @FLGESTADO='A'
	 BEGIN
		SET @WHERE = @WHERE + ' AND E.FLGREC32 LIKE ' + '''' + '%' + @FLGESTADO + '%' +'''' + ' AND ISNULL(B.numcom52,'''')='''' '
	 END
	 
	 PRINT '...' + @SELECT + @WHERE
	 
	 Execute(@SELECT + @WHERE) 
	  
SET NOCOUNT OFF;  
END

GO
/****** Object:  StoredProcedure [dbo].[sp_FacPa_AgregarMaquinaria]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_FacPa_AgregarMaquinaria]  

 @desmaq61 varchar(10),  

 @descmaq61 varchar(100),  

 @tipmaq61 int,  

 @sermaq61 int,

 @flgmaq61 char(1),  

 @usuarioreg varchar(30),  

 @codmaq61 tinyint output  

as  

 insert into depositos.dbo.PDMAQUIN61  

 (desmaq61,descmaq61, servmaq61, tipmaq61,flgmaq61,usuarioreg)   

 values(@desmaq61,@descmaq61, @sermaq61, @tipmaq61,@flgmaq61,@usuarioreg)  

select @codmaq61 = @@identity  


GO
/****** Object:  StoredProcedure [dbo].[sp_FacPa_ListaMaquinas]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_FacPa_ListaMaquinas]  

as  

Select codmaq61, desmaq61,descmaq61,tipmaq61,flgmaq61,  servmaq61

from depositos.dbo.PDMAQUIN61   

return 0  


GO
/****** Object:  StoredProcedure [dbo].[sp_FacPa_ListaTipoMaquinas]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_FacPa_ListaTipoMaquinas]  

as  

Select codtip61,

descri61

from depositos.dbo.PDTIPMAQ61   

return 0  


GO
/****** Object:  StoredProcedure [dbo].[sp_FacPa_ModificarMaquinaria]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_FacPa_ModificarMaquinaria]  

 @codmaq61 tinyint,  

 @desmaq61 varchar(10),  

 @descmaq61 varchar(100),  

 @tipmaq61 int,  

 @sermaq61 int,

 @flgmaq61 char(1),  

 @usuariomod varchar(30)  

as  

 update depositos.dbo.PDMAQUIN61   

 set  desmaq61=@desmaq61,descmaq61=@descmaq61,  

  tipmaq61=@tipmaq61, servmaq61 = @sermaq61,

  flgmaq61=@flgmaq61,  

  usuariomod = @usuariomod,fechamod=getdate()  

 where codmaq61 = @codmaq61  

return 0  


GO
/****** Object:  StoredProcedure [dbo].[SP_FINDCLIENTE_DET_OT]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_FINDCLIENTE_DET_OT]  
@OT VARCHAR(8)  
AS   
BEGIN  
SET NOCOUNT ON;  
	 SET @OT=LTRIM(RTRIM(@OT))  
	 
	 SELECT B.CLASEABC,LTRIM(RTRIM(B.NOMBRE)) AS NOMBRE,  
	 A.CODCLIENTE
	 ,TIPOUNIDAD=CASE WHEN ISNULL(A.TIPOUNIDAD,'')='' 
					  THEN ISNULL(C.TIPOUNIDAD33,'')
					  ELSE A.TIPOUNIDAD
					  END
	 ,A.NUMORD58  
	 FROM DDPLAREC32 A WITH (NOLOCK)  
	 LEFT JOIN DDDETREC33 C WITH (NOLOCK) ON A.ID_PLAREC32=C.ID_PLAREC32
	 INNER JOIN AACLIENTESAA B WITH (NOLOCK) ON A.CODCLIENTE=B.CONTRIBUY  
	 WHERE A.NRO_PLAREC32=@OT  
SET NOCOUNT OFF;  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_FRMDUIDES_SERIES_DUADEP]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_FRMDUIDES_SERIES_DUADEP] --'A00969400'           
@NUMCER varchar(9)            
AS            
            
--Select a.numser12,bulsld=a.numbul14-a.buldes14,b.codemb06,pessld=a.pesbru14-a.pesdes14,fobsld=a.valfob14-a.fobdes14,a.desmer14,b.parara12,            
--flesld=a.valfle14-a.fledes14,segsld=a.valseg14-a.segdes14,a.unidad12,a.tipuni12             
--From DDDCeAdu14 a            
--Inner Join DDSerDep12 b on a.numdui11=b.numdui11 And a.NumSer12=b.NumSer12            
--Where             
--(a.numbul14-a.buldes14+a.pesbru14-a.pesdes14+a.valfob14-a.fobdes14+a.valfle14-a.fledes14+a.valseg14-a.segdes14)<>0 and             
--a.numcer13 =@NUMCER            
--Order by a.numser12          
        
--declare @totunid decimal (9,5)            
--set @totunid =(select isnull(sum(unidad12),0) from  DDSerDes17 where numcer13 = @NUMCER)            
    
    
--|SOLUCINAR LOS SALDOS NEGATIVOS    
--|FRANKLIN MILLA 06-04-2015    
/*  
IF SUBSTRING(@NUMCER,1,1)='A'    
BEGIN    
 DECLARE @NUMDUI VARCHAR(11)    
 ---NUM_SOL     
 SELECT @NUMDUI=numdui11 FROM DDDCeAdu14 WHERE numcer13 = @NUMCER --AND  CONVERT(INT,numser12)>1820    
     
 UPDATE DDDCeAdu14 SET fledes14=valfle14,segdes14=valseg14,fobdes14=valfob14 WHERE numcer13 = @NUMCER    
     
 --SELECT numser12,numbul12,buldes12 FROM DDSerDep12 WHERE numdui11 = '1181470007263' --AND CONVERT(INT,numser12)>1820    
 UPDATE DDSerDep12 SET buldes12=numbul12 WHERE numdui11 = @NUMDUI --and numser12 NOT IN ('0053','0136','0178','0285') --AND CONVERT(INT,numser12)>1820    
END    
*/  
--|    
              
Select a.numser12,bulsld=a.numbul14-a.buldes14,b.codemb06,pessld=a.pesbru14-a.pesdes14,fobsld=a.valfob14-a.fobdes14,a.desmer14,b.parara12,              
flesld=a.valfle14-a.fledes14,segsld=a.valseg14-a.segdes14,            
--a.unidad12,            
unidad12=         
(select a.unidad12 - (isnull(sum(unidad12),0))         
from  DDSerDes17         
where numcer13 = @NUMCER and  numser12 =a.numser12        
),        
a.tipuni12  
,CodigoWarrant = ISNULL(b.flgcons_ws12, '0')
,ValorWarrant = ISNULL(b.warrant12, '')              
From DDDCeAdu14 a              
Inner Join DDSerDep12 b on a.numdui11=b.numdui11 And a.NumSer12=b.NumSer12              
Where               
(a.numbul14-a.buldes14+a.pesbru14-a.pesdes14+a.valfob14-a.fobdes14+a.valfle14-a.fledes14+a.valseg14-a.segdes14)<>0 and               
a.numcer13 =@NUMCER              
Order by a.numser12 
GO
/****** Object:  StoredProcedure [dbo].[sp_getfec]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_getfec    Script Date: 08-09-2002 08:44:04 PM ******/
ALTER PROCEDURE [dbo].[sp_getfec]
as
	select fecser=getdate()
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInfo]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[sp_GetInfo]
	@Campos varchar(300),
	@Tablas varchar(300),
	@Where varchar(300),
	@GroupBy varchar(300),
	@OrderBy varchar(300)
As
	Declare @xWhere varchar(300),  @xGroupBy varchar(300), @xOrderBy varchar(300)
	if @Where<>" " Select @xWhere= " Where " + @Where
	if @GroupBy<>" " Select @xGroupBy = " Group By " + @GroupBy
	if @OrderBy<>" " Select @xOrderBy = " Order By " + @OrderBy
	Execute("Select " + @Campos + " From " + @Tablas + @xWhere + @xGroupBy + @xOrderBy)



GO
/****** Object:  StoredProcedure [dbo].[SP_Graba_Carga_Solicitud_Aut]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Graba_Carga_Solicitud_Aut]
@NroSol01 varchar(10),
@TotSer01 int,
@PesTot01 decimal(15,4),
@CodTer01 char(04),
@Vigenc01 int,
@Tiempo01 varchar(04),
@FecNum01 char(8) ,
@NroSer01 char(04),
@CanBul01 int,
@CodEmb01 char(03) ,
@UniCon01 int ,
@TipMer01 char(02) ,
@DesMer01 varchar(100),
@CodPro01 char(05),
@ParAre01 varchar(15),
@PesBrt01 decimal(15,4),
@MonFob01 decimal(15,4),
@MonFle01 decimal(15,4),  
@MonSeg01 decimal(15,4),
@CodUsu01 varchar(15)

AS    
    insert DDCARGASOL01 (NroSol01, TotSer01, PesTot01, CodTer01, Vigenc01, Tiempo01, FecNum01,
	    NroSer01, CanBul01, CodEmb01, UniCon01, TipMer01, DesMer01, CodPro01, 
	    ParAre01, PesBrt01, MonFob01, MonFle01, MonSeg01, CodUsu01   ) 
	values
	  (@NroSol01, @TotSer01, @PesTot01, @CodTer01, @Vigenc01, @Tiempo01, @FecNum01,
	    @NroSer01, @CanBul01, @CodEmb01, @UniCon01, @TipMer01, @DesMer01, @CodPro01, 
	    @ParAre01, @PesBrt01, @MonFob01, @MonFle01, @MonSeg01, @CodUsu01   )
GO
/****** Object:  StoredProcedure [dbo].[sp_Graba_Carga_Tkt_Manual]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Graba_Carga_Tkt_Manual]
	@TipDep01 as char(1),
	@TipMer01 as char(1),
	@FecIng01 as smalldatetime,
	@NroSol01 as char(6),
	@CanBul01 as int,
	@NroCha01 as varchar(17),
	@PesCar01 as int,
	@CodUsu01 as varchar(15)
as
insert DDCARGATKT01
	(TipDep01, TipMer01, FecIng01, NroSol01, CanBul01, NroCha01, PesCar01, CodUsu01)
	values
	(@TipDep01, @TipMer01, @FecIng01, @NroSol01, @CanBul01, @NroCha01, @PesCar01, @CodUsu01)

GO
/****** Object:  StoredProcedure [dbo].[SP_GRABAR_RUTADUADESPACHO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_GRABAR_RUTADUADESPACHO]
@ruc varchar (20),
@NroId varchar(10),
@Ruta varchar(200),
@Nom_Arch varchar(100)
AS

Begin

INSERT INTO DRUTADUA
 VALUES ( @NroId,@Ruc,@Ruta,'A',@Nom_Arch)

END


GO
/****** Object:  StoredProcedure [dbo].[SP_HABILITAR_AGENTE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_HABILITAR_AGENTE    Script Date: 08-09-2002 08:44:06 PM ******/
ALTER PROCEDURE [dbo].[SP_HABILITAR_AGENTE] AS

update ddmenues01 set MENSAJ01='A',PENSAR01='S'
where SISTEM01='SIDA' 
--and USUARI01 not in ('hvega')
GO
/****** Object:  StoredProcedure [dbo].[SP_Imprimir_Acta_Apertura_Rep]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Imprimir_Acta_Apertura_Rep]
       @NumSol  Char( 7  )
As

SET NOCOUNT ON

SELECT d.codter09, 
       'Av. Argentina 2085 - Callao ' as direccion, 
       al.desalm99 as almacen,  s.numman10 as manifiesto, 
       s.numdui10  as dua,      d.fecdui11 as fecha, d.fecdui11 as fecresolucion, 
       c.nombre    as agente,   b.contribuy, b.nombre as cliente, 
       t.nomter09  as Terminal, r.numrec69 as guia, r.guirem69 as guia2, r.pesnet69 as peso, 
       r.priing69  as fechainicio, Convert( Char( 15 ), r.priing69, 114 ) as horainicio, 
       ap.NumSol,    ap.NumActa,   ap.NomTra,    ap.PlaVeh, ap.NroDocSal, 
       ap.FecSalTer, Convert( Char( 15 ), ap.HorSalTer, 114 ) as HorSalTer, 
       ap.PesTotSal, ap.FecTer, Convert( Char( 15 ), ap.HorTer, 114 ) as HorTer,  
       ap.ObsAct,    ap.ClaBul, tm.desemb06, ap.CodUbi,  ub.desubi71, ap.FecUsu11, 
       f.numctr65, IsNULL( h.PrecOrig, '' ) as PrecOrig, 
       IsNULL( h.PrecAdu, '' ) as PrecAdu,   IsNULL( h.NroBulRec, 0) As NroBulRec, 
       IsNULL( h.NroBulFal, 0) As NroBulFal, IsNULL( h.NroBulSob, 0) As NroBulSob
FROM  DDSolAdu10 s (nolock) 
      INNER JOIN DDDuiDep11 d  (nolock) on s.numsol10 = d.numsol10 
      INNER JOIN DQTerAdu09 t  (nolock) on d.codter09 = t.CodTer09 
      INNER JOIN DDRecMer69 r  (nolock) on s.numsol10 = r.numsol62 and r.flgval69 = '1'
      INNER JOIN DDAlmExp99 a  (nolock) on s.numsol10 = a.numsol99 
      INNER JOIN DQAlmDep99 al (nolock) on a.codalm99 = al.codalm99 
      INNER JOIN AAClientesAA b (nolock) on s.tipcli02=b.claseabc and s.codcli02=b.contribuy 
      INNER JOIN AAClientesAA c (nolock) on s.codage19=c.cliente 
      INNER JOIN DDACTAPER11 ap (nolock) on ap.numsol = s.numsol10
      INNER JOIN DQEMBALA06 tm (nolock) on tm.codemb06 = ap.ClaBul COLLATE database_default
      INNER JOIN DQTipUbi71  ub (nolock) on ub.codubi71 = ap.CodUbi,
      DDCtrDep65 f (nolock)
      LEFT OUTER JOIN DDACTAPER11 g ON  f.numsol62 = g.numsol 
      LEFT OUTER JOIN DDACTAPERDET12 h ON  h.NumActa = g.NumActa and f.numctr65 = h.codcon04 
WHERE s.numsol10 = @NumSol and s.numsol10 = f.numsol62 

SET NOCOUNT OFF


GO
/****** Object:  StoredProcedure [dbo].[SP_Imprimir_Acta_Inventario_Rep]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC SP_SEL_Acta_Inventario_Rep 'A004577'
-- DROP procedure SP_SEL_Acta_Inventario_Rep
ALTER PROCEDURE [dbo].[SP_Imprimir_Acta_Inventario_Rep]
      @NumSol  Char( 7  )
As

SET NOCOUNT ON

SELECT s.numdui10 as dua, c.nombre as agente,  
       b.contribuy + ' ' + b.nombre as cliente,  
       r.pesnet69 as peso, 
      ( SELECT sum( e.numbul70 ) as numBultos
        FROM DDDReMer70 e (NOLOCK) Where r.numrec69 = e.numrec69 ) as NumBultos,
       d.NumActa, d.NumSol, d.FecActa, d.ObsAct,
       d.FlgAbierto, d.FlgMalaCond, d.FlgReconoci, d.FlgFaltante, d.FlgSobrante     
FROM  DDSolAdu10 s (nolock)  
      INNER JOIN DDRecMer69 r (nolock)   on s.numsol10 = r.numsol62 and r.flgval69 = 1
      INNER JOIN AAClientesAA b (nolock) on s.tipcli02 = b.claseabc and s.codcli02 = b.contribuy  
      INNER JOIN AAClientesAA c (nolock) on s.codage19 = c.cliente  
      INNER JOIN DDACTAINV13  d (nolock) on d.NumSol   = s.numsol10 
WHERE s.numsol10 = @NumSol

SET NOCOUNT OFF
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_CER_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_CER_ADU    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_CER_ADU]
@NUMCER CHAR(9)
AS

Select
a.*
From 
DDCERADU13 a,AAClientesAA b
Where 
a.numcer13=@NUMCER
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_CERTIFICADO_ADUANE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_CERTIFICADO_ADUANE    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_CERTIFICADO_ADUANE]
@NUMCER CHAR(9)
AS

Select
a.numcer13,a.numdui11,a.pesbru13,a.pescer13,a.fobcer13,a.cifcer13,a.feccer13,a.obscer13,
NombreC=g.nombre,g.direccion,g.claseabc,g.contribuy,
j.despai07,
NombreT=i.nombre,

b.conemb10,b.faccom10,b.fecfac10,
f.priing69,
c.abaleg11,c.fecdui11,
NombreA=h.nombre,
d.numser12,d.numbul14,d.desmer14,d.numbul14,
e.codemb06,e.parara12
From
DDCerAdu13 a,DDSolAdu10 b,DDDuiDep11 c,DDDCeAdu14 d,DDSerDep12 e,DDRecMer69 f,
AAClientesAA g,AAClientesAA h,AAClientesAA i,
Descarga..DQPaises07 j
Where 
a.numcer13=@NUMCER and 
a.numcer13=d.numcer13 and a.numdui11=c.numdui11 and a.numsol10=b.numsol10 and 
a.tipcli02=g.claseabc and a.codcli02=g.contribuy and 
b.numsol10=f.numsol62 and b.codage19=h.cliente and b.codemp04=i.contribuy and 
b.codpai07=j.codpai07 and 
d.numdui11=e.numdui11 and d.numser12=e.numser12 and
f.flgval69='1'
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_CERTIFICADO_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_CERTIFICADO_SIMPLE    Script Date: 08-09-2002 08:44:07 PM ******/    
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_CERTIFICADO_SIMPLE]    
@NUMCER CHAR(7)    
AS    
    
Select     
a.*,NombreC=b.nombre,b.direccion,NombreA=c.nombre,d.pesbru85,d.pesnet85,    
e.numser67,e.bulrec67,e.codemb06,e.desmer67,e.preuni67,e.pretot67    
From     
DDCERSIM74 a  
inner join AAClientesAA b on (a.tipcli02=b.claseabc and a.codcli02=b.contribuy)  
inner join dvpesing85 d on (a.numsol62=d.numsol62)  
inner join DDDSOSIM67 e on (a.numsol62=e.numsol62)  
left  join AAClientesAA c on (a.codage19=c.cliente and a.codage19 <> '')  
Where     
a.numcer74=@NUMCER    

GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_CTRS_EN_ORDEN_SERVICIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_CTRS_EN_ORDEN_SERVICIO] 
@pOrd_Ser varchar(6)
AS

Declare @Filas integer
Declare @Cer_Sol varchar(9)
Declare @Tip_Dep char(1)
Declare @Num_Sol varchar(7)
Declare @Num_Cer varchar(9)
Declare @name varchar(250)
Declare @Ord_Ser varchar(6)
Declare @Cadena varchar(255)

Select @Ord_Ser=@pOrd_Ser
Select @Cadena=''

Select @Num_Cer=a.numcer58,@Num_Sol=a.numsol58,@FILAS=count(b.numord58) 
From ddordser58 a Inner Join DDDOrSer59 b on a.numord58=b.numord58
Where a.numord58=@Ord_Ser and b.numuni54>0
Group by a.numcer58,a.numsol58

if @Filas>0
Begin
	Select @Cer_Sol=case when numsol58 is null then 'C' else 'S' end From ddordser58 where numord58=@Ord_Ser
	if @Cer_Sol='C'
	Begin
		Select @Tip_Dep=left(numcer58,1) from ddordser58 where numord58=@Ord_Ser
		if @Tip_Dep='A'
			Begin
				Select @Num_Sol=numsol10 from DDceradu13 where numcer13=@Num_Cer
			End
		else
			Begin
				Select @Num_Sol=numsol62 from DDcersim74 where numcer74=@Num_Cer	
			End
	End

	Begin
		DECLARE CUR_DEP CURSOR FOR
		select numctr65 from DDCtrDep65 where numsol62=@Num_Sol
		OPEN CUR_DEP
		FETCH NEXT FROM CUR_DEP INTO @name
		WHILE (@@fetch_status <> -1)
		Begin
			Select @cadena=@cadena+'Nro.CNT: '+@name+', '
			FETCH NEXT FROM CUR_DEP INTO @name
		End
		
		CLOSE CUR_DEP
		DEALLOCATE CUR_DEP
	End
End

Select Cadena=@cadena

GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ENTREGA_ADUANERA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_ENTREGA_ADUANERA    Script Date: 08-09-2002 08:44:15 PM ******/
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_ENTREGA_ADUANERA]
@NUMENT CHAR(7)
AS

Select 
c.nument79,c.fecent79,c.numdui11,c.numcer13,c.numret75,c.numpla79,c.obsent79,c.codrep77,c.ultret79,
b.nombreb,b.tipdep,b.coddep,b.tipdes,b.coddes,b.nombrec,
d.numser70,d.numbul80,d.marmer80,d.numbul80,
f.codemb06,f.desmer17,f.parara17,
e.nomrep77
From
DRRetAdu18 a,DVRetAdu33_112 b,DDEntMer79 c,DDDEnMer80 d,DQMaeRep77 e,DDSerDes17 f
Where 
c.nument79=@NUMENT and
a.numret18=b.numret18 and a.fecret18=b.fecret18 and a.numdui16=b.numdui16 and 
a.obsret18=b.obsret18 and a.codrep77=b.codrep11 and b.numret18=c.numret75 and
c.nument79=d.nument79 and c.codrep77=e.codrep11 and
d.numdui16=f.numdui16 and d.numser17=f.numser17
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ENTREGA_ADUANERA_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_ENTREGA_ADUANERA    Script Date: 08-09-2002 08:44:15 PM ******/
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_ENTREGA_ADUANERA_NEW] @NUMENT CHAR(7)
AS
SELECT c.nument79
	,c.fecent79
	,c.numdui11
	,c.numcer13
	,c.numret75
	,c.numpla79
	,c.obsent79
	,c.codrep77
	,c.ultret79
	,b.nombreb
	,b.tipdep
	,b.coddep
	,b.tipdes
	,b.coddes
	,b.nombrec
	,d.numser70
	,d.numbul80
	,d.marmer80
	,d.numbul80
	,f.codemb06
	,f.desmer17
	,f.parara17
	,e.nomrep77
	,numbul12UC = ISNULL(d.numbul12,0)
FROM DRRetAdu18 a
	,DVRetAdu33_112 b
	,DDEntMer79 c
	,DDDEnMer80 d
	,DQMaeRep77 e
	,DDSerDes17 f
WHERE c.nument79 = @NUMENT
	AND a.numret18 = b.numret18
	AND a.fecret18 = b.fecret18
	AND a.numdui16 = b.numdui16
	AND a.obsret18 = b.obsret18
	AND a.codrep77 = b.codrep11
	AND b.numret18 = c.numret75
	AND c.nument79 = d.nument79
	AND c.codrep77 = e.codrep11
	AND d.numdui16 = f.numdui16
	AND d.numser17 = f.numser17

GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ENTREGA_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_ENTREGA_SIMPLE    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_ENTREGA_SIMPLE]
@NUMENT CHAR(7)
AS

Select 
a.nument79,a.fecent79,a.numpla79,a.obsent79,a.codrep77,a.ultret79,
e.numcer74,e.numret75,
g.nombre,
f.tipcli02,f.codcli02,f.ceradu74,
b.numser70,b.numbul80,b.marmer80,b.numbul80,
c.codemb06,c.desmer70,
d.nomrep77
From 
DDEntMer79 a,DDDenMer80 b,DDDReMer70 c,DQMaeRep77 d,DDRetSim75 e,DDCerSim74 f,
AAClientesAA g
Where 
a.nument79=@NUMENT and
a.nument79=b.nument79 and a.numret75=e.numret75 and a.codrep77=d.codrep11 and 

b.numrec69=c.numrec69 and b.numser70=c.numser70 and
e.numcer74=f.numcer74 and 
f.tipcli02=g.claseabc and f.codcli02=g.contribuy
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_FACTURA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_FACTURA] AS


Select a.*,b.*
From ddcabcom52 a
Inner Join dddetcom53 b on b.codcom50=a.codcom50 and b.numcom52=a.numcom52 and b.numcer52=a.numcer52
Where a.codcom50='01' and a.numcom52='0150006325' --and a.facesp52='S'
Order by a.numcer52
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_FACTURA_ESPECIAL]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_IMPRIMIR_FACTURA_ESPECIAL]  
@TIPDOC varchar(2),  
@NUMDOC varchar(10),  
@FECEMI varchar(255),  
@MONLET varchar(255)  
  
AS  
  
Select   
codcom50,numcom52,feccom52,tipdes52,docdes52,nomdes52,dirdes52,PORIGV=(porigv52*100),SUBTOT=SUM(subtot52),TOTIGV=sum(igvtot52),TOTGEN=sum(subtot52+igvtot52),  
FECEMI=@FECEMI,MONLET=@MONLET,tipmon52  
From ddcabcom52   
Where codcom50=@TIPDOC and numcom52=@NUMDOC --and a.facesp52='S'  
Group by codcom50,numcom52,feccom52,tipdes52,docdes52,nomdes52,dirdes52,porigv52 ,tipmon52


GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_FACTURA_ESPECIAL_ANEXO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_FACTURA_ESPECIAL_ANEXO]
@TIPDOC varchar(2),
@NUMDOC varchar(10)

AS

Select a.*,b.*,TITULO='ANEXO DETALLADO DEL DOCUMENTO : ' + left(@NUMDOC,3) + ' - ' + right(@NUMDOC,7),FECHA=getdate()
From ddcabcom52 a
Inner Join dddetcom53 b on b.codcom50=a.codcom50 and b.numcom52=a.numcom52 and b.numcer52=a.numcer52
Where a.codcom50=@TIPDOC and a.numcom52=@NUMDOC --and a.facesp52='S'
Order by a.numcer52
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_FACTURA_ESPECIAL_DET]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_FACTURA_ESPECIAL_DET]
@TIPDOC varchar(2),
@NUMFAC varchar(10),
@FECEMI varchar(255),
@MONLET varchar(255),
@DEPOSI CHAR(1)
AS

BEGIN

DECLARE @dettranS char(1), @dettranC char(1), @dettrac52 char(1), @tc decimal(5,3), @tot_fac decimal(15,2), 
	@num_cert varchar(9), @porc_igv decimal(12,2),
	@servicio varchar(8), @val_fac decimal(15,2), @val_ref decimal(12,2), @num_sol varchar(7), @tot_viajes int,
	@tot_viajes_temp int,
	@valor_referencial decimal(15,2), @aplica int, @val_ref_calc decimal(15,2)

--Verificando si es factura por detracción de transporte, y si tiene o no valor referencial
SELECT 	@dettranS = c.dettrans,
	@dettranC = c.dettranc,
	@dettrac52 = c.detrac52,
	@tc = c.tipcam52, 	
	@porc_igv = c.porigv52
FROM ddcabcom52 c (NOLOCK) 
WHERE numcom52 = @NUMFAC

SELECT @tot_fac = sum(c.SubTot52+c.IGVTot52)
FROM ddcabcom52 c (NOLOCK) 
WHERE numcom52 = @NUMFAC

SET @aplica = 0
SET @val_ref_calc = 0
SET @tot_viajes_temp = 0
SET @tot_viajes = 0

--Si es SIN valor referencial, verificar si el total facturado es mayor a S/400
--de ser así, indicar que debe figurar glosa fija NUNCA FIGURA MONTO A DETRAER
IF @dettranS = 'S'
BEGIN
	IF (@tot_fac * @tc) > 400
	BEGIN
		SELECT @valor_referencial = 1
	END
	ELSE
	BEGIN
		SELECT @valor_referencial = 0
	END
END

IF @dettranC = 'S'
BEGIN
	--Ubicando información del número de viajes
	IF @DEPOSI = 'S'
	BEGIN
		DECLARE c1 CURSOR FOR
		SELECT numsol62
		FROM DDCerSim74 (NOLOCK)
		WHERE numcer74 = @num_cert	
		ORDER BY numsol62

		OPEN c1 
		FETCH NEXT FROM c1 
		INTO @num_sol

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @tot_viajes_temp = count(*) 
			FROM ddticket01 (NOLOCK)
			WHERE docaut01 = @num_sol and tipope01 = 'D'

			SELECT @tot_viajes = @tot_viajes + @tot_viajes_temp

			FETCH NEXT FROM c1 
			INTO @num_sol

		END
		
		CLOSE c1
		DEALLOCATE c1
	END

	IF @DEPOSI = 'A'
	BEGIN
		DECLARE c1 CURSOR FOR
		SELECT numsol10
		FROM ddceradu13 (NOLOCK)
		WHERE numcer13 = @num_cert	
		ORDER BY numsol10

		OPEN c1 
		FETCH NEXT FROM c1 
		INTO @num_sol

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @tot_viajes_temp = count(*) 
			FROM ddticket01 (NOLOCK)
			WHERE docaut01 = @num_sol and tipope01 = 'D'

			SELECT @tot_viajes = @tot_viajes + @tot_viajes_temp

			FETCH NEXT FROM c1 
			INTO @num_sol

		END
		
		CLOSE c1
		DEALLOCATE c1
	END
	
	--Verificando item por item para encontrar el V.R. por cada servicio
	DECLARE c_items CURSOR FOR 
	SELECT codcon51, valcon53 * (1 + @porc_igv), isnull(valref,0)
	FROM   DDDetCom53 (NOLOCK)  INNER JOIN DDSERVIC52 (NOLOCK) ON DDDetCom53.codcon51 = DDSERVIC52.SERVIC52
	WHERE  numcom52 = @NUMFAC and DEPOSI52 = @DEPOSI
	ORDER BY codcon51

	OPEN c_items

	FETCH NEXT FROM c_items 
	INTO @servicio, @val_fac, @val_ref

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Si el valor facturado supera los S/ 400 APLICA
		IF (@val_fac * @tc) > 400
		BEGIN
			SET @aplica = @aplica + 1
		END
		ELSE -- Si el valor referencial supera los S/ 400 APLICA
		IF (@val_ref * @tot_viajes) > 400
		BEGIN
			SET @aplica = @aplica + 1
		END

		SET @val_ref_calc = @val_ref_calc + (@val_ref * @tot_viajes)

		FETCH NEXT FROM c_items 
   		INTO @servicio, @val_fac, @val_ref
	END

	CLOSE c_items
	DEALLOCATE c_items

	IF @aplica > 0
	BEGIN
		SELECT @valor_referencial = @val_ref_calc
	END
	ELSE
	BEGIN
		SELECT @valor_referencial = 0
	END
	
END

SELECT 
codcom50,numcom52,feccom52,tipdes52,docdes52,nomdes52,dirdes52,PORIGV=(porigv52*100),
SUBTOT=SUM(subtot52),TOTIGV=sum(igvtot52),TOTGEN=sum(subtot52+igvtot52),
FECEMI=@FECEMI,MONLET=@MONLET,dettrans = @dettranS,dettranc = @dettranC,
dettrac52 = @dettrac52, valref = @valor_referencial
FROM ddcabcom52 (NOLOCK)
WHERE codcom50=@TIPDOC and numcom52=@NUMFAC 
GROUP BY codcom50,numcom52,feccom52,tipdes52,docdes52,nomdes52,dirdes52,porigv52

END

GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ORDEN_DE_SERVICIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_ORDEN_DE_SERVICIO]   
@NUMORD CHAR(6)  
AS  
  
Declare @Filas integer  
Declare @Cer_Sol varchar(9)  
Declare @Tip_Dep char(1)  
Declare @Num_Sol varchar(7)  
Declare @Num_Cer varchar(9)  
Declare @name varchar(250)  
Declare @Ord_Ser varchar(6)  
Declare @Cadena varchar(1000)   
  
Select @Ord_Ser=@NUMORD  
Select @Cadena=''  
  
Select @Num_Cer=a.numcer58,@Num_Sol=a.numsol58,@FILAS=count(b.numord58)   
From ddordser58 a Inner Join DDDOrSer59 b on a.numord58=b.numord58  
Where a.numord58=@Ord_Ser and b.numuni54>0  
Group by a.numcer58,a.numsol58  
  
if @Filas>0  
Begin  
 Select @Cer_Sol=case when numsol58 is null then 'C' else 'S' end From ddordser58 where numord58=@Ord_Ser  
 if @Cer_Sol='C'  
 Begin  
  Select @Tip_Dep=left(numcer58,1) from ddordser58 where numord58=@Ord_Ser  
  if @Tip_Dep='A'  
   Begin  
    Select @Num_Sol=numsol10 from DDceradu13 where numcer13=@Num_Cer  
   End  
  else  
   Begin  
    Select @Num_Sol=numsol62 from DDcersim74 where numcer74=@Num_Cer   
   End  
 End  
  
 Begin  
  DECLARE CUR_DEP CURSOR FOR  
  select numctr65 from DDCtrDep65 where numsol62=@Num_Sol  
  OPEN CUR_DEP  
  FETCH NEXT FROM CUR_DEP INTO @name  
  WHILE (@@fetch_status <> -1)  
  Begin  
   Select @cadena=@cadena+@name+' / '  
   FETCH NEXT FROM CUR_DEP INTO @name  
  End  
    
  CLOSE CUR_DEP  
  DEALLOCATE CUR_DEP  
 End  
End  
  
--Select Cadena=@cadena  
 
Select Cadena=@cadena,  
a.numord58,a.fecord58,a.resser58,a.numcer58,a.tipmon58,a.tipcli02,a.codcli02,a.codage19,a.obsord58,  
a.resser58,  
b.uniser59,b.codcon51,b.obsser59,b.valcob59,b.uniser59,c.desser52,  
NombreC=d.nombre,NombreA=e.nombre,f.numdui11  
From  
DDORDSER58 a  
inner join DDDORSER59 b on (a.numord58=b.numord58)  
inner join DDSERVIC52 c on (b.codcon51=c.servic52)  
inner join AAClientesAA d on (a.tipcli02=d.claseabc and a.codcli02=d.contribuy)  
left join AAClientesAA e on (a.codage19=e.cliente and a.codage19 <> '')  
left join DDCERADU13 f on (a.numcer58=f.numcer13 )  
Where  
a.numord58=@NUMORD and (substring(a.numcer58,1,1)=c.deposi52 or substring(a.numsol58,1,1)=c.deposi52)


GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ORDENES_DE_SERVICIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_ORDENES_DE_SERVICIO]  
@fecDesde varchar(10),
@fecHasta varchar(10)
AS  

-->Modificado JLR 25052012
Select a.numord58,a.fecord58,a.codcli02,c.nombre as nombreCliente,d.codcon51,a.totser58,a.totcob58 
From DDOrdSer58 a  
Inner Join AAClientesAA b on b.cliente=a.codage19  
Inner Join AAClientesAA c on c.contribuy=a.codcli02   
Inner Join DDDOrSer59 d on d.numord58 = a.numord58
Where a.codage19<>''  
and a.fecord58 >= @fecDesde and a.fecord58 <=@fecHasta
UNION  
select a.numord58,a.fecord58,a.codcli02,c.nombre as nombreCliente,d.codcon51,a.totser58,a.totcob58  
from DDOrdSer58 a  
Inner Join AAClientesAA c on c.contribuy=a.codcli02   
Inner Join DDDOrSer59 d on d.numord58 = a.numord58
where a.codage19 = ''  
and a.fecord58 >= @fecDesde and a.fecord58 <=@fecHasta
Order by a.fecord58 desc, a.numord58 desc

-->Anterior 25052012  
/*Select a.numord58,a.fecord58,a.codage19,b.nombre as nombreAgencia,a.codcli02,c.nombre as nombreCliente  
From DDOrdSer58 a  
Inner Join AAClientesAA b on b.cliente=a.codage19  
Inner Join AAClientesAA c on c.contribuy=a.codcli02   
Where a.codage19<>''  
UNION  
select a.numord58,a.fecord58,a.codage19,'' as nombreAgencia,a.codcli02,c.nombre as nombreCliente  
from DDOrdSer58 a  
Inner Join AAClientesAA c on c.contribuy=a.codcli02   
where a.codage19 = ''  
Order by a.fecord58 desc, a.numord58 desc*/
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ORDENES_DE_SERVICIO_MOD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC dbo.SP_IMPRIMIR_ORDENES_DE_SERVICIO_MOD '20141101','20141113'
--select * from DDSolAdu10
--select * from DDSolSim62
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_ORDENES_DE_SERVICIO_MOD]  
@fecDesde varchar(10),
@fecHasta varchar(10),
@deposi varchar(5)='X',
@numcer varchar(20)='X',
@estado varchar(5)='X',
@tipcli	varchar(5)='X',
@codcli varchar(15)='X'
AS  
BEGIN
IF @deposi= 'X' SET @deposi=''
IF @numcer= 'X' SET @numcer=''
IF @estado= 'X' SET @estado=''
IF @tipcli= 'X' SET @tipcli=''
IF @codcli= 'X' SET @codcli=''


SELECT *
  FROM (SELECT (CASE WHEN data.flgval58 = '0' THEN 'ANU' 
					 ELSE (CASE WHEN ISNULL(data.codcom50+data.numcom52,'')<>'' 
								THEN 'FAC'
								ELSE 'ACT'
						  END)
				END) as [estado]
			  ,data.fecord58 as [emision]
			  ,data.numcer58 as [certificado]
			  ,data.codcli02 as [cliente]
			  ,data.NOMBRE	as [razonSocial]
			  ,data.codcon51 as [servicio]
			  ,sv1.DESSER52 as [concepto]
			  ,data.uniser59 as [cantidad]
			  ,u.UNIMED54 as [unidadMedida]
			  ,(CASE WHEN m.TIPMON54 = 'S' THEN 'SOL'
					 WHEN m.TIPMON54 = 'D' THEN 'DOL'
					 ELSE ISNULL(m.TIPMON54,'')
				END) as [Moneda]
			  ,data.valcob59 as [tarifa]
			  ,data.totcob58 as [total]
			  ,data.obsser59 as [observacion]
			  ,data.numord58
		  FROM (select a.flgval58
					  ,d.codcom50
					  ,d.numcom52
					  ,a.fecord58
					  ,a.numcer58
					  ,a.codcli02
					  ,c.NOMBRE
					  ,d.codcon51
					  ,d.uniser59
					  ,d.numuni54
					  ,a.TIPMON58
					  ,d.valcob59
					  ,a.totcob58
					  ,d.obsser59
					  ,a.numord58
					  ,a.tipcli02
				   From DDOrdSer58 a  
				  Inner Join AAClientesAA b on b.cliente=a.codage19  
				  Inner Join AAClientesAA c on c.contribuy=a.codcli02   
				  Inner Join DDDOrSer59 d on d.numord58 = a.numord58
				  Where a.codage19<>''
					and a.fecord58 >= @fecDesde and a.fecord58 <=@fecHasta
				  UNION  
				 select a.flgval58
					  ,d.codcom50
					  ,d.numcom52
					  ,a.fecord58
					  ,a.numcer58
					  ,a.codcli02
					  ,c.NOMBRE
					  ,d.codcon51
					  ,d.uniser59
					  ,d.numuni54
					  ,a.TIPMON58
					  ,d.valcob59
					  ,a.totcob58
					  ,d.obsser59
					  ,a.numord58
					  ,a.tipcli02
				   from DDOrdSer58 a  
				  Inner Join AAClientesAA c on c.contribuy=a.codcli02   
				  Inner Join DDDOrSer59 d on d.numord58 = a.numord58
				  where a.codage19 = ''  
					and a.fecord58 >= @fecDesde and a.fecord58 <=@fecHasta
			  ) data
		  LEFT JOIN DDSERVIC52 sv1 ON sv1.SERVIC52 = data.codcon51 AND sv1.DEPOSI52 = LEFT(data.numcer58,1)
		  LEFT JOIN DDUNIMED54 u ON u.NUMUNI54 = data.numuni54
		  LEFT JOIN DDCLIMON54 m ON m.CODCLI54 = data.codcli02
		WHERE (data.tipcli02= @tipcli or @tipcli = '')
       ) t
 WHERE (LEFT(t.certificado,1) = @deposi or @deposi='')
   AND (t.certificado = @numcer or @numcer='')
   AND (LEFT(t.estado,3) = @estado or @estado='')
   AND (t.cliente = @codcli or @codcli='')
order by [emision] desc,numord58 desc
END
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_RECEPCION_ADUANERA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_RECEPCION_ADUANERA]    
@NUMREC CHAR(7)    
AS    
      
Select     
a.numrec69,a.fecrec69,a.priing69,a.fining69,a.bultot69,a.codemb06,a.obsrec69,a.guirem69,    
a.pesnet69,a.codubi71,    
b.tipcli02,b.codcli02,b.codage19,    
c.numser70,c.numbul70,c.codemb06,c.desmer70,    
d.desubi71,    
NombreC=e.nombre,    
NombreA=f.nombre,    
g.numdui11    
From     
DDRECMER69 a  
 inner join DDSOLADU10 b on (a.numsol62=b.numsol10)  
 inner join DDDREMER70 c on (a.numrec69=c.numrec69)  
 inner join DQTIPUBI71 d on (a.codubi71=d.codubi71)  
 inner join AACLIENTESAA e on (b.tipcli02=e.claseabc and b.codcli02=e.contribuy)    
 inner join DDDUIDEP11 g on (b.numsol10=g.numsol10)  
 left  join AACLIENTESAA f on (b.codage19=f.cliente and b.codage19 <> '')    
Where     
a.numrec69=@NUMREC   
Order by c.numser70

GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_RECEPCION_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_RECEPCION_SIMPLE]    
@NUMREC CHAR(7)    
AS    
    
Select     
a.numrec69,a.fecrec69,a.priing69,a.fining69,a.bultot69,a.codemb06,a.obsrec69,a.guirem69,    
a.pesnet69,a.codubi71,    
b.tipcli02,b.codcli02,b.codage19,    
c.numser70,c.numbul70,c.codemb06,c.desmer70,    
d.desubi71,    
NombreC=e.nombre,    
NombreA=f.nombre    
From     
DDRECMER69 a  
inner join DDSOLSIM62 b on (a.numsol62=b.numsol62 )  
inner join DDDREMER70 c on (a.numrec69=c.numrec69)  
inner join DQTIPUBI71 d on (a.codubi71=d.codubi71)  
inner join AACLIENTESAA e on (b.tipcli02=e.claseabc and b.codcli02=e.contribuy)  
left  join AACLIENTESAA f on (b.codage19=f.cliente and b.codage19<>'' )   
Where     
a.numrec69=@NUMREC 
--and (f.cliente<>'')        
Order by c.numser70
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_RETIRO_ADUANERO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_RETIRO_ADUANERO    Script Date: 08-09-2002 08:44:14 PM ******/  
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_RETIRO_ADUANERO]  
@NUMRET CHAR(7)  
AS  
Declare   
@CIFENT16 as decimal(15,3)  
  
--Calculo cual es el monto CIF entregado para esa Orden de Retiro.  
--====================================================  
Select @CIFENT16=coalesce(sum(pretot79+cuadep79),0) from ddentmer79 where numret75=@NUMRET and flgval79=1  
  
SELECT distinct  
 a.numret18,a.fecret18,a.numdui16,a.obsret18,a.numvig18,  
     b.fecdui16,b.feccan16,b.valcif16,b.numdui11,b.numcer13,b.numbul16,cifent16=@CIFENT16,  
     g.valfob11,g.valfle11,g.valseg11, g.fobdes11, g.fledes11, g.segdes11,  
     c.codrep11, c.nomrep77,d.cliente,NombreA=d.nombre,  
     coddes=e.contribuy, NombreC=e.nombre,coddep=i.contribuy, NombreB=i.nombre,  
     j.codreg15, j.desreg15,k.numser12,k.numbul17,  
     bulent17=(Select coalesce(sum(b.numbul80),0) From ddentmer79 a Inner Join DDDEnMer80 b on a.nument79=b.nument79 where a.numret75=@NUMRET and a.flgval79=1 and b.numser70=k.numser12),  
     k.codemb06,k.desmer17,k.parara17,k.valfob17,k.valcif17,K.unidad12,K.tipuni12,l.codubi71,
     B.canaldua16, CONVERT(VARCHAR(10),B.FecCanal16, 103)AS FecCanal16, 
     CONVERT(VARCHAR(10), B.HoraCanal16, 108) AS HoraCanal16
FROM DRRetAdu18 a   
inner join DDDuiDes16 b on a.numdui16 = b.numdui16   
inner join DQMaeRep77 c on a.codrep77 = c.codrep11  
inner join AAClientesAA d on b.codage19 = d.cliente  
inner join AAClientesAA e on b.codcli02 = e.contribuy  
inner join DDDuiDep11 g on b.numdui11 = g.numdui11   
inner join DDSolAdu10 h on g.numsol10 = h.numsol10  
inner join AAClientesAA i on h.codcli02 = i.contribuy  
inner join DQRegime15 j on SUBSTRING(b.numdui16,6,2)=j.codreg15  
inner join DDSERDES17 k on k.numdui16 = a.numdui16  
inner join DDRecMer69 l on h.numsol10 = l.numsol62  
Where a.numret18 = @NUMRET and l.flgval69 = '1'


GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_RETIRO_ADUANERO_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_RETIRO_ADUANERO    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_RETIRO_ADUANERO_NEW] @NUMRET CHAR(7)
AS
DECLARE @CIFENT16 AS DECIMAL(15, 3)

--Calculo cual es el monto CIF entregado para esa Orden de Retiro.      
--====================================================      
SELECT @CIFENT16 = coalesce(sum(pretot79 + cuadep79), 0)
FROM ddentmer79
WHERE numret75 = @NUMRET
	AND flgval79 = 1

SELECT DISTINCT a.numret18
	,a.fecret18
	,a.numdui16
	,a.obsret18
	,a.numvig18
	,b.fecdui16
	,b.feccan16
	,b.valcif16
	,b.numdui11
	,b.numcer13
	,b.numbul16
	,cifent16 = @CIFENT16
	,g.valfob11
	,g.valfle11
	,g.valseg11
	,g.fobdes11
	,g.fledes11
	,g.segdes11
	,c.codrep11
	,c.nomrep77
	,d.cliente
	,NombreA = d.nombre
	,coddes = e.contribuy
	,NombreC = e.nombre
	,coddep = i.contribuy
	,NombreB = i.nombre
	,j.codreg15
	,j.desreg15
	,k.numser12
	,k.numbul17
	,bulent17 = (
		SELECT coalesce(sum(b.numbul80), 0)
		FROM ddentmer79 a
		INNER JOIN DDDEnMer80 b ON a.nument79 = b.nument79
		WHERE a.numret75 = @NUMRET
			AND a.flgval79 = 1
			AND b.numser70 = k.numser12
		)
	,k.codemb06
	,k.desmer17
	,k.parara17
	,k.valfob17
	,k.valcif17
	,K.unidad12
	,K.tipuni12
	,l.codubi71
	,B.canaldua16
	,CONVERT(VARCHAR(10), B.FecCanal16, 103) AS FecCanal16
	,CONVERT(VARCHAR(10), B.HoraCanal16, 108) AS HoraCanal16
	,bulent12UC = (
		SELECT coalesce(sum(b.numbul12), 0)
		FROM ddentmer79 a
		INNER JOIN DDDEnMer80 b ON a.nument79 = b.nument79
		WHERE a.numret75 = @NUMRET
			AND a.flgval79 = 1
			AND b.numser70 = k.numser12
		)
	,Warrant = case when isnull(k.flgcons_ws17,'0') = '0' then '' else ('W: ' + k.warrant17) end
FROM DRRetAdu18 a
INNER JOIN DDDuiDes16 b ON a.numdui16 = b.numdui16
INNER JOIN DQMaeRep77 c ON a.codrep77 = c.codrep11
INNER JOIN AAClientesAA d ON b.codage19 = d.cliente
INNER JOIN AAClientesAA e ON b.codcli02 = e.contribuy
INNER JOIN DDDuiDep11 g ON b.numdui11 = g.numdui11
INNER JOIN DDSolAdu10 h ON g.numsol10 = h.numsol10
INNER JOIN AAClientesAA i ON h.codcli02 = i.contribuy
INNER JOIN DQRegime15 j ON SUBSTRING(b.numdui16, 6, 2) = j.codreg15
INNER JOIN DDSERDES17 k ON k.numdui16 = a.numdui16
INNER JOIN DDRecMer69 l ON h.numsol10 = l.numsol62
WHERE a.numret18 = @NUMRET
	AND l.flgval69 = '1'

GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_RETIRO_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_RETIRO_SIMPLE]          
@NUMRET CHAR(7)          
AS          
          
Select distinct           
a.fecret75,a.numcer74,a.numret75,a.codage19,a.bultot75,          
a.pretot75,a.codrep77,a.obsret75,a.numvig75,          
NombreC=b.nombre,    
b.claseabc,b.contribuy,          
NombreA=c.nombre,          
d.bultot74,d.numret74,          
e.numser67,e.bultot76,e.bulret76,SALDO=e.bultot76-e.bulret76,e.codemb06,e.desmer67,pretot76,          
f.nomrep77,e.codubi71,d.numsol62          
From           
DDRETSIM75 a        
inner join DVDRESIM86 e on (a.numret75=e.numret75)        
inner join DDCERSIM74 d on (a.numcer74=d.numcer74 )        
inner join AACLIENTESAA b on (d.tipcli02=b.claseabc and d.codcli02=b.contribuy)        
inner join DQMAEREP77 f  on (a.codrep77=f.codrep11)        
left  join AACLIENTESAA c on (a.codage19=c.cliente and a.codage19<>'')        
Where           
a.numret75=@NUMRET and d.flgval74='1' --and c.cliente<>''
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_SOLICITUD_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[SP_IMPRIMIR_SOLICITUD_SIMPLE]    
@NUMSOL CHAR(7)    
AS    
BEGIN    
    
--rdelacuba 29/12/2006: Se incluye la nave    
Select    
a.numsol62,a.tipcli02,a.codcli02,a.codage19,a.obssol62,a.bultot62,    
b.numbul67,b.codemb06,desmer67=b.numser67+' - '+b.desmer67,    
NombreC=c.nombre,c.direccion,NombreA=d.nombre,f.desnav08    
From     
DDSolSim62 a  
inner join DDDSoSim67 b on (a.numsol62=b.numsol62)  
inner join AAClientesAA c on (a.codcli02=c.contribuy  and a.tipcli02=c.claseabc)  
left  join AAClientesAA d on (a.codage19=d.cliente and a.codage19<>'' )  
left  join Descarga..DQNAVIER08 f  on (a.codnav08=f.codnav08)  
Where     
a.numsol62= @NUMSOL  
 --and d.cliente<>''   
order by b.numser67    
    
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_ING_CAM_1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ING_CAM_1    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_ING_CAM_1]
@TIPEST CHAR(1)
AS

Select 
tipope82="R",fecing82=a.fecing20,numpla82=a.numpla20,pescam82=a.pestar20,docaut82=a.ordret20,
numgui82=a.nument79,obsing82=d.nombre,tipest82=a.tipest20
From 
DDOrdPla20 a,DRRetAdu18 b,DDDuiDes16 c,AAClientesAA d
where substring(ordret20,1,1)='A' and a.ordret20=b.numret18 and b.numdui16=c.numdui16 and
c.codcli02=d.contribuy and
a.tipest20=@TIPEST
UNION ALL
Select 
tipope82="R",fecing82=a.fecing20,numpla82=a.numpla20,pescam82=a.pestar20,docaut82=a.ordret20,
numgui82=a.nument79,obsing82=d.nombre,tipest82=a.tipest20
From 
DDOrdPla20 a,DDRetSim75 b,DDCerSim74 c,AAClientesAA d
where substring(ordret20,1,1)='S' and a.ordret20=b.numret75 and b.numcer74=c.numcer74 and 

c.codcli02=d.contribuy and 
a.tipest20=@TIPEST
GO
/****** Object:  StoredProcedure [dbo].[SP_ING_CAM_2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ING_CAM_2    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_ING_CAM_2]
@TIPEST CHAR(1)
AS

Select 
tipope82="D",fecing82=fecing01,numpla82=numpla01,pescam82=pesbru01,docaut82=docaut01,
numgui82=numgui01,obsing82=nombre,tipest82=tipest01
From 
DDTicket01,AAClientesAA
Where 
tipmer01 in ("M","C") and tipope01="D" and (codcli02=contribuy or codcli02=catcliente) and tipest01=@TIPEST
GO
/****** Object:  StoredProcedure [dbo].[SP_INGRESOS_POR_CERTIFICADO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_INGRESOS_POR_CERTIFICADO    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[SP_INGRESOS_POR_CERTIFICADO]
@NUMCER CHAR(9)
AS


Delete from DTINGCER36_11 

/* Lleno primera tabla temporal */

INSERT INTO DTINGCER36_11 
Select 
a.numcer13,a.feccer13,a.numdui11,d.fecdui11,a.tipcli02,a.codcli02,e.nombre,c.numrec69,
c.priing69,c.pesnet69,a.numbul13,b.codemb06,b.desmer10,a.pescer13,a.cifcer13,a.bulent13,
a.cifent13,a.pesent13,USER_NAME() AS USUARIO

From DDCerAdu13 a
Inner Join DDSolAdu10 b on a.numsol10=b.numsol10
Inner Join DDRecMer69 c on b.numsol10=c.numsol62
Inner Join DDDuiDep11 d on a.numdui11=d.numdui11
Inner Join AAClientesAA e on a.tipcli02=e.claseabc and a.codcli02=e.contribuy
Where
a.numcer13=@NUMCER and  a.flgval13='1' and c.flgval69='1' and c.flgemi69='1'
GO
/****** Object:  StoredProcedure [dbo].[SP_INGRESOS_POR_CERTIFICADO_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec SP_INGRESOS_POR_CERTIFICADO 'A00142000'
/****** Object:  Stored Procedure dbo.SP_INGRESOS_POR_CERTIFICADO    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[SP_INGRESOS_POR_CERTIFICADO_NEW] @NUMCER CHAR(9)
AS
DELETE
FROM DTINGCER36_11_NEW

/* Lleno primera tabla temporal */
INSERT INTO DTINGCER36_11_NEW
SELECT a.numcer13
	,a.feccer13
	,a.numdui11
	,d.fecdui11
	,a.tipcli02
	,a.codcli02
	,e.nombre
	,c.numrec69
	,c.priing69
	,c.pesnet69
	,a.numbul13
	,b.codemb06
	,b.desmer10
	,a.pescer13
	,a.cifcer13
	,a.bulent13
	,a.cifent13
	,a.pesent13
	,USER_NAME() AS USUARIO
	,bulent12 = (select SUM(ISNULL(unidad12,0)) from DDDCeAdu14 zz where a.numcer13 = zz.numcer13)
FROM DDCerAdu13 a
INNER JOIN DDSolAdu10 b ON a.numsol10 = b.numsol10
INNER JOIN DDRecMer69 c ON b.numsol10 = c.numsol62
INNER JOIN DDDuiDep11 d ON a.numdui11 = d.numdui11
INNER JOIN AAClientesAA e ON a.tipcli02 = e.claseabc
	AND a.codcli02 = e.contribuy
WHERE a.numcer13 = @NUMCER
	AND a.flgval13 = '1'
	AND c.flgval69 = '1'
	AND c.flgemi69 = '1'


GO
/****** Object:  StoredProcedure [dbo].[SP_INGRESOS_POR_CERTIFICADO_S]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_INGRESOS_POR_CERTIFICADO_S    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_INGRESOS_POR_CERTIFICADO_S]
@NUMCER CHAR(7)
AS

DELETE FROM DTINGSIM91_11

INSERT INTO DTINGSIM91_11
Select 
a.numcer74,a.feccer74,c.numsol62,c.tipcli02,c.codcli02,d.nombre,b.numrec69,b.fecrec69, 
b.priing69,b.bultot69,b.codemb06,c.desmer62,b.pesnet69,b.pretot69,bulent74,preent74,pesent74
From DDCerSim74 a
Inner Join DDRecMer69 b on b.numsol62=a.numsol62 
Inner Join DDSolSim62 c on b.numsol62=c.numsol62
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy
where 
a.numcer74=@NUMCER and a.flgval74='1' and b.flgval69='1' and b.flgemi69='1'
GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Cliente_CRM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Insert_Cliente_CRM]                                    
@TipoDocumento char(1),                                     
@Contribuy  varchar(11),                                     
@RazonSocial varchar(80),                                     
@direccion  varchar(200),                                     
@telefono1  varchar(15),                                     
@Telefono2  varchar(15),                                     
@Fax   varchar(15),                                     
@Contacto  varchar(30),                                     
@Activo   char(1),                                     
@Observaciones varchar(100),                                     
@Convenio  char(1),                                     
@Pais   char(5),                                      
@Alias   varchar(80) = '',                                     
@Email   varchar(150),                                     
--@Cadena  varchar(20),  --                                    
@CodAgeAduana varchar(11),                                     
@DiasAbast  char(4) ,                                     
@DiasPromat  char(4) ,                                    
@Catcliente  varchar(8) = '',                                     
@Vendedor  char(2),                                     
@Cobrador  varchar(20),                                     
@Sector   char(10),                                    
@ClienteVip  char(1),                                      
@Departamento char(5),                                    
@Provincia  char(10),                                     
@Distrito  char(10),                                     
@Customer  char(2),                                    
@Analista  char(2),                                      
@Credito  char(1),                                     
@FecVigCred  datetime =  null,                                     
@CodAgeMaritimo char(4),                                     
@CodAgeCarga char(4),                                     
@FlgBloTotal char(1) = 0,                                     
@FlatExpo  char(1),                                     
                                    
--Datos para formar Cadena,                                    
@AgeGeneral  char(1),                                    
@CiaConsolidadora char(1),                                    
@AgeTransporte char(1),                                    
@EmpresaAfin char(1),                                    
@Importador  char(1),                                    
@CiaSeguros  char(1),                                    
@Otros   char(1),                                    
@Embarcador  char(1),                                    
@LineaArea  char(1),                                    
@Exportador  char(1),                                    
@TarifaFlatImpo char(1),                                    
@HorasExtras char(1),                                    
@FacAdelanto char(1),                                    
@BloWebConsol char(1),                                    
@CliProspecto char(1),                                    
@Msg_Error  varchar(500) output,                                    
@Msg_Valor  int output                                    
as                                    
begin                                    
 set @Msg_Valor = 0                               
 set @Msg_Error = ''                                   
 --Validaciones                        
 --declare @iCodAge int                
 --select @iCodAge=count(cliente) from aaclientesaa where cliente=@CodAgeAduana                 
 --if @iCodAge>0                
 --set @CodAgeAduana=''                             
                            
 --Seteando ClienteVip                                    
 if (@ClienteVip = '1') or (@ClienteVip = '2')                                    
 begin                                    
  set @ClienteVip = 'V'                                    
 end                                    
 if (@ClienteVip = '3') or (@ClienteVip = '4')            
 begin                                    
  set @ClienteVip = 'N'                                    
 end         
                    
-- Equivalencia de Estado de cliente                  
if (@activo= '0')                  
begin                  
set @activo='S'          
end                  
                   
if (@activo= '1')                  
begin                  
set @activo='N'                  
end                  
                  
-- Equivalencia agentes de transporte                    
                  
if (@AgeTransporte = 'T')                    
begin                    
set @AgeTransporte = '1'                    
end                     
                    
if (@AgeTransporte = 'F')                    
begin                    
set @AgeTransporte = '0'                    
end                    
                  
-- Convertir CHECK de cadena                    
                     
 if (@CodAgeCarga <> '') or (@CodAgeCarga is not null )                             
 begin                            
 set @CiaConsolidadora = '1'                            
 end                      
                    
--Validacion y autocompletado de Agencia de Carga por CiaConsolidadora                    
                if (@CodAgeCarga <> '') or (@CodAgeCarga is not null )                             
 begin                            
 set @CiaConsolidadora = '1'                            
 end                            
 if (@CodAgeCarga = '') or (@CodAgeCarga is null )                  
 begin                            
 set @CiaConsolidadora = '0'                            
 end                    
                                     
 --*****Documento******                                    
 if (@Contribuy is null) or (@Contribuy = '')                                    
 begin                                    
  set @Msg_Error = 'Documento ingresado no es correcto, Favor de verificar.'                                    
Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                     
 end                                    
 --*****RazonSocial******                                    
 if (@RazonSocial is null) or (@RazonSocial = '')                                    
 begin                                    
  set @Msg_Error = 'Razon Social ingresado no es correcto, Favor de verificar.'                                  
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --*****Direccion******     
 /*                                   
 if (@direccion is null) or (@direccion = '')                                    
 begin                                    
  set @Msg_Error = 'Direccion ingresada no es correcta, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end         
 */                               
 --*****@telefono1******                                    
 if (@telefono1 is null) or (@telefono2 is null)                                    
 begin                                    
  set @Msg_Error = 'Telefono1 ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --*****@telefono2******                                    
 if (@telefono2 is null)                                    
 begin                                    
  set @Msg_Error = 'Telefono2 ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
 --*****@Fax******                                    
 if (@Fax is null)                                    
 begin                                    
set @Msg_Error = 'Fax ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --*****@Contacto******       
 if (@Contacto is null)                                    
 begin                                    
  set @Msg_Error = 'Contacto ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return          
 end                                    
 --*****Activo*******                                    
 if (@Activo is null) or (@Activo = '')                                    
 begin                                    
  set @Msg_Error = 'Valor de Cliente Activo ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                         
                                  
 --*****@Observaciones******                                    
 if (@Observaciones is null)                                    
 begin                                    
  set @Msg_Error = 'Observacion ingresada no es correcta, Favor de verificar.'                                    
 Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --*****Convenio*******                                    
 if (@Convenio is null) or (@Convenio = '') or isnumeric(@Convenio) = 1                                    
 begin                  
  set @Msg_Error = 'Valor de Cliente con Convenio ingresado no es correcto. Permitido S o N, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@Convenio <> 'S') and (@Convenio <> 'N')                                    
 begin                        
  set @Msg_Error = 'Valor de Cliente con Convenio ingresado no es correcto. Permitido S o N, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --*****@Alias******                                    
 if (@Alias is null)                                    
 begin                                    
  set @Msg_Error = 'Alias ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
 --*****@Email******                                    
 if (@Email is null)                                  
 begin                                    
  set @Msg_Error = 'Email ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
 --*****@DiasAbast******                                    
 if (@DiasAbast is null)                                    
 begin                                    
  set @Msg_Error = 'DiasAbast ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
 --*****@DiasPromat******                               
 if (@DiasPromat is null)                                    
 begin                                    
  set @Msg_Error = 'DiasPromat ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
 --*****Catcliente******                                    
 if (@Catcliente is null)                                    
 begin                                    
  set @Msg_Error = 'Categoria ingresada no es correcta, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
 --*****ClienteVip*******                             
 if (@ClienteVip is null) or (@ClienteVip = '') or isnumeric(@ClienteVip) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Cliente VIP ingresado no es correcto. Permitido N o V, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@ClienteVip <> 'N') and (@ClienteVip <> 'V')                                    
 begin                                    
  set @Msg_Error = 'Valor de Cliente VIP ingresado no es correcto. Permitido N o V, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --*****@Customer******                                    
 if (@Customer is null)                                    
 begin             
  set @Msg_Error = 'Customer ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
 --*****@Analista******                                    
 if (@Analista is null)                                    
 begin                                   
  set @Msg_Error = 'Analista ingresado no es correcto, Favor de verificar.'                                    
  Select @Msg_Error                               
 Select @Msg_Valor                                     
 return                                       
 end                                    
 --*****Credito*******                                    
 if (@Credito is null) or (@Credito = '') or not isnumeric(@Credito) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Credito ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                 
 end                                      
 if  (@Credito <> '1') and (@Credito <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Credito ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --*****FlgBloTotal*******                                    
 if (@FlgBloTotal is null) or (@FlgBloTotal = '') or not isnumeric(@FlgBloTotal) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Bloqueo Total al Cliente ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@FlgBloTotal <> '1') and (@FlgBloTotal <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Bloqueo Total al Cliente ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                 
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --***************************                                    
                                    
 ---Equivalencias                                    
 declare @TipoDocumento_Val char(1)                                    
 declare @Sector_Val   char(10)                                    
 declare @Pais_Val   char(5)                                    
 declare @Departamento_Val char(5)                                    
 declare @Provincia_Val  char(10)                         
 declare @Distrito_Val  char(10)                                    
                                    
 select @TipoDocumento_Val = CodTipDoc from TIPODOCUMENTO_CRM where CodTipDocEqui = @TipoDocumento                                    
 select @Sector_Val = id_Sector from SECTOR_ECONOMICO where ID_Sector_Equi = @Sector                                    
 select @Pais_Val = codpai07 from DQPAISES07 where CodPaiEqui07 = @Pais                                    
 select @Departamento_Val = codigo_departamento from DEPARTAMENTOS where CodDep_Equivalente = @Departamento                                    
 select @Provincia_Val = codigo_provincia from PROVINCIAS where CodProv_Equivalente = @Provincia                              
 select @Distrito_Val = codigo_distrito from DISTRITOS where CodDist_Equivalente = @Distrito                                    
                                     
 print @TipoDocumento_Val                                     
 print @Sector_Val                                    
 print @Pais_Val                                    
 print @Departamento_Val                                    
 print @Provincia_Val                                     
 print @Distrito_Val                                     
                                    
 --Validacion de Datos de la Cadena                                    
            
 --****Codigo Agente Aduana*****                     
 if (@CodAgeAduana is null)-- or (@CodAgeAduana = '')                                    
 begin                                    
  set @Msg_Error = 'Debe de ingresar Codigo Agente de Aduana correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                     
 --*******Agente General********                                    
 if (@AgeGeneral is null) or (@AgeGeneral = '') or not isnumeric(@AgeGeneral) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Agente General ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'           
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@AgeGeneral <> '1') and (@AgeGeneral <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Agente General ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end       
 --****Codigo Agente Maritimo*****                       
 if (@CodAgeMaritimo is null) --or (@CodAgeMaritimo = '')                                    
 begin                                    
  set @Msg_Error = 'Debe de ingresar Codigo Agente Maritimmo correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                     
 --******Cia Consolidadora******                                    
 if (@CiaConsolidadora is null) or (@CiaConsolidadora = '') or not isnumeric(@CiaConsolidadora) = 1                         begin                                    
  set @Msg_Error = 'Valor de Cia Consolidadora ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                       
 return                                       
 end                                      
 if  (@CiaConsolidadora <> '1') and (@CiaConsolidadora <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Cia Consolidadora ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error            
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Agente Transporte******                                    
 if (@AgeTransporte is null) or (@AgeTransporte = '') --or not isnumeric(@AgeTransporte) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Agente Transporte ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@AgeTransporte <> '1') and (@AgeTransporte <> '0')                                    
 begin                         
  set @Msg_Error = 'Valor de Agente Transporte ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Empresa Afin******                                    
 if (@EmpresaAfin is null) or (@EmpresaAfin = '') or not isnumeric(@EmpresaAfin) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Empresa Afin ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                 
 return                                       
 end                                      
 if  (@EmpresaAfin <> '1') and (@EmpresaAfin <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Empresa Afin ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Importador******                                    
 if (@Importador is null) or (@Importador = '') or not isnumeric(@Importador) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Importador ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                 
 end                                      
 if  (@Importador <> '1') and (@Importador <> '0')                                   
 begin                                    
  set @Msg_Error = 'Valor de Importador ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Otros******                                    
 if (@Otros is null) or (@Otros = '') or not isnumeric(@Otros) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Datos Otros ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@Otros <> '1') and (@Otros <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Dato Otros ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                            
 end                                    
 --******Cia Seguros******                                    
 if (@CiaSeguros is null) or (@CiaSeguros = '') or not isnumeric(@CiaSeguros) = 1                 
 begin                                    
  set @Msg_Error = 'Valor de Cia Seguros ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                  
 if  (@CiaSeguros <> '1') and (@CiaSeguros <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Cia Seguros ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Horas Extras******                                    
 if (@HorasExtras is null) or (@HorasExtras = '') or not isnumeric(@HorasExtras) = 1                                    
 begin                                    
 set @Msg_Error = 'Valor de Horas Extras ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                             
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@HorasExtras <> '1') and (@HorasExtras <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Horas Extras ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Fac Adelanto******                                    
 if (@FacAdelanto is null) or (@FacAdelanto = '') or not isnumeric(@FacAdelanto) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Fac Adelanto ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@FacAdelanto <> '1') and (@FacAdelanto <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Fac Adelanto ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Bloqueo Web Consolidador******                                    
 if (@BloWebConsol is null) or (@BloWebConsol = '') or not isnumeric(@BloWebConsol) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Bloqueo Web Consolidador ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor               
 return             
 end                                      
 if  (@BloWebConsol <> '1') and (@BloWebConsol <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Bloqueo Web Consolidador ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Embarcador******                                    
 if (@Embarcador is null) or (@Embarcador = '') or not isnumeric(@Embarcador) = 1                                    
 begin                             
  set @Msg_Error = 'Valor de Embarcador ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                   
 Select @Msg_Valor                          
 return                                       
 end                                      
 if  (@Embarcador <> '1') and (@Embarcador <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Embarcador ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Linea Area******                                    
 if (@LineaArea is null) or (@LineaArea = '') or not isnumeric(@LineaArea) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Linea Area ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                        
 end                                      
 if (@LineaArea <> '1') and (@LineaArea <> '0')                                    
 begin                                      set @Msg_Error = 'Valor de Linea Area ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                  
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --*****Agente de Carga******                                    
 if (@CodAgeCarga is null) --or (@CodAgeCarga = '')                                    
 begin                                    
  set @Msg_Error = 'Debe de ingresar Codigo Agente de Carga correcto, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                     
 --******Exportador******                                    
 if (@Exportador is null) or (@Exportador = '') or not isnumeric(@Exportador) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Exportador ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@Exportador <> '1') and (@Exportador <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Exportador ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                  
 return                                      
 end                                    
 --******Cliente Prospecto******                                    
 if (@CliProspecto is null) or (@CliProspecto = '') or not isnumeric(@CliProspecto) = 1                     
 begin                                    
  set @Msg_Error = 'Valor de Cliente Prospecto ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@CliProspecto <> '1') and (@CliProspecto <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Cliente Prospecto ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Tarifa Flat Importación******                                    
 if (@TarifaFlatImpo is null) or (@TarifaFlatImpo = '') or not isnumeric(@TarifaFlatImpo) = 1                            
 begin                                    
  set @Msg_Error = 'Valor de Tarifa Flat Importacion ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@TarifaFlatImpo <> '1') and (@TarifaFlatImpo <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Tarifa Flat Importacion ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 --******Flat Exportacion******                                    
 if (@FlatExpo is null) or (@FlatExpo = '') or not isnumeric(@FlatExpo) = 1                                    
 begin                                    
  set @Msg_Error = 'Valor de Tarifa Flat Exportacion ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                      
 if  (@FlatExpo <> '1') and (@FlatExpo <> '0')                                    
 begin                                    
  set @Msg_Error = 'Valor de Tarifa Flat Exportacion ingresado no es correcto. Permitido 1 u 0, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
 ---------**********************                                    
                                    
 declare @Cadena varchar(20)                                    
 set @Cadena = dbo.fn_Valor_Cadena(@CodAgeAduana, @AgeGeneral, @CodAgeMaritimo, @CiaConsolidadora,                                    
      @AgeTransporte, @EmpresaAfin, @Importador,@Otros, @CiaSeguros,                                      
      '1','1',@BloWebConsol,@Embarcador,                                    
      @LineaArea, @CodAgeCarga, @Exportador,@CliProspecto, @TarifaFlatImpo, @FlatExpo)                                    
                                    
 print @cadena                                    
                                     
 ----------**********************                                    
                                    
 --Validaciones de Tablas intermedias                                    
                                    
 if @TipoDocumento_Val is null                                    
 begin                                    
  set @Msg_Error = 'Tipo de Documento ingresado no se encuentra registrado, Favor de verificar.'                                    
  Select @Msg_Error                Select @Msg_Valor                                     
 return                                    
 end                                    
                                     
 if @Sector_Val is null                                    
 begin                                    
  set @Msg_Error = 'Sector Economico ingresado no se encuentra registrado, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
                                    
 if @Pais_Val is null                                    
 begin                                    
  set @Msg_Error = 'Pais ingresado no se encuentra registrado, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return   --@Msg_Error                                    
 end                                    
                                     
 if @Departamento_Val is null                                    
 begin                                    
  set @Msg_Error = 'Departamento ingresado no se encuentra registrado, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
                                    
 if @Provincia_Val is null                                    
 begin                                    
  set @Msg_Error = 'Provincia ingresado no se encuentra registrado, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                      
 end                                    
                                    
 if @Distrito_Val is null                                    
 begin                                
  set @Msg_Error = 'Distrito ingresado no se encuentra registrado, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                     
 end                                    
                                    
-- declare @Vendedor char(2)                                    
-- set @Vendedor = 'FF'                                    
 declare @Vendedor_Val char(2)                                    
select @Vendedor_Val = idCodVen from TB_Vendedor where idcodven = @Vendedor                                    
 print @Vendedor_Val                                    
                                    
 if @Vendedor_Val is null                                    
 begin                                    
  set @Msg_Error = 'Vendedor ingresado no se encuentra registrado, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
                                    
-- declare @Cobrador varchar(20)                                    
-- set @Cobrador = 'FF'                                    
 declare @Cobrador_Val char(2)                                    
 select @Cobrador_Val = idCodCob from TB_Cobrador where idCodCob = @Cobrador                                    
 print @Cobrador_Val                                    
                                    
 if @Cobrador_Val is null                                    
 begin                                    
  set @Msg_Error = 'Cobrador ingresado no se encuentra registrado, Favor de verificar.'                                    
  Select @Msg_Error                                       
 Select @Msg_Valor                                     
 return                                       
 end                                    
                                    
 -------------------                                 
 ---Valido que operacion se realizara... insert o update                        
 ------------------                                    
 declare @Existe int                                    
 select @Existe = count(*) from aaclientesaa where contribuy = @Contribuy                            
 print @Existe                                    
               
 --usuario transporte activo/inactivo - creado: FML 05/08/2014              
 declare @activo_transporte char(1)               
 if (@activo= 'S')                  
 begin                  
 set @activo_transporte='A'                  
 end              
 else              
 begin              
 set @activo_transporte='I'              
 end               
 ----------              
                                      
 if @Existe = 0                                    
 begin                                    
      print 'Ingresar:'                              
  Insert AACLIENTESAA (                                    
  CLASEABC,CONTRIBUY,NOMBRE,DIRECCION,TELEFONO1,TELEFONO2,FAX,CONTACTO,                                    
  ACTIVO, NOTAS,TIENECONVE, PAIS, ALIAS, EMAIL,CADENA, CLIENTE, DIASABAST,DIASPROMAT,                                    
  CATCLIENTE,VENDEDOR,NIVELPREC, SECTOR,CLIENTEVIP,DEPARTAMENTO,PROVINCIA,DISTRITO,                                    
  CUSTOMER,ANALISTA, credito, FecVigCred,CODAGEMAR,CODAGECAR,flgbloqtot,flatexpo)                                    
values (                                    
  @TipoDocumento_Val, @Contribuy, @RazonSocial, @direccion, @telefono1, @Telefono2, @Fax, @contacto,                                    
  @Activo, @Observaciones, @Convenio, @Pais_Val, @Alias, @Email, @Cadena, @CodAgeAduana, '15', '2',                                    
  @Catcliente, @Vendedor_Val, @Cobrador_Val, @Sector_Val, @ClienteVip, @Departamento_Val, @Provincia_Val, @Distrito_Val,                                    
  @Customer, @Analista, @Credito, @FecVigCred, @CodAgeMaritimo, @CodAgeCarga, @FlgBloTotal, @FlatExpo)                                    
                                      
  set @Msg_Error = 'Datos registrados correctamente.'                                    
  set @Msg_Valor = 1                  
                
  --Insertar usuario de transporte - creado: FML 05/08/2014              
  if SUBSTRING(@Cadena,5,1)='1'              
  begin              
 declare @persona int              
 declare @PersonaTipoPersona int              
                
 select @persona=MAX(PERSONA)FROM Logistica..SB_Persona              
 select @PersonaTipoPersona=MAX(PersonaTipoPersona) from Logistica..SB_PersonaTipoPersona              
                
 set @persona = @persona + 1              
 set @PersonaTipoPersona = @PersonaTipoPersona + 1              
                   
 --INSERT INTO Logistica..SB_Persona(Persona,ApellidoPaterno,ApellidoMaterno,Nombre01,Nombre02,Nombre,         
 --Estado,UltimoUsuario,UltimaFecha,Ruc,EsEmpresa,CodigoPersona,Pais,TipoDocumento,Departamento,Documento,               
 --Provincia,Empresa,Dsitrito,NivelGrupo,Telefono01,Telefono02,Direccion,                  
 --Rubro,Sucursal,SectoristaCliente,ManejaLote,Paletizable,CustomerService,CertificadoInscripcion,              
 --SectoristaInterno,RepresentanteLegal,              
 --Email,Fax,MetodoDespacho,Contacto,responsableoperativo,almacen,zona,division,articulogenerico,correlativoSI,correlativoSR,              
 --correlativoSS,correlativoST,zonaDES,divisionDES,almacenDES,codigoexterno,correlativoPL,manejafechavto,referencia01,referencia02,              
 --referencia03,referencia04,referencia05,referencia06,referencia07,referencia08,referencia09,referencia10,etiqueta01,              
 --etiqueta02,etiqueta03,etiqueta04,etiqueta05,etiqueta06,etiqueta07,etiqueta08,etiqueta09,              
 --etiqueta10,cantidaddecimal,pesodecimal,volumendecimal,abrref01,abrref02,abrref03,abrref04,abrref05,abrref06,              
 --abrref07,abrref08,abrref09,abrref10,flagabrref01,flagabrref02,flagabrref03,flagabrref04,flagabrref05,flagabrref06,flagabrref07,              
 --flagabrref08,flagabrref09,flagabrref10,ManejaSerie,tipolecturaserie,componenteserie,              
 --mailinterfaz,flagarticuloserie,almacenmaq,zonamaq,divisionmaq,ftpservidor,ftpusuario,ftppassword,flagmailinterfaz,              
 --flagftpinterfaz,ftparchivointerfaz,ftparchivoinconsitencia,              
 --ftparchivointerfazdesp,nooficina,CodigoExterno2,TipoFormato,TipoVia,NombreVia,ZonaUbigeo,DireccionNumero,Interior)              
              
 --SELECT @persona,              
 --ApellidoPaterno,ApellidoMaterno,Nombre01,Nombre02,@RazonSocial,              
 --'A','logistica',GETDATE(),@Contribuy,EsEmpresa,@Contribuy,              
 --@Pais_Val,TipoDocumento,@Departamento_Val,Documento,               
 --@Provincia_Val,1,@Distrito_Val,NivelGrupo,@telefono1,@Telefono2,@direccion,                  
 --@Sector_Val,1,SectoristaCliente,ManejaLote,Paletizable,CustomerService,CertificadoInscripcion,              
 --SectoristaInterno,'',              
 --@Email,@Fax,MetodoDespacho,@contacto,responsableoperativo,almacen,zona,division,articulogenerico,correlativoSI,correlativoSR,              
 --correlativoSS,correlativoST,zonaDES,divisionDES,almacenDES,@Contribuy,correlativoPL,manejafechavto,referencia01,referencia02,              
 --referencia03,referencia04,referencia05,referencia06,referencia07,referencia08,referencia09,referencia10,etiqueta01,              
 --etiqueta02,etiqueta03,etiqueta04,etiqueta05,etiqueta06,etiqueta07,etiqueta08,etiqueta09,              
 --etiqueta10,cantidaddecimal,pesodecimal,volumendecimal,abrref01,abrref02,abrref03,abrref04,abrref05,abrref06,              
 --abrref07,abrref08,abrref09,abrref10,flagabrref01,flagabrref02,flagabrref03,flagabrref04,flagabrref05,flagabrref06,flagabrref07,              
 --flagabrref08,flagabrref09,flagabrref10,ManejaSerie,tipolecturaserie,componenteserie,              
 --mailinterfaz,flagarticuloserie,almacenmaq,zonamaq,divisionmaq,ftpservidor,ftpusuario,ftppassword,flagmailinterfaz,              
 --flagftpinterfaz,ftparchivointerfaz,ftparchivoinconsitencia,              
 --ftparchivointerfazdesp,nooficina,CodigoExterno2,TipoFormato,TipoVia,NombreVia,ZonaUbigeo,DireccionNumero,Interior              
 --FROM Logistica..SB_Persona              
 --WHERE PERSONA=2              
               
 --INSERT INTO Logistica..SB_PersonaTipoPersona(PersonaTipoPersona,UltimoUsuario,Sucursal,UltimaFecha,Empresa,TipoPersona,              
 --Persona,Estado)              
 --SELECT @PersonaTipoPersona,              
 --UltimoUsuario,Sucursal,GETDATE(),Empresa,TipoPersona,              
 --@persona,'A'              
 --FROM Logistica..SB_PersonaTipoPersona WHERE PERSONA=2              
              
  end              
  -----------------------------              
                                   
 end                                    
                                    
 if @Existe > 0                                     
 begin                                    
    print 'Actualizar'                              
   Update AACLIENTESAA set                               
   CATCLIENTE= @Catcliente,                                     
   NOMBRE= @RazonSocial,                                    
   DIRECCION= @direccion,                                    
   TELEFONO1= @telefono1,                                    
   TELEFONO2= @Telefono2,                                    
   FAX= @Fax,                                    
   DEPARTAMENTO= @Departamento_Val,                                    
   PROVINCIA= @Provincia_Val,                                    
   DISTRITO= @Distrito_Val,                                    
   CONTACTO= @contacto,                                     
   CONTRIBUY= @Contribuy,                                    
   NOTAS= @Observaciones,                                    
   ACTIVO= @Activo,                                    
   TIENECONVE= @Convenio,                                    
   PAIS= @Pais_Val,                                    
   ALIAS= @Alias,                                    
   EMAIL= @Email,                                    
   CLIENTE= @CodAgeAduana,                                    
   CADENA= @Cadena,                        DIASABAST= '15',                                     
   --DIASABAST= @DiasAbast,                                       
   DIASPROMAT='2' ,                                    
   --DIASPROMAT= @DiasPromat,                                    
   VENDEDOR= @Vendedor_Val,                                    
   NIVELPREC= @Cobrador_Val,           
   SECTOR= @Sector_Val,                                    
   CLIENTEVIP= @ClienteVip,                                     
   CUSTOMER= @Customer,                                    
   ANALISTA= @Analista,                                    
   Credito= @Credito,                                    
   CODAGEMAR=  @CodAgeMaritimo,                                     
   CODAGECAR= @CodAgeCarga,                                     
   FecVigCred= @FecVigCred,                                     
   flgbloqtot= @FlgBloTotal,                                    
   flatexpo= @FlatExpo                                   
   WHERE CLASEABC = @TipoDocumento_Val and CONTRIBUY = @Contribuy                                    
                                       
   set @Msg_Error = 'Datos actualizados correctamente.'                                    
   set @Msg_Valor = 1                 
                 
   --actualizar usuario de transporte - creado: FML 05/08/2014              
   if SUBSTRING(@Cadena,5,1)='0'    
   begin              
   if exists(select * FROM Logistica..SB_Persona where Ruc=@Contribuy )          
   begin          
    declare @persona1 int              
    select @persona1=PERSONA FROM Logistica..SB_Persona where Ruc=@Contribuy                   
    --update Logistica..SB_Persona set Nombre=@RazonSocial,estado='I',UltimaFecha=GETDATE(),              
    --Ruc=@Contribuy,CodigoPersona=@Contribuy,Pais=@Pais_Val,Departamento=@Departamento_Val,               
    --Provincia=@Provincia_Val,Dsitrito=@Distrito_Val,Telefono01=@telefono1,Telefono02=@Telefono2,Direccion=@direccion,                  
    --Rubro=@Sector_Val,Email=@Email,Fax=@Fax,Contacto=@contacto,codigoexterno=@Contribuy              
    --where Ruc=@Contribuy              
                  
    --update Logistica..SB_PersonaTipoPersona set UltimaFecha=GETDATE(),Estado='I'              
    --where PERSONA= @persona1          
   end                 
   end               
                  
   if SUBSTRING(@Cadena,5,1)='1'              
   begin              
   if not exists(select * FROM Logistica..SB_Persona where Ruc=@Contribuy )          
   begin          
    declare @persona2 int              
    declare @PersonaTipoPersona2 int                   
    select @persona2=MAX(PERSONA)FROM Logistica..SB_Persona              
    select @PersonaTipoPersona2=MAX(PersonaTipoPersona) from Logistica..SB_PersonaTipoPersona                   
    set @persona2 = @persona2 + 1              
    set @PersonaTipoPersona2 = @PersonaTipoPersona2 + 1              
                      
    --INSERT INTO Logistica..SB_Persona(Persona,ApellidoPaterno,ApellidoMaterno,Nombre01,Nombre02,Nombre,              
    --Estado,UltimoUsuario,UltimaFecha,Ruc,EsEmpresa,CodigoPersona,Pais,TipoDocumento,Departamento,Documento,               
    --Provincia,Empresa,Dsitrito,NivelGrupo,Telefono01,Telefono02,Direccion,                  
    --Rubro,Sucursal,SectoristaCliente,ManejaLote,Paletizable,CustomerService,CertificadoInscripcion,              
    --SectoristaInterno,RepresentanteLegal,              
    --Email,Fax,MetodoDespacho,Contacto,responsableoperativo,almacen,zona,division,articulogenerico,correlativoSI,correlativoSR,              
    --correlativoSS,correlativoST,zonaDES,divisionDES,almacenDES,codigoexterno,correlativoPL,manejafechavto,referencia01,referencia02,              
    --referencia03,referencia04,referencia05,referencia06,referencia07,referencia08,referencia09,referencia10,etiqueta01,              
    --etiqueta02,etiqueta03,etiqueta04,etiqueta05,etiqueta06,etiqueta07,etiqueta08,etiqueta09,              
    --etiqueta10,cantidaddecimal,pesodecimal,volumendecimal,abrref01,abrref02,abrref03,abrref04,abrref05,abrref06,              
    --abrref07,abrref08,abrref09,abrref10,flagabrref01,flagabrref02,flagabrref03,flagabrref04,flagabrref05,flagabrref06,flagabrref07,              
    --flagabrref08,flagabrref09,flagabrref10,ManejaSerie,tipolecturaserie,componenteserie,              
    --mailinterfaz,flagarticuloserie,almacenmaq,zonamaq,divisionmaq,ftpservidor,ftpusuario,ftppassword,flagmailinterfaz,              
    --flagftpinterfaz,ftparchivointerfaz,ftparchivoinconsitencia,              
    --ftparchivointerfazdesp,nooficina,CodigoExterno2,TipoFormato,TipoVia,NombreVia,ZonaUbigeo,DireccionNumero,Interior)              
                 
    --SELECT @persona2,              
    --ApellidoPaterno,ApellidoMaterno,Nombre01,Nombre02,@RazonSocial,              
    --'A','logistica',GETDATE(),@Contribuy,EsEmpresa,@Contribuy,              
    --@Pais_Val,TipoDocumento,@Departamento_Val,Documento,               
    --@Provincia_Val,1,@Distrito_Val,NivelGrupo,@telefono1,@Telefono2,@direccion,                  
    --@Sector_Val,1,SectoristaCliente,ManejaLote,Paletizable,CustomerService,CertificadoInscripcion,              
    --SectoristaInterno,'',              
    --@Email,@Fax,MetodoDespacho,@contacto,responsableoperativo,almacen,zona,division,articulogenerico,correlativoSI,correlativoSR,              
    --correlativoSS,correlativoST,zonaDES,divisionDES,almacenDES,@Contribuy,correlativoPL,manejafechavto,referencia01,referencia02,              
    --referencia03,referencia04,referencia05,referencia06,referencia07,referencia08,referencia09,referencia10,etiqueta01,              
    --etiqueta02,etiqueta03,etiqueta04,etiqueta05,etiqueta06,etiqueta07,etiqueta08,etiqueta09,              
    --etiqueta10,cantidaddecimal,pesodecimal,volumendecimal,abrref01,abrref02,abrref03,abrref04,abrref05,abrref06,              
    --abrref07,abrref08,abrref09,abrref10,flagabrref01,flagabrref02,flagabrref03,flagabrref04,flagabrref05,flagabrref06,flagabrref07,              
    --flagabrref08,flagabrref09,flagabrref10,ManejaSerie,tipolecturaserie,componenteserie,              
    --mailinterfaz,flagarticuloserie,almacenmaq,zonamaq,divisionmaq,ftpservidor,ftpusuario,ftppassword,flagmailinterfaz,              
    --flagftpinterfaz,ftparchivointerfaz,ftparchivoinconsitencia,              
    --ftparchivointerfazdesp,nooficina,CodigoExterno2,TipoFormato,TipoVia,NombreVia,ZonaUbigeo,DireccionNumero,Interior              
    --FROM Logistica..SB_Persona              
    --WHERE PERSONA=2              
                  
    --INSERT INTO Logistica..SB_PersonaTipoPersona(PersonaTipoPersona,UltimoUsuario,Sucursal,UltimaFecha,Empresa,TipoPersona,              
    --Persona,Estado)              
    --SELECT @PersonaTipoPersona2,              
    --UltimoUsuario,Sucursal,GETDATE(),Empresa,TipoPersona,              
    --@persona2,'A'              
    --FROM Logistica..SB_PersonaTipoPersona WHERE PERSONA=2              
   end           
   else          
   begin          
    if exists(select * FROM Logistica..SB_Persona where Ruc=@Contribuy )          
    begin          
    if @activo='N'          
   begin          
      declare @persona111 int              
      select @persona111=PERSONA FROM Logistica..SB_Persona where Ruc=@Contribuy                    
                
      --update Logistica..SB_Persona set Nombre=@RazonSocial,estado='I',UltimaFecha=GETDATE(),              
      --Ruc=@Contribuy,CodigoPersona=@Contribuy,Pais=@Pais_Val,Departamento=@Departamento_Val,               
      --Provincia=@Provincia_Val,Dsitrito=@Distrito_Val,Telefono01=@telefono1,Telefono02=@Telefono2,Direccion=@direccion,                  
      --Rubro=@Sector_Val,Email=@Email,Fax=@Fax,Contacto=@contacto,codigoexterno=@Contribuy              
      --where Ruc=@Contribuy              
                 
      --update Logistica..SB_PersonaTipoPersona set UltimaFecha=GETDATE(),Estado='I'              
      --where PERSONA= @persona111             
    end          
    else          
    begin          
      declare @persona1111 int              
      select @persona1111=PERSONA FROM Logistica..SB_Persona where Ruc=@Contribuy                    
                
      --update Logistica..SB_Persona set Nombre=@RazonSocial,estado='A',UltimaFecha=GETDATE(),              
      --Ruc=@Contribuy,CodigoPersona=@Contribuy,Pais=@Pais_Val,Departamento=@Departamento_Val,               
      --Provincia=@Provincia_Val,Dsitrito=@Distrito_Val,Telefono01=@telefono1,Telefono02=@Telefono2,Direccion=@direccion,                  
      --Rubro=@Sector_Val,Email=@Email,Fax=@Fax,Contacto=@contacto,codigoexterno=@Contribuy              
      --where Ruc=@Contribuy              
              
   --   if exists(select *from Logistica..SB_PersonaTipoPersona WHERE Persona=@persona1111)        
   --   begin         
                
   ----update Logistica..SB_PersonaTipoPersona set UltimaFecha=GETDATE(),Estado='A'              
   ----where PERSONA= @persona1111                     
   --end        
   --else      
   --begin        
                
   -- declare @PersonaTipoPersona1111 int                    
   -- select @PersonaTipoPersona1111=MAX(PersonaTipoPersona) from Logistica..SB_PersonaTipoPersona                   
   -- set @PersonaTipoPersona1111 = @PersonaTipoPersona1111 + 1        
               
   -- INSERT INTO Logistica..SB_PersonaTipoPersona(PersonaTipoPersona,UltimoUsuario,Sucursal,UltimaFecha,Empresa,TipoPersona,              
   -- Persona,Estado)              
   -- SELECT @PersonaTipoPersona1111,              
   -- UltimoUsuario,Sucursal,GETDATE(),Empresa,TipoPersona,              
   -- @persona1111,'A'              
   -- FROM Logistica..SB_PersonaTipoPersona WHERE PERSONA=2         
          
   --   end         
    end          
    end              
   end              
   end            
             
             
------------------------------              
end                                    
                                                                 
 Select @Msg_Error                                       
 Select @Msg_Valor                                    
                                    
 return                                     
                                    
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_Inserta_DUA_DESPACHO_Cabezera]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Inserta_DUA_DESPACHO_Cabezera]  
(  
@numdui16 varchar(14),  
@fecdui16 smalldatetime,  
@feccan16 smalldatetime,  
@tipcli02 char(1),  
@codcli02 varchar(11),   
@codage19 varchar(4),  
@totser16 smallint,  
@numbul16 int,  
@pesbru16 decimal(9,3),  
@valfob16 varchar(19),  
@valfle16 decimal(9,3),  
@valseg16 decimal(9,3),  
@valcif16 varchar(19),  
@numdui11 char(13),  
@numcer13 char(9),  
@nomusu16 varchar(15),  
@canaldua16 char(1),  
@FecCanal16 datetime,  
@HoraCanal16 datetime  
)  
AS  
BEGIN  

declare @valfob17 decimal(15,3)  
set @valfob17 =  CAST( REPLACE(@valfob16,',','') as decimal(15,3) )  

declare @valcif17 decimal(15,3)  
set @valcif17 =  CAST( REPLACE(@valcif16,',','') as decimal(15,3) ) 
  
Insert Into DDDuiDes16  
(numdui16, fecdui16, feccan16, tipcli02, codcli02, codage19, totser16, numbul16, pesbru16, valfob16, valfle16, valseg16, valcif16, flgret16,   
nument16, bulent16, cifent16, pesent16, numdui11, numcer13, flgdui16, flgver16, parara16, fecver16, nomusu16, fecusu16, flglev16, canaldua16,   
FecCanal16, HoraCanal16)  
Values   
(@numdui16, @fecdui16, @feccan16, @tipcli02, @codcli02, @codage19, @totser16, @numbul16, @pesbru16, @valfob17, @valfle16, @valseg16, @valcif17, '0',   
0, 0, 0, 0, @numdui11, @numcer13, '1', '0', '0', Null, @nomusu16, getdate(), '0', @canaldua16, @FecCanal16, @HoraCanal16)  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[sp_Inserta_DUA_DESPACHO_Detalle]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Inserta_DUA_DESPACHO_Detalle]  
(  
@numdui16 varchar(14), @numser17 varchar(4),  
@numcer13 varchar(9),  @numdui11 varchar(13),  
@numser12 varchar(4),  @numbul17 decimal(9,3),  
@codemb06 varchar(3),  @desmer17 varchar(100),  
@parara17 varchar(10), @pesbru17 decimal(9,3),  
@valfob17 decimal(9,3),  @valfle17 decimal(9,3),  
@valseg17 decimal(9,3),  @cifuni17 varchar(15),  
@valcif17 decimal(9,3),  @bulent17 decimal(9,3),  
@cifent17 decimal(9,3),  @unidad12 decimal(9,3),  
@tipuni12 varchar(2)  
)  
AS  
BEGIN  

declare @cifuni18 decimal(9,3)
set @cifuni18 =  CAST( REPLACE(@cifuni17,',','') as decimal(9,3) )
  
Insert Into DDSerDes17   
(numdui16, numser17, numcer13, numdui11, numser12, numbul17, codemb06, desmer17, parara17, pesbru17, valfob17,  
valfle17, valseg17, cifuni17, valcif17, bulent17, cifent17, unidad12,tipuni12)   
Values   
(@numdui16, @numser17, @numcer13, @numdui11, @numser12, @numbul17, @codemb06, @desmer17, @parara17, @pesbru17,  
@valfob17, @valfle17, @valseg17, @cifuni18, @valcif17, @bulent17, @cifent17, @unidad12, @tipuni12)  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTA_PLACA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_INSERTA_PLACA]
@numpla20 CHAR(6),
@ordret20 CHAR(7),
@nument79 VARCHAR(7),
@fecing20 VARCHAR(17),
@pestar20 INT,
@tipest20 CHAR(1),
@obsing20 VARCHAR(100),
@nomusu20 VARCHAR(15)
AS
INSERT INTO DDOrdPla20 (
numpla20,
ordret20,
nument79,
fecing20,
pestar20,
tipest20,
obsing20,
fecsal20,
nomusu20,
fecusu20)
VALUES
(
@numpla20,
@ordret20,
@nument79,
@fecing20,
@pestar20,
@tipest20,
@obsing20,
GETDATE(),
@nomusu20,
GETDATE()
)
RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_CARRITOCOMPRAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[SP_INSERTAR_CARRITOCOMPRAS]
    @IdOrd Varchar(10),  
    @contribuy varchar(20),        
    @numcer13 varchar(10),    
    @numser12 varchar(4),    
    @codemb06 varchar(10),    
    @desmer14 varchar(200),     
    @Cantidad int,
    @duaDespacho varchar(200),
    @servicio varchar(200),      
    @duaDeposito varchar(200)
as  
  
begin  
  
   INSERT INTO  OrdRetiroCarrito VALUES   
   (@IdOrd,   
    @contribuy,   
    @numcer13,    
    --right('000' + convert(varchar(3),@numser12) ,3),    
    @numser12,    
    @codemb06,  
    @desmer14,   
    @Cantidad ,  
    getdate(),  
    null,  
    'R',  
    null,  
    @duaDespacho,
    @servicio,
    @duaDeposito)
  
Return 0  
end  










GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_CARRITOCOMPRAS_SAA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[SP_INSERTAR_CARRITOCOMPRAS_SAA]
    @IdOrd Varchar(10),  
    @contribuy varchar(20),        
    @numcer13 varchar(10),    
    @numser12 varchar(4),    
    @codemb06 varchar(10),    
    @desmer14 varchar(200),     
    @Cantidad int,
    @duaDespacho varchar(200),
    @servicio varchar(200),      
    @duaDeposito varchar(200),
    @fechaEntrega dateTime
as  
  
begin  
  
   INSERT INTO  OrdRetiroCarrito VALUES   
   (@IdOrd,   
    @contribuy,   
    @numcer13,    
    --right('000' + convert(varchar(3),@numser12) ,3),    
    @numser12,    
    @codemb06,  
    @desmer14,   
    @Cantidad ,  
    getdate(),  
    @fechaEntrega,  
    'R',  
    null,  
    @duaDespacho,
    @servicio,
    @duaDeposito)
  
Return 0  
end 



GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_DIRECCION_DISTRITO_ZONAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_INSERTAR_DIRECCION_DISTRITO_ZONAS] 
 @RUC Varchar(20), 
 @CAL_CODIGO int, 
 @CAL_ZONA varchar(100),
 @DIRECCION varchar(500)
AS  
BEGIN
 INSERT INTO DIRECCION_DISTRITO_ZONAS
 VALUES (
 @RUC, 
 @CAL_CODIGO , 
 @CAL_ZONA ,
 @DIRECCION,
 'A')
END






GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_ORDRETADUANAWEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[SP_INSERTAR_ORDRETADUANAWEB]  
    @IdOrd Varchar(10),  
    @contribuy varchar(20),        
    @numcer13 varchar(10),    
    @numser12 varchar(4),    
    @codemb06 varchar(10),    
    @desmer14 varchar(200),     
    @Cantidad int , 
    @AddID    int OUTPUT  
as  
  
begin  
  
   INSERT INTO  OrdRetiroAduanaWeb VALUES   
   (@IdOrd,   
    @contribuy,   
    @numcer13,    
    right('000' + convert(varchar(3),@numser12) ,3),    
    --@numser12,    
    @codemb06,  
    @desmer14,   
    @Cantidad ,  
    getdate(),  
    null,  
    'R',  
    null,  
    null) -- Estado confirmar Aduana  
  
SET @AddID = scope_identity()
end  



GO
/****** Object:  StoredProcedure [dbo].[sp_Integracion]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_Integracion    Script Date: 08-09-2002 08:44:10 PM ******/
/****** Object:  Stored Procedure dbo.sp_Integracion    Script Date: 28/04/2000 9:21:59 PM ******/
ALTER PROCEDURE [dbo].[sp_Integracion]
		@fec_i varchar(8),
		@fec_f varchar(8),
		@fec_s varchar(8)


as

begin transaction

exec sp_provision3 @fec_i, @fec_f

if @@error <> 0 GOTO E_General_Error

exec sp_cancelacion3 @fec_i, @fec_f, '20000825'
if @@error <> 0 GOTO E_General_Error


commit transaction
return 0

E_General_Error:
   raiserror('no se pudo crear la tabla Intermedia',1,2) with seterror

   rollback transaction

   return 2
GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_DESPACHOxCLIENTE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_LISTAR_DESPACHOxCLIENTE]
@Ruc varchar(20),
@FechaIni datetime,
@FechaFin datetime,
@certificado varchar(20),
@duadeposito varchar(20),
@mecarderia varchar(250)

As

select IdOrd,Contribuy,numcer13 as Numcer
,numser12 as Serie,codemb06,desmer14,cantidad ,fecharReg,fechaConf as	FechaEntrega , estado,NroServicio,duadeposito
from ordRetiroCarrito
Where fecharReg >= @FechaIni and fecharReg <= @FechaFin + 1
AND Contribuy = @Ruc 
AND desmer14 like '%' + @mecarderia + '%'
AND duadeposito like '%' + @duadeposito + '%'
AND numcer13 like '%' + @certificado + '%'
order by fecharReg desc



GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_NACIONALxCLIENTE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_LISTAR_NACIONALxCLIENTE]
@Ruc varchar(20),
@FechaIni datetime,
@FechaFin datetime
As

select IdOrd,Contribuy,numcer13,numser12 ,desmer14 ,codemb06 ,cantidad,fecharReg,fechaConf,estado,duaDespacho,OrdRetiro
from OrdRetiroAduanaWeb
Where fecharReg >= @FechaIni and fecharReg <= @FechaFin + 1
And Contribuy = @Ruc
order by fecharReg desc

GO
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ORDRETADUANAWEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_LISTAR_ORDRETADUANAWEB]  
  @IdOrd Varchar(10)  
as  
begin  
  Select IdOrd,contribuy,numcer13,numser12,desmer14,codemb06,cantidad ,estado,duadespacho ,OrdRetiro ,fecharReg,fechaConf
  from OrdRetiroAduanaWeb   
  where IdOrd = @IdOrd  
End 


GO
/****** Object:  StoredProcedure [dbo].[sp_nologdeposito]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_nologdeposito]  
AS  
--dump transaction depositos with no_log  
backup log depositos with no_log  
dbcc checktable(syslogs)
GO
/****** Object:  StoredProcedure [dbo].[SP_NUEVA_ENTREGA_ADUANERA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_NUEVA_ENTREGA_ADUANERA    Script Date: 08-09-2002 08:44:14 PM ******/  
ALTER PROCEDURE [dbo].[SP_NUEVA_ENTREGA_ADUANERA] @NUMORD CHAR(7)  
AS  
BEGIN  
 	SELECT DISTINCT *
	FROM (
		SELECT a.fecret18
			,a.numdui16
			,b.tipcli02
			,b.codcli02
			,NombreC = c.nombre
			,b.codage19
			,NombreA = d.nombre
			,a.tipdoc55
			,a.codrep77
			,e.nomrep77
			,b.valcif16
			,
			--b.cifent16,    
			cifent16 = (
				SELECT coalesce(sum(pretot79 + cuadep79), 0)
				FROM ddentmer79
				WHERE numdui16 = a.numdui16
					AND flgval79 = '1'
				)
			,a.flgval18
			,a.flgemi18
			,f.obscer13
		FROM DRRetAdu18 a
		INNER JOIN DDDuiDes16 b ON a.numdui16 = b.numdui16
		INNER JOIN AAClientesAA c ON b.tipcli02 = c.claseabc
			AND b.codcli02 = c.contribuy
		INNER JOIN AAClientesAA d ON b.codage19 = d.cliente
		INNER JOIN DQMaeRep77 e ON a.codrep77 = e.codrep11
		INNER JOIN DDCerAdu13 f ON b.numcer13 = f.numcer13
		WHERE a.numret18 = @NumOrd
			AND convert(CHAR(8), a.fecret18, 112) = convert(CHAR(8), getdate(), 112)
			--|AGREGAR HABILITACION DE ORDENES PROLONGADAS  
			/*  
	  UNION  
	    
	  SELECT a.fecret18  
	   ,a.numdui16  
	   ,b.tipcli02  
	   ,b.codcli02  
	   ,NombreC = c.nombre  
	   ,b.codage19  
	   ,NombreA = d.nombre  
	   ,a.tipdoc55  
	   ,a.codrep77  
	   ,e.nomrep77  
	   ,b.valcif16  
	   ,  
	   --b.cifent16,    
	   cifent16 = (  
		SELECT coalesce(sum(pretot79 + cuadep79), 0)  
		FROM ddentmer79  
		WHERE numdui16 = a.numdui16  
		 AND flgval79 = '1'  
		)  
	   ,a.flgval18  
	   ,a.flgemi18  
	   ,f.obscer13  
	  FROM DRRetAdu18 a  
	  INNER JOIN DDDuiDes16 b ON a.numdui16 = b.numdui16  
	  INNER JOIN AAClientesAA c ON b.tipcli02 = c.claseabc  
	   AND b.codcli02 = c.contribuy  
	  INNER JOIN AAClientesAA d ON b.codage19 = d.cliente  
	  INNER JOIN DQMaeRep77 e ON a.codrep77 = e.codrep11  
	  INNER JOIN DDCerAdu13 f ON b.numcer13 = f.numcer13  
	  --|  
	  INNER JOIN DDHABORDRET H ON H.numret = a.numret18  
	  WHERE a.numret18 = @NumOrd  
	   and H.fecsig >= GETDATE()  
	  */
		) DATA
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_NUEVA_ENTREGA_ADUANERA_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_NUEVA_ENTREGA_ADUANERA    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_NUEVA_ENTREGA_ADUANERA_NEW] @NUMORD CHAR(7)
AS
BEGIN
	SELECT DISTINCT *
	FROM (
		SELECT a.fecret18
			,a.numdui16
			,b.tipcli02
			,b.codcli02
			,NombreC = c.nombre
			,b.codage19
			,NombreA = d.nombre
			,a.tipdoc55
			,a.codrep77
			,e.nomrep77
			,b.valcif16
			,
			--b.cifent16,    
			cifent16 = (
				SELECT coalesce(sum(pretot79 + cuadep79), 0)
				FROM ddentmer79
				WHERE numdui16 = a.numdui16
					AND flgval79 = '1'
				)
			,a.flgval18
			,a.flgemi18
			,f.obscer13
		FROM DRRetAdu18 a
		INNER JOIN DDDuiDes16 b ON a.numdui16 = b.numdui16
		INNER JOIN AAClientesAA c ON b.tipcli02 = c.claseabc
			AND b.codcli02 = c.contribuy
		INNER JOIN AAClientesAA d ON b.codage19 = d.cliente
		INNER JOIN DQMaeRep77 e ON a.codrep77 = e.codrep11
		INNER JOIN DDCerAdu13 f ON b.numcer13 = f.numcer13
		WHERE a.numret18 = @NumOrd
			AND convert(CHAR(8), a.fecret18, 112) = convert(CHAR(8), getdate(), 112)
			--|AGREGAR HABILITACION DE ORDENES PROLONGADAS  
			/*  
	  UNION  
	    
	  SELECT a.fecret18  
	   ,a.numdui16  
	   ,b.tipcli02  
	   ,b.codcli02  
	   ,NombreC = c.nombre  
	   ,b.codage19  
	   ,NombreA = d.nombre  
	   ,a.tipdoc55  
	   ,a.codrep77  
	   ,e.nomrep77  
	   ,b.valcif16  
	   ,  
	   --b.cifent16,    
	   cifent16 = (  
		SELECT coalesce(sum(pretot79 + cuadep79), 0)  
		FROM ddentmer79  
		WHERE numdui16 = a.numdui16  
		 AND flgval79 = '1'  
		)  
	   ,a.flgval18  
	   ,a.flgemi18  
	   ,f.obscer13  
	  FROM DRRetAdu18 a  
	  INNER JOIN DDDuiDes16 b ON a.numdui16 = b.numdui16  
	  INNER JOIN AAClientesAA c ON b.tipcli02 = c.claseabc  
	   AND b.codcli02 = c.contribuy  
	  INNER JOIN AAClientesAA d ON b.codage19 = d.cliente  
	  INNER JOIN DQMaeRep77 e ON a.codrep77 = e.codrep11  
	  INNER JOIN DDCerAdu13 f ON b.numcer13 = f.numcer13  
	  --|  
	  INNER JOIN DDHABORDRET H ON H.numret = a.numret18  
	  WHERE a.numret18 = @NumOrd  
	   and H.fecsig >= GETDATE()  
	  */
		) DATA
END

GO
/****** Object:  StoredProcedure [dbo].[SP_NUEVA_ENTREGA_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_NUEVA_ENTREGA_ADUANERA    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_NUEVA_ENTREGA_SIMPLE] @NUMORD CHAR(7)
AS
BEGIN
	SELECT DISTINCT *
	FROM (
			SELECT a.fecret75
				,a.numcer74
				,b.NumSol62
				,b.obscer74
				,a.codage19
				,NombreA = e.nombre
				,a.tipdoc55
				,a.codrep77
				,c.nomrep77
				,a.bultot75
				,a.pretot75
				,a.bulret75
				,a.preret75
				,a.flgval75
				,a.flgemi75
				,b.tipcli02
				,b.codcli02
				,NombreC = d.nombre
			FROM DDRetSim75 a
			INNER JOIN DDCerSim74 b ON (a.numcer74 = b.numcer74)
			INNER JOIN DQMaerep77 c ON (a.codrep77 = c.codrep11)
			INNER JOIN AAClientesAA d ON (
					b.tipcli02 = d.claseabc
					AND b.codcli02 = d.contribuy
					)
			LEFT JOIN AAClientesAA e ON (
					a.codage19 = e.cliente
					AND a.codage19 <> ''
					)
			WHERE a.numret75 = @NumOrd
				AND convert(CHAR(8), a.fecret75, 112) = convert(CHAR(8), getdate(), 112)
			--|AGREGAR HABILITACION DE ORDENES PROLONGADAS  
			/*
			UNION  
    
			SELECT a.fecret75
				,a.numcer74
				,b.NumSol62
				,b.obscer74
				,a.codage19
				,NombreA = e.nombre
				,a.tipdoc55
				,a.codrep77
				,c.nomrep77
				,a.bultot75
				,a.pretot75
				,a.bulret75
				,a.preret75
				,a.flgval75
				,a.flgemi75
				,b.tipcli02
				,b.codcli02
				,NombreC = d.nombre
			FROM DDRetSim75 a
			INNER JOIN DDCerSim74 b ON (a.numcer74 = b.numcer74)
			INNER JOIN DQMaerep77 c ON (a.codrep77 = c.codrep11)
			INNER JOIN AAClientesAA d ON (
					b.tipcli02 = d.claseabc
					AND b.codcli02 = d.contribuy
					)
			LEFT JOIN AAClientesAA e ON (
					a.codage19 = e.cliente
					AND a.codage19 <> ''
					)
			INNER JOIN DDHABORDRET H ON H.numret = a.numret75 
			WHERE a.numret75 = @NumOrd
			and H.fecsig >= GETDATE() 
			*/
  --|  
		) DATA
END

GO
/****** Object:  StoredProcedure [dbo].[SP_NUMSOL_CEPDEP_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_NUMSOL_CEPDEP_ADU    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[SP_NUMSOL_CEPDEP_ADU]
@NUMSOL CHAR(7)
AS

Select
a.numdui11,a.fecdui11,b.fecsol10,b.cobalm10,b.tipcli02,b.codcli02,NombreC=c.nombre,b.codage19,
NombreA=d.nombre,a.numbul11,a.pesbru11,a.valfob11,a.valfle11,a.valseg11,a.valcif11,
b.flgcer10,b.numrec10,a.flgdil11
From 
ddduidep11 a,ddsoladu10 b,AAClientesAA c,AAClientesAA d
Where 
a.numsol10=b.numsol10 and b.tipcli02=c.claseabc and b.codcli02=c.Contribuy and flgcer10=0 and 
b.CodAge19=d.cliente And b.numsol10=@NUMSOL
--25/11/2002 - HV - Agrege la condicion flgcer10=0 para evitar que la Solicitud sea utilizada nuevamente en la Generación de Otro Certificado,
--lo que sucedia es que de vez en cuando se autogeneraban Certificados Aduaneros con la misma solicitud, el porque? nunca lo pude determinar, asi que
--mejoré la condicion de busqueda de las solicitudes para que cuando ya tenga Certificado Generado no pueda ser usada nuevamente.
GO
/****** Object:  StoredProcedure [dbo].[SP_ObtenerOrdAduaneroWeb]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ObtenerOrdAduaneroWeb]
@iFolioHost int = 0 OUTPUT 
AS 
BEGIN 
SET NOCOUNT ON 
BEGIN TRAN MyTran 
	SELECT @iFolioHost = isnull(idOrd,0) FROM NroOrdAduanaWeb ROWLOCK 
	UPDATE NroOrdAduanaWeb WITH (ROWLOCK) 
	SET idOrd = ISNULL(@iFolioHost, 0) + 1 
COMMIT TRAN MyTran 
/*IF @iOrigen = 1 */
  Select @iFolioHost as NroOrden
END

GO
/****** Object:  StoredProcedure [dbo].[SP_ObtieneOrdenRetiro]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_ObtieneOrdenRetiro]
@iFolioHost int = 0 OUTPUT 
AS 
BEGIN 
SET NOCOUNT ON 
BEGIN TRAN MyTran 
	SELECT @iFolioHost = conret75 FROM DCRetSim75 ROWLOCK 
	UPDATE DCRetSim75 WITH (ROWLOCK) 
	SET conret75 = ISNULL(conret75, 0) + 1 
COMMIT TRAN MyTran 
/*IF @iOrigen = 1 */
  Select @iFolioHost as NroOrden
END


GO
/****** Object:  StoredProcedure [dbo].[SP_ORDEN_RETSIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_ORDEN_RETSIM    Script Date: 08-09-2002 08:44:12 PM ******/      
ALTER PROCEDURE [dbo].[SP_ORDEN_RETSIM]      
@NUMORD CHAR(7)      
AS      
      
Select       
a.fecret75,a.numcer74,a.codage19,NombreA=e.nombre,a.tipdoc55,a.codrep77,d.nomrep77,b.feccer74,      
b.numsol62,b.tipcli02,b.codcli02,NombreC=c.nombre,a.pretot75,a.obsret75,a.flgval75,a.flgemi75,      
f.codubi71      
From       
DDRetSim75 a    
inner join DDCerSim74 b on (a.numcer74=b.numcer74 and a.numcer74=b.numcer74)    
inner join AAClientesAA c on (b.codcli02=c.contribuy and b.tipcli02=c.claseabc)    
inner join DQMaeRep77 d on (a.codrep77=d.codrep11)    
inner join DDrecmer69 f on (b.numsol62=f.numsol62)      
left  join AAClientesAA e on (a.codage19=e.cliente and a.codage19 <> '')    
Where       
a.numret75=@NUMORD and       
b.flgval74='1' and       
f.flgval69='1'
GO
/****** Object:  StoredProcedure [dbo].[SP_OT_ANULAOS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_OT_ANULAOS]
@ORDSER VARCHAR(6)
AS
BEGIN
	SET @ORDSER=LTRIM(RTRIM(@ORDSER))
	
	IF EXISTS(SELECT TOP 1 *FROM DDPLAREC32 WHERE NUMORD58=@ORDSER)
	BEGIN
		UPDATE DDPLAREC32 SET FLGREC32='A'
		WHERE NUMORD58=@ORDSER
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_PERMISOS_ACCIONES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_PERMISOS_ACCIONES]
@USER_ID 	VARCHAR(15),
@KEYFORM	VARCHAR(15),
@SISTEMA	VARCHAR(15),
@POSCAD	int

AS

Declare @COUNT int
Declare @ACCION varchar(20)
Declare @NOM_ACCION varchar(20)

Select @COUNT=count(*)
From DDMENUES01 
Where USUARI01=@USER_ID and (KEYFOR01=@KEYFORM OR KEYFOR01='*') and SISTEM01=@SISTEMA

if @COUNT=1
	Select @ACCION=substring(CADENA01, @POSCAD, 1)
	From DDMENUES01 
	Where USUARI01=@USER_ID and (KEYFOR01=@KEYFORM OR KEYFOR01='*') and SISTEM01=@SISTEMA
else
	Select @ACCION='0'


if @POSCAD=1  Select @NOM_ACCION='NUEVO'
if @POSCAD=2  Select @NOM_ACCION='CONSULTAR'
if @POSCAD=3  Select @NOM_ACCION='GRABAR'
if @POSCAD=4  Select @NOM_ACCION='IMPRIMIR'
if @POSCAD=5  Select @NOM_ACCION='ANULAR'
if @POSCAD=6  Select @NOM_ACCION='DILIGENIAR'
if @POSCAD=7  Select @NOM_ACCION='MODIFICAR'
if @POSCAD=8  Select @NOM_ACCION='VERIFICAR'
if @POSCAD=9  Select @NOM_ACCION='PESAR'
if @POSCAD=10  Select @NOM_ACCION='PROCESAR'
if @POSCAD=11  Select @NOM_ACCION='BLOQUEAR'
if @POSCAD=12  Select @NOM_ACCION='DESBLOQUEAR'
if @POSCAD=13  Select @NOM_ACCION='BUSCAR'
if @POSCAD=14  Select @NOM_ACCION='DESVERIFICAR'
if @POSCAD>=15 Select @NOM_ACCION='NO PROGRAMADO'

Select CONTADOR=@COUNT, ACCION=@ACCION, NOM_ACCION=@NOM_ACCION
GO
/****** Object:  StoredProcedure [dbo].[SP_PERMISOS_OPCIONES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_PERMISOS_OPCIONES]
@USER_ID 	VARCHAR(15),
@KEYFORM	VARCHAR(15),
@SISTEMA	VARCHAR(15)

AS

Select * From DDMENUES01 Where USUARI01=@USER_ID and (KEYFOR01=@KEYFORM OR KEYFOR01='*') and SISTEM01=@SISTEMA
GO
/****** Object:  StoredProcedure [dbo].[SP_PERMISOS_OPCIONES_NUEVO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_PERMISOS_OPCIONES_NUEVO]  
@USER_ID  VARCHAR(15),  
@KEYFORM VARCHAR(15),  
@SISTEMA VARCHAR(15)  
  
AS  
BEGIN  
SET NOCOUNT ON;
Select * From Terminal.dbo.DDMENUES01 
Where USUARI01=@USER_ID and (KEYFOR01=@KEYFORM OR KEYFOR01='*') 
and SISTEM01=@SISTEMA  
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_PLACA_DESTARE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_PLACA_DESTARE    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_PLACA_DESTARE]
@PLACA CHAR(6)
AS

Select a.*,b.nombre
From DDTICKET01 a,AACLIENTESAA b
Where a.tipope01='D' and a.tipest01='I' and
a.numpla01=@PLACA and 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
GO
/****** Object:  StoredProcedure [dbo].[sp_ProcesoIvan]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_ProcesoIvan]
as
declare @cod varchar(5), 
	@des varchar(30)

declare cursorproc scroll cursor 
for select codcon51 from dqconcom51
for read only
open cursorproc
fetch first from cursorproc into @cod
while @@fetch_status=0
begin
	exec sp_conceptos_dep @cod, @des output	
	insert into PRUEBA (codigo, descripcion) values (@cod,@des)
fetch next from cursorproc into @cod
if @@fetch_status <> 0 
   begin
	close cursorproc
	deallocate cursorproc
   end
end

GO
/****** Object:  StoredProcedure [dbo].[sp_provision]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/****** Object:  Stored Procedure dbo.sp_provision    Script Date: 08-09-2002 08:44:07 PM ******/  
/****** Object:  Stored Procedure dbo.sp_provision    Script Date: 28/04/2000 8:36:49 PM ******/  
/****** Object:  Stored Procedure dbo.sp_provision    Script Date: 18/04/2000 9:19:30 AM ******/  
ALTER PROCEDURE [dbo].[sp_provision]  
  @fec_i varchar(8),  
  @fec_f varchar(8)  
  
as  
  
/********* Para provisiones *********/    
  
/****** Para la cuenta 70 *****/  
/*substring(convert(char(12),getdate(),114),1,2) + substring(convert(char(12),getdate(),114),4,2) + substring(convert(char(12),getdate(),114),7,2) + substring(convert(char(12),getdate(),114),10,3)*/  
  
select codsbd03=c.codsbd03, coddoc07=d.coddoc07, codmon30='D', fecmov12= a.feccom52,   
codcue01=c.codcue01, serdoc12=substring(a.numcom52,1,3), numdoc12=substring(a.numcom52,4,8),  
codcco06='', codcco07='', desmov12=b.descon53, nrocan04=a.docdes52, codana02='01',   
impmna12= convert(decimal(15,3),(b.valcon53*a.tipcam52)), impmex12=convert(decimal(15,3),b.valcon53), ticadi12= convert(decimal(15,3),a.tipcam52), IGV=(convert(decimal(15,3),b.valcon53)*0.180),   
descan04=case when e.nomcli02=null then '' else e.nomcli02 end, tipaut12 = case when f.flgigv50 = '1' then 'GS1' else 'EXO' end,   
sistem12='D', flagdh12 = 'H', flglei12='N', fecven12=''   
into #tmp010011   
from 
ddcabcom52 a (nolock)  
inner join dddetcom53 b (nolock) on (a.codcom50=b.codcom50 and a.numcom52=b.numcom52)   
inner join crconcep01 c (nolock) on (b.codcon51=c.codcon14) 
inner join crtipdoc02 d (nolock) on (a.codcom50=d.codtip02)  
left  join dqclipro99 e (nolock) on (a.codcli02=e.codcli02)  
left  join dqcompag50 f (nolock) on (a.codcom50=f.codcom50) 
where  
(a.flgcan52='0' and a.flgemi52='1' and a.flgval52 = '1')  
and (c.tipapp01='D')  
and (d.tipapp02='D')  
and (a.flglei52='N')  
and (a.feccom52 >= @fec_i  
and a.feccom52 < @fec_f)   
group by c.codsbd03, d.coddoc07, a.feccom52, c.codcue01, a.numcom52, b.descon53, a.docdes52,  
b.valcon53, a.tipcam52, e.nomcli02, f.flgigv50    
if @@error <> 0 goto E_Select_Error  
  
/****** para la cuenta 12 ******/  
  
select codsbd03=b.codsbd03, coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12,  
a.numdoc12, codcco06='', codcco07='', desmov12=a.descan04, a.nrocan04, a.codana02,  
impmna12= case when a.codmon30 = 'D' then ((sum(a.impmex12)+sum(a.igv))*a.ticadi12) else 0 end,   
impmex12= case when a.codmon30 = 'D' then sum(a.impmex12)+sum(a.igv) else 0 end,   a.ticadi12, a.descan04, tipaut12='', a.sistem12, flagdh12='D', a.flglei12, fecven12=''  
into #tmp010012   
from #tmp010011 a,   
crconcep01 b  
where a.codmon30=b.codcon14 and b.tipapp01='D'  
group by b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.nrocan04, a.codana02, a.ticadi12, b.codcue01,  
a.serdoc12, a.numdoc12, a.descan04, a.sistem12, a.flagdh12, a.flglei12  
if @@error <> 0 goto E_Select_Error   
  
/****** para la cuenta 40 ******/  
  
select codsbd03=b.codsbd03, coddoc07='', codmon30='D', fecmov12='',   
/*codcue01='40110000', serdoc12='', numdoc12='',*/  
codcue01=b.codcue01, serdoc12='', numdoc12='',  
codcco06='', codcco07='', desmov12='IGV', nrocan04='', codana02='',   
impmna12= sum(convert(decimal(15,3),igv*ticadi12)), impmex12=sum(convert(decimal(15,3),igv)), ticadi12=0.00,  
descan04='', tipaut12='', sistem12='D', flagdh12 = 'H', flglei12='N', fecven12=''   
into #tmp010013  
from #tmp010011 a,  
crconcep01 b  
where (b.codcon14='IGV' and b.tipapp01='D')  
group by b.codsbd03, a.codana02, b.codcue01   
if @@error <> 0 goto E_Select_Error  
  
begin transaction  
   
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)    
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010011    
if @@error <> 0 goto E_General_Error  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12, codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010012  if @@error <> 0 goto E_General_Error  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010013   
if @@error <> 0 goto E_General_Error  
  
update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010012)   
if @@error <> 0 GOTO E_General_Error  
  
commit transaction  
return 0  
  
E_General_Error:  
raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror  
rollback transaction  
return 2   
  
E_Select_Error:  
raiserror('No se pudo crear la tabla temporal',1,2) with seterror  
return 2  

GO
/****** Object:  StoredProcedure [dbo].[sp_provision2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.sp_provision2    Script Date: 08-09-2002 08:44:07 PM ******/  
ALTER PROCEDURE [dbo].[sp_provision2]  
  @fec_i varchar(8),  
  @fec_f varchar(8)  
  
as  
  
/********* Para provisiones *********/    
  
/****** Para la cuenta 70 *****/  
/*substring(convert(char(12),getdate(),114),1,2) + substring(convert(char(12),getdate(),114),4,2) + substring(convert(char(12),getdate(),114),7,2) + substring(convert(char(12),getdate(),114),10,3)*/  
  
select codsbd03=c.codsbd03, coddoc07=d.coddoc07, codmon30='D', fecmov12= a.feccom52,   
codcue01=c.codcue01, serdoc12=substring(a.numcom52,1,3), numdoc12=substring(a.numcom52,4,8),  
codcco06='', codcco07='', desmov12=b.descon53, nrocan04=a.docdes52, codana02='01',   
impmna12= convert(decimal(15,2),(b.valcon53*a.tipcam52)), impmex12=convert(decimal(15,2),b.valcon53), ticadi12= convert(decimal(15,5),a.tipcam52), IGV=convert(decimal(15,2),b.valcon53*0.18),   
descan04=case when e.nomcli02=null then '' else e.nomcli02 end, tipaut12 = case when d.flgigv50 = '1' then 'GS1' else 'EXO' end,   
sistem12='D', flagdh12 = 'H', flglei12='N', fecven12=''   
into #tmp010011   
from ddcabcom52 a (nolock)  
	inner join dddetcom53 b (nolock) on (a.codcom50=b.codcom50 and a.numcom52=b.numcom52) 
	inner join dqconcom51 c (nolock) on (b.codcon51=c.codcon51)  
	inner join dqcompag50 d (nolock) on (a.codcom50=d.codcom50) 
	left  join dqclient02 e (nolock) on (a.codcli02=e.codcli02)  
where   
(a.flgemi52='1' and a.flgval52 = '1')  
and (a.flglei52='N')  
and (a.feccom52 >= @fec_i  
and a.feccom52 < @fec_f)   
group by c.codsbd03, d.coddoc07, a.feccom52, c.codcue01, a.numcom52, b.descon53, a.docdes52,  
b.valcon53, a.tipcam52, e.nomcli02, d.flgigv50    
if @@error <> 0 goto E_Select_Error  
  
/****** para la cuenta 12 ******/  
  
select codsbd03=b.codsbd03, coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12,  
a.numdoc12, codcco06='', codcco07='', desmov12=a.descan04, a.nrocan04, a.codana02,  
impmna12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),((a.impmex12+a.igv)*a.ticadi12))) else 0.00 end,   
impmex12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),(a.impmex12+a.igv))) else 0 end,   a.ticadi12, a.descan04, tipaut12='', a.sistem12, flagdh12='D', a.flglei12, fecven12=''  
into #tmp010012   
from #tmp010011 a,   
dqconcom51 b  
where a.codmon30=b.codcon51  
group by b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.nrocan04, a.codana02, a.ticadi12, b.codcue01,  
a.serdoc12, a.numdoc12, a.descan04, a.sistem12, a.flagdh12, a.flglei12  
if @@error <> 0 goto E_Select_Error   
  
/****** para la cuenta 40 ******/  
  
select codsbd03=b.codsbd03, coddoc07='', codmon30='D', fecmov12='',   
codcue01=b.codcue01, serdoc12='', numdoc12='',  
codcco06='', codcco07='', desmov12='IGV', nrocan04='', codana02='',   
impmna12= sum(convert(decimal(15,2),(a.igv*a.ticadi12))), impmex12=sum(convert(decimal(15,2),a.igv)), ticadi12=0.00,  
descan04='', tipaut12='', sistem12='D', flagdh12 = 'H', flglei12='N', fecven12=''   
into #tmp010013  
from #tmp010011 a,  
dqconcom51 b  
where b.codcon51='IGV'  
group by b.codsbd03, a.codana02, b.codcue01   
if @@error <> 0 goto E_Select_Error  
  
begin transaction  
   
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)    
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010011    
if @@error <> 0 goto E_General_Error  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12, codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010012  if @@error <> 0 goto E_General_Error  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010013   
if @@error <> 0 goto E_General_Error  
  
update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010012)   
if @@error <> 0 GOTO E_General_Error  
  
commit transaction  
return 0  
  
E_General_Error:  
raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror  
rollback transaction  
return 2   
  
E_Select_Error:  
raiserror('No se pudo crear la tabla temporal',1,2) with seterror  
return 2
GO
/****** Object:  StoredProcedure [dbo].[sp_provision3]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_provision3]  
  @fec_i varchar(8),  
  @fec_f varchar(8)  
as  
  
 
  
select codsbd03=c.codsbd03, coddoc07=d.coddoc07, codmon30='D', fecmov12= a.feccom52,   
codcue01=c.codcue01, serdoc12=substring(a.numcom52,1,3), numdoc12=substring(a.numcom52,4,8),  
codcco06='', codcco07='', desmov12=b.descon53, nrocan04=a.docdes52, codana02='01',   
impmna12= convert(decimal(15,2),(b.valcon53*a.tipcam52)), impmex12=b.valcon53, ticadi12= a.tipcam52, IGV=convert(decimal(15,2),(b.valcon53*0.18)),   
descan04=case when e.nomcli02=null then '' else e.nomcli02 end, tipaut12 = case when d.flgigv50 = '1' then 'GS1' else 'EXO' end,   
sistem12='D', flagdh12 = 'H', flglei12='N', fecven12=''   
into #tmp010011   
from ddcabcom52 a (nolock)  
	inner join dddetcom53 b (nolock) on (a.codcom50=b.codcom50 and a.numcom52=b.numcom52)  
	inner join dqconcom51 c (nolock) on (b.codcon51=c.codcon51)  
	inner join dqcompag50 d (nolock) on (a.codcom50=d.codcom50) 
	left  join dqclient02 e (nolock) on (a.codcli02=e.codcli02) 
where 
(a.flgemi52='1' and a.flgval52 = '1')  
and (a.flglei52='N')  
and (a.feccom52 >= @fec_i  
and a.feccom52 < @fec_f)   
group by c.codsbd03, d.coddoc07, a.feccom52, c.codcue01, a.numcom52, b.descon53, a.docdes52,  
b.valcon53, a.tipcam52, e.nomcli02, d.flgigv50    
if @@error <> 0 goto E_Select_Error  
  

select codsbd03=b.codsbd03, coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12,  
a.numdoc12, codcco06='', codcco07='', desmov12=a.descan04, a.nrocan04, a.codana02,  
impmna12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),((a.impmex12+a.igv)*a.ticadi12))) else 0.00 end,   
impmex12= case when a.codmon30 = 'D' then sum(a.impmex12+a.igv) else 0 end,   a.ticadi12, a.descan04, tipaut12='', a.sistem12, flagdh12='D', a.flglei12, fecven12=''  
into #tmp010012   
from #tmp010011 a,   
dqconcom51 b  
where a.codmon30=b.codcon51  
group by b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.nrocan04, a.codana02, a.ticadi12, b.codcue01,  
a.serdoc12, a.numdoc12, a.descan04, a.sistem12, a.flagdh12, a.flglei12  
if @@error <> 0 goto E_Select_Error  
  
 
  
select codsbd03=b.codsbd03, coddoc07='', codmon30='D', fecmov12='',   
codcue01=b.codcue01, serdoc12='', numdoc12='',  
codcco06='', codcco07='', desmov12='IGV', nrocan04='', codana02='',   
impmna12= sum(convert(decimal(15,2),(a.igv*a.ticadi12))), impmex12=sum(a.igv), ticadi12=0.00,  
descan04='', tipaut12='', sistem12='D', flagdh12 = 'H', flglei12='N', fecven12=''   
into #tmp010013  
from #tmp010011 a,  
dqconcom51 b  
where b.codcon51='IGV'  
group by b.codsbd03, a.codana02, b.codcue01   
if @@error <> 0 goto E_Select_Error  
  
  

  
select codsbd03=c.codsbd03, coddoc07=d.coddoc07, codmon30='D', fecmov12= a.feccom52,   
codcue01=c.codcue01, serdoc12='', numdoc12=a.numcom52,  
codcco06='', codcco07='', desmov12=b.descon53, nrocan04=a.docdes52, codana02='01',   
impmna12= convert(decimal(15,2),(b.valcon53*a.tipcam52)), impmex12=convert(decimal(15,2),b.valcon53), ticadi12= convert(decimal(15,5),a.tipcam52), IGV=convert(decimal(15,2),b.valcon53*0.18),   
descan04=case when e.nomcli02=null then '' else e.nomcli02 end, tipaut12 = case when d.flgigv50 = '1' then 'GS1' else 'EXO' end,   
sistem12='D', flagdh12 = 'H', flglei12='N', fecven12=''   
into #tmp010014  
from 
ddcabcom52 a (nolock)  
inner join dddetcom53 b (nolock) on (a.codcom50=b.codcom50 and a.numcom52=b.numcom52)  
inner join dqcompag50 d (nolock) on (a.codcom50=d.codcom50) 
left  join dqconcom51 c (nolock) on ('NOTAS'=c.codcon51) 
left  join dqclient02 e (nolock) on (a.codcli02=e.codcli02)  
where (a.flgemi52='1' and a.flgval52 = '1')  
and (a.codcom50='NC')  
and (a.flglei52='N')  
and (a.feccom52 >= @fec_i  
and a.feccom52 < @fec_f)  
group by c.codsbd03, d.coddoc07, a.feccom52, c.codcue01, a.numcom52, b.descon53, a.docdes52,  
b.valcon53, a.tipcam52, e.nomcli02, d.flgigv50    
if @@error <> 0 goto E_Select_Error  
  
  

  
select codsbd03=b.codsbd03, coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12,  
a.numdoc12, codcco06='', codcco07='', desmov12=a.descan04, a.nrocan04, a.codana02,   
impmna12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),((a.impmex12+a.igv)*a.ticadi12))) else 0.00 end,   
impmex12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),(a.impmex12+a.igv))) else 0 end,   
a.ticadi12, a.descan04, tipaut12='', a.sistem12, flagdh12='D', a.flglei12, fecven12=''  
into #tmp010015  
from #tmp010014 a,  
dqconcom51 b  
where 'NOTAS'=b.codcon51  
group by b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.nrocan04, a.codana02, a.ticadi12, b.codcue01,  
a.serdoc12, a.numdoc12, a.descan04, a.sistem12, a.flagdh12, a.flglei12  
if @@error <> 0 goto E_Select_Error  
  

  
select codsbd03=b.codsbd03, coddoc07='', codmon30='D', fecmov12='',  
codcue01=b.codcue01, serdoc12='', numdoc12='',  
codcco06='', codcco07='', desmov12='IGV', nrocan04='', codana02='',  
impmna12= sum(convert(decimal(15,2),(a.igv*a.ticadi12))), impmex12=sum(convert(decimal(15,2),a.igv)), ticadi12=0.00,  
descan04='', tipaut12='', sistem12='D', flagdh12 = 'H', flglei12='N', fecven12=''   
into #tmp010016  
from #tmp010014 a,  
dqconcom51 b  
where b.codcon51='IGV'  
group by b.codsbd03, a.codana02, b.codcue01  
if @@error <> 0 goto E_Select_Error  
  

  
select codsbd03='500', coddoc07=d.coddoc07, codmon30='S', fecmov12= a.feccom52,   
codcue01='70760300', serdoc12=substring(a.numcom52,1,3), numdoc12=substring(a.numcom52,4,8),  
codcco06='', codcco07='', desmov12='ANULADO', nrocan04='', codana02='',   
impmna12= 0.00, impmex12=0.00, ticadi12= 0.00, IGV=0.00,   
descan04='ANULADO', tipaut12 = 'GS1',   
sistem12='D', flagdh12 = 'D', flglei12='N', fecven12=getdate()   
into #tmp010019   
from ddcabcom52 a (nolock)  
	inner join dddetcom53 b (nolock) on (a.codcom50=b.codcom50 and a.numcom52=b.numcom52)
	inner join dqconcom51 c (nolock) on (b.codcon51=c.codcon51)  
	inner join dqcompag50 d (nolock) on (a.codcom50=d.codcom50)  
	left  join dqclient02 e (nolock) on (a.codcli02=e.codcli02) 
where (a.flgemi52='1' and a.flgval52 = '0')  
and (a.flglei52='N')  
and (a.feccom52 >= @fec_i  
and a.feccom52 < @fec_f)   
group by d.coddoc07, a.feccom52, a.numcom52   
if @@error <> 0 goto E_Select_Error  
  
begin transaction  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)    
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010011    
if @@error <> 0 goto E_General_Error  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12, codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010012  if @@error <> 0 goto E_General_Error  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010013   
if @@error <> 0 goto E_General_Error  

INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010014  
if @@error <> 0 goto E_General_Error  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12, codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010015  
if @@error <> 0 goto E_General_Error  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010016  
if @@error <> 0 goto E_General_Error  
  
INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010019  
if @@error <> 0 goto E_General_Error  
  
  
update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010019)   
if @@error <> 0 GOTO E_General_Error  
  
update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010012)   
if @@error <> 0 GOTO E_General_Error  
  
update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010015)   
if @@error <> 0 GOTO E_General_Error  
  
  
commit transaction   
  

  
select codsbd03, D=case when flagdh12='D' then sum(impmna12) else 0.00 end,   
H=case when flagdh12='H' then sum(impmna12) else 0.00 end   
into #tmp010017  
from cdmovimi15   
GROUP BY codsbd03, FLAGDH12  
  
select a.codsbd03, codmon30='S', fecmov12=getdate(),   
codcue01='', desmov12='', impmna12=(sum(a.d)-sum(a.h)), sistem12='D',   
flagdh12= case when (sum(a.d)-sum(a.h)) > 0.00 then 'H' else 'D' end, flglei12='N', fecven12=getdate(),   
concepto=case when (sum(a.d)-sum(a.h)) > 0.00 then 'GANRE' else 'PERRE' end  
into #tmp010018  
from #tmp010017 a  
group by a.codsbd03  
  
INSERT INTO CDMOVIMI15(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12)   
select codsbd03=a.codsbd03, coddoc07='', a.codmon30, a.fecmov12, codcue01=b.codcue01, serdoc12='', numdoc12='', codcco06='', codcco07='', a.desmov12, nrocan04='', codana02='',  
impmna12=abs(a.impmna12), impmex12=0.00, ticadi12=0.00, descan04='', tipaut12='', a.sistem12, a.flagdh12, a.flglei12, a.fecven12  
from #tmp010018 a, dqconcom51 b  
where b.codcon51=a.concepto and a.impmna12 <> 0.00  
  
return 0  
E_General_Error:  
raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror  
rollback transaction  
return 2  
E_Select_Error:  
raiserror('No se pudo crear la tabla temporal',1,2) with seterror  
return 2
GO
/****** Object:  StoredProcedure [dbo].[SP_RANKING_CIF]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RANKING_CIF    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[SP_RANKING_CIF]

 AS

Select 
c.nombre,total=sum(a.valcif11),desde='20020101',hasta='20020821',fecha=getdate(),
reporte="facturacion.rpt"
From ddduidep11 a, ddsoladu10 b,aaclientesaa c
Where 
convert(char(8),a.fecdui11,112) between '20020101' and '20020821' and b.flgval10='1' and 
a.numsol10=b.numsol10 and b.tipcli02=c.claseabc and b.codcli02=c.contribuy
Group by c.nombre
order by 2 desc
GO
/****** Object:  StoredProcedure [dbo].[SP_RECEPCION_ADUANERA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RECEPCION_ADUANERA    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_RECEPCION_ADUANERA]
@NUMSOL CHAR(7)
AS

Select 
a.numrec10,a.fecsol10,a.tipcli02,a.codcli02,a.codage19,nombrea=d.nombre,fecing01=Min(b.fecing01),
fecsal01=Max(b.fecsal01),pesbru01=SUM(b.pesnet01),pesnet01=SUM(b.pesnet01-b.tarcon01),a.flgcer10,
a.flgdui10,nombrec=e.nombre
From 
DDSolAdu10 a,DDTicket01 b,AAClientesAA d,AAClientesAA e
Where
a.numsol10=b.docaut01 and a.codage19=d.cliente and a.numsol10=@NUMSOL and b.tipope01='D' and 
b.tipest01='S' and b.numgui01=null and
a.tipcli02=e.claseabc and a.codcli02=e.contribuy
Group by 
a.numrec10,a.fecsol10,a.tipcli02,a.codcli02,a.codage19,d.nombre,a.flgcer10,a.flgdui10,e.nombre
GO
/****** Object:  StoredProcedure [dbo].[SP_RECEPCION_ADUANERA_CON]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RECEPCION_ADUANERA_CON    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_RECEPCION_ADUANERA_CON]
@NUMREC CHAR(7)
AS

Select 
a.fecrec69,a.numsol62,numsol10=a.numsol62,b.fecsol10,b.codage19,d.nombre,b.tipcli02,b.codcli02,a.codubi71,
e.desubi71,a.codemb06,a.PriIng69,a.fining69,a.pesbru69,a.pesnet69,a.guirem69,a.obsrec69,
a.flgval69,a.flgemi69,NombreC=f.nombre
From 
DDRecMer69 a,DDSolAdu10 b,AAClientesAA d,DQTipUbi71 e,AAClientesAA f
Where 
a.numsol62=b.numsol10 and b.codage19=d.cliente and a.codubi71=e.codubi71 and 
b.tipcli02=f.claseabc and b.codcli02=f.contribuy and 
NumRec69=@NUMREC
GO
/****** Object:  StoredProcedure [dbo].[SP_RECEPCION_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_RECEPCION_SIMPLE    Script Date: 08-09-2002 08:44:10 PM ******/    
ALTER PROCEDURE [dbo].[SP_RECEPCION_SIMPLE]    
@NUMSOL CHAR(7)    
AS    
Select     
a.numrec62,a.fecsol62,a.tipcli02,a.codage19,nombrea=d.nombre,
a.codcli02,fecing01=Min(b.fecing01),    
fecsal01=Max(b.fecsal01),pesbru01=SUM(b.pesnet01),pesnet01=SUM(b.pesnet01-b.tarcon01),a.flgcer62,    
nombrec=e.nombre    
From     
ddsolsim62 a  
inner join ddticket01 b on (a.numsol62=b.docaut01)  
inner join AAClientesAA e on (a.tipcli02=e.claseabc and a.codcli02=e.contribuy)   
left  join AAClientesAA d on (a.codage19=d.cliente)  
Where     
a.numsol62= @NUMSOL 
and b.tipope01='D' and b.tipest01='S' and b.numgui01 is null         
Group by     
a.numrec62,a.fecsol62,a.tipcli02,a.codcli02,a.codage19,d.nombre,a.flgcer62,e.nombre  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_RECEPCION_SIMPLE_CON]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_RECEPCION_SIMPLE_CON]  
@NUMREC CHAR(7)  
AS  
  
Select   
a.fecrec69,a.numsol62,numsol10=a.numsol62,b.fecsol62,b.codage19,d.nombre,b.tipcli02,b.codcli02,a.codubi71,e.desubi71,  
a.codemb06,a.PriIng69,a.fining69,a.pesbru69,a.pesnet69,a.guirem69,a.obsrec69,a.flgval69,  
a.flgemi69,NombreC=f.nombre  
From   
DDRecMer69 a
inner join DDSolSim62 b on (a.numsol62=b.numsol62)
inner join DQTipUbi71 e on (a.codubi71=e.codubi71)
inner join AAClientesAA f  on (b.tipcli02=f.claseabc and b.codcli02=f.contribuy)
left  join AAClientesAA d on (b.codage19=d.cliente)
Where   
NumRec69=@NUMREC
  
GO
/****** Object:  StoredProcedure [dbo].[sp_RegVen]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_RegVen    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[sp_RegVen]
@FECINI CHAR(8),
@FECFIN CHAR(8),
@SERIE CHAR(3),
@DOCUM CHAR(2)
AS

Delete from CDREGVEN23 where userid=user_name() and hostid=host_name()
Delete from CDREGVEN24 where userid=user_name() and hostid=host_name()

/* Lleno primera tabla temporal a.razage19 DESCAN04,*/
INSERT INTO DESCARGA..CDREGVEN23 
(FECMOV12,CODDOC07,SERDOC12,NUMDOC12,DESCAN04,NROCAN04,IMPMNA12,TICADI12,TOTDOL,
IMPINA,IMPAFE,IMPIGV,TOTGEN,USERID,HOSTID)
SELECT convert(char(8),c.feccom52,112) FECMOV12,c.codcom50 CODDOC07,substring(c.numcom52,1,3) SERDOC12,
substring(c.numcom52,4,7) NUMDOC12,
'DESCAN04'= CASE WHEN c.flgval52='0' then
		'A  N  U  L  A  D  O'
	    ELSE
        	c.nomdes52
	    END,
'NROCAN04'=CASE WHEN c.flgval52='0' then
		''
	    else
		c.docdes52
	    END,
(c.monpag52*f.camleg28) IMPMNA12,
'TICADI12'= CASE WHEN c.flgval52='0' then
		0
	    ELSE
		f.camleg28
	    END,
'TOTDOL'= CASE WHEN c.flgval52='1' THEN
	  	(c.subtot52+c.igvtot52)
	  ELSE
		0
	  END,
'IMPINA'= 0,
'IMPAFE'= CASE WHEN c.flgval52='0' THEN
		0
	  ELSE
		convert(decimal(20,2),c.subtot52*f.camleg28)

	  END,
'IMPIGV'= CASE WHEN c.flgval52='1' THEN
		convert(decimal(20,2),c.igvtot52*f.camleg28)
	  ELSE
		0
	  END,
'TOTGEN'= CASE WHEN c.flgval52='1' THEN
		convert(decimal(20,2),c.igvtot52*f.camleg28)+convert(decimal(20,2),c.subtot52*f.camleg28)
	  ELSE
		0
	  END,
user_name() USERID,host_name() HOSTID

From DDCABCOM52 c (NOLOCK),Descarga..dqtipcam28 f (NOLOCK)
Where 
(convert(char(8),c.feccom52,112)>=@FECINI and convert(char(8),c.feccom52,112)<=@FECFIN ) and 
convert(char(8),c.feccom52,112)=f.fecfor28 and 
substring(c.numcom52,1,3)=@SERIE and c.codcom50=@DOCUM

Order by c.codcom50,c.numcom52



INSERT INTO DESCARGA..CDREGVEN24 
(CODDOC07,SERDOC12,NUMDOC12,DESCAN04,FECMOV12,NROCAN04,TICADI12,IMPMNA12,TOTDOL,
IMPAFE,IMPINA,IMPIGV,TOTGEN,USERID,HOSTID)
SELECT CODDOC07,SERDOC12,NUMDOC12,DESCAN04,convert(char(8),FECMOV12,112),NROCAN04,TICADI12,
SUM(IMPMNA12) AS TOTALSOLES, SUM(TOTDOL) AS TOTALDOLARES,SUM(IMPAFE) AS MAFECTO, 
SUM(IMPINA) AS MINAFECTO, SUM(IMPIGV) AS MONTOIGV,TOTGEN,user_name(),host_name()
FROM DESCARGA..CDREGVEN23 (NOLOCK)
WHERE USERID=user_name() and HOSTID=host_name()
GROUP BY CODDOC07,SERDOC12,NUMDOC12,DESCAN04,convert(char(8),FECMOV12,112),NROCAN04,TICADI12,TOTGEN
ORDER BY CODDOC07,SERDOC12,NUMDOC12
GO
/****** Object:  StoredProcedure [dbo].[SP_REINDEXAR_TABLA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_REINDEXAR_TABLA]
@TABLA VARCHAR(30)
AS
declare
@QUERY VARCHAR(50)

Select @QUERY='dbcc dbreindex (' + @TABLA + ','',85)'
PRINT "TABLA " + @TABLA + " REINDEXADA"
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_DE_MOVIMIENTO_DE_CONTENEDORES]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_REPORTE_DE_MOVIMIENTO_DE_CONTENEDORES]
@FECINI char(8),
@FECFIN char(8)
 AS

Select a.numsol62,b.codnav08,d.desnav08,b.numvia62,c.fecing01,a.numctr65,a.tamctr65,a.numtkt01,FECHA=getdate(),Importador=e.nombre,
SUBTITULO='DESDE : '+right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'  HASTA  : '+right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4)
From DDCtrDep65 a
Inner Join ddsolsim62 b on a.numsol62=b.numsol62
Inner Join ddticket01 c on a.numtkt01=c.numtkt01 
Inner Join terminal..dqnavier08 d on b.codnav08=d.codnav08
Inner Join AAclientesAA e on e.contribuy=b.codcli02
Where c.fecing01 between @FECINI and @FECFIN and c.tipope01='D'
Union 
Select a.numsol62,b.codnav08,d.desnav08,b.numvia62,b.fecsol62,a.numctr65,a.tamctr65,a.numtkt01,FECHA=getdate(),Importador=e.nombre,
SUBTITULO='DESDE : '+right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'  HASTA  : '+right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4)
From DDCtrDep65 a
Inner Join ddsolsim62 b on a.numsol62=b.numsol62
Inner Join terminal..dqnavier08 d on b.codnav08=d.codnav08
Inner Join AAclientesAA e on e.contribuy=b.codcli02
Where b.fecsol62 between @FECINI and @FECFIN and a.numtkt01 is null
UNION ALL
Select a.numsol62,b.codnav08,d.desnav08,b.numvia10,c.fecing01,a.numctr65,a.tamctr65,a.numtkt01,FECHA=getdate(),Importador=e.nombre,
SUBTITULO='DESDE : '+right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'  HASTA  : '+right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4)
From DDCtrDep65 a
Inner Join DDSolAdu10 b on a.numsol62=b.numsol10
Inner Join terminal..dqnavier08 d on b.codnav08=d.codnav08
left Join ddticket01 c on a.numtkt01=c.numtkt01
Inner Join AAclientesAA e on e.contribuy=b.codcli02
Where c.fecing01 between @FECINI and @FECFIN and c.tipope01='D'
Union
Select a.numsol62,b.codnav08,d.desnav08,b.numvia10,b.fecsol10,a.numctr65,a.tamctr65,a.numtkt01,FECHA=getdate(),Importador=e.nombre,
SUBTITULO='DESDE : '+right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'  HASTA  : '+right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4)
From DDCtrDep65 a
Inner Join DDSolAdu10 b on a.numsol62=b.numsol10
Inner Join terminal..dqnavier08 d on b.codnav08=d.codnav08
Inner Join AAclientesAA e on e.contribuy=b.codcli02
Where b.fecsol10 between @FECINI and @FECFIN and a.numtkt01 is null
Order by c.fecing01,numctr65
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_INGRESO_ADUANERO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORTE_INGRESO_ADUANERO]  
@FECINI CHAR(8),  
@FECFIN CHAR(8)  
AS  
DECLARE @TOTALS decimal(15,3)  
DECLARE @TOTALD decimal(15,3) 

	--CALCULAR LOS TOTALES SEGUN DUAS DE DEPOSITO  
	--===============================================  
	Select @TOTALD=sum(c.valcif11),@TOTALS=Sum(c.valcif11*c.tipcam11)  
	From DDSolAdu10 a, DDRecMer69 b, DDduidep11 c, AAClientesAA d  
	Where convert(char(8),b.priing69,112) between @FECINI and @FECFIN and a.numsol10=b.numsol62 and a.numsol10=c.numsol10 and a.tipcli02=d.claseabc and a.codcli02=d.contribuy and   
	b.flgval69='1' and b.flgemi69='1'  
	  
	Select c.numdui11,c.fecdui11,c.tippla11,c.numpla11,c.codter09,c.valcif11,c.tipcam11,b.numrec69,b.priing69,b.bultot69,b.codemb06,b.pesnet69,d.nombre,a.desmer10,a.codage19,  
	e.numser12,e.numbul12,e.codemb06,CIFSER=(e.valfob12+e.valfle12+e.valseg12),e.parara12, TOTALD=@TOTALD,TOTALS=@TOTALS,c.abaleg11,c.fterrec11  
	,e.unidad12
	,totalUC = (select SUM(cc.unidad12) from DDserdep12 cc where cc.numdui11 = e.numdui11)
	From DDSolAdu10 a  
	Inner Join DDRecMer69 b on b.numsol62=a.numsol10  
	Inner Join DDduidep11 c on c.numsol10=a.numsol10   
	Inner Join AAClientesAA d on d.claseabc=a.tipcli02 and d.contribuy=a.codcli02  
	Inner Join DDserdep12 e on e.numdui11=c.numdui11  
	Where convert(char(8),b.priing69,112) between @FECINI and @FECFIN and b.flgval69='1' and b.flgemi69='1'   
	Order by b.numrec69

GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_INGRESO_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_REPORTE_INGRESO_SIMPLE]
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS


Select 
a.numcer74,a.tipcli02,a.codcli02,d.nombre,c.codter as numrec69,b.priing69,b.bultot69,b.codemb06,
b.pesnet69,b.pretot69,c.desmer62
From
DDCerSim74 a,DDRecMer69 b,DDSolSim62 c,AAClientesAA d
Where 
convert(char(8),b.priing69,112)>=@FECINI and convert(char(8),b.priing69,112)<=@FECFIN and
a.numsol62=b.numsol62 and b.numsol62=c.numsol62 and 
a.tipcli02=d.claseabc and a.codcli02=d.contribuy and 
b.flgval69='1' and b.flgemi69='1' and a.flgval74='1' and c.flgval62='1'


GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_MOV_GEN_ADU_T1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_REPORTE_MOV_GEN_ADU_T1    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_REPORTE_MOV_GEN_ADU_T1]
@NUMCER CHAR(9),
@FECFIN CHAR(8)
AS

Select 
a.numdui11,a.numcer13,a.numdui16,a.numret75,a.nument79,a.fecent79,c.fecsal01,a.bultot79,
a.codemb06,a.pesbru79,b.tipcli02,b.codcli02,d.nombre,a.pretot79,a.cuadep79,b.codage19
From 
DDEntMer79 a,DDDuiDes16 b,DDTicket01 c,AAClientesAA d 
Where 
a.numdui16=b.numdui16 and a.nument79=c.numgui01 and c.tipope01='R' and 
b.tipcli02=d.claseabc and b.CODCLI02=d.contribuy and 
a.numcer13=@NUMCER and 
convert(char(8),c.fecsal01,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_MOV_GEN_ADU_T2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_REPORTE_MOV_GEN_ADU_T2    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_REPORTE_MOV_GEN_ADU_T2]
@NUMCER CHAR(9),
@FECFIN CHAR(8)
AS

Select 
a.numdui11,a.numcer13,a.numdui16,a.numret75,a.nument79,a.fecent79,c.fecsal01,a.bultot79,
a.codemb06,a.pesbru79,b.tipcli02,b.codcli02,d.nombre,a.pretot79,a.cuadep79,b.codage19
From 
DDEntMer79 a,DDDuiDes16 b,DDTicket01 c,AAClientesAA d 
Where 
a.numdui16=b.numdui16 and a.nument79=c.numgui01 and c.tipope01='R' and 
b.tipcli02=d.claseabc and b.CODCLI02=d.contribuy and 
a.numcer13=@NUMCER and 
convert(char(8),c.fecsal01,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_SALIDAS_ADUANERO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SP_REPORTE_SALIDAS_ADUANERO    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_REPORTE_SALIDAS_ADUANERO]
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS
Declare @TOTGEN as decimal(15,3)
Declare @TOTGENS as decimal(15,3)
--OBTENGO LOS TOTALES SEGUN LAS CABECERAS DE LAS ENTREGAS DE MERCADERIAS
--=============================================================================

Select @TOTGEN=SUM(a.pretot79+a.cuadep79),@TOTGENS=SUM((a.pretot79+a.cuadep79)*e.tipcam11)
From DDEntMer79 a
Inner Join DDDuiDes16 c on a.numdui16=c.numdui16
Inner Join DDTicket01 d on d.numgui01=a.nument79
Inner Join DDDuiDep11 e on e.numdui11=a.numdui11
Inner Join DDSolAdu10 h on h.numsol10=e.numsol10
Inner Join DDRecMer69 i on i.numsol62=h.numsol10
Where 
convert(char(8),d.fecsal01,112) between @FECINI and @FECFIN and d.tipope01='R' and a.flgval79='1' and h.flgval10='1' and i.flgval69='1'
--=============================================================================


Select numcer13=substring(a.numcer13,2,6)+'-'+right(a.numcer13,2),
numdui11=left(a.numdui11,3)+'-'+substring(a.numdui11,4,2)+'-'+substring(a.numdui11,6,2)+'-'+right(a.numdui11,6),
numdui16=left(a.numdui16,3)+'-'+substring(a.numdui16,4,2)+'-'+substring(a.numdui16,6,2)+'-'+substring(a.numdui16,8,6)+'-'+right(a.numdui16,1),
c.fecdui16,c.valcif16,numret75=right(a.numret75,6),nument79=right(a.nument79,6),a.fecent79,d.fecsal01,
a.bultot79,a.codemb06,a.pesbru79,tipdes=c.tipcli02,coddes=c.codcli02,nomdes=left(g.nombre,25),
tipdep=h.tipcli02,coddep=h.codcli02,nomdep=left(f.nombre,28),a.pretot79,a.cuadep79,c.parara16,
c.totser16,c.codage19,agente=k.nombre,e.tipcam11,h.desmer10,i.codubi71,
j.numser70,j.numbul80,j.preent80,
Partida=(Select parara12 from DDSerDep12 where numdui11=a.numdui11 and numser12=j.numser70),
TipBul=(Select codemb06 from DDSerDep12 where numdui11=a.numdui11 and numser12=j.numser70),
TITULO='SALIDA DE MERCADERIA - ADUANA MARITIMA + ADUANA AEREA' ,
ANIO='DESDE : ' +right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'     HASTA : ' +right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4),
FECHA=getdate(),REPORTE="SalAdu.rpt",TOTGEN=@TOTGEN,TOTGENS=@TOTGENS
From DDEntMer79 a
Inner Join DDDuiDes16 c on a.numdui16=c.numdui16
Inner Join DDTicket01 d on d.numgui01=a.nument79
Inner Join DDDuiDep11 e on e.numdui11=a.numdui11
Inner Join DDSolAdu10 h on h.numsol10=e.numsol10
Inner Join AAClientesAA f on f.claseabc=h.tipcli02 and f.contribuy=h.codcli02
Inner Join AAClientesAA g on g.claseabc=c.tipcli02 and g.contribuy=c.codcli02
Inner Join DDRecMer69 i on i.numsol62=h.numsol10
Inner Join dddenmer80 j on j.nument79=a.nument79
Inner Join AAClientesAA k on k.cliente=c.codage19
Where 
convert(char(8),d.fecsal01,112) between @FECINI and @FECFIN and d.tipope01='R' and a.flgval79='1' and h.flgval10='1' and i.flgval69='1'
Order by numcer13,numret75,nument79
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_SALIDAS_ADUANERO_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_REPORTE_SALIDAS_ADUANERO    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_REPORTE_SALIDAS_ADUANERO_NEW] @FECINI CHAR(8)
	,@FECFIN CHAR(8)
AS
DECLARE @TOTGEN AS DECIMAL(15, 3)
DECLARE @TOTGENS AS DECIMAL(15, 3)

--OBTENGO LOS TOTALES SEGUN LAS CABECERAS DE LAS ENTREGAS DE MERCADERIAS    
--=============================================================================    
SELECT @TOTGEN = SUM(a.pretot79 + a.cuadep79)
	,@TOTGENS = SUM((a.pretot79 + a.cuadep79) * e.tipcam11)
FROM DDEntMer79 a
INNER JOIN DDDuiDes16 c ON a.numdui16 = c.numdui16
INNER JOIN DDTicket01 d ON d.numgui01 = a.nument79
INNER JOIN DDDuiDep11 e ON e.numdui11 = a.numdui11
INNER JOIN DDSolAdu10 h ON h.numsol10 = e.numsol10
INNER JOIN DDRecMer69 i ON i.numsol62 = h.numsol10
WHERE convert(CHAR(8), d.fecsal01, 112) BETWEEN @FECINI
		AND @FECFIN
	AND d.tipope01 = 'R'
	AND a.flgval79 = '1'
	AND h.flgval10 = '1'
	AND i.flgval69 = '1'

--=============================================================================    
SELECT numcer13 = substring(a.numcer13, 2, 6) + '-' + right(a.numcer13, 2)
	,numdui11 = left(a.numdui11, 3) + '-' + substring(a.numdui11, 4, 2) + '-' + substring(a.numdui11, 6, 2) + '-' + right(a.numdui11, 6)
	,numdui16 = left(a.numdui16, 3) + '-' + substring(a.numdui16, 4, 2) + '-' + substring(a.numdui16, 6, 2) + '-' + substring(a.numdui16, 8, 6) + '-' + right(a.numdui16, 1)
	,c.fecdui16
	,c.valcif16
	,numret75 = right(a.numret75, 6)
	,nument79 = right(a.nument79, 6)
	,a.fecent79
	,d.fecsal01
	,a.bultot79
	,a.codemb06
	,a.pesbru79
	,tipdes = c.tipcli02
	,coddes = c.codcli02
	,nomdes = left(g.nombre, 25)
	,tipdep = h.tipcli02
	,coddep = h.codcli02
	,nomdep = left(f.nombre, 28)
	,a.pretot79
	,a.cuadep79
	,c.parara16
	,c.totser16
	,c.codage19
	,agente = k.nombre
	,e.tipcam11
	,h.desmer10
	,i.codubi71
	,j.numser70
	,j.numbul80
	,j.preent80
	,Partida = (
		SELECT parara12
		FROM DDSerDep12
		WHERE numdui11 = a.numdui11
			AND numser12 = j.numser70
		)
	,TipBul = (
		SELECT codemb06
		FROM DDSerDep12
		WHERE numdui11 = a.numdui11
			AND numser12 = j.numser70
		)
	,TITULO = 'SALIDA DE MERCADERIA - ADUANA MARITIMA + ADUANA AEREA'
	,ANIO = 'DESDE : ' + right(@FECINI, 2) + '/' + substring(@FECINI, 5, 2) + '/' + left(@FECINI, 4) + '     HASTA : ' + right(@FECFIN, 2) + '/' + substring(@FECFIN, 5, 2) + '/' + left(@FECFIN, 4)
	,FECHA = getdate()
	,REPORTE = 'SalAdu.rpt'
	,TOTGEN = @TOTGEN
	,TOTGENS = @TOTGENS
	,numbul12 = ISNULL(j.numbul12, 0)
	,totalUC = ISNULL((
				SELECT SUM(zz.numbul12)
				FROM dddenmer80 zz
				WHERE zz.nument79 = a.nument79
				) , 0)
FROM DDEntMer79 a
INNER JOIN DDDuiDes16 c ON a.numdui16 = c.numdui16
INNER JOIN DDTicket01 d ON d.numgui01 = a.nument79
INNER JOIN DDDuiDep11 e ON e.numdui11 = a.numdui11
INNER JOIN DDSolAdu10 h ON h.numsol10 = e.numsol10
INNER JOIN AAClientesAA f ON f.claseabc = h.tipcli02
	AND f.contribuy = h.codcli02
INNER JOIN AAClientesAA g ON g.claseabc = c.tipcli02
	AND g.contribuy = c.codcli02
INNER JOIN DDRecMer69 i ON i.numsol62 = h.numsol10
INNER JOIN dddenmer80 j ON j.nument79 = a.nument79
INNER JOIN AAClientesAA k ON k.cliente = c.codage19
WHERE convert(CHAR(8), d.fecsal01, 112) BETWEEN @FECINI
		AND @FECFIN
	AND d.tipope01 = 'R'
	AND a.flgval79 = '1'
	AND h.flgval10 = '1'
	AND i.flgval69 = '1'
ORDER BY numcer13
	,numret75
	,nument79

GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_SALIDAS_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_REPORTE_SALIDAS_SIMPLE    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_REPORTE_SALIDAS_SIMPLE]
@FECINI CHAR(8),
@FECFIN CHAR(8)
AS

Select 
a.numcer13,c.numcer74,c.tipcli02,c.codcli02,f.nombre,a.numret75,a.nument79,a.fecent79,d.fecsal01,
a.bultot79,a.codemb06,e.desmer62,a.pesbru79,a.pretot79,d.codage19 
From 
DDEntMer79 a,DDRetSim75 b,DDCerSim74 c,DDTicket01 d,DDSolSim62 e,AAClientesAA f 
Where 
a.numret75=b.numret75 and b.numcer74=c.numcer74 and a.nument79=d.numgui01 and 
d.tipope01='R' and c.numsol62=e.numsol62 And c.CODCLI02=f.contribuy and 

convert(char(8),d.fecsal01,112)>=@FECINI and 
convert(char(8),d.fecsal01,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[SP_RESUMEN_CONCEPTOS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SP_RESUMEN_CONCEPTOS]
@CODCOM CHAR(2),
@NUMSER CHAR(3),
@FECINI CHAR(8),
@FECFIN CHAR(8),
@CONDIC CHAR(1),
@TIPCLI CHAR(1),
@CODCLI VARCHAR(11)
AS

if @CONDIC='0' 
	Select 
    	a.descon53,a.numcom52,c.docdes52,d.nombre,a.valcon53,
    	DOLARES=case when c.TIPMON52 = 'D' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53/e.camleg28)) end,
    	SOLES  =case when c.TIPMON52 = 'S' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53*e.camleg28)) end,c.numcer52 
    	From 
    	dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal..dqtipcam28 e
    	Where 
    	a.numcom52=c.numcom52 and c.flgval52='1' and c.flgemi52='1' and 
    	c.tipdes52=d.claseabc and c.docdes52=d.contribuy and 
    	convert(char(8),c.feccom52,112) between @FECINI and @FECFIN and 
    	substring(a.numcom52,1,3)=@NUMSER and a.CodCom50=@CODCOM and 
    	e.fecfor28=convert(char(8),c.feccom52,112) and c.facesp52='N'
Union
	Select 
    	a.descon53,a.numcom52,c.docdes52,d.nombre,a.valcon53,
    	DOLARES=case when c.TIPMON52 = 'D' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53/e.camleg28)) end,
    	SOLES  =case when c.TIPMON52 = 'S' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53*e.camleg28)) end,c.numcer52 
    	From 
    	dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal..dqtipcam28 e
    	Where 
    	a.numcom52=c.numcom52 and c.numcer52=a.numcer52 and c.flgval52='1' and c.flgemi52='1' and 
    	c.tipdes52=d.claseabc and c.docdes52=d.contribuy and 
    	convert(char(8),c.feccom52,112) between @FECINI and @FECFIN and 
    	substring(a.numcom52,1,3)=@NUMSER and a.CodCom50=@CODCOM and 
    	e.fecfor28=convert(char(8),c.feccom52,112) and c.facesp52='S'
	Order by a.descon53,d.nombre,a.numcom52
else
    Select 
    a.descon53,a.numcom52,c.docdes52,d.nombre,a.valcon53,
    DOLARES=case when c.TIPMON52 = 'D' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53/e.camleg28)) end,
    SOLES  =case when c.TIPMON52 = 'S' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53*e.camleg28)) end,c.numcer52 
    From 
    dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal..dqtipcam28 e
    Where 
    a.numcom52=c.numcom52 and c.flgval52='1' and c.flgemi52='1' and 
    c.tipdes52=d.claseabc and c.docdes52=d.contribuy and 
    convert(char(8),c.feccom52,112) between @FECINI and @FECFIN and 
    substring(a.numcom52,1,3)=@NUMSER and a.CodCom50=@CODCOM and 
    e.fecfor28=convert(char(8),c.feccom52,112) and c.tipdes52=@TIPCLI and c.docdes52=@CODCLI and c.facesp52='N'
Union
    Select 
    a.descon53,a.numcom52,c.docdes52,d.nombre,a.valcon53,
    DOLARES=case when c.TIPMON52 = 'D' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53/e.camleg28)) end,
    SOLES  =case when c.TIPMON52 = 'S' then convert(decimal(15,2),a.valcon53) else convert(decimal(15,2),(a.valcon53*e.camleg28)) end,c.numcer52 
    From 
    dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal..dqtipcam28 e
    Where 
    a.numcom52=c.numcom52 and c.numcer52=a.numcer52 and c.flgval52='1' and c.flgemi52='1' and 
    c.tipdes52=d.claseabc and c.docdes52=d.contribuy and 
    convert(char(8),c.feccom52,112) between @FECINI and @FECFIN and 
    substring(a.numcom52,1,3)=@NUMSER and a.CodCom50=@CODCOM and 
    e.fecfor28=convert(char(8),c.feccom52,112) and c.tipdes52=@TIPCLI and c.docdes52=@CODCLI and c.facesp52='S'
    Order by a.descon53,d.nombre,a.numcom52


GO
/****** Object:  StoredProcedure [dbo].[SP_RETIRO_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_RETIRO_SIMPLE]        
@NUMCER CHAR(7)        
AS        
        
Select         
a.numsol62,a.feccer74,a.tipcli02,a.codcli02,NombreC=b.nombre,a.codage19,NombreA=c.nombre,        
d.codubi71        
From         
DDCerSim74 a      
inner join AAClientesAA b on (a.tipcli02=b.claseabc and a.codcli02=b.contribuy)      
inner join DDrecmer69 d on (a.numsol62=d.numsol62)         
left  join AAClientesAA c on (a.codage19=c.cliente and a.codage19<>'')      
Where a.numcer74=@NUMCER and
a.flgval74='1' and d.flgval69 ='1' 
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDO_FISICO_POR_SERIE_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SALDO_FISICO_POR_SERIE_ADU]        
@NUMCER char(8),        
@TIPCLI char(1),        
@CODCLI VARCHAR(11)        
AS        
        
if @CODCLI<>''        
Select d.claseabc,d.contribuy,d.nombre,a.numdui11,a.numcer13,a.feccer13,b.numser12,b.numbul14,b.bulent14,sldbul=b.numbul14-b.bulent14,c.codemb06,b.desmer14        
From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d         
Where         
a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and a.numbul13-a.bulent13>=0 and b.numbul14-b.bulent14>0 and         
a.tipcli02=d.claseabc and a.codcli02=d.contribuy and a.tipcli02=@TIPCLI and a.codcli02=@CODCLI and flgval13 = 1      
order by a.numcer13, b.numser12     
        
if @NUMCER<>''        
Select d.claseabc,d.contribuy,d.nombre,a.numdui11,a.numcer13,a.feccer13,b.numser12,b.numbul14,b.bulent14,sldbul=b.numbul14-b.bulent14,c.codemb06,ltrim(rtrim(b.desmer14)) as  desmer14      
From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d         
Where         
a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and a.numbul13-a.bulent13>=0 and b.numbul14-b.bulent14>=0 and         
a.tipcli02=d.claseabc and a.codcli02=d.contribuy and a.numcer13='A'+@NUMCER and flgval13 = 1      
order by a.numcer13, b.numser12    
    
--Añadido por Eugenia Palao        
if @NUMCER='' and  @CODCLI=''       
Select d.claseabc,d.contribuy,d.nombre,a.numdui11,a.numcer13,a.feccer13,b.numser12,b.numbul14,b.bulent14,sldbul=b.numbul14-b.bulent14,c.codemb06,b.desmer14        
From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d         
Where         
a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and a.numbul13-a.bulent13>=0 and b.numbul14-b.bulent14>=0 and         
a.tipcli02=d.claseabc and a.codcli02=d.contribuy and flgval13 = 1--and a.numcer13='A'+@NUMCER        
order by a.numcer13, b.numser12    
    
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDO_FISICO_POR_SERIE_ADU_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC SP_SALDO_FISICO_POR_SERIE_ADU_NEW '00142000','',''
ALTER PROCEDURE [dbo].[SP_SALDO_FISICO_POR_SERIE_ADU_NEW] @NUMCER CHAR(8)
	,@TIPCLI CHAR(1)
	,@CODCLI VARCHAR(11)
AS
IF @CODCLI <> ''
	SELECT d.claseabc
		,d.contribuy
		,d.nombre
		,a.numdui11
		,a.numcer13
		,a.feccer13
		,b.numser12
		,b.numbul14
		,b.bulent14
		,sldbul = b.numbul14 - b.bulent14
		,c.codemb06
		,b.desmer14
		,unidad12 = b.unidad12
		,bulent12 = ISNULL(b.bulent12,0)
		,sldbulUC = (b.unidad12 - ISNULL(b.bulent12,0))
	FROM DDCERADU13 a
		,DDDCEADU14 b
		,DDSERDEP12 c
		,AAClientesAA d
	WHERE a.numcer13 = b.numcer13
		AND a.numsol10 = c.numsol10
		AND b.numser12 = c.numser12
		AND a.numbul13 - a.bulent13 >= 0
		AND b.numbul14 - b.bulent14 > 0
		AND a.tipcli02 = d.claseabc
		AND a.codcli02 = d.contribuy
		AND a.tipcli02 = @TIPCLI
		AND a.codcli02 = @CODCLI
		AND flgval13 = 1
	ORDER BY a.numcer13
		,b.numser12

IF @NUMCER <> ''
	SELECT d.claseabc
		,d.contribuy
		,d.nombre
		,a.numdui11
		,a.numcer13
		,a.feccer13
		,b.numser12
		,b.numbul14
		,b.bulent14
		,sldbul = b.numbul14 - b.bulent14
		,c.codemb06
		,ltrim(rtrim(b.desmer14)) AS desmer14
		,unidad12 = b.unidad12
		,bulent12 = ISNULL(b.bulent12,0)
		,sldbulUC = (b.unidad12 - ISNULL(b.bulent12,0))
	FROM DDCERADU13 a
		,DDDCEADU14 b
		,DDSERDEP12 c
		,AAClientesAA d
	WHERE a.numcer13 = b.numcer13
		AND a.numsol10 = c.numsol10
		AND b.numser12 = c.numser12
		AND a.numbul13 - a.bulent13 >= 0
		AND b.numbul14 - b.bulent14 >= 0
		AND a.tipcli02 = d.claseabc
		AND a.codcli02 = d.contribuy
		AND a.numcer13 = 'A' + @NUMCER
		AND flgval13 = 1
	ORDER BY a.numcer13
		,b.numser12

--Añadido por Eugenia Palao          
IF @NUMCER = ''
	AND @CODCLI = ''
	SELECT d.claseabc
		,d.contribuy
		,d.nombre
		,a.numdui11
		,a.numcer13
		,a.feccer13
		,b.numser12
		,b.numbul14
		,b.bulent14
		,sldbul = b.numbul14 - b.bulent14
		,c.codemb06
		,b.desmer14
		,unidad12 = b.unidad12
		,bulent12 = ISNULL(b.bulent12,0)
		,sldbulUC = (b.unidad12 - ISNULL(b.bulent12,0))
	FROM DDCERADU13 a
		,DDDCEADU14 b
		,DDSERDEP12 c
		,AAClientesAA d
	WHERE a.numcer13 = b.numcer13
		AND a.numsol10 = c.numsol10
		AND b.numser12 = c.numser12
		AND a.numbul13 - a.bulent13 >= 0
		AND b.numbul14 - b.bulent14 >= 0
		AND a.tipcli02 = d.claseabc
		AND a.codcli02 = d.contribuy
		AND flgval13 = 1 --and a.numcer13='A'+@NUMCER          
	ORDER BY a.numcer13
		,b.numser12

GO
/****** Object:  StoredProcedure [dbo].[sp_SALDO_FISICO_POR_SERIE_ADU_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_SALDO_FISICO_POR_SERIE_ADU_SIM] --'4','20100124492'    
@TIPCLI CHAR (1),    
@CODCLI VARCHAR (11)    
AS  
Select d.claseabc as Tipo,    
d.contribuy as Cliente,    
d.nombre as Razon_Social,    
a.numdui11 as DUA,    
a.numcer13 as Certificado,    
a.feccer13 as Fecha_Certificado,    
b.numser12 as Serie,    
b.numbul14 as Total_Bultos,    
b.bulent14 as Bultos_Entregados,    
sldbul=b.numbul14-b.bulent14,  
isnull(f.numdui16,'') as DUA_DESP,
bulsld=isnull(f.numbul16-f.bulent16, 0),  
c.codemb06 as Embalaje,    
b.desmer14 as Mercadería,    
'ADUANERO' as Tipo_Operacion,  
h.codubi71 + ' - ' + h.desubi71 as Ubicacion,  
e.desmer10 as Referencia   
From DDCERADU13 AS a     
INNER JOIN DDDCEADU14 AS b ON a.numcer13=b.numcer13    
INNER JOIN DDSERDEP12 AS c ON b.numser12=c.numser12 AND a.numsol10=c.numsol10  
INNER JOIN AAClientesAA AS d ON a.tipcli02=d.claseabc AND a.codcli02=d.contribuy
INNER JOIN DDSolAdu10 AS e ON a.numsol10=e.numsol10
left JOIN DDDuiDes16 AS f ON f.numcer13=a.numcer13 and f.numbul16-f.bulent16 > 0 
INNER JOIN DDRecMer69 AS g ON g.numsol62 = e.numsol10 and g.flgval69 = 1
INNER JOIN DQTipUbi71 AS h ON g.codubi71 = h.codubi71
Where         
a.numbul13-a.bulent13>0 and b.numbul14-b.bulent14>0
and a.tipcli02=@TIPCLI   
and a.codcli02=@CODCLI  
and flgval13 = 1     
union    
Select distinct   
d.claseabc AS Tipo,    
d.contribuy AS Cliente,    
d.nombre AS Razon_Social,    
'' AS DUA,    
a.numcer74 AS Certificado,    
a.feccer74 AS Fecha_Certificado,    
b.numser67 AS Serie,    
b.bulrec67 AS Total_Bultos,    
b.bulent67 AS Bultos_Entregados,    
sldbul=b.bulrec67-b.bulent67,  
'' as DUA_DESP,
bulsld=isnull(f.bultot75-f.bulret75,0),   
b.codemb06 AS Embalaje,    
b.desmer67 AS Mercadería,     
'SIMPLE' AS Tipo_Operacion,  
h.codubi71 + ' - ' + h.desubi71 as Ubicacion,  
e.desmer62 as Referencia   
From DDCerSim74 a      
Inner Join DDDSoSim67 b on a.numsol62=b.numsol62      
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy
inner join DDSolSim62 e on b.numsol62=e.numsol62
left join DDRetSim75 f on f.numcer74=a.numcer74 and f.bultot75-f.bulret75 > 0 and f.flgval75 = '1' and f.flgemi75='1'
INNER JOIN DDRecMer69 AS g ON g.numsol62 = b.numsol62 and g.flgval69 = 1
INNER JOIN DQTipUbi71 AS h ON g.codubi71 = h.codubi71  
Where a.bultot74-a.bulent74>0 and b.bulrec67-b.bulent67>0     
and a.flgval74=1 and a.codcli02= @CODCLI    
order by Certificado    
  
return 0 

GO
/****** Object:  StoredProcedure [dbo].[SP_SALDO_FISICO_POR_SERIE_ADU_WEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SALDO_FISICO_POR_SERIE_ADU_WEB]      
@NUMCER char(9),      
@TIPCLI char(1),      
@CODCLI VARCHAR(11)      
AS      
  Select d.claseabc,d.contribuy,d.nombre,
  a.numdui11 as Dua,
  a.numcer13 as Numcer,
  a.feccer13 as Fecha,
  b.numser12 as Serie,
  b.numbul14 as numbul,
  b.bulent14 as bultos,
  sldbul=b.numbul14-b.bulent14 ,
  c.codemb06 as Tipo,
  b.desmer14 as descr ,    
  ''  as preUni,
  b.numsol10 as Numsol
From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d       
Where       
a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and a.numbul13-a.bulent13>=0 and b.numbul14-b.bulent14>0 and       
a.tipcli02=d.claseabc and a.codcli02=d.contribuy 
and a.numcer13 = @NUMCER
--and a.tipcli02=@TIPCLI 
and a.codcli02= @CODCLI 
and flgval13 = 1    
order by a.numcer13, b.numser12 



GO
/****** Object:  StoredProcedure [dbo].[SP_SALDO_FISICO_POR_SERIE_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SALDO_FISICO_POR_SERIE_SIM]
@NUMCER VARCHAR(7) ,
@CODCLI VARCHAR(11) 

AS
/*
********************************************************************************************
Tuve que utilizar un artificio, es decir el comidin hvega porque cuando instale
el Rational Rose en mi PC se actualizaron algunas librerias del Cristal reports y
no me quedo otra alternativa. Si no utiilizaba ese artificio, antes que el reporte 
apareciera en pantalla se me preguntaba, en un apantalla rara, el valor de las 
variables que no eran pasadas al SP.
10/09/2003 - 11:31 AM - hvega
********************************************************************************************
*/

if @NUMCER<>'hector' and @CODCLI='hvega'
begin
Select d.claseabc,d.contribuy,d.nombre,a.numcer74,a.feccer74,b.numser67,b.bulrec67,b.bulent67,sldbul=b.bulrec67-b.bulent67,b.codemb06,b.desmer67
From DDCerSim74 a
Inner Join DDDSoSim67 b on a.numsol62=b.numsol62
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy
Where a.bultot74-a.bulent74>0 and b.bulrec67-b.bulent67>0 and a.flgval74=1 and a.numcer74='S'+@NUMCER
end

if @NUMCER='hector' and @CODCLI<>'hvega'
Begin
Select d.claseabc,d.contribuy,d.nombre,a.numcer74,a.feccer74,b.numser67,b.bulrec67,b.bulent67,sldbul=b.bulrec67-b.bulent67,b.codemb06,b.desmer67
From DDCerSim74 a
Inner Join DDDSoSim67 b on a.numsol62=b.numsol62
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy
Where a.bultot74-a.bulent74>0 and b.bulrec67-b.bulent67>0 and a.flgval74=1 and a.codcli02=@CODCLI
end 

if @NUMCER='hector' and @CODCLI='hvega'
Begin
Select d.claseabc,d.contribuy,d.nombre,a.numcer74,a.feccer74,b.numser67,b.bulrec67,b.bulent67,sldbul=b.bulrec67-b.bulent67,b.codemb06,b.desmer67
From DDCerSim74 a
Inner Join DDDSoSim67 b on a.numsol62=b.numsol62
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy
Where a.bultot74-a.bulent74>0 and b.bulrec67-b.bulent67>0 and a.flgval74=1 
end

if @NUMCER<>'' and @CODCLI<>''
begin
Select d.claseabc,d.contribuy,d.nombre,
       --'V' as Dua,
       a.numcer74 as Numcer,
       a.feccer74 as Fecha,
       b.numser67 as Serie ,
       b.bulrec67 as numbul,
       b.bulent67 as bultos,
       sldbul=b.bulrec67-b.bulent67,
       b.codemb06 as Tipo,
       b.desmer67 as descr,
       b.preuni67 as preUni,
       b.numsol62 as Numsol
From DDCerSim74 a
Inner Join DDDSoSim67 b on a.numsol62=b.numsol62
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy
Where a.bultot74-a.bulent74>0 and b.bulrec67-b.bulent67>0 and a.flgval74=1 and a.numcer74=@NUMCER and a.codcli02=@CODCLI
end










GO
/****** Object:  StoredProcedure [dbo].[SP_SALDO_MERCADERIAS_1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SALDO_MERCADERIAS_1]
@TIPDEP char(1),
@FECINI char(8),
@FECFIN char(8)

AS

If @TIPDEP='A'
Begin
        Delete DTSalAdu35
        Insert DTSalAdu35 
        Select numdui11,bulent=sum(COALESCE(bultot79,0)),cifent=sum(COALESCE(pretot79,0)+COALESCE(cuadep79,0)),host_name()
        From DDEntMer79 d
        Where convert(char(8),fecent79,112) between @FECINI and @FECFIN and numdui11 is not NULL and flgval79='1'
        and Exists (Select 1 from ddticket01 where docaut01 = d.numret75 and convert(char(8),fecusu01,112) between @FECINI and @FECFIN )
        Group by numdui11
End
Else
Begin
        Delete DTSalSim88
        INSERT DTSalSim88 
        Select numcer74,pesbru79=SUM(pesbru79),bultot79=SUM(bultot79),pretot79=SUM(pretot79),hostid88=host_name()
        From DVSalSim92_11 
        Where convert(char(8),fecsal01,112) between @FECINI and @FECFIN
        group by numcer74
End
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDO_MERCADERIAS_1_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec SP_SALDO_MERCADERIAS_1_NEW 'a','19990101','20171130'  
--exec SP_SALDO_MERCADERIAS_1_NEWW 'a','19990101','20170511'  
ALTER PROCEDURE [dbo].[SP_SALDO_MERCADERIAS_1_NEW] @TIPDEP CHAR(1)
	,@FECINI CHAR(8)
	,@FECFIN CHAR(8)
AS
IF @TIPDEP = 'A'
BEGIN
	DELETE DTSalAdu35_NEW

	SELECT d.numdui11
		,SUM(ISNULL(F.numbul12, 0)) AS totalUC
	INTO #TEMPORAL
	FROM DDEntMer79 d
	LEFT JOIN DDDEnMer80 F ON F.nument79 = d.nument79
	WHERE convert(CHAR(8), fecent79, 112) BETWEEN @FECINI
			AND @FECFIN
		AND d.numdui11 IS NOT NULL
		AND flgval79 = '1'
		AND EXISTS (
			SELECT 1
			FROM ddticket01
			WHERE docaut01 = d.numret75
				--AND numgui01 = d.nument79
				AND convert(CHAR(8), fecusu01, 112) BETWEEN @FECINI
					AND @FECFIN
			)
	GROUP BY d.numdui11

	/*  
 UPDATE DDEntMer79 SET bultot12UC = A.totalUC  
 FROM #TEMPORAL A  
 INNER JOIN DDEntMer79 B ON A.nument79 = B.nument79  
 */
	INSERT DTSalAdu35_NEW
	SELECT numdui11
		,bulent = sum(COALESCE(bultot79, 0))
		,cifent = sum(COALESCE(pretot79, 0) + COALESCE(cuadep79, 0))
		,host_name()
		,bulent12 = sum(COALESCE(bultot12UC, 0))
	FROM DDEntMer79 d
	WHERE convert(CHAR(8), fecent79, 112) BETWEEN @FECINI
			AND @FECFIN
		AND numdui11 IS NOT NULL
		AND flgval79 = '1'
		AND EXISTS (
			SELECT 1
			FROM ddticket01
			WHERE docaut01 = d.numret75
				--AND numgui01 = d.nument79
				AND convert(CHAR(8), fecusu01, 112) BETWEEN @FECINI
					AND @FECFIN
			)
	GROUP BY numdui11

	UPDATE DTSalAdu35_NEW
	SET bulent12 = B.totalUC
	FROM DTSalAdu35_NEW A
	INNER JOIN #TEMPORAL B ON A.numdui35 = B.numdui11
END
ELSE
BEGIN
	DELETE DTSalSim88

	INSERT DTSalSim88
	SELECT numcer74
		,pesbru79 = SUM(pesbru79)
		,bultot79 = SUM(bultot79)
		,pretot79 = SUM(pretot79)
		,hostid88 = host_name()
	FROM DVSalSim92_11
	WHERE convert(CHAR(8), fecsal01, 112) BETWEEN @FECINI
			AND @FECFIN
	GROUP BY numcer74
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SALDO_MERCADERIAS_1_NEWW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec SP_SALDO_MERCADERIAS_1_NEW 'a','19990101','20170511'
--exec SP_SALDO_MERCADERIAS_1_NEWW 'a','19990101','20170511'



ALTER PROCEDURE [dbo].[SP_SALDO_MERCADERIAS_1_NEWW] @TIPDEP CHAR(1)
	,@FECINI CHAR(8)
	,@FECFIN CHAR(8)
AS
IF @TIPDEP = 'A'
BEGIN
	DELETE DTSalAdu35_NEW

	SELECT d.numdui11,SUM(ISNULL(F.numbul12,0)) AS totalUC
		INTO #TEMPORAL
	FROM DDEntMer79 d
	LEFT JOIN DDDEnMer80 F ON F.nument79 = d.nument79
	WHERE convert(CHAR(8), fecent79, 112) BETWEEN @FECINI
			AND @FECFIN
		AND d.numdui11 IS NOT NULL
		AND flgval79 = '1'
		AND EXISTS (
			SELECT 1
			FROM ddticket01
			WHERE docaut01 = d.numret75
				AND convert(CHAR(8), fecusu01, 112) BETWEEN @FECINI
					AND @FECFIN
			)
	GROUP BY  d.numdui11
	
	/*
	UPDATE DDEntMer79 SET bultot12UC = A.totalUC
	FROM #TEMPORAL A
	INNER JOIN DDEntMer79 B ON A.nument79 = B.nument79
	*/
	
	INSERT DTSalAdu35_NEW
	SELECT numdui11
		,bulent = sum(COALESCE(bultot79, 0))
		,cifent = sum(COALESCE(pretot79, 0) + COALESCE(cuadep79, 0))
		,host_name()
		,bulent12 = sum(COALESCE(bultot12UC, 0))
	FROM DDEntMer79 d
	WHERE convert(CHAR(8), fecent79, 112) BETWEEN @FECINI
			AND @FECFIN
		AND numdui11 IS NOT NULL
		AND flgval79 = '1'
		AND EXISTS (
			SELECT 1
			FROM ddticket01
			WHERE docaut01 = d.numret75
				AND convert(CHAR(8), fecusu01, 112) BETWEEN @FECINI
					AND @FECFIN
			)
	GROUP BY numdui11
	
	UPDATE DTSalAdu35_NEW SET bulent12 = b.totalUC
	FROM DTSalAdu35_NEW A
	INNER JOIN #TEMPORAL B ON A.numdui35 = B.numdui11
END
ELSE
BEGIN
	DELETE DTSalSim88

	INSERT DTSalSim88
	SELECT numcer74
		,pesbru79 = SUM(pesbru79)
		,bultot79 = SUM(bultot79)
		,pretot79 = SUM(pretot79)
		,hostid88 = host_name()
	FROM DVSalSim92_11
	WHERE convert(CHAR(8), fecsal01, 112) BETWEEN @FECINI
			AND @FECFIN
	GROUP BY numcer74
END



GO
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_POR_SERIE_ADUANERO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SALDOS_POR_SERIE_ADUANERO    Script Date: 08-09-2002 08:44:10 PM ******/
ALTER PROCEDURE [dbo].[SP_SALDOS_POR_SERIE_ADUANERO]
@NUMCER CHAR(9)
AS

Delete DTSalSer38 

Insert into DTSalSer38
Select 
b.numcer13,b.numser70,a.nument79,c.fecsal01,numbul80=SUM(b.numbul80),preent80=SUM(b.preent80),
a.obsent79,d.nombre,host_name()
From 
DDEntMer79 a,DDDEnMer80 b,DDTicket01 c,AAClientesAA d,DDCERADU13 e
Where 
b.numcer13=@NUMCER and
b.numcer13=e.numcer13 and 
e.tipcli02=d.claseabc and e.codcli02=d.contribuy and 
a.nument79=b.nument79 and a.nument79=c.numgui01 and c.tipope01="R" and 
SUBSTRING(a.nument79,1,1)='A'
group by 
b.numcer13,b.numser70,a.nument79,c.fecsal01,a.obsent79,d.nombre
Order by a.nument79,c.fecsal01
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_POR_SERIE_ADUANERO_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SALDOS_POR_SERIE_ADUANERO_NEW] @NUMCER CHAR(9)
AS
DELETE DTSalSer38_NEW

DECLARE @ingtotUC DECIMAL(10, 2)
	,@saltotUC DECIMAL(10, 2)

SELECT @ingtotUC = SUM(ISNULL(unidad12, 0))
	,@saltotUC = SUM(ISNULL(bulent12, 0))
FROM DDDCeAdu14
WHERE numcer13 = @NUMCER

UPDATE DDCerAdu13
	SET saltotUC = @saltotUC
	,ingtotUC = @ingtotUC
WHERE numcer13 = @NUMCER

INSERT INTO DTSalSer38_NEW
SELECT b.numcer13
	,b.numser70
	,a.nument79
	,c.fecsal01
	,numbul80 = SUM(b.numbul80)
	,preent80 = SUM(b.preent80)
	,a.obsent79
	,d.nombre
	,host_name()
	,numbul12 = SUM(ISNULL(b.numbul12, 0))
	,ingtotUC = @ingtotUC
	,saltotUC = @saltotUC
FROM DDEntMer79 a
	,DDDEnMer80 b
	,DDTicket01 c
	,AAClientesAA d
	,DDCERADU13 e
WHERE b.numcer13 = @NUMCER
	AND b.numcer13 = e.numcer13
	AND e.tipcli02 = d.claseabc
	AND e.codcli02 = d.contribuy
	AND a.nument79 = b.nument79
	AND a.nument79 = c.numgui01
	AND c.tipope01 = 'R'
	AND SUBSTRING(a.nument79, 1, 1) = 'A'
GROUP BY b.numcer13
	,b.numser70
	,a.nument79
	,c.fecsal01
	,a.obsent79
	,d.nombre
ORDER BY a.nument79
	,c.fecsal01
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_POR_SERIE_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SALDOS_POR_SERIE_SIMPLE    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_SALDOS_POR_SERIE_SIMPLE]
@NUMCER CHAR(7)
AS

Delete from DTSalSer40

Insert into DTSalSer40
Select 
c.numcer74,c.numsol62,a.numser70,nument79=a.nument79,d.fecsal01,numbul80=(a.numbul80),
preent80=SUM(a.preent80),e.obsent79,f.nombre,host_name()
From 
DDDEnMer80 a , DDRecMer69 b, DDCerSim74 c, DDTicket01 d, DDENTMER79 e, AAClientesAA f
Where 
c.numcer74=@NUMCER and a.nument79=e.nument79 and 
c.tipcli02=f.claseabc and c.codcli02=f.contribuy and 
a.numrec69=b.numrec69 and b.numsol62=c.numsol62 and
a.nument79=d.numgui01 and d.tipope01="R" and c.flgval74='1' and b.flgval69='1'
Group by 
c.numcer74,c.numsol62,a.nument79,d.fecsal01,a.numser70,a.numbul80,a.preent80,e.obsent79,f.nombre
order by a.numser70,d.fecsal01
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SP_SALDOS_X_TIPO_MERCADERIA_1    Script Date: 08-09-2002 08:44:15 PM ******/
ALTER PROCEDURE [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_1]
@MERCAD VARCHAR(5),
@FECFIN CHAR(8),
@FLAG CHAR(1)
AS

IF @FLAG='1'

Insert DTMerIng46 
Select 
g.claseabc,g.contribuy,a.numcer13,a.numdui11,d.priing69,a.numser12,a.numbul14,b.codemb06,
b.tipmer72,a.desmer14,c.desmer10,f.flgdil11,g.nombre
From 
DDDCeAdu14 a,DDSerDep12 b,DDSolAdu10 c,DDRecMer69 d,DDCerAdu13 e,DDDuiDep11 f,AAClientesAA g 
Where 
e.tipcli02=g.claseabc and e.codcli02=g.contribuy and 
e.numcer13=a.numcer13 and e.numdui11=f.numdui11 and a.numdui11=b.numdui11 and 
a.numser12=b.numser12 and b.numsol10=c.numsol10 and c.numsol10=d.numsol62 and 
d.flgval69='1' and d.flgemi69='1' and e.flgval13='1' and convert(char(8),d.priing69,112)<=@FECFIN

ELSE

Insert DTMerIng46 
Select 
g.claseabc,g.contribuy,a.numcer13,a.numdui11,d.priing69,a.numser12,a.numbul14,b.codemb06,
b.tipmer72,a.desmer14,c.desmer10,f.flgdil11,g.nombre
From 
DDDCeAdu14 a,DDSerDep12 b,DDSolAdu10 c,DDRecMer69 d,DDCerAdu13 e,DDDuiDep11 f,AAClientesAA g 
Where 
e.tipcli02=g.claseabc and e.codcli02=g.contribuy and b.tipmer72=@MERCAD AND 
e.numcer13=a.numcer13 and e.numdui11=f.numdui11 and a.numdui11=b.numdui11 and 
a.numser12=b.numser12 and b.numsol10=c.numsol10 and c.numsol10=d.numsol62 and 
d.flgval69='1' and d.flgemi69='1' and e.flgval13='1' and convert(char(8),d.priing69,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SALDOS_X_TIPO_MERCADERIA_2    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_2]
@MERCAD VARCHAR(5),
@FECFIN CHAR(8),
@FLAG CHAR(1)
AS

IF @FLAG='1'

Insert DTMerIng46 
Select 
e.claseabc,e.contribuy,a.numcer74,a.numcer74,d.priing69,b.numser67,b.bulrec67,b.codemb06,
b.tipmer72,b.desmer67,c.desmer62,'2',e.nombre
From 
DDCerSim74 a,DDDSoSim67 b,DDSolSim62 c,DDRecMer69 d,AAclientesAA e
Where
a.tipcli02=e.claseabc and a.codcli02=e.contribuy and 
a.numsol62=b.numsol62 and a.numsol62=c.numsol62 and a.numsol62=d.numsol62 and a.flgval74='1' and 
d.flgval69='1' and d.flgemi69='1' and convert(char(8),d.priing69,112)<=@FECFIN

ELSE

Insert DTMerIng46 
Select 
e.claseabc,e.contribuy,a.numcer74,a.numcer74,d.priing69,b.numser67,b.bulrec67,b.codemb06,
b.tipmer72,b.desmer67,c.desmer62,'2',e.nombre
From 
DDCerSim74 a,DDDSoSim67 b,DDSolSim62 c,DDRecMer69 d,AAclientesAA e
Where
a.tipcli02=e.claseabc and a.codcli02=e.contribuy and b.tipmer72=@MERCAD AND 
a.numsol62=b.numsol62 and a.numsol62=c.numsol62 and a.numsol62=d.numsol62 and a.flgval74='1' and 
d.flgval69='1' and d.flgemi69='1' and convert(char(8),d.priing69,112)<=@FECFIN
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_3]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SALDOS_X_TIPO_MERCADERIA_3    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_3]
@MERCAD VARCHAR(5),
@FECFIN CHAR(8),
@FLAG CHAR(1)
AS

Insert DTMerSal47 
Select 
b.numcer13,b.numser70,numbul80=SUM(b.numbul80)
From 
DDEntMer79 a,DDDEnMer80 b,DDTicket01 c 
Where 
a.nument79=b.nument79 and a.nument79=c.numgui01 and c.tipope01='R' and 
SUBSTRING(a.nument79,1,1)='A' and convert(char(8),c.fecsal01,112)<=@FECFIN
Group by 
b.numcer13,b.numser70
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_4]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SALDOS_X_TIPO_MERCADERIA_4    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_4]
@MERCAD VARCHAR(5),
@FECFIN CHAR(8),
@FLAG CHAR(1)
AS

Insert DTMerSal47 
Select 
c.numcer74, a.numser70, numbul80=SUM(a.numbul80) 
From 
DDDEnMer80 a, DDRecMer69 b, DDCerSim74 c, DDTicket01 d 
Where 
SUBSTRING(a.nument79,1,1)='S' and a.numrec69=b.numrec69 and b.numsol62=c.numsol62 and 
a.nument79=d.numgui01 and d.tipope01='R' and convert(char(8),d.fecsal01,112)<=@FECFIN
Group by 
c.numcer74, a.numser70
GO
/****** Object:  StoredProcedure [dbo].[SP_SALIDAS_POR_CERTIFICADO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SALIDAS_POR_CERTIFICADO    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_SALIDAS_POR_CERTIFICADO]
@NUMCER CHAR(9)
AS


Delete from DTSALCER37_11

/* Lleno primera tabla temporal */

INSERT INTO DTSALCER37_11
Select 
a.numdui11,a.numcer13,a.numdui16,a.numret75,a.nument79,a.fecent79,c.fecsal01,a.bultot79,
a.codemb06,a.pesbru79,b.tipcli02,b.codcli02,d.nombre,a.pretot79,a.cuadep79,b.codage19,
a.obsent79,USER_NAME()
From DDEntMer79 a
Inner Join DDDuiDes16 b on a.numdui16=b.numdui16
Inner Join DDTicket01 c on a.nument79=c.numgui01
Inner Join AAClientesAA d on b.tipcli02=d.claseabc and b.codcli02=d.contribuy
Where 
a.numcer13=@NUMCER AND c.tipope01='R'

order by c.fecsal01
GO
/****** Object:  StoredProcedure [dbo].[SP_SALIDAS_POR_CERTIFICADO_NEW]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_SALIDAS_POR_CERTIFICADO    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_SALIDAS_POR_CERTIFICADO_NEW] @NUMCER CHAR(9)
AS
DELETE
FROM DTSALCER37_11_NEW

/* Lleno primera tabla temporal */
INSERT INTO DTSALCER37_11_NEW
SELECT a.numdui11
	,a.numcer13
	,a.numdui16
	,a.numret75
	,a.nument79
	,a.fecent79
	,c.fecsal01
	,a.bultot79
	,a.codemb06
	,a.pesbru79
	,b.tipcli02
	,b.codcli02
	,d.nombre
	,a.pretot79
	,a.cuadep79
	,b.codage19
	,a.obsent79
	,USER_NAME()
	,bultot12 = (select sum(ISNULL(zz.numbul12,0)) from DDDEnMer80 zz where zz.nument79 = a.nument79)
FROM DDEntMer79 a
INNER JOIN DDDuiDes16 b ON a.numdui16 = b.numdui16
INNER JOIN DDTicket01 c ON a.nument79 = c.numgui01
INNER JOIN AAClientesAA d ON b.tipcli02 = d.claseabc
	AND b.codcli02 = d.contribuy
WHERE a.numcer13 = @NUMCER
	AND c.tipope01 = 'R'
ORDER BY c.fecsal01
GO
/****** Object:  StoredProcedure [dbo].[SP_SALIDAS_POR_CERTIFICADO_S]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SALIDAS_POR_CERTIFICADO_S]
@NUMCER CHAR(7)
AS


delete from DTSALREC39_11

INSERT INTO DTSALREC39_11
Select 
b.numcer74,a.numret75,a.nument79,c.fecsal01,a.bultot79,a.codemb06,a.pesbru79,
a.pretot79,a.obsent79
From DDEntMer79 a
Inner Join DDRetSim75 b on a.numret75=b.numret75
Inner Join DDTicket01 c on a.nument79=c.numgui01
where 
b.numcer74=@NUMCER and c.tipope01='R'
Order by c.fecsal01
GO
/****** Object:  StoredProcedure [dbo].[SP_SERIES_A_BLOQUEAR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SERIES_A_BLOQUEAR    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[SP_SERIES_A_BLOQUEAR]
@NUMCER VARCHAR(9),
@TIPDEP CHAR(1)
AS

if @TIPDEP='A'
    Select a.feccer13,a.numsol10,a.tipcli02,a.codcli02,b.nombre,a.flgval13
    From DDCerAdu13 a,AAClientesAA b 
    Where a.tipcli02=b.claseabc and a.codcli02=b.contribuy and
    a.numcer13=@NumCer
else
    Select a.feccer74,a.numsol62,a.tipcli02,a.codcli02,b.nombre,a.flgval74
    From DDCerSim74 a,AAClientesAA b 
    Where a.tipcli02=b.claseabc and a.codcli02=b.contribuy and
    a.numcer74=@NumCer
GO
/****** Object:  StoredProcedure [dbo].[SP_SERIES_A_BLOQUEAR_DET]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SERIES_A_BLOQUEAR_DET    Script Date: 08-09-2002 08:44:15 PM ******/
ALTER PROCEDURE [dbo].[SP_SERIES_A_BLOQUEAR_DET]
@NUMDOC VARCHAR(9),
@TIPDEP CHAR(1)
AS

if @TIPDEP='A'
    Select
    numser67=a.numser12,bulsld67=a.numbul14-a.bulent14,bulblo67=a.bulblo14,b.codemb06,
    desmer67=a.desmer14
    From 
    DDDCeAdu14 a, DDSerDep12 b 
    Where 
    a.numdui11=b.numdui11 and a.NumSer12=b.NumSer12 and
    a.numcer13=@NUMDOC and ((a.numbul14-a.bulent14>0) or (a.numbul14=0 and cifent14=0))
    Order by a.numser12
else
    Select
    numser67, bulsld67=bulrec67-bulent67,bulblo67,codemb06,desmer67,preuni67
    From 
    DDDSoSim67
    Where 
    numsol62=@NUMDOC and bulrec67-bulent67>0
    Order by numser67
GO
/****** Object:  StoredProcedure [dbo].[SP_SOL_CERSIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_SOL_CERSIM    Script Date: 08-09-2002 08:44:13 PM ******/  
ALTER PROCEDURE [dbo].[SP_SOL_CERSIM]  
@NUMSOL CHAR(7)  
AS  
  
Select   
a.fecsol62,a.tipcli02,a.codcli02,NombreC=b.nombre,a.codage19,NombreA=c.nombre,  
flgcer62=case when (Select count(*) from ddcersim74 where numsol62=@NUMSOL and flgval74='1')>=1 then   
    '1'   
else   
    '0'   
end,  
a.numrec62,a.bultot62,a.totrec62,a.PesTot62,a.cobalm62  
From   
DDSolSim62 a
inner join AAClientesAA b on (a.tipcli02=b.claseabc and a.codcli02=b.contribuy)
left  join AAClientesAA c on (a.codage19=c.cliente)   
Where   
a.numsol62=@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[SP_SOLICITUD_DUA_DEP]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SOLICITUD_DUA_DEP    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_SOLICITUD_DUA_DEP]
@NUMSOL CHAR(7)
AS

Select
a.fecsol10,a.numdui10,a.tipcli02,a.codcli02,NombreC=b.nombre,a.codage19,NombreA=c.nombre,
a.numbul10,a.codemb06,a.desmer10,a.flgseg10,a.valfob10,a.valfle10,a.valseg10,a.valcif10,
a.flgval10,a.flgemi10,a.flgdui10
From DDSolAdu10 a,AAClientesAA b,AAClientesAA c
Where numsol10=@NUMSOL and
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.codage19=c.cliente
GO
/****** Object:  StoredProcedure [dbo].[SP_SOLICITUD_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SOLICITUD_SIMPLE]  
@NUMSOL CHAR(7)  
AS  
  
--rdelacuba 31/10/2006: Incluir el dato de terminal  
SELECT   
a.*, factComercial = isnull(a.FACTCOMER,'') , NombreC=b.nombre,NombreA=c.nombre,e.codalm99,e.desalm99, isnull(f.NomTer09,'') as nomter , isnull(de20,'') as  de20c ,isnull(de40,'') as de40c,isnull(cgsuelta10,'0') as cgsuelta10c  
FROM   
DDSolSim62 a
inner join AAClientesAA b on (a.tipcli02=b.claseabc and a.codcli02=b.contribuy)
inner join DDAlmExp99 d on (a.numsol62=d.numsol99)
inner join DQAlmDep99 e on (d.codalm99=e.codalm99)
left  join AAClientesAA c on (a.codage19=c.cliente)
left  join DQTerAdu09 f on (a.CodTer = f.codter09) 

WHERE  
a.NumSol62=@NUMSOL  
  
  
  

GO
/****** Object:  StoredProcedure [dbo].[SP_SOLUCITUD_ADUANERA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SOLUCITUD_ADUANERA    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_SOLUCITUD_ADUANERA]
@NUMSOL CHAR(7)
AS


Select 
a.*,NombreC=b.nombre,b.direccion,NombreA=c.nombre,d.despai07,e.despue02,f.desnav08
From
DDSOLADU10 a,AAClientesAA b,AAClientesAA c,Descarga..DQPAISES07 d,
Descarga..DQPUERTO02 e,Descarga..DQNAVIER08 f
Where 
a.numsol10=@NUMSOL and a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.codage19=c.cliente and a.codpai07=d.codpai07 and a.codpue03=e.codpue02 and 
a.codnav08=f.codnav08
GO
/****** Object:  StoredProcedure [dbo].[SP_SQLSERIE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SQLSERIE    Script Date: 08-09-2002 08:44:15 PM ******/
ALTER PROCEDURE [dbo].[SP_SQLSERIE]
@NUMCER CHAR(9)
AS

Select 
a.numser12,numbul14=a.numbul14-a.buldes14,b.codemb06,a.desmer14,pesbru14=a.pesbru14-a.pesdes14,
valfob14=a.valfob14-a.fobdes14
From 
DDDCeAdu14 a, DDSerDep12 b 
Where 
a.numdui11=b.numdui11 and a.numser12=b.numser12 and 
(a.numbul14-a.buldes14>0 or a.valfob14-a.fobdes14>0) and
a.numcer13=@NUMCER
GO
/****** Object:  StoredProcedure [dbo].[SP_SQLTARJA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_SQLTARJA    Script Date: 08-09-2002 08:44:05 PM ******/
ALTER PROCEDURE [dbo].[SP_SQLTARJA]
@NUMCER CHAR(9),
@NUMSER CHAR(4)
AS

Select a.*,bulsld73=a.numbul73-a.bulret73
From DDMerAlm73 a,DDRECMER69 b
Where a.numrec69=b.numrec69 and b.flgval69='1' and 
a.numcer73=@NUMCER and a.numser70=@NUMSER



GO
/****** Object:  StoredProcedure [dbo].[SP_SSI_INSOrden_Servicio_Web_SAA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SSI_INSOrden_Servicio_Web_SAA]
                @vchCodigo      varchar(10),
                @intServicio      varchar(10),                
                @intZonaini       int,
                @vchDirecIni     varchar(200),
                @chrFechaIni     Datetime,                
                @intZonaFin      int,
                @vchDirecFin    varchar(200),
                @chrFechaFin   char(8),
                @chrHoraFin     char(5),
                @intZonaEmb   int
as
Declare @CodZona int
BEGIN
if not exists(select * from ssi_orden_servicio where ord_codigo = @vchcodigo and ser_codigo = @intServicio)
 begin
                declare @dtFIni               datetime,
                        @dtFFin              datetime
               
                if @chrFechaFin <>''
                               set @dtFFin = @chrFechaFin+ ' ' +  @chrHoraFin
                else
                               set @dtFFin = null
                
                IF @intZonaini= 0
                               SET @intZonaini= NULL
                IF @intZonaFin = 0
                               SET @intZonaFin = NULL
                IF @intZonaEmb=0
                               SET @intZonaEmb=NULL

                If left(@vchcodigo,1) = 'D'  
                    Select @CodZona = Cod_Zona from  depositos.dbo.Distrito_zonas where Cal_Codigo = @intZonaFin
                else
                     SET @CodZona = @intZonaFin

                insert into ssi_orden_servicio 
                (ORD_CODIGO,SER_CODIGO,SER_FLAG,SER_FECHAINI,CAL_CODIGOINI,SER_REFERENCIAINI,SER_FECHAFIN,CAL_CODIGOFIN,SER_REFERENCIAFIN,CAL_EMBARQUE) 
                values(@vchcodigo,@intServicio,'1',@dtFIni,@intZonaini,@vchDirecIni,@dtFFin,@CodZona,@vchDirecFin,@intZonaEmb)

                --rdelacuba 02/02/2007: Insertar, si corresponde la orden de transporte
                execute usp_SSI_InsertaosTranspCalle @vchcodigo,@intServicio

 end

END


GO
/****** Object:  StoredProcedure [dbo].[SP_TARIFA_DEPOSITO_ADUANERO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TARIFA_DEPOSITO_ADUANERO    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_TARIFA_DEPOSITO_ADUANERO]
@NUMSOL CHAR(7)
AS

Select
a.fecsol10,b.nombre,a.flgval10,a.flgtar10
From DDSolAdu10 a,AAClientesAA b
Where a.codcli02=b.contribuy and a.numsol10=@NumSol
GO
/****** Object:  StoredProcedure [dbo].[SP_TARIFA_DEPOSITO_SIMPLE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TARIFA_DEPOSITO_SIMPLE    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_TARIFA_DEPOSITO_SIMPLE]
@NUMSOL CHAR(7)
AS

Select fecsol10=a.fecsol62,b.nombre,flgval10=a.flgval62,flgtar10=a.flgtar62
From DDSolSim62 a,AAClientesAA b 
Where a.codcli02=b.contribuy and a.numsol62=@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[SP_TCKMAN_CON_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TCKMAN_CON_ADU    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_TCKMAN_CON_ADU]
@NUMSOL CHAR(7)
AS

Select 
a.fecsol10,a.codage19,a.tipcli02,a.codcli02,b.nombre,a.flgval10,a.flgemi10,
a.flgctr10,a.flgcer10
From DDSolAdu10 a,AAClientesAA b
Where 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.numsol10=@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[SP_TCKMAN_CON_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TCKMAN_CON_SIM    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_TCKMAN_CON_SIM]
@NUMSOL CHAR(7)
AS

Select 
a.fecsol62,a.desmer62,a.codage19,a.tipcli02,a.codcli02,b.nombre,a.flgval62,a.flgemi62,
a.flgctr62,a.flgcer62
From 
DDSolSim62 a,AAClientesAA b
Where 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.numsol62=@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[SP_TICKET]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_TICKET    Script Date: 08-09-2002 08:44:11 PM ******/        
ALTER PROCEDURE [dbo].[SP_TICKET]        
@NUMTKT CHAR(8)        
AS          

Select        
a.numtkt01,
a.tipope01,
a.tipest01,
a.tipmer01,
a.docaut01,
a.numgui01,
a.fecing01,
a.fecsal01,
a.pesbru01,
a.pestar01,
a.pesnet01,
a.tarcon01,
a.numpla01,
a.numbul01,
a.codemb06,
a.numcha01,
a.tipcli02,
a.codcli02,
a.codage19,
a.nomusu01,
a.fecusu01,
a.flgman01,
flgdes01 = case when a.flgdes01 = '1' then '0'
									  else a.flgdes01
									  end,
a.tktter01,
a.horext01,
a.codcom50,
a.numcom52,
a.horcob01,
a.tarct101,
a.tarct201,
a.nro_brevete
,numsol10=a.docaut01,NombreC=b.nombre,    
NombreA=c.nombre,    
d.desemb06,    
e.numctr65,e.tamctr65        
From         
DDTICKET01 a      
inner join AAclientesAA b on (a.tipcli02=b.claseabc and a.codcli02=b.contribuy)      
inner join DQEMBALA06 d on (a.codemb06=d.codemb06)      
left  join AAclientesAA c on (a.codage19=c.cliente and a.codage19 <> '')      
left  join DDCTRDEP65 e on (a.numtkt01=e.numtkt01)        
Where        
a.numtkt01= @NUMTKT
GO
/****** Object:  StoredProcedure [dbo].[SP_TICKET_TER_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TICKET_TER_ADU    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_TICKET_TER_ADU]
@NUMSOL CHAR(7)
AS

Select 
a.fecsol10,a.codage19,NombreA=c.nombre,a.tipcli02,a.codcli02,NombreC=b.nombre,a.flgval10,
a.flgemi10,a.flgctr10,a.flgcer10
From 
DDSolAdu10 a,AAClientesAA b,AAClientesAA c
Where 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.codage19=c.cliente and a.numsol10=@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[SP_TICKET_TER_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_TICKET_TER_SIM]    
@NUMSOL CHAR(7)    
AS    
    
Select     
a.desmer62,a.fecsol62,a.codage19,NombreA=c.nombre,a.tipcli02,a.codcli02,NombreC=b.nombre,    
a.flgval62,a.flgemi62,a.flgctr62,a.flgcer62     
From     
DDSolSim62 a  
inner join AAClientesAA b on (a.tipcli02=b.claseabc and a.codcli02=b.contribuy)  
left  join AAClientesAA c on (a.codage19=c.cliente)    
Where     
a.numsol62=@NUMSOL 
and (c.cliente<>'' or c.cliente is null)  
GO
/****** Object:  StoredProcedure [dbo].[SP_TIPO_DE_CAMBIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TIPO_DE_CAMBIO    Script Date: 08-09-2002 08:44:05 PM ******/
ALTER PROCEDURE [dbo].[SP_TIPO_DE_CAMBIO]
@FECHA CHAR(8)

AS


Select fecfor28, fecnor28, camleg28
from Terminal..DQTIPCAM28
where fecfor28=@FECHA
GO
/****** Object:  StoredProcedure [dbo].[SP_TKTMAN_VEH_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TKTMAN_VEH_ADU    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_TKTMAN_VEH_ADU]
@NUMSOL CHAR(7)
AS

Select 
a.fecsol10,a.codage19,a.tipcli02,a.codcli02,b.nombre,a.flgval10,a.flgemi10,
a.flgctr10,a.flgcer10
From 
DDSolAdu10 a,AAClientesAA b
Where 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.numsol10=@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[SP_TKTMAN_VEH_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TKTMAN_VEH_SIM    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[SP_TKTMAN_VEH_SIM]
@NUMSOL CHAR(7)
AS

Select 
a.fecsol62,a.codage19,a.tipcli02,a.codcli02,b.nombre,a.flgval62,a.flgemi62,
a.flgctr62,a.flgcer62
From 
DDSolSim62 a,AAClientesAA b 
Where 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.numsol62=@NUMSOL
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_ACUERDO_SAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_UPDATE_ACUERDO_SAS]
@TIPCLIE VARCHAR(2),
@CODCLIENTE VARCHAR(11),
@CODSERVICIO VARCHAR(10),
@TIPDEPOSITO VARCHAR(1),
@NUMACUERDO VARCHAR(5)
AS
BEGIN
	RETURN;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_OT_OS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_UPDATE_OT_OS]  
@OT VARCHAR(8),  
@ORDSER VARCHAR(8)  
AS  
BEGIN  
 --|SETEO DE VARIABLES  
 SET @OT=LTRIM(RTRIM(@OT))  
 SET @ORDSER=LTRIM(RTRIM(@ORDSER))  
 --|  
   
 --|ASOCIAR ORDEN DE SERVICIO A LA ORDEN DE TRABAJO  
 UPDATE DDPLAREC32 SET NUMORD58=@ORDSER,FLGREC32='F'  
 WHERE NRO_PLAREC32=@OT  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Valida_Carga_Solicitud_Aut]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_Valida_Carga_Solicitud_Aut]
@NroSol01 varchar(10),
@TotSer01 int,
@PesTot01 decimal(15,4),
@CodTer01 char(04),
@Vigenc01 int,
@Tiempo01 varchar(04),
@FecNum01 char(8) ,
@NroSer01 char(04),
@CanBul01 int,
@CodEmb01 char(03) ,
@UniCon01 int ,
@TipMer01 char(02) ,
@DesMer01 varchar(100),
@CodPro01 char(05),
@ParAre01 varchar(15),
@PesBrt01 decimal(15,4),
@MonFob01 decimal(15,4),
@MonFle01 decimal(15,4),  
@MonSeg01 decimal(15,4),
@CodUsu01 varchar(15)

as 

declare @Val as integer
declare @Cad as varchar(1000)
Select @Val=count(numsol10)
From DDSolAdu10 a,AAClientesAA b,AAClientesAA c
Where numsol10=@NroSol01 and
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.codage19=c.cliente

if @Val =0 
	set @Cad='SOLICITUD INVALIDA '	

select @Val=count(CodTer09) from DQTerAdu09 where CodTer09=@CodTer01

if @Val =0 
	set @Cad= @Cad + 'TERMINAL INVALIDO '	

if substring(@Tiempo01,1,3)='MES' or substring(@Tiempo01,1,3)='DIA'
	set @Cad= @Cad 
else
	set @Cad= @Cad + 'MES/DIA INVALIDO '	

select @Val=count(codemb06) from DQEmbala06 where codemb06=@CodEmb01
if @Val =0 
	set @Cad= @Cad + 'EMBALAJE INVALIDO '	

select @Val=count(tipmer72) from DQTipMer72 where tipmer72=@CodPro01

if @Val =0 
	set @Cad= @Cad + 'PRODUCTO INVALIDO '	

select @Cad



GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDA_CIENTE_OT]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VALIDA_CIENTE_OT]    
@CODCLIENTE VARCHAR(15),    
@FACTURA VARCHAR(50),    
@GUIA VARCHAR(50),    
@NUMCER VARCHAR(11)    
AS    
BEGIN    
 --|SETEO DE VARIABLES    
 SET @CODCLIENTE=LTRIM(RTRIM(@CODCLIENTE))    
 SET @FACTURA=LTRIM(RTRIM(@FACTURA))    
 SET @GUIA=LTRIM(RTRIM(@GUIA))    
 SET @NUMCER=LTRIM(RTRIM(@NUMCER))    
 --|    
     
 DECLARE @MENSAJE VARCHAR(250)    
 SET @MENSAJE=''    
     
 IF @CODCLIENTE='20513997222' OR @CODCLIENTE='20555212390'    
 BEGIN    
  IF LEN(@FACTURA)=0    
  BEGIN    
   SET @MENSAJE='Ingresar el nro. de factura'    
   SELECT @MENSAJE AS 'MENSAJE','1' AS ID    
   RETURN;    
  END    
  IF LEN(@GUIA)=0    
  BEGIN    
   SET @MENSAJE='Ingresar el nro. de Guía'    
   SELECT @MENSAJE AS 'MENSAJE','2' AS ID    
   RETURN;    
  END    
 END    
     
 DECLARE @ICOUNT INT    
 IF SUBSTRING(@NUMCER,1,1)='S'    
 BEGIN    
  SELECT @ICOUNT=COUNT(*)    
  FROM DdcerSim74 WITH (NOLOCK)    
  WHERE numcer74=@NUMCER    
  IF @ICOUNT=0    
  BEGIN    
   SET @MENSAJE='El nro. de cetificado :' +@NUMCER + 'no existe'    
   SELECT @MENSAJE AS 'MENSAJE','3' AS ID    
   RETURN;    
  END    
 END    
     
 IF SUBSTRING(@NUMCER,1,1)='A'    
 BEGIN    
  SELECT @ICOUNT=COUNT(*)    
  FROM DdCerAdu13 WITH (NOLOCK)    
  WHERE numcer13=@NUMCER    
  IF @ICOUNT=0    
  BEGIN    
   SET @MENSAJE='El nro. de cetificado :' +@NUMCER + 'no existe'    
   SELECT @MENSAJE AS 'MENSAJE','3' AS ID    
   RETURN;    
  END    
 END   
   
IF SUBSTRING(@NUMCER,1,1)<>'A' AND SUBSTRING(@NUMCER,1,1)<>'S'    
 BEGIN    
   SET @MENSAJE='El nro. de cetificado :' +@NUMCER + ' no existe (no es Aduanero ni Simple)'    
   SELECT @MENSAJE AS 'MENSAJE','3' AS ID    
   RETURN;    
 END     
     
 SELECT @MENSAJE AS 'MENSAJE'    
END

GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDA_CONT_PELIGROSO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VALIDA_CONT_PELIGROSO]        
@MERCADERIA VARCHAR(250)        
AS        
BEGIN        
--|FML 03-07-2015        
--|VALIDAR SI LA MERCADERIA ES PELIGROSA        
SET NOCOUNT ON;        
 --|SETEO DE VARIABLE        
 SET @MERCADERIA = LTRIM(RTRIM(@MERCADERIA))        
 --|        
 DECLARE @MENSAJE AS VARCHAR(250), @DESCRIPCION VARCHAR(250)        
         
 SET @MENSAJE=''        
 SET @DESCRIPCION=''        
         
 --|VALIDAR SI LA MERCADERIA CONTIENE MERCADERIA PELIGROSA (ESPAÑOL)        
 --|INICIO         
 SELECT @DESCRIPCION=LTRIM(RTRIM(DESCRIPCION_E))        
 FROM TERMINAL.DBO.PRODUCTOS_PROHI WITH (NOLOCK)        
 WHERE         
 @MERCADERIA LIKE '%' + LTRIM(RTRIM(DESCRIPCION_E)) + '%'        
 AND LTRIM(RTRIM(DESCRIPCION_E))<>'LACAS'      
         
 IF ISNULL(@DESCRIPCION,'')<>''        
 BEGIN        
  SET @MENSAJE = 'La Mercadería contiene: ' + LTRIM(RTRIM(@DESCRIPCION)) + ', No puede ingresar!!'        
  SELECT @MENSAJE AS 'Resultado','0' as 'Dato'        
  RETURN;        
 END        
 --|FIN        
         
         
 --|VALIDAR SI LA MERCADERIA CONTIENE MERCADERIA PELIGROSA (INGLES)        
 --|INICIO        
 SELECT @DESCRIPCION=LTRIM(RTRIM(DESCRIPCION_I))        
 FROM TERMINAL.DBO.PRODUCTOS_PROHI WITH (NOLOCK)        
 WHERE         
 @MERCADERIA LIKE '% ' + LTRIM(RTRIM(DESCRIPCION_I)) + '%'        
 AND LTRIM(RTRIM(DESCRIPCION_E))<>'LACAS'      
         
 IF ISNULL(@DESCRIPCION,'')<>''        
 BEGIN        
  SET @MENSAJE = 'La Mercadería contiene: ' + LTRIM(RTRIM(@DESCRIPCION)) + ', No puede ingresar!!'        
  SELECT @MENSAJE AS 'Resultado','0' as 'Dato'       
  RETURN;        
 END        
 --|FIN        
        
 SELECT @MENSAJE AS 'Resultado'        
         
SET NOCOUNT OFF;        
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_Valida_Cuadre_Carga_Solicitud_Aut]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Valida_Cuadre_Carga_Solicitud_Aut]
@NroSol   char(6),
@CodTip   char(3),
@CanBul   float,
@Fob      decimal(15,4),
@Flete    decimal(15,4),
@Seguro   decimal(15,4),
@PesBrt01 decimal(15,4),
@CanSer01 int,
@codusu01 varchar(15)
as
declare
@aNroSol   char(6),
@aCodTip   char(3),
@aCanBul   float,
@aFob      decimal(15,4),
@aFlete    decimal(15,4),
@aSeguro   decimal(15,4),
@aPesBrt01  decimal(15,4),
@aCanSer01 int,
@Msg      varchar(1000)
select @aNroSol=NroSol01, @aCodTip=CodEmb01, @aCanBul=sum(CanBul01), @PesBrt01=sum(PesBrt01), 
@aFob=sum(MonFob01), @aFlete=sum(MonFle01), @aSeguro=sum(MonSeg01), @aCanSer01=count(NroSol01)
from DDCARGASOL01 where CodUsu01=@codusu01
group by NroSol01,CodEmb01
set @msg=''
if @NroSol<>@aNroSol
	set @msg='NRO DE LA SOLICITUD INVALIDO. '

if @CodTip<>@aCodTip
	set @msg= @msg + 'EMBALAJE NO COINCIDE CON EL DE LA SOLICITUD. '

if @CanBul<>@aCanBul
	set @msg= @msg + 'CANTIDAD DE BULTOS NO COINCIDE CON EL DE LA SOLICITUD. '

if @Fob<>@aFob
	set @msg= @msg + 'VALOR FOB NO COINCIDE CON EL DE LA SOLICITUD. '

if @Flete<>@aFlete
	set @msg= @msg + 'VALOR FLETE NO COINCIDE CON EL DE LA SOLICITUD. '

if @Seguro<>@aSeguro
	set @msg= @msg + 'VALOR SEGURO NO COINCIDE CON EL DE LA SOLICITUD. '

if @aCanSer01<>@aCanSer01
	set @msg= @msg + 'CANTIDAD DE SERIES NO COINCIDE CON EL DE LA SOLICITUD. '


/*
if @PesBrt01<>a@PesBrt01
	set @msg= @msg + 'EL PESO NO COINCIDE CON EL DE LA SOLICITUD. '
*/
select @msg

GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDAR_MERC_SAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_VALIDAR_MERC_SAS]    
@NUMCAR VARCHAR(9)    
AS    
BEGIN    
SET NOCOUNT ON;    
 SET @NUMCAR=LTRIM(RTRIM(@NUMCAR))    
 DECLARE @IngCli44 TABLE    
 (    
  numcer44 varchar(9),    
  buling44 decimal(10,2)    
 )    
     
 DECLARE @SalCli45 TABLE    
 (    
  numcer45 varchar(9),    
  bulent45 decimal(10,2)    
 )    
   
 DECLARE @ICOUNT INT, @MENSAJE VARCHAR(200)    
 SET @MENSAJE=''   
   
 /**************************/  
 DECLARE @TIPCER VARCHAR(1)  
 IF SUBSTRING(@NUMCAR,1,1)='S'  
 BEGIN  
	 IF NOT EXISTS(SELECT TOP 1 *FROM DDCerSim74 WITH (NOLOCK) WHERE numcer74=@NUMCAR)  
	 BEGIN  
		  --IF NOT EXISTS(SELECT TOP 1 *FROM DDCerSim74 WITH (NOLOCK) WHERE numsol62=@NUMCAR)
		  --BEGIN
		SELECT @MENSAJE AS 'MENSAJE'   
		RETURN;  
		  --END
	 END  
 END   
 ELSE  
 BEGIN  
 IF NOT EXISTS(SELECT TOP 1 *FROM DDCerAdu13 WITH (NOLOCK) WHERE numcer13=@NUMCAR)  
 BEGIN  
	  --IF NOT EXISTS(SELECT TOP 1 *FROM DDCerAdu13 WITH (NOLOCK) WHERE numsol10=@NUMCAR)  
	  --BEGIN
	SELECT @MENSAJE AS 'MENSAJE'   
	RETURN;  
	  --END
 END  
 END  
 /**************************/  
     
 INSERT INTO @IngCli44(numcer44,buling44)    
 SELECT A.numcer74,B.bultot69    
 FROM DDCerSim74 A WITH (NOLOCK)    
 INNER JOIN DDRecMer69 B WITH (NOLOCK) ON B.numsol62=A.numsol62    
 WHERE A.numcer74=@NUMCAR    
     
 IF NOT EXISTS(SELECT TOP 1 * FROM @IngCli44 WHERE numcer44=@NUMCAR)    
 BEGIN    
  INSERT INTO @IngCli44(numcer44,buling44)    
  SELECT A.numcer13,A.numbul13    
  FROM DDCerAdu13 A WITH (NOLOCK)    
  INNER JOIN DDSolAdu10 B WITH (NOLOCK) ON A.numsol10=B.numsol10    
  WHERE A.numcer13=@NUMCAR    
 END    
     
 INSERT INTO @SalCli45(numcer45,bulent45)    
 SELECT A.numcer13,SUM(A.bultot79)    
 FROM DDEntMer79 A WITH(NOLOCK)    
 INNER JOIN DDTicket01 B WITH (NOLOCK) ON A.Numtkt01=B.Numtkt01    
 WHERE A.numcer13=@NUMCAR    
 GROUP BY A.numcer13    
 /*    
 IF NOT EXISTS(SELECT TOP 1 * FROM @SalCli45 WHERE numcer45=@NUMCAR)    
 BEGIN    
  SELECT A.numcer13,SUM(A.bultot79)    
  FROM DDEntMer79 A WITH (NOLOCK)    
  INNER JOIN DDTicket01 B WITH (NOLOCK) ON A.Numtkt01=B.Numtkt01    
  WHERE A.numcer13=@NUMCAR    
  GROUP BY A.numcer13    
 END    
 */     
     
 SELECT  @ICOUNT=COUNT(*)    
 FROM @IngCli44 A     
 LEFT JOIN @SalCli45 B ON A.numcer44=B.numcer45    
 WHERE A.buling44 > ISNULL(B.bulent45,0)    
 AND A.numcer44=@NUMCAR    
     
 IF @ICOUNT = 0    
 BEGIN    
  SET @MENSAJE='Ya se retiro toda la Carga Asociada al Nro. de Certificado: ' + @NUMCAR    
  SELECT @MENSAJE AS 'MENSAJE'    
  RETURN;    
 END    
     
 SELECT @MENSAJE AS 'MENSAJE'    
SET NOCOUNT OFF;    
END  
GO
/****** Object:  StoredProcedure [dbo].[SPW_SALDO_DEP]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SPW_SALDO_DEP]  
as  
  
Select a.numcer44, a.numdui44, a.fecing44,   
        Case when b.bulent45=null then a.buling44 else a.buling44-b.bulent45 end, a.codemb44, a.desmer44,   
 Case when b.cifent45=null then a.cifing44 else a.cifing44-b.cifent45 end   
From 
DTIngcli44 a 
left join DTsalcli45 b on (a.numdui44=b.numdui45 )  
where 
Case when b.bulent45 is null then a.buling44 else a.buling44-b.bulent45 end > 0   
order by a.numcer44 desc
GO
/****** Object:  StoredProcedure [dbo].[STPS_CREA_USUARIO_SAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author
-- Create date: 
-- Description:	
-- =============================================

ALTER PROCEDURE [dbo].[STPS_CREA_USUARIO_SAS]
@Usuario varchar(35) --Usuario de red igual al creado en la Base de datos, Ejemplo: frmilla
,@UsuarioSimilar varchar(35) --Usuario con perfil similar
,@NombreUsuario varchar(100) --Nombre de nuevo Usuario
AS

BEGIN
	SET NOCOUNT ON;

INSERT INTO DDMENUES01
(USUARI01, KEYFOR01, SISTEM01, DESFOR01, CADENA01, GENERO01, NOMBRE01, MENSAJ01, PENSAR01) 
select 
USUARI01 = @Usuario,
KEYFOR01,
SISTEM01,
DESFOR01,
CADENA01,
GENERO01,
NOMBRE01 = @NombreUsuario,
MENSAJ01,
PENSAR01
from DDMENUES01 (nolock)
where SISTEM01 = 'SIDA' and USUARI01 = @UsuarioSimilar
and KEYFOR01 not in (select KEYFOR01 from DDMENUES01 where SISTEM01 = 'SIDA' and USUARI01 = @Usuario)

END

GO
/****** Object:  StoredProcedure [dbo].[TAR_ACUERDOS_TARIFARIOS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_ACUERDOS_TARIFARIOS] 
AS    
Select     
TIPDEP53=case when a.TIPDEP53='A' 
	          then 'DEPOSITO ADUANERO' 
	          else 'DEPOSITO SIMPLE' 
	          end,    
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,   
MONEDA=case when f.TIPMON54='D' 
		    then 'DOLARES' 
			else 'SOLES' 
			end,  
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' 
			    then c.TARIFA52 
			    else  c.TARIFA52S 
			    end,  
TARMIN52 = case when f.TIPMON54='D' 
				then c.TARMIN52 
				else  c.TARMIN52S 
				end,    
APLICA52=case when c.APLICA52='P' 
			  then 'PORCENTAJE' 
			  else case when c.aplica52='U' 
						then 'UNIDAD' 
						else 'MONTO' 
						end 
			  end,    
a.gloser53,    
CLAACU53=case when a.CLAACU53='D' 
			  then 'DESCUENTO' 
			  else 'INCREMENTO' 
			  end,    
VALACU53 = case when f.TIPMON54='D' 
				then a.VALACU53 
				else a.VALACU53S 
				end,    
TARMIN53 = case when f.TIPMON54='D' 
				then a.TARMIN53 
				else a.TARMIN53S 
				end,   
ESTADO53=case when a.ESTADO53='A' 
			  then 'ACTIVO' 
			  else 'INACTIVO' 
			  end,    
APLMIN53=case when a.APLMIN53='S' 
			  then 'SI' 
			  else 'NO' 
			  end,    
a.NUMACU53    
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
Order by TIPDEP53,b.nombre,c.desser52,a.NUMACU53  
  
  
GO
/****** Object:  StoredProcedure [dbo].[TAR_ACUERDOS_TARIFARIOS_NUEVO1]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_ACUERDOS_TARIFARIOS_NUEVO1] 
@CODCLIENTE VARCHAR(11),
@MONEDA VARCHAR(1),
@REGIMEN VARCHAR(1),
@CODSERVICIO VARCHAR(8)
AS 
BEGIN
SET NOCOUNT ON;  

SET @CODCLIENTE=LTRIM(RTRIM(@CODCLIENTE))
SET @CODSERVICIO=LTRIM(RTRIM(@CODSERVICIO)) 

Select TOP 1 a.TIPDEP53
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
--Order by TIPDEP53,b.nombre,c.desser52,a.NUMACU53  
SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[TAR_ACUERDOS_TARIFARIOS_NUEVO2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_ACUERDOS_TARIFARIOS_NUEVO2] 
@CODCLIENTE VARCHAR(11),
@MONEDA VARCHAR(1),
@REGIMEN VARCHAR(1),
@CODSERVICIO VARCHAR(8)
AS 

SET @CODCLIENTE=LTRIM(RTRIM(@CODCLIENTE))
SET @CODSERVICIO=LTRIM(RTRIM(@CODSERVICIO))
SET @MONEDA=LTRIM(RTRIM(@MONEDA))
SET @REGIMEN=LTRIM(RTRIM(@REGIMEN))

DECLARE @TEMP TABLE
(
TIPDEP53 VARCHAR(1),
TIPCLI53 VARCHAR(1),
CODCLI53 VARCHAR(11),
nombre VARCHAR(80),
TIPMON54 VARCHAR(1),
CODSER53 VARCHAR(8),
desser52 VARCHAR(60),
TIPMER72 VARCHAR(5),
desmer72 VARCHAR(30),
CODEMB06 VARCHAR(3),
desemb06 VARCHAR(100),
TARIFA52 DECIMAL(10,3),
TARMIN52 DECIMAL(10,3),
APLICA52 VARCHAR(1),
gloser53 VARCHAR(255),
CLAACU53 VARCHAR(1),
VALACU53 DECIMAL(15,3),
MINIMA DECIMAL(10,3),
ESTADO53 VARCHAR(1),
APLMIN53 VARCHAR(1),
NUMACU53 VARCHAR(3),
PERIODO INT,
OPCION VARCHAR(1),
MINDOL DECIMAL(10,3),
MINSOL DECIMAL(10,3)
)

INSERT INTO @TEMP(TIPDEP53,TIPCLI53,CODCLI53,nombre,TIPMON54,CODSER53,desser52,TIPMER72,desmer72,CODEMB06,desemb06,TARIFA52,
TARMIN52,APLICA52,gloser53,CLAACU53,VALACU53,MINIMA,ESTADO53,APLMIN53,NUMACU53,PERIODO,OPCION,MINDOL,MINSOL)

Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,    
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=case when f.TIPMON54='D'
			 then (case when isnull(a.TARMINP2,0) > 0
						then 1
						else 0
						end)
			 else (case when isnull(a.TARMINP2s,0) > 0
						then 1
						else 0
						end)
			end,
'0',
NULL,NULL   
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
--Order by TIPDEP53,b.nombre,c.desser52,a.NUMACU53  
/***** ESCALONADA 2 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,   
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=2,
'1',
a.TARMINP2,a.TARMINP2s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 3 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,   
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=3,
'1',
a.TARMINP3,a.TARMINP3s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 4 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,    
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=4,
'1',
a.TARMINP4,a.TARMINP4s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 5 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,   
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=5,
'1',
a.TARMINP5,a.TARMINP5s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 6 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,    
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=6,
'1',
a.TARMINP6,a.TARMINP6s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 7 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,   
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=7,
'1',
a.TARMINP7,a.TARMINP7s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 8 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,   
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=8,
'1',
a.TARMINP8,a.TARMINP8s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 9 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,    
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=9,
'1',
a.TARMINP9,a.TARMINP9s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 10 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,   
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=10,
'1',
a.TARMINP10,a.TARMINP10s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 11 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,   
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=11,
'1',
a.TARMINP11,a.TARMINP11s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)
/***** ESCALONADA 12 *******/
UNION ALL
Select     
a.TIPDEP53,   
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54,    
a.CODSER53,ltrim(rtrim(c.desser52)) as desser52,c.TIPMER72,ltrim(rtrim(d.desmer72)) as desmer72,c.CODEMB06,
ltrim(rtrim(e.desemb06)) as desemb06,  
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,  
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,    
c.APLICA52,
a.gloser53,    
a.CLAACU53,
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,    
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end,   
a.ESTADO53,   
a.APLMIN53,  
a.NUMACU53,
PERIODO=12,
'1',
a.TARMINP12,a.TARMINP12s  
From     
ddacuerd53 a, 
aaclientesaa b, 
ddservic52 c, 
DQTipMer72 d, 
DQEMBALA06 e, 
DDCLIMON54 f  
Where     
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy 
and f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 
and a.codser53=c.servic52 and a.tipdep53=c.deposi52 
and c.VISIBLE52='S' and a.ESTADO53='A' 
and c.tipmer72=d.tipmer72 
and c.codemb06=e.codemb06    
AND a.CODCLI53 LIKE '%' + @CODCLIENTE + '%'
AND f.TIPMON54 LIKE '%' + @MONEDA + '%'
AND a.TIPDEP53 LIKE '%' + @REGIMEN + '%'
AND a.CODSER53 LIKE '%' + @CODSERVICIO + '%'
AND a.CODSER53 LIKE 'ALMAN%'
AND (ISNULL(a.TARMINP2,0)>0 OR ISNULL(a.TARMINP2s,0)>0)


Select     
TIPDEP53=case when TIPDEP53='A' 
	          then 'DEPOSITO ADUANERO' 
	          else 'DEPOSITO SIMPLE' 
	          end,    
TIPCLI53,CODCLI53,nombre, TIPMON54,   
MONEDA=case when TIPMON54='D' 
		    then 'DOLARES' 
			else 'SOLES' 
			end,  
CODSER53,ltrim(rtrim(desser52)) as desser52,TIPMER72,ltrim(rtrim(desmer72)) as desmer72,CODEMB06,
ltrim(rtrim(desemb06)) as desemb06,  
TARIFA52,  
TARMIN52,    
APLICA52=case when APLICA52='P' 
			  then 'PORCENTAJE' 
			  else case when APLICA52='U' 
						then 'UNIDAD' 
						else 'MONTO' 
						end 
			  end,    
gloser53,    
CLAACU53=case when CLAACU53='D' 
			  then 'DESCUENTO' 
			  else 'INCREMENTO' 
			  end,    
VALACU53,    
TARMIN53 = case when OPCION='0' 
				then MINIMA
				else (CASE WHEN TIPMON54='D'
						   THEN MINDOL
						   ELSE MINSOL
						   END
					  )
				end,   
ESTADO53=case when ESTADO53='A' 
			  then 'ACTIVO' 
			  else 'INACTIVO' 
			  end,    
APLMIN53=case when APLMIN53='S' 
			  then 'SI' 
			  else 'NO' 
			  end, 
PERIODO1=CASE WHEN PERIODO=0 THEN '' ELSE CAST(PERIODO AS VARCHAR) END,    
NUMACU53    
FROM @TEMP
Order by TIPDEP53,nombre,desser52,NUMACU53,PERIODO 

GO
/****** Object:  StoredProcedure [dbo].[TAR_CALCULA_TIPO_CAMBIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[TAR_CALCULA_TIPO_CAMBIO]
@FECHA CHAR(8)
AS

  BEGIN	

	SELECT camleg28 fROM DQTIPCAM28 where fecfor28 = @FECHA
	
  END



GO
/****** Object:  StoredProcedure [dbo].[TAR_CERTIFICADO_EN_DESCUENTOS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[TAR_CERTIFICADO_EN_DESCUENTOS]
@TIPDEP CHAR(1),
@NUMCER VARCHAR(9)
AS

if @TIPDEP='S'
    Select feccer=a.feccer74, a.tipcli02, a.codcli02, b.nombre, flgval=a.flgval74 ,c.tipmon54
    From DDCerSim74 a, AAClientesAA b, DDCLIMON54 c
    Where a.flgval74='1' and a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
    c.TIPCLI54=a.tipcli02 and c.CODCLI54=a.codcli02 and
    a.numcer74=@NUMCER
else
    Select feccer=a.feccer13,a.tipcli02,a.codcli02,b.nombre, flgval=a.flgval13 ,c.tipmon54
    From DDCerAdu13 a,AAClientesAA b, DDCLIMON54 c
    Where a.flgval13='1' and a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
    c.TIPCLI54=a.tipcli02 and c.CODCLI54 =a.codcli02 and
    a.numcer13=@NUMCER


GO
/****** Object:  StoredProcedure [dbo].[TAR_COBRAR_ALMACENAJE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_COBRAR_ALMACENAJE]
@NUMCER VARCHAR(9)
AS
BEGIN

--rdelacuba 19/02/2007: Considerar filtro por el acuerdo para determinar activo e inactivo y no se dupliquen
--pero si no tiene acuerdo, entonces trabajarlo normalmente
DECLARE @acu varchar(3)
DECLARE @tipo char(1)
DECLARE @codigo varchar(11)
DECLARE @tipmon char(1)

if substring(@numcer,1,1)='A'
BEGIN

 SELECT @acu = ISNULL(numacu13,''),@tipo = ticlfa13, @codigo = coclfa13  FROM DDCerAdu13 (nolock) WHERE numcer13=@NUMCER
 SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo
 IF @acu <> ''
  BEGIN
    Select a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72,
    servic52=coalesce(d.servic52,''),
    aplica52=coalesce(d.aplica52,''), 
    tarifa52=coalesce(case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end,0),
    tarmin52=coalesce(case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end ,0),
    claacu53=coalesce((Select claacu53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and deposi52='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),''),
    tipacu53=coalesce((Select tipacu53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and deposi52='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),''),
    valacu53=coalesce((Select valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),0),
    aplmin53=coalesce((Select aplmin53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),'S'),
    tarmin53=coalesce((Select (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),'0'),   
    e.diaalm10,tipmon = @tipmon,        
    p1=coalesce((case when @tipmon = 'D' then f.p1 else f.p1s end),0),
    p2=coalesce((case when @tipmon = 'D' then f.p2 else f.p2s end),0),
    p3=coalesce((case when @tipmon = 'D' then f.p3 else f.p3s end),0),
    p4=coalesce((case when @tipmon = 'D' then f.p4 else f.p4s end),0),
    p5=coalesce((case when @tipmon = 'D' then f.p5 else f.p5s end),0),
    p6=coalesce((case when @tipmon = 'D' then f.p6 else f.p6s end),0),
    p7=coalesce((case when @tipmon = 'D' then f.p7 else f.p7s end),0),
    p8=coalesce((case when @tipmon = 'D' then f.p8 else f.p8s end),0),
    p9=coalesce((case when @tipmon = 'D' then f.p9 else f.p9s end),0),
    p10=coalesce((case when @tipmon = 'D' then f.p10 else f.p10s end),0),
    p11=coalesce((case when @tipmon = 'D' then f.p11 else f.p11s end),0),
    p12=coalesce((case when @tipmon = 'D' then f.p12 else f.p12s end),0),
    m1 = coalesce((case when @tipmon = 'D' then f.TARMINP1 else f.TARMINP1s end),0), 
    m2 = coalesce((case when @tipmon = 'D' then f.TARMINP2 else f.TARMINP2s end),0),
    m3 = coalesce((case when @tipmon = 'D' then f.TARMINP3 else f.TARMINP3s end ),0),
    m4 = coalesce((case when @tipmon = 'D' then f.TARMINP4 else f.TARMINP4s end ),0),
    m5 = coalesce((case when @tipmon = 'D' then f.TARMINP5 else f.TARMINP5s end ),0),
    m6 = coalesce((case when @tipmon = 'D' then f.TARMINP6 else f.TARMINP6s end ),0),
    m7 = coalesce((case when @tipmon = 'D' then f.TARMINP7 else f.TARMINP7s end ),0),
    m8 = coalesce((case when @tipmon = 'D' then f.TARMINP8 else f.TARMINP8s end ),0),
    m9 = coalesce((case when @tipmon = 'D' then f.TARMINP9 else f.TARMINP9s end ),0),
    m10 = coalesce((case when @tipmon = 'D' then f.TARMINP10 else f.TARMINP10s end ),0),
    m11 = coalesce((case when @tipmon = 'D' then f.TARMINP11 else f.TARMINP11s end ),0),
    m12 = coalesce((case when @tipmon = 'D' then f.TARMINP12 else f.TARMINP12s end ),0),

    isnull(f.TARESCA53,0) TARESC
    
    From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d,DDsoladu10 e, ddacuerd53 f
    Where a.numcer13=@NUMCER and 
    a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and 
    (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and
    d.status52='A' and d.visible52='S' and (d.concep51='ALMAN' or d.concep51='ALMVE') and d.aplica52=e.cobalm10 and 
    e.numsol10=a.numsol10 and e.cobalm10=d.aplica52 and deposi52='A' and    
    a.numacu13 = f.NUMACU53 and d.servic52=f.codser53 and d.deposi52=f.tipdep53 and f.estado53 = 'A' and 
    f.tipcli53 = a.tipcli02 and f.codcli53 = a.codcli02 and f.tipdep53 = 'A' 
    order by b.numser12
  END
  ELSE
  BEGIN
    Select a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72,
    servic52=coalesce(d.servic52,''),
    aplica52=coalesce(d.aplica52,''),
    tarifa52=coalesce( (case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end) ,0),    claacu53=coalesce((Select claacu53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and deposi52='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),''),    
    tipacu53=coalesce((Select tipacu53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and deposi52='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),''),  
    valacu53=coalesce((Select valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),0),   
    aplmin53=coalesce((Select aplmin53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),'S'),
    tarmin53=coalesce((Select (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and numacu53=a.numacu13 and aplica52=e.cobalm10 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),'0'),
    e.diaalm10,tipmon = @tipmon,
    p1 ='',    p2 ='',    p3 ='',    p4 ='',    p5 ='',    p6 ='',    p7 ='',    p8 ='',    p9 ='',    p10 ='',    p11 ='',     p12 ='',
    m1 ='',    m2 ='',    m3 ='',    m4 ='',    m5 ='',    m6 ='',    m7 ='',    m8 ='',    m9 ='',    m10 ='',    m11 ='',     m12 ='',
 -- Tarifa Escalonada
    /*p1=coalesce(case when @tipmon = 'D' then d.p1 else d.p1s end,0),
    p2=coalesce(case when @tipmon = 'D' then d.p2 else d.p2s end,0),
    p3=coalesce(case when @tipmon = 'D' then d.p3 else d.p3s end,0),
    p4=coalesce(case when @tipmon = 'D' then d.p4 else d.p4s end,0),
    p5=coalesce(case when @tipmon = 'D' then d.p5 else d.p5s end,0),
p6=coalesce(case when @tipmon = 'D' then d.p6 else d.p6s end,0),
    p7=coalesce(case when @tipmon = 'D' then d.p7 else d.p7s end,0),
    p8=coalesce(case when @tipmon = 'D' then d.p8 else d.p8s end,0),
    p9=coalesce(case when @tipmon = 'D' then d.p9 else d.p9s end,0),
    p10=coalesce(case when @tipmon = 'D' then d.p10 else d.p10s end,0),
    p11=coalesce(case when @tipmon = 'D' then d.p11 else d.p11s end,0),
    p12=coalesce(case when @tipmon = 'D' then d.p12 else d.p12s end,0),

    m1 = coalesce(case when @tipmon = 'D' then d.TARMINP1 else d.TARMINP1s end ,0),
    m2 = coalesce(case when @tipmon = 'D' then d.TARMINP2 else d.TARMINP2s end ,0),
    m3 = coalesce(case when @tipmon = 'D' then d.TARMINP3 else d.TARMINP3s end ,0),
    m4 = coalesce(case when @tipmon = 'D' then d.TARMINP4 else d.TARMINP4s end ,0),
    m5 = coalesce(case when @tipmon = 'D' then d.TARMINP5 else d.TARMINP5s end ,0),
    m6 = coalesce(case when @tipmon = 'D' then d.TARMINP6 else d.TARMINP6s end ,0),
    m7 = coalesce(case when @tipmon = 'D' then d.TARMINP7 else d.TARMINP7s end ,0),
    m8 = coalesce(case when @tipmon = 'D' then d.TARMINP8 else d.TARMINP8s end ,0),
    m9 = coalesce(case when @tipmon = 'D' then d.TARMINP9 else d.TARMINP9s end ,0),
    m10 = coalesce(case when @tipmon = 'D' then d.TARMINP10 else d.TARMINP10s end ,0),
    m11 = coalesce(case when @tipmon = 'D' then d.TARMINP11 else d.TARMINP11s end ,0),
    m12 = coalesce(case when @tipmon = 'D' then d.TARMINP12 else d.TARMINP12s end ,0),
    isnull(d.TARESC533,0) TARESC*/
    TARESC = 0 
    From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d,DDsoladu10 e
    Where a.numcer13=@NUMCER and 
    a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and 
    (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and
    d.status52='A' and d.visible52='S' and (d.concep51='ALMAN' or d.concep51='ALMVE') and d.aplica52=e.cobalm10 and 
    e.numsol10=a.numsol10 and e.cobalm10=d.aplica52 and deposi52='A'  
    order by b.numser12
  END
END
else
BEGIN

  SELECT @acu = ISNULL(numacu74,''), @tipo = ticlfa74, @codigo = coclfa74  FROM DDCerSim74 (nolock) WHERE numcer74=@NUMCER
  SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo
  IF @acu <> ''
  BEGIN
    Select a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,
    servic52=coalesce(d.servic52,''),
    aplica52=coalesce(d.aplica52,''),
    tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),    
    claacu53=coalesce((Select claacu53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52  and estado53='A' and deposi52='S' and numacu53=a.numacu74 and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),''),
    tipacu53=coalesce((Select tipacu53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52  and estado53='A' and deposi52='S' and numacu53=a.numacu74 and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),''),
    valacu53=coalesce((Select valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and numacu53=a.numacu74 and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),0),
    aplmin53=coalesce((Select aplmin53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and numacu53=a.numacu74 and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),'S'),
    tarmin53=coalesce((Select (case when @tipmon = 'D' then tarmin53 else tarmin53s end)  from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and numacu53=a.numacu74 and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),'0'),
    e.diaalm62,tipmon = @tipmon,
    p1=coalesce((case when @tipmon = 'D' then f.p1 else f.p1s end),0),
    p2=coalesce((case when @tipmon = 'D' then f.p2 else f.p2s end),0),
    p3=coalesce((case when @tipmon = 'D' then f.p3 else f.p3s end),0),
    p4=coalesce((case when @tipmon = 'D' then f.p4 else f.p4s end),0),
    p5=coalesce((case when @tipmon = 'D' then f.p5 else f.p5s end),0),
    p6=coalesce((case when @tipmon = 'D' then f.p6 else f.p6s end),0),
    p7=coalesce((case when @tipmon = 'D' then f.p7 else f.p7s end),0),
    p8=coalesce((case when @tipmon = 'D' then f.p8 else f.p8s end),0),    
    p9=coalesce((case when @tipmon = 'D' then f.p9 else f.p9s end),0),    
    p10=coalesce((case when @tipmon = 'D' then f.p10 else f.p10s end),0),    
    p11=coalesce((case when @tipmon = 'D' then f.p11 else f.p11s end),0),    
    p12=coalesce((case when @tipmon = 'D' then f.p12 else f.p12s end),0),              
    m1=coalesce((case when @tipmon = 'D' then f.TARMINP1 else f.TARMINP1s end),0),              
    m2 = coalesce((case when @tipmon = 'D' then f.TARMINP2 else f.TARMINP2s end ),0),              
    m3 = coalesce((case when @tipmon = 'D' then f.TARMINP3 else f.TARMINP3s end ),0),              
    m4 = coalesce((case when @tipmon = 'D' then f.TARMINP4 else f.TARMINP4s end ),0),              
    m5 = coalesce((case when @tipmon = 'D' then f.TARMINP5 else f.TARMINP5s end ),0),              
    m6 = coalesce((case when @tipmon = 'D' then f.TARMINP6 else f.TARMINP6s end ),0),              
    m7 = coalesce((case when @tipmon = 'D' then f.TARMINP7 else f.TARMINP7s end ),0),              
    m8 = coalesce((case when @tipmon = 'D' then f.TARMINP8 else f.TARMINP8s end ),0),              
    m9 = coalesce((case when @tipmon = 'D' then f.TARMINP9 else f.TARMINP9s end ),0),              
    m10 = coalesce((case when @tipmon = 'D' then f.TARMINP10 else f.TARMINP10s end ),0),              
    m11 = coalesce((case when @tipmon = 'D' then f.TARMINP11 else f.TARMINP11s end ),0),              
    m12 = coalesce((case when @tipmon = 'D' then f.TARMINP12 else f.TARMINP12s end ),0),              
    isnull(f.TARESCA53,0) TARESC
    From DDCerSim74 a,DDDSoSim67 b,DDservic52 d,DDsolsim62 e, ddacuerd53 f
    Where a.numcer74=@NUMCER and a.numsol62=e.numsol62 and e.numsol62=b.numsol62 and 
    (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and
    d.status52='A' and d.visible52='S' and (d.concep51='ALMAN' or d.concep51='ALMVE') and d.aplica52=e.cobalm62 and 
    deposi52='S' and
    a.numacu74 = f.NUMACU53 and d.servic52=f.codser53 and f.estado53 = 'A' and 
    f.tipcli53 = a.tipcli02 and f.codcli53 = a.codcli02  
     and f.TIPDEP53 = 'S' --'Rtello
    order by b.numser67
  END
  ELSE
  BEGIN
    Select a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,
    servic52=coalesce(d.servic52,''),
    aplica52=coalesce(d.aplica52,''),
    tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),
    claacu53=coalesce((Select claacu53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52  and estado53='A' and deposi52='S' and numacu53=a.numacu74 and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),''),
    tipacu53=coalesce((Select tipacu53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52  and estado53='A' and deposi52='S' and numacu53=a.numacu74 and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),''),
    valacu53=coalesce((Select valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and numacu53=a.numacu74    and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),0),
    aplmin53=coalesce((Select aplmin53 from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and numacu53=a.numacu74 and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),'S'),
    tarmin53=coalesce((Select (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from TARIFAS_CERTIFICADO where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and numacu53=a.numacu74 and aplica52=e.cobalm62 and (codser53 like 'ALMAN%' or codser53 like 'ALMVE%')),'0'),
    e.diaalm62,tipmon = @tipmon,
    p1 ='',    p2 ='',    p3 ='',    p4 ='',    p5 ='',    p6 ='',    p7 ='',    p8 ='',    p9 ='',    p10 ='',    p11 ='',     p12 ='',
    m1 ='',    m2 ='',    m3 ='',    m4 ='',    m5 ='',    m6 ='',    m7 ='',    m8 ='',    m9 ='',    m10 ='',    m11 ='',     m12 ='',
/*    p1=coalesce((case when @tipmon = 'D' then d.p1 else d.p1s end),0),
    p2=coalesce((case when @tipmon = 'D' then d.p2 else d.p2s end),0),
    p3=coalesce((case when @tipmon = 'D' then d.p3 else d.p3s end),0),
    p4=coalesce((case when @tipmon = 'D' then d.p4 else d.p4s end),0),
    p5=coalesce((case when @tipmon = 'D' then d.p5 else d.p5s end),0),
    p6=coalesce((case when @tipmon = 'D' then d.p6 else d.p6s end),0),
    p7=coalesce((case when @tipmon = 'D' then d.p7 else d.p7s end),0),
    p8=coalesce((case when @tipmon = 'D' then d.p8 else d.p8s end),0),    
    p9=coalesce((case when @tipmon = 'D' then d.p9 else d.p9s end),0),    
    p10=coalesce((case when @tipmon = 'D' then d.p10 else d.p10s end),0),    
    p11=coalesce((case when @tipmon = 'D' then d.p11 else d.p11s end),0),    
    p12=coalesce((case when @tipmon = 'D' then d.p12 else d.p12s end),0),              
  
    m1=coalesce((case when @tipmon = 'D' then d.TARMINP1 else d.TARMINP1s end),0),              
    m2 = coalesce((case when @tipmon = 'D' then d.TARMINP2 else d.TARMINP2s end ),0),     
    m3 = coalesce((case when @tipmon = 'D' then d.TARMINP3 else d.TARMINP3s end ),0),              
    m4 = coalesce((case when @tipmon = 'D' then d.TARMINP4 else d.TARMINP4s end ),0),              
    m5 = coalesce((case when @tipmon = 'D' then d.TARMINP5 else d.TARMINP5s end ),0),              
    m6 = coalesce((case when @tipmon = 'D' then d.TARMINP6 else d.TARMINP6s end ),0),              
    m7 = coalesce((case when @tipmon = 'D' then d.TARMINP7 else d.TARMINP7s end ),0),              
    m8 = coalesce((case when @tipmon = 'D' then d.TARMINP8 else d.TARMINP8s end ),0),              
    m9 = coalesce((case when @tipmon = 'D' then d.TARMINP9 else d.TARMINP9s end ),0),              
    m10 = coalesce((case when @tipmon = 'D' then d.TARMINP10 else d.TARMINP10s end ),0),              
    m11 = coalesce((case when @tipmon = 'D' then d.TARMINP11 else d.TARMINP11s end ),0),              
    m12 = coalesce((case when @tipmon = 'D' then d.TARMINP12 else d.TARMINP12s end ),0),              

  */
    TARESC = 0
    From DDCerSim74 a,DDDSoSim67 b,DDservic52 d,DDsolsim62 e
    Where a.numcer74=@NUMCER and a.numsol62=e.numsol62 and e.numsol62=b.numsol62 and 
    (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and
    d.status52='A' and d.visible52='S' and (d.concep51='ALMAN' or d.concep51='ALMVE') and d.aplica52=e.cobalm62 and 
    deposi52='S' 
    order by b.numser67
  END
END

END 






GO
/****** Object:  StoredProcedure [dbo].[TAR_COBRAR_ALMACENAJE_SER]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.TAR_COBRAR_ALMACENAJE_SER    Script Date: 08-09-2002 08:44:15 PM ******/
ALTER PROCEDURE [dbo].[TAR_COBRAR_ALMACENAJE_SER]
@NUMCER varchar(11)
AS



if substring(@numcer,1,1)='A'
    Select b.numser12, b.numbul14,b.valtar14,c.cobalm10
    From DDCerAdu13 a, DDDCeAdu14 b, DDSolAdu10 c
    Where a.numcer13=@NUMCER and 

    a.numcer13=b.numcer13 and a.numsol10=c.numsol10
else
    Select numser12=b.numser67, numbul14=b.numbul67,valtar14=b.valtar67,cobalm10=c.cobalm62
    From DDCerSim74 a, DDDSoSim67 b, DDSolSim62 c
    Where a.numcer74=@NUMCER and 

    a.numsol62=b.numsol62 and a.numsol62=c.numsol62
GO
/****** Object:  StoredProcedure [dbo].[TAR_COBRAR_GASTO_ADMINISTRATIV]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_COBRAR_GASTO_ADMINISTRATIV]             
@NUMCER VARCHAR(9)            
AS            
DECLARE @tipo char(1)            
DECLARE @codigo varchar(11)            
DECLARE @tipmon char(1)            
DECLARE @acu varchar(3)       
            
if substring(@NUMCER,1,1)='A'            
BEGIN             
 SELECT @tipo = ticlfa13, @codigo = coclfa13, @acu = ISNULL(numacu13,'')  FROM DDCerAdu13 (nolock) WHERE numcer13=@NUMCER            
 SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo            
    /*      
    IF @acu <> ''      
    BEGIN      
     Select a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72          
  ,servic52=coalesce(d.servic52,'')          
  ,aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0)          
  ,claacu53=coalesce((Select Distinct claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'')          
  ,tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'')          
  ,valacu53=coalesce((Select TOP 1 valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcl
i53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),0)          
  ,aplmin53=coalesce((Select TOP 1 aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'S')          
  ,tarmin53=coalesce((Select TOP 1 (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'0')     
       
   From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d      
   --|RETORNE EL GASTO ADMINISTRATIVO DE LA CARGA SEGUN EL ACUERDO       
   ,ddacuerd53 e             
   Where a.numcer13=@NUMCER and   exists (select 1  from DDacuerd53 ad where ad.codcli53 = a.codcli02 and d.Servic52 = ad.codSer53) and            
   a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and              
   (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and             
   d.status52='A' and d.visible52='S' and d.concep51='GASAD' and deposi52='A'      
   --|VALIDACIONES            
   and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02               
   and e.codser53=d.servic52 and e.tipdep53=d.deposi52            
   union all            
   select 4 ,'' as CodCli02 , '' as numser12 , 0 as numbul14 , '' as Codemb06             
   , '' as tipmer72 ,SERVIC52 as servic52 , 'P' as aplica52,             
   tarifa52=coalesce((case when @tipmon = 'D' then TARIFA52 else TARIFA52S end),0),            
   tarmin52=coalesce((case when @tipmon = 'D' then TARMIN52 else TARMIN52S end),0), '' as claacu53, '' as tipacu53 , 0 as  valacu53 ,  '' as  aplmin53,            
   tarmin52=coalesce((case when @tipmon = 'D' then TARMIN52 else TARMIN52S end),0)            
   from DDservic52 where SERVIC52 like 'GASAD001%' and Deposi52 = 'A'        
    END      
    ELSE      
    BEGIN       
    */     
  
  Select a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72          
  ,servic52=coalesce(d.servic52,'')          
  ,aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0)          
  ,claacu53=coalesce((Select Distinct claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'')          
  ,tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'')          
  ,valacu53=coalesce((Select TOP 1 valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),0)          
  ,aplmin53=coalesce((Select TOP 1 aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'S')          
  ,tarmin53=coalesce((Select TOP 1 (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'0')     
       
   From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d      
   --|RETORNE EL GASTO ADMINISTRATIVO DE LA CARGA SEGUN EL ACUERDO       
   ,ddacuerd53 e             
   Where a.numcer13=@NUMCER and   exists (select 1  from DDacuerd53 ad where ad.codcli53 = a.codcli02 and d.Servic52 = ad.codSer53) and            
   a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and              
   (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and             
   d.status52='A' and d.visible52='S' and d.concep51='GASAD' and deposi52='A'      
   --|VALIDACIONES            
   and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02               
   and e.codser53=d.servic52 and e.tipdep53=d.deposi52  
  
  union all 
      
  Select a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72          
  ,servic52=coalesce(d.servic52,'')          
  ,aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0)          
  ,claacu53=coalesce((Select Distinct claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'')          
  ,tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'')          
  ,valacu53=coalesce((Select TOP 1 valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),0)          
  ,aplmin53=coalesce((Select TOP 1 aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'S')          
  ,tarmin53=coalesce((Select TOP 1 (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'0')     
      
   From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d            
   Where a.numcer13=@NUMCER and   exists (select 1  from DDacuerd53 ad where ad.codcli53 = a.codcli02 and d.Servic52 = ad.codSer53) and            
   a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and              
   (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and             
   d.status52='A' and d.visible52='S' and d.concep51='GASAD' and deposi52='A'            
   union all            
   select 4 ,'' as CodCli02 , '' as numser12 , 0 as numbul14 , '' as Codemb06             
   , '' as tipmer72 ,SERVIC52 as servic52 , 'P' as aplica52,             
   tarifa52=coalesce((case when @tipmon = 'D' then TARIFA52 else TARIFA52S end),0),            
   tarmin52=coalesce((case when @tipmon = 'D' then TARMIN52 else TARMIN52S end),0), '' as claacu53, '' as tipacu53 , 0 as  valacu53 ,  '' as  aplmin53,            
   tarmin52=coalesce((case when @tipmon = 'D' then TARMIN52 else TARMIN52S end),0)            
   from DDservic52 where SERVIC52 like 'GASAD001%' and Deposi52 = 'A'        
 --END            
END            
ELSE            
  BEGIN            
            
     SELECT @tipo = ticlfa74, @codigo = coclfa74, @acu = ISNULL(numacu74,'')  FROM DDCerSim74 (nolock) WHERE numcer74=@NUMCER            
     SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo            
    /*       
     IF @acu <> ''      
     BEGIN      
   Select a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,            
   servic52=coalesce(d.servic52,''),            
   aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),            
   claacu53=coalesce((Select claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),''),            
   tipacu53=coalesce((Select tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),''),            
   valacu53=coalesce((Select TOP 1 valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcl
i53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),0),            
   aplmin53=coalesce((Select TOP 1 aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),'S'),            
   tarmin53=coalesce((Select TOP 1 (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),'0')     
  
    
   From DDCerSim74 a,DDDSoSim67 b,DDservic52 d      
   --|RETORNE EL GASTO ADMINISTRATIVO DE LA CARGA SEGUN EL ACUERDO       
   ,ddacuerd53 e             
   Where a.numcer74=@NUMCER and a.numsol62=b.numsol62 and             
   (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and            
   d.status52='A' and d.visible52='S' and d.concep51='GASAD' and deposi52='S'       
   --|VALIDACIONES            
   and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02               
   and e.codser53=d.servic52 and e.tipdep53=d.deposi52         
     END      
     ELSE      
     BEGIN      
     */    
   
   Select a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,            
   servic52=coalesce(d.servic52,''),            
   aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),            
   claacu53=coalesce((Select claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),''),            
   tipacu53=coalesce((Select tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),''),            
   valacu53=coalesce((Select TOP 1 valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),0),            
   aplmin53=coalesce((Select TOP 1 aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),'S'),            
   tarmin53=coalesce((Select TOP 1 (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),'0')     
  
    
   From DDCerSim74 a,DDDSoSim67 b,DDservic52 d      
   --|RETORNE EL GASTO ADMINISTRATIVO DE LA CARGA SEGUN EL ACUERDO       
   ,ddacuerd53 e             
   Where a.numcer74=@NUMCER and a.numsol62=b.numsol62 and             
   (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and            
   d.status52='A' and d.visible52='S' and d.concep51='GASAD' and deposi52='S'       
   --|VALIDACIONES            
   and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02               
   and e.codser53=d.servic52 and e.tipdep53=d.deposi52 
   
   union all
     
   Select a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,            
   servic52=coalesce(d.servic52,''),            
   aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),            
   claacu53=coalesce((Select claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),''),            
   tipacu53=coalesce((Select tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),''),            
   valacu53=coalesce((Select TOP 1 valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),0),            
   aplmin53=coalesce((Select TOP 1 aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),'S'),            
   tarmin53=coalesce((Select TOP 1 (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),'0')     
  
   From DDCerSim74 a,DDDSoSim67 b,DDservic52 d            
   Where a.numcer74=@NUMCER and a.numsol62=b.numsol62 and             
   (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and            
   d.status52='A' and d.visible52='S' and d.concep51='GASAD' and deposi52='S'          
     --END      
END 
GO
/****** Object:  StoredProcedure [dbo].[TAR_COBRAR_SEGURO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_COBRAR_SEGURO]                           
@NUMCER VARCHAR(9)                          
AS                          
                          
DECLARE @tipo char(1)                          
DECLARE @codigo varchar(11)                          
DECLARE @tipmon char(1)                
DECLARE @acu varchar(3)                          
                          
if substring(@NUMCER,1,1)='A'                          
BEGIN                           
     SELECT @tipo = ticlfa13, @codigo = coclfa13, @acu = ISNULL(numacu13,'')  FROM DDCerAdu13 (nolock) WHERE numcer13=@NUMCER                          
     SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo                          
     /*              
     IF @acu <> ''              
     BEGIN              
     Select                           
     a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72,                          
     servic52=coalesce(d.servic52,''),                          
     aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end) ,0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),                          
     claacu53=coalesce((Select Distinct claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),                          
     tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),                          
     valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and 
codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),0),      aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52   
     and  estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'S'),                          
     tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end)  from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'0'
),                   
     tipmon =  @tipmon                          
     From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d                   
     --RETORNE EL SEGURO DE LA CARGA SEGUN EL ACUERDO                  
     ,ddacuerd53 e                         
     Where a.numcer13=@NUMCER and                           
     a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and                           
     (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and                          
     d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='A'                   
     --VALIDACIONES                  
     and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02                     
     and e.codser53=d.servic52 and e.tipdep53=d.deposi52               
     END              
     ELSE              
     BEGIN               
     */                
   Select                           
   a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72,                          
   servic52=coalesce(d.servic52,''),                          
   aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end) ,0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),                          
   claacu53=coalesce((Select Distinct claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),                          
   tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),                  
   valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),0),      aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 
   where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and  estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'S'),                          
   tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end)  from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'0'),
                      
   tipmon =  @tipmon                          
   From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d                   
   --RETORNE EL SEGURO DE LA CARGA SEGUN EL ACUERDO                  
   ,ddacuerd53 e                         
   Where a.numcer13=@NUMCER and                           
   a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and                           
   (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and                          
   d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='A'           
   --order by d.SERVIC52 asc                
   --VALIDACIONES                  
   and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02                     
   and e.codser53=d.servic52 and e.tipdep53=d.deposi52     
     
   union all  
     
   Select                           
   a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72,                          
   servic52=coalesce(d.servic52,''),                          
   aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end) ,0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),                          
   claacu53=coalesce((Select Distinct claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),                          
   tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),                  
   valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 
   where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),0),      aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and  estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'S'),                          
   tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end)  from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'0'),                    
   tipmon =  @tipmon                          
   From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d                   
   --RETORNE EL SEGURO DE LA CARGA SEGUN EL ACUERDO                  
   --,ddacuerd53 e                         
   Where a.numcer13=@NUMCER and                           
   a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and                           
   (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and                          
   d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='A'           
   --order by d.SERVIC52 asc                
   --VALIDACIONES                  
   --and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02                     
   --and e.codser53=d.servic52 and e.tipdep53=d.deposi52    
               
 --END                        
END                          
ELSE                         
BEGIN                          
     SELECT @tipo = ticlfa74, @codigo = coclfa74, @acu = ISNULL(numacu74,'')  FROM DDCerSim74 (nolock) WHERE numcer74=@NUMCER                          
     SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo                          
     /*              
     IF @acu <> ''              
     BEGIN              
       Select a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,                          
    servic52=coalesce(d.servic52,''),                          
    aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),                          
    claacu53=coalesce((Select Distinct  claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),                          
    tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),                          
    valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02   
    and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),0),      aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic5
2   
    and  estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'S'),                          
    tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'0'),
                       
    tipmon =  @tipmon                          
    From DDCerSim74 a,DDDSoSim67 b,DDservic52 d                   
    --RETORNE EL SEGURO DE LA CARGA SEGUN EL ACUERDO                  
    ,ddacuerd53 e                            
    Where a.numcer74=@NUMCER and a.numsol62=b.numsol62 and                           
    (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and                          
    d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='S'              
    --VALIDACIONES                  
    and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02                     
    and e.codser53=d.servic52 and e.tipdep53=d.deposi52               
     END              
     ELSE              
     BEGIN             
     */                  
   Select a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,                          
   servic52=coalesce(d.servic52,''),                          
   aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),                          
   claacu53=coalesce((Select Distinct  claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),                          
   tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),                          
   valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),0),      aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and  estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'S'),                          
   tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'0'), 
                     
   tipmon =  @tipmon                          
   From DDCerSim74 a,DDDSoSim67 b,DDservic52 d                   
   --RETORNE EL SEGURO DE LA CARGA SEGUN EL ACUERDO                  
   ,ddacuerd53 e                            
   Where a.numcer74=@NUMCER and a.numsol62=b.numsol62 and                           
   (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and                          
   d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='S'         
   --order by d.SERVIC52 asc                    
   --VALIDACIONES                  
   and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02                     
   and e.codser53=d.servic52 and e.tipdep53=d.deposi52  
     
   union all  
     
   Select a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,                          
   servic52=coalesce(d.servic52,''),                          
   aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),                          
   claacu53=coalesce((Select Distinct  claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),                          
   tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),                          
   valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),0),      aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and  estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'S'),                          
   tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'0'), 
                     
   tipmon =  @tipmon                          
   From DDCerSim74 a,DDDSoSim67 b,DDservic52 d                   
   --RETORNE EL SEGURO DE LA CARGA SEGUN EL ACUERDO                  
   --,ddacuerd53 e                            
   Where a.numcer74=@NUMCER and a.numsol62=b.numsol62 and                           
   (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and                          
   d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='S'         
   --order by d.SERVIC52 asc                    
   --VALIDACIONES                  
   --and e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02                     
   --and e.codser53=d.servic52 and e.tipdep53=d.deposi52                       
     --END                 
END 
GO
/****** Object:  StoredProcedure [dbo].[TAR_COBRAR_SEGURO_PRUEBA_F]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_COBRAR_SEGURO_PRUEBA_F]                     
@NUMCER VARCHAR(9)                    
AS                    
                    
DECLARE @tipo char(1)                    
DECLARE @codigo varchar(11)                    
DECLARE @tipmon char(1)          
DECLARE @acu varchar(3)                    
                    
if substring(@NUMCER,1,1)='A'                    
BEGIN                     
     SELECT @tipo = ticlfa13, @codigo = coclfa13, @acu = ISNULL(numacu13,'')  FROM DDCerAdu13 (nolock) WHERE numcer13=@NUMCER                    
     SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo                    
    
   Select                     
   a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72,                    
   servic52=coalesce(d.servic52,''),                    
   aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end) ,0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),                    
   claacu53=coalesce((Select Distinct claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),                    
   tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),            
   valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),0),      aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and  estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'S'),                    
   tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end)  from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'0'),
             
   tipmon =  @tipmon                    
   From DDCerAdu13 a
   INNER JOIN DDDCeAdu14 b with (nolock) on a.numcer13=b.numcer13
   inner join DDSerDep12 c with (nolock) on a.numsol10=c.numsol10 and b.numser12=c.numser12 
   inner join DDservic52 d with (nolock) on (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS')            
   --RETORNE EL SEGURO DE LA CARGA SEGUN EL ACUERDO            
   left join ddacuerd53 e  with (nolock) on (e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02               
   and e.codser53=d.servic52 and e.tipdep53=d.deposi52)                 
   Where a.numcer13=@NUMCER and                                                       
   d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='A'               
   --VALIDACIONES            
   --and          
 --END                  
END                    
ELSE                   
BEGIN                    
     SELECT @tipo = ticlfa74, @codigo = coclfa74, @acu = ISNULL(numacu74,'')  FROM DDCerSim74 (nolock) WHERE numcer74=@NUMCER                    
     SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo                    
    
   Select a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,                    
   servic52=coalesce(d.servic52,''),                    
   aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),                    
   claacu53=coalesce((Select Distinct  claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),                    
   tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),                    
   valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),0),      aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and  estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'S'),                    
   tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'0'), 
                
   tipmon =  @tipmon                    
   From DDCerSim74 a
   inner join DDDSoSim67 b with (nolock) on a.numsol62=b.numsol62
   inner join DDservic52 d with (nolock) on (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS')            
   --RETORNE EL SEGURO DE LA CARGA SEGUN EL ACUERDO            
   left join ddacuerd53 e with (nolock) on (e.tipcli53=a.tipcli02 and e.codcli53=a.codcli02               
   and e.codser53=d.servic52 and e.tipdep53=d.deposi52)                      
   Where a.numcer74=@NUMCER and                                     
   d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='S'                
   --VALIDACIONES            
   --and                
     --END           
END 
GO
/****** Object:  StoredProcedure [dbo].[TAR_ENTREGAS_X_SERIE_DEPOSIT_A]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.TAR_ENTREGAS_X_SERIE_DEPOSIT_A    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[TAR_ENTREGAS_X_SERIE_DEPOSIT_A]
@NUMCER VARCHAR(9),
@FECINI CHAR(8)
AS



Select 
b.numcer13,b.numser70,numbul80=SUM(b.numbul80)
From 
DDEntMer79 a,DDDEnMer80 b,DDTicket01 c
Where 
a.nument79=b.nument79 and a.nument79=c.numgui01 and c.tipope01='R' and 
b.numcer13=@NUMCER and convert(char(8),c.fecsal01,112) < @FECINI
Group by 
b.numcer13,b.numser70
GO
/****** Object:  StoredProcedure [dbo].[TAR_FACTURAS_FACTURAR]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_FACTURAS_FACTURAR]          
@DEPADU VARCHAR(3),          
@DEPSIM VARCHAR(3),          
@PORCER VARCHAR(3),          
@PORCLI VARCHAR(3),          
@NUMCER VARCHAR(9),          
@TIPCLI VARCHAR(3),          
@CODCLI VARCHAR(13),        
@FECSER VARCHAR(8) = ''        
AS          
IF @FECSER <> ''        
  BEGIN        
 SET @FECSER = CONVERT(VARCHAR,DATEADD(DAY,1,CONVERT(DATETIME,@FECSER)),112)        
  END        
        
Declare @SelectA1 varchar(255)           
Declare @SelectA2 varchar(255)          
Declare @SelectA3 varchar(255)          
Declare @FromA1 varchar(255)          
Declare @WhereA1 varchar(500)          
Declare @WhereA2 varchar(255)          
Declare @Union varchar(50)          
Declare @SelectS1 varchar(255)          
Declare @SelectS2 varchar(255)          
Declare @SelectS3 varchar(255)          
Declare @SelectS4 varchar(255)          
Declare @FromS1 Varchar(255)          
Declare @WhereS1 varchar(500)          
Declare @WhereS2 varchar(255)          
Declare @WhereS3 varchar(500)        
          
Select @SelectA1 =''           
Select @SelectA2 =''           
Select @SelectA3 =''           
Select @FromA1 =''           
Select @WhereA1 =''           
Select @WhereA2 =''           
Select @Union =''           
Select @SelectS1 =''           
Select @SelectS2 =''           
Select @SelectS3 =''           
Select @SelectS4 =''           
Select @FromS1 =''           
Select @WhereS1 =''           
Select @WhereS2 =''           
Select @WhereS3 = ''        
        
--Este SP Selecciona todos aquellos Certificados que aun deben ser Facturados          
          
If @DEPADU='1'          
Begin          
    Select @SelectA1='Select a.numcer13,a.numdui11,a.numsol10,a.perfac13,a.inifac13,a.finalm13,a.ultent13,a.numbul13,a.cifcer13,a.pescer13,a.flgtar13,a.numtar68,a.finser13,a.ultfac13,'          
    Select @SelectA2='tipcli02C=a.tipcli02,codcli02C=a.codcli02,tipcli02=a.ticlfa13,codcli02=a.coclfa13,b.nombre,b.direccion,FLGHOR02=substring(b.cadena,11,1),TOLHOR02=b.diasabast,FACHOR02=b.diaspromat,'          
    Select @SelectA3='c.diaalm10,c.segnep10,c.porseg10,c.desmer10,c.faccom10,c.conemb10,CERADU74='''''           
    Select @FromA1='From DDCerAdu13 a,AAClientesAA b,DDSolAdu10 c '          
--    Select @WhereA1='Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and  a.numsol10=c.numsol10 and a.flgval13='1' and a.flgfac13='1' and substring(b.cadena,12,1)='1' and a.finser13='0' and a.flstfa13='N' '          
    --Select @WhereA1='Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and a.numsol10=c.numsol10 and a.flgval13=''1'' and substring(b.cadena,12,1)=''1'' and a.finser13=''0'' and a.flstfa13=''N''  and a.numsol10 not in (Select a.numsol10 From ddceradu13 a,ddcabcom52 b where a.numcer13=b.numcer52 and b.flgval52=''1'' and flstfa13=''S'') and b.contribuy not in (select contribuy from DQCLIPROY00) '       
    Select @WhereA1='Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and a.numsol10=c.numsol10 and a.flgval13=''1'' and substring(b.cadena,12,1)=''1'' and a.flstfa13=''N''  and a.numsol10 not in (Select a.numsol10 From ddceradu13 a,ddcabcom52 b where a.numcer13=b.numcer52 and b.flgval52=''1'' and flstfa13=''S'') and b.contribuy not in (select contribuy from DQCLIPROY00) '       
          
    IF @PORCER='1'          
        Select @WhereA2=' and a.numcer13=''' + @NUMCER + ''''          
    IF @PORCLI='1'          
        Select @WhereA2=' and b.claseabc=''' + @TIPCLI + ''' and b.contribuy=''' + @CODCLI + ''' '        
    --**************************************************************************************************************        
 IF RTRIM(LTRIM(ISNULL(@FECSER,''))) <>'' AND @PORCER='0' --Ya que la fecha se toma del mismo certificado.        
  Select @WhereS3=@WhereS3 + ' and a.inifac13<''' + @FECSER + ''' and a.inifac13>=''' + '20140101' + ''' '          
 --**************************************************************************************************************        
End          
          
If @DEPADU='1' And @DEPSIM='1'          
    Select @Union=' UNION ALL '          
          
If @DEPSIM='1'          
Begin          
    Select @SelectS1='Select numcer13=a.numcer74,numdui11=c.numdui11,numsol10=a.numsol62,perfac13=a.perfac74,inifac13=a.inifac74,finalm13=a.finalm74,ultent13=a.ultent74,numbul13=a.bultot74,'          
    Select @SelectS2='cifcer13=a.pretot74,pescer13=a.pestot74,flgtar13=a.flgtar74,a.numtar68,finser13=a.finser74,ultfac13=a.ultfac74,tipcli02C=a.tipcli02,codcli02C=a.codcli02,'              
    Select @SelectS3='TipCli02=a.ticlfa74,CodCli02=a.coclfa74,b.nombre,b.direccion,FLGHOR02=substring(b.cadena,11,1),TOLHOR02=b.diasabast,FACHOR02=b.diaspromat,'              
    Select @SelectS4='diaalm10=c.diaalm62,segnep10=c.segnep62,porseg10=c.porseg62,desmer10=c.desmer62,faccom10=c.FACTCOMER,conemb10=c.codemb62,CERADU74=a.ceradu74 '          
    Select @FromS1='From DDCerSim74 a,AAClientesAA b, DDSolSim62 c '          
--    Select @WhereS1='Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74='1' and a.flgfac74='1' and substring(b.cadena,12,1)='1' and a.finser74='0' and a.flstfa74='N'  '          
    --Select @WhereS1='Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74=''1''  and substring(b.cadena,12,1)=''1'' and a.finser74=''0'' and a.flstfa74=''N''  and c.diaalm62>0 and  a.numsol62 not in (Select a.numsol62 From DDCerSim74 a,ddcabcom52 b where a.numcer74=b.numcer52 and b.flgval52=''1'' and flstfa74=''S'') and b.contribuy not in (select contribuy from DQCLIPROY00)  '          
    Select @WhereS1='Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74=''1''  and substring(b.cadena,12,1)=''1'' and a.flstfa74=''N''  and c.diaalm62>0 and  a.numsol62 not in (Select a.numsol62 From DDCerSim74 a,ddcabcom52 b where a.numcer74=b.numcer52 and b.flgval52=''1'' and flstfa74=''S'') and b.contribuy not in (select contribuy from DQCLIPROY00)  '          
      
    IF @PORCER='1'          
        Select @WhereS2=@WhereS2 + ' and a.numcer74=''' + @NUMCER + ''' '          
    IF @PORCLI='1'          
        Select @WhereS2=@WhereS2 + ' and b.claseabc=''' + @TIPCLI + ''' and b.contribuy=''' + @CODCLI + ''' '        
 --**************************************************************************************************************        
  IF RTRIM(LTRIM(ISNULL(@FECSER,''))) <>'' AND @PORCER='0' --Ya que la fecha se toma del mismo certificado.        
  Select @WhereS3=@WhereS3 + ' and a.inifac74<''' + @FECSER + ''' and a.inifac74>=''' + '20140101' + ''' '          
 --**************************************************************************************************************        
End          
        
print '.. ' + @SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2+@WhereS3        
        
--Execute(@SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2+@WhereS3)     
    
--|FRANKLIN MILLA - 01/04/2015    
--|REQUERIMIENTO FACTURACION AUTOMATICA PARA CERTIFICADOS SIN STOCK    
CREATE TABLE #SASTEMP    
(    
id int identity(1,1),    
numcer13 varchar(9),    
numdui11 varchar(14),    
numsol10 varchar(7),    
perfac13 int,    
inifac13 smalldatetime,    
finalm13 char(1),    
ultent13 smalldatetime,    
numbul13 decimal(10,2),    
cifcer13 decimal(15,3),    
pescer13 decimal(15,3),    
flgtar13 char(1),    
numtar68 varchar(2),    
finser13 char(1),    
ultfac13 smalldatetime,    
tipcli02C char(1),    
codcli02C varchar(11),    
tipcli02 char(1),    
codcli02 varchar(11),    
nombre varchar(80),    
direccion varchar(150),    
FLGHOR02 varchar(1),    
TOLHOR02 int,    
FACHOR02 int,    
diaalm10 int,    
segnep10 char(1),    
porseg10 decimal(5,2),    
desmer10 varchar(200),    
faccom10 varchar(50),    
conemb10 varchar(20),    
CERADU74 char(9)    
)    
    
INSERT INTO #SASTEMP(numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,    
finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,    
desmer10,faccom10,conemb10,CERADU74)    
    
Execute(@SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2+@WhereS3)     
    
    
SELECT    
numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,    
finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,    
desmer10,faccom10,conemb10,CERADU74    
FROM     
#SASTEMP    
WHERE finser13='0'    
    
UNION    
    
SELECT    
A.numcer13,A.numdui11,A.numsol10,A.perfac13,A.inifac13,A.finalm13,A.ultent13,A.numbul13,A.cifcer13,A.pescer13,A.flgtar13,A.numtar68,    
A.finser13,A.ultfac13,A.tipcli02C,A.codcli02C,A.tipcli02,A.codcli02,A.nombre,A.direccion,A.FLGHOR02,A.TOLHOR02,A.FACHOR02,A.diaalm10,    
A.segnep10,A.porseg10,    
A.desmer10,A.faccom10,A.conemb10,A.CERADU74    
FROM     
#SASTEMP A    
INNER JOIN    
(    
SELECT DISTINCT D.numcer58 FROM DDOrdSer58 D    
INNER JOIN DDDOrSer59 E WITH (NOLOCK) ON D.numord58=E.numord58    
WHERE     
E.codcom50 IS null           
AND D.flgval58='1'           
AND E.valcob59<>0           
--and isnull(D.dettrans,'N') = 'N'           
--and isnull(D.dettranc,'N') = 'N'              
AND (D.fecord58>='20150406')     
AND isnull(E.numcom52,'')=''    
--AND D.numcer58=A.numcer13    
) B ON B.numcer58=A.numcer13    
AND A.finser13='1'    
    
    
/*    
IF NOT EXISTS(SELECT *FROM #SASTEMP)    
BEGIN    
 SELECT    
 numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,    
 finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,    
 desmer10,faccom10,conemb10,CERADU74    
 FROM     
 #SASTEMP    
 DROP TABLE #SASTEMP    
 RETURN;    
END    
    
CREATE TABLE #SASFINAL    
(    
numcer13 varchar(9),    
numdui11 varchar(14),    
numsol10 varchar(7),    
perfac13 int,    
inifac13 smalldatetime,    
finalm13 char(1),    
ultent13 smalldatetime,    
numbul13 decimal(10,2),    
cifcer13 decimal(15,3),    
pescer13 decimal(15,3),    
flgtar13 char(1),    
numtar68 varchar(2),    
finser13 char(1),    
ultfac13 smalldatetime,    
tipcli02C char(1),    
codcli02C varchar(11),    
tipcli02 char(1),    
codcli02 varchar(11),    
nombre varchar(80),    
direccion varchar(150),    
FLGHOR02 varchar(1),    
TOLHOR02 int,    
FACHOR02 int,    
diaalm10 int,    
segnep10 char(1),    
porseg10 decimal(5,2),    
desmer10 varchar(200),    
faccom10 varchar(50),    
conemb10 varchar(20),    
CERADU74 char(9)    
)    
    
--|VARIABLES    
DECLARE @COUNT INT,@COUNT_TOT INT    
DECLARE @NUMCERTIFICADO VARCHAR(35)    
    
DECLARE @FLGSTOCK VARCHAR(1)    
--|finser13=0 TIENE STOCK    
--|finser13=1 NO TIENE STOCK    
    
SET @COUNT=1    
SELECT @COUNT_TOT=COUNT(*) FROM #SASTEMP     
    
WHILE @COUNT < @COUNT_TOT + 1    
BEGIN    
 SELECT @NUMCERTIFICADO=numcer13,@FLGSTOCK=finser13     
 FROM #SASTEMP WHERE id=@COUNT    
    
 SET @NUMCERTIFICADO=LTRIM(RTRIM(@NUMCERTIFICADO))    
     
 IF @FLGSTOCK='0'    
 BEGIN    
  --|CARGA CON STOCK    
  --|    
  INSERT INTO #SASFINAL    
  SELECT    
  numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,    
  finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,    
  desmer10,faccom10,conemb10,CERADU74    
  FROM     
  #SASTEMP WHERE numcer13=@NUMCERTIFICADO    
 END    
 ELSE    
 BEGIN    
  --|CARGA SIN STOCK    
  --|    
  --|VALIDAR SI CUENTA CON ORDEN DE SERVICO ACTIVA Y NO FACTURADA - CERTIFICADO SIMPLE    
  IF SUBSTRING(@NUMCERTIFICADO,1,1)='S'    
  BEGIN    
   IF EXISTS(    
       SELECT TOP 1*    
       FROM DDOrdSer58 D WITH (NOLOCK)    
       INNER JOIN DDDOrSer59 E WITH (NOLOCK) ON D.numord58=E.numord58     
       and E.codcom50 IS null           
       and D.flgval58='1'           
       and E.valcob59<>0           
       --and isnull(D.dettrans,'N') = 'N'           
       --and isnull(D.dettranc,'N') = 'N'              
       and (D.fecord58>='20150326')     
       and isnull(E.numcom52,'')=''    
       and numcer58=@NUMCERTIFICADO       
       )     
   BEGIN    
    INSERT INTO #SASFINAL    
    SELECT    
    numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,    
    finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,    
    desmer10,faccom10,conemb10,CERADU74    
    FROM     
    #SASTEMP WHERE numcer13=@NUMCERTIFICADO    
   END    
  END    
      
  --|VALIDAR SI CUENTA CON ORDEN DE SERVICO ACTIVA Y NO FACTURADA - CERTIFICADO ADUANERO    
  IF SUBSTRING(@NUMCER,1,1)='A'    
  BEGIN    
   IF EXISTS(    
       SELECT TOP 1*    
       FROM DDOrdSer58 D WITH (NOLOCK)    
       INNER JOIN DDDOrSer59 E WITH (NOLOCK) ON D.numord58=E.numord58     
       and E.codcom50 IS null           
       and D.flgval58='1'           
       and E.valcob59<>0           
       --and isnull(D.dettrans,'N') = 'N'           
       --and isnull(D.dettranc,'N') = 'N'              
       and (D.fecord58>='20150326')     
       and isnull(E.numcom52,'')=''    
       and numcer58=@NUMCERTIFICADO      
       )        
   BEGIN    
    INSERT INTO #SASFINAL    
    SELECT    
    numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,    
    finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,    
    desmer10,faccom10,conemb10,CERADU74    
    FROM     
    #SASTEMP WHERE numcer13=@NUMCERTIFICADO    
   END    
  END    
      
 END    
 SET @COUNT = @COUNT + 1    
END    
    
SELECT *FROM #SASFINAL    
*/    
DROP TABLE #SASTEMP    
--DROP TABLE #SASFINAL
GO
/****** Object:  StoredProcedure [dbo].[TAR_FACTURAS_FACTURAR_EWMN]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[TAR_FACTURAS_FACTURAR_EWMN]
@DEPADU VARCHAR(3),
@DEPSIM VARCHAR(3),
@PORCER VARCHAR(3),
@PORCLI VARCHAR(3),
@NUMCER VARCHAR(9),
@TIPCLI VARCHAR(3),
@CODCLI VARCHAR(13)
AS

Declare @SelectA1 varchar(255) 
Declare @SelectA2 varchar(255)
Declare @SelectA3 varchar(255)
Declare @FromA1 varchar(255)
Declare @WhereA1 varchar(500)
Declare @WhereA2 varchar(255)
Declare @Union varchar(50)
Declare @SelectS1 varchar(255)
Declare @SelectS2 varchar(255)
Declare @SelectS3 varchar(255)
Declare @SelectS4 varchar(255)
Declare @FromS1 Varchar(255)
Declare @WhereS1 varchar(500)
Declare @WhereS2 varchar(255)

Select @SelectA1 ='' 
Select @SelectA2 ='' 
Select @SelectA3 ='' 
Select @FromA1 ='' 
Select @WhereA1 ='' 
Select @WhereA2 ='' 
Select @Union ='' 
Select @SelectS1 ='' 
Select @SelectS2 ='' 
Select @SelectS3 ='' 
Select @SelectS4 ='' 
Select @FromS1 ='' 
Select @WhereS1 ='' 
Select @WhereS2 ='' 

--Este SP Selecciona todos aquellos Certificados que aun deben ser Facturados

If @DEPADU='1'
Begin
    Select @SelectA1="Select a.numcer13,a.numdui11,a.numsol10,a.perfac13,a.inifac13,a.finalm13,a.ultent13,a.numbul13,a.cifcer13,a.pescer13,a.flgtar13,a.numtar68,a.finser13,a.ultfac13,"
    Select @SelectA2="tipcli02C=a.tipcli02,codcli02C=a.codcli02,tipcli02=a.ticlfa13,codcli02=a.coclfa13,b.nombre,b.direccion,FLGHOR02=substring(b.cadena,11,1),TOLHOR02=b.diasabast,FACHOR02=b.diaspromat,"
    Select @SelectA3="c.diaalm10,c.segnep10,c.porseg10,c.desmer10,c.faccom10,c.conemb10,CERADU74='' " 
    Select @FromA1="From DDCerAdu13 a,AAClientesAA b,DDSolAdu10 c "
--    Select @WhereA1="Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and 	a.numsol10=c.numsol10 and a.flgval13='1' and a.flgfac13='1' and substring(b.cadena,12,1)='1' and a.finser13='0' and a.flstfa13='N' "
    Select @WhereA1="Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and a.numsol10=c.numsol10 and a.flgval13='1' and substring(b.cadena,12,1)='1' and a.finser13='0' and a.flstfa13='N'  and a.numsol10 not in (Select a.numsol10 From ddceradu13 a,ddcabcom52 b where a.numcer13=b.numcer52 and b.flgval52='1' and flstfa13='S') and b.contribuy not in (select contribuy from DQCLIPROY00) "

    IF @PORCER='1'
        Select @WhereA2=" and a.numcer13='" + @NUMCER + "'"
    IF @PORCLI='1'
        Select @WhereA2=" and b.claseabc='" + @TIPCLI + "' and b.contribuy='" + @CODCLI + "' "
End

If @DEPADU='1' And @DEPSIM='1'
    Select @Union=" UNION ALL "

If @DEPSIM='1'
Begin
    Select @SelectS1="Select numcer13=a.numcer74,numdui11=c.numdui11,numsol10=a.numsol62,perfac13=a.perfac74,inifac13=a.inifac74,finalm13=a.finalm74,ultent13=a.ultent74,numbul13=a.bultot74,"
    Select @SelectS2="cifcer13=a.pretot74,pescer13=a.pestot74,flgtar13=a.flgtar74,a.numtar68,finser13=a.finser74,ultfac13=a.ultfac74,tipcli02C=a.tipcli02,codcli02C=a.codcli02,"    
    Select @SelectS3="TipCli02=a.ticlfa74,CodCli02=a.coclfa74,b.nombre,b.direccion,FLGHOR02=substring(b.cadena,11,1),TOLHOR02=b.diasabast,FACHOR02=b.diaspromat,"    
    Select @SelectS4="diaalm10=c.diaalm62,segnep10=c.segnep62,porseg10=c.porseg62,desmer10=c.desmer62,faccom10=c.FACTCOMER,conemb10=c.codemb62,CERADU74=a.ceradu74 "
    Select @FromS1="From DDCerSim74 a,AAClientesAA b, DDSolSim62 c "
--    Select @WhereS1="Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74='1' and a.flgfac74='1' and substring(b.cadena,12,1)='1' and a.finser74='0' and a.flstfa74='N'  "
    Select @WhereS1="Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74='1'  and substring(b.cadena,12,1)='1' and a.finser74='0' and a.flstfa74='N'  and c.diaalm62>0 and  a.numsol62 not in (Select a.numsol62 From DDCerSim74 a,ddcabcom52 b where a.numcer74=b.numcer52 and b.flgval52='1' and flstfa74='S') and b.contribuy not in (select contribuy from DQCLIPROY00)  "
    IF @PORCER='1'
        Select @WhereS2=@WhereS2 + " and a.numcer74='" + @NUMCER + "' "
    IF @PORCLI='1'
        Select @WhereS2=@WhereS2 + " and b.claseabc='" + @TIPCLI + "' and b.contribuy='" + @CODCLI + "' "
End


Print(@SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2)

Execute(@SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2)

/*
EXEC TAR_FACTURAS_FACTURAR '1','0','1','0','A00172400','',''
*/

GO
/****** Object:  StoredProcedure [dbo].[TAR_FACTURAS_FACTURAR_FRANKLIN]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_FACTURAS_FACTURAR_FRANKLIN]      
@DEPADU VARCHAR(3),      
@DEPSIM VARCHAR(3),      
@PORCER VARCHAR(3),      
@PORCLI VARCHAR(3),      
@NUMCER VARCHAR(9),      
@TIPCLI VARCHAR(3),      
@CODCLI VARCHAR(13),    
@FECSER VARCHAR(8) = ''    
AS      
IF @FECSER <> ''    
  BEGIN    
 SET @FECSER = CONVERT(VARCHAR,DATEADD(DAY,1,CONVERT(DATETIME,@FECSER)),112)    
  END    
    
Declare @SelectA1 varchar(255)       
Declare @SelectA2 varchar(255)      
Declare @SelectA3 varchar(255)      
Declare @FromA1 varchar(255)      
Declare @WhereA1 varchar(500)      
Declare @WhereA2 varchar(255)      
Declare @Union varchar(50)      
Declare @SelectS1 varchar(255)      
Declare @SelectS2 varchar(255)      
Declare @SelectS3 varchar(255)      
Declare @SelectS4 varchar(255)      
Declare @FromS1 Varchar(255)      
Declare @WhereS1 varchar(500)      
Declare @WhereS2 varchar(255)      
Declare @WhereS3 varchar(500)    
      
Select @SelectA1 =''       
Select @SelectA2 =''       
Select @SelectA3 =''       
Select @FromA1 =''       
Select @WhereA1 =''       
Select @WhereA2 =''       
Select @Union =''       
Select @SelectS1 =''       
Select @SelectS2 =''       
Select @SelectS3 =''       
Select @SelectS4 =''       
Select @FromS1 =''       
Select @WhereS1 =''       
Select @WhereS2 =''       
Select @WhereS3 = ''    
    
--Este SP Selecciona todos aquellos Certificados que aun deben ser Facturados      
      
If @DEPADU='1'      
Begin      
    Select @SelectA1='Select a.numcer13,a.numdui11,a.numsol10,a.perfac13,a.inifac13,a.finalm13,a.ultent13,a.numbul13,a.cifcer13,a.pescer13,a.flgtar13,a.numtar68,a.finser13,a.ultfac13,'      
    Select @SelectA2='tipcli02C=a.tipcli02,codcli02C=a.codcli02,tipcli02=a.ticlfa13,codcli02=a.coclfa13,b.nombre,b.direccion,FLGHOR02=substring(b.cadena,11,1),TOLHOR02=b.diasabast,FACHOR02=b.diaspromat,'      
    Select @SelectA3='c.diaalm10,c.segnep10,c.porseg10,c.desmer10,c.faccom10,c.conemb10,CERADU74='''''       
    Select @FromA1='From DDCerAdu13 a,AAClientesAA b,DDSolAdu10 c '      
--    Select @WhereA1='Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and  a.numsol10=c.numsol10 and a.flgval13='1' and a.flgfac13='1' and substring(b.cadena,12,1)='1' and a.finser13='0' and a.flstfa13='N' '      
    --Select @WhereA1='Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and a.numsol10=c.numsol10 and a.flgval13=''1'' and substring(b.cadena,12,1)=''1'' and a.finser13=''0'' and a.flstfa13=''N''  and a.numsol10 not in (Select a.numsol10 From ddceradu13 a,ddcabcom52 b where a.numcer13=b.numcer52 and b.flgval52=''1'' and flstfa13=''S'') and b.contribuy not in (select contribuy from DQCLIPROY00) '   
    Select @WhereA1='Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and a.numsol10=c.numsol10 and a.flgval13=''1'' and substring(b.cadena,12,1)=''1'' and a.flstfa13=''N''  and a.numsol10 not in (Select a.numsol10 From ddceradu13 a,ddcabcom52 b where a.numcer13=b.numcer52 and b.flgval52=''1'' and flstfa13=''S'') and b.contribuy not in (select contribuy from DQCLIPROY00) '   
      
    IF @PORCER='1'      
        Select @WhereA2=' and a.numcer13=''' + @NUMCER + ''''      
    IF @PORCLI='1'      
        Select @WhereA2=' and b.claseabc=''' + @TIPCLI + ''' and b.contribuy=''' + @CODCLI + ''' '    
    --**************************************************************************************************************    
 IF RTRIM(LTRIM(ISNULL(@FECSER,''))) <>'' AND @PORCER='0' --Ya que la fecha se toma del mismo certificado.    
  Select @WhereS3=@WhereS3 + ' and a.inifac13<''' + @FECSER + ''' '      
 --**************************************************************************************************************    
End      
      
If @DEPADU='1' And @DEPSIM='1'      
    Select @Union=' UNION ALL '      
      
If @DEPSIM='1'      
Begin      
    Select @SelectS1='Select numcer13=a.numcer74,numdui11=c.numdui11,numsol10=a.numsol62,perfac13=a.perfac74,inifac13=a.inifac74,finalm13=a.finalm74,ultent13=a.ultent74,numbul13=a.bultot74,'      
    Select @SelectS2='cifcer13=a.pretot74,pescer13=a.pestot74,flgtar13=a.flgtar74,a.numtar68,finser13=a.finser74,ultfac13=a.ultfac74,tipcli02C=a.tipcli02,codcli02C=a.codcli02,'          
    Select @SelectS3='TipCli02=a.ticlfa74,CodCli02=a.coclfa74,b.nombre,b.direccion,FLGHOR02=substring(b.cadena,11,1),TOLHOR02=b.diasabast,FACHOR02=b.diaspromat,'          
    Select @SelectS4='diaalm10=c.diaalm62,segnep10=c.segnep62,porseg10=c.porseg62,desmer10=c.desmer62,faccom10=c.FACTCOMER,conemb10=c.codemb62,CERADU74=a.ceradu74 '      
    Select @FromS1='From DDCerSim74 a,AAClientesAA b, DDSolSim62 c '      
--    Select @WhereS1='Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74='1' and a.flgfac74='1' and substring(b.cadena,12,1)='1' and a.finser74='0' and a.flstfa74='N'  '      
    --Select @WhereS1='Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74=''1''  and substring(b.cadena,12,1)=''1'' and a.finser74=''0'' and a.flstfa74=''N''  and c.diaalm62>0 and  a.numsol62 not in (Select a.numsol62 From DDCerSim74 a,ddcabcom52 b where a.numcer74=b.numcer52 and b.flgval52=''1'' and flstfa74=''S'') and b.contribuy not in (select contribuy from DQCLIPROY00)  '      
    Select @WhereS1='Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74=''1''  and substring(b.cadena,12,1)=''1'' and a.flstfa74=''N''  and c.diaalm62>0 and  a.numsol62 not in (Select a.numsol62 From DDCerSim74 a,ddcabcom52 b where a.numcer74=b.numcer52 and b.flgval52=''1'' and flstfa74=''S'') and b.contribuy not in (select contribuy from DQCLIPROY00)  '      
  
    IF @PORCER='1'      
        Select @WhereS2=@WhereS2 + ' and a.numcer74=''' + @NUMCER + ''' '      
    IF @PORCLI='1'      
        Select @WhereS2=@WhereS2 + ' and b.claseabc=''' + @TIPCLI + ''' and b.contribuy=''' + @CODCLI + ''' '    
 --**************************************************************************************************************    
    IF RTRIM(LTRIM(ISNULL(@FECSER,''))) <>'' AND @PORCER='0' --Ya que la fecha se toma del mismo certificado.    
  Select @WhereS3=@WhereS3 + ' and a.inifac74<''' + @FECSER + ''' '      
 --**************************************************************************************************************    
End      
    
print '.. ' + @SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2+@WhereS3    
    
--Execute(@SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2+@WhereS3) 

--|FRANKLIN MILLA - 01/04/2015
--|REQUERIMIENTO FACTURACION AUTOMATICA PARA CERTIFICADOS SIN STOCK
CREATE TABLE #SASTEMP
(
id int identity(1,1),
numcer13 varchar(9),
numdui11 varchar(14),
numsol10 varchar(7),
perfac13 int,
inifac13 smalldatetime,
finalm13 char(1),
ultent13 smalldatetime,
numbul13 decimal(10,2),
cifcer13 decimal(15,3),
pescer13 decimal(15,3),
flgtar13 char(1),
numtar68 varchar(2),
finser13 char(1),
ultfac13 smalldatetime,
tipcli02C char(1),
codcli02C varchar(11),
tipcli02 char(1),
codcli02 varchar(11),
nombre varchar(80),
direccion varchar(150),
FLGHOR02 varchar(1),
TOLHOR02 int,
FACHOR02 int,
diaalm10 int,
segnep10 char(1),
porseg10 decimal(5,2),
desmer10 varchar(200),
faccom10 varchar(50),
conemb10 varchar(20),
CERADU74 char(9)
)

INSERT INTO #SASTEMP(numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,
finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,
desmer10,faccom10,conemb10,CERADU74)

Execute(@SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2+@WhereS3) 

/*
SELECT
numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,
finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,
desmer10,faccom10,conemb10,CERADU74
FROM 
#SASTEMP
WHERE finser13='0'

UNION

SELECT
A.numcer13,A.numdui11,A.numsol10,A.perfac13,A.inifac13,A.finalm13,A.ultent13,A.numbul13,A.cifcer13,A.pescer13,A.flgtar13,A.numtar68,
A.finser13,A.ultfac13,A.tipcli02C,A.codcli02C,A.tipcli02,A.codcli02,A.nombre,A.direccion,A.FLGHOR02,A.TOLHOR02,A.FACHOR02,A.diaalm10,
A.segnep10,A.porseg10,
A.desmer10,A.faccom10,A.conemb10,A.CERADU74
FROM 
#SASTEMP A
INNER JOIN
(
SELECT DISTINCT D.numcer58 FROM DDOrdSer58 D
INNER JOIN DDDOrSer59 E WITH (NOLOCK) ON D.numord58=E.numord58
WHERE 
E.codcom50 IS null       
AND D.flgval58='1'       
AND E.valcob59<>0       
--and isnull(D.dettrans,'N') = 'N'       
--and isnull(D.dettranc,'N') = 'N'          
AND (D.fecord58>='2015049') 
AND isnull(E.numcom52,'')=''
--AND D.numcer58=A.numcer13
) B ON B.numcer58=A.numcer13
AND A.finser13='1'


/*
IF NOT EXISTS(SELECT *FROM #SASTEMP)
BEGIN
	SELECT
	numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,
	finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,
	desmer10,faccom10,conemb10,CERADU74
	FROM 
	#SASTEMP
	DROP TABLE #SASTEMP
	RETURN;
END

CREATE TABLE #SASFINAL
(
numcer13 varchar(9),
numdui11 varchar(14),
numsol10 varchar(7),
perfac13 int,
inifac13 smalldatetime,
finalm13 char(1),
ultent13 smalldatetime,
numbul13 decimal(10,2),
cifcer13 decimal(15,3),
pescer13 decimal(15,3),
flgtar13 char(1),
numtar68 varchar(2),
finser13 char(1),
ultfac13 smalldatetime,
tipcli02C char(1),
codcli02C varchar(11),
tipcli02 char(1),
codcli02 varchar(11),
nombre varchar(80),
direccion varchar(150),
FLGHOR02 varchar(1),
TOLHOR02 int,
FACHOR02 int,
diaalm10 int,
segnep10 char(1),
porseg10 decimal(5,2),
desmer10 varchar(200),
faccom10 varchar(50),
conemb10 varchar(20),
CERADU74 char(9)
)

--|VARIABLES
DECLARE @COUNT INT,@COUNT_TOT INT
DECLARE @NUMCERTIFICADO VARCHAR(35)

DECLARE @FLGSTOCK VARCHAR(1)
--|finser13=0 TIENE STOCK
--|finser13=1 NO TIENE STOCK

SET @COUNT=1
SELECT @COUNT_TOT=COUNT(*) FROM #SASTEMP 

WHILE @COUNT < @COUNT_TOT + 1
BEGIN
	SELECT @NUMCERTIFICADO=numcer13,@FLGSTOCK=finser13 
	FROM #SASTEMP WHERE id=@COUNT

	SET @NUMCERTIFICADO=LTRIM(RTRIM(@NUMCERTIFICADO))
	
	IF @FLGSTOCK='0'
	BEGIN
		--|CARGA CON STOCK
		--|
		INSERT INTO #SASFINAL
		SELECT
		numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,
		finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,
		desmer10,faccom10,conemb10,CERADU74
		FROM 
		#SASTEMP WHERE numcer13=@NUMCERTIFICADO
	END
	ELSE
	BEGIN
		--|CARGA SIN STOCK
		--|
		--|VALIDAR SI CUENTA CON ORDEN DE SERVICO ACTIVA Y NO FACTURADA - CERTIFICADO SIMPLE
		IF SUBSTRING(@NUMCERTIFICADO,1,1)='S'
		BEGIN
			IF EXISTS(
					  SELECT TOP 1*
					  FROM DDOrdSer58 D WITH (NOLOCK)
					  INNER JOIN DDDOrSer59 E WITH (NOLOCK) ON D.numord58=E.numord58 
					  and E.codcom50 IS null       
					  and D.flgval58='1'       
					  and E.valcob59<>0       
					  --and isnull(D.dettrans,'N') = 'N'       
					  --and isnull(D.dettranc,'N') = 'N'          
					  and (D.fecord58>='20150326') 
					  and isnull(E.numcom52,'')=''
					  and numcer58=@NUMCERTIFICADO   
					  ) 
			BEGIN
				INSERT INTO #SASFINAL
				SELECT
				numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,
				finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,
				desmer10,faccom10,conemb10,CERADU74
				FROM 
				#SASTEMP WHERE numcer13=@NUMCERTIFICADO
			END
		END
		
		--|VALIDAR SI CUENTA CON ORDEN DE SERVICO ACTIVA Y NO FACTURADA - CERTIFICADO ADUANERO
		IF SUBSTRING(@NUMCER,1,1)='A'
		BEGIN
			IF EXISTS(
					  SELECT TOP 1*
					  FROM DDOrdSer58 D WITH (NOLOCK)
					  INNER JOIN DDDOrSer59 E WITH (NOLOCK) ON D.numord58=E.numord58 
					  and E.codcom50 IS null       
					  and D.flgval58='1'       
					  and E.valcob59<>0       
					  --and isnull(D.dettrans,'N') = 'N'       
					  --and isnull(D.dettranc,'N') = 'N'          
					  and (D.fecord58>='20150326') 
					  and isnull(E.numcom52,'')=''
					  and numcer58=@NUMCERTIFICADO  
					  )		  
			BEGIN
				INSERT INTO #SASFINAL
				SELECT
				numcer13,numdui11,numsol10,perfac13,inifac13,finalm13,ultent13,numbul13,cifcer13,pescer13,flgtar13,numtar68,
				finser13,ultfac13,tipcli02C,codcli02C,tipcli02,codcli02,nombre,direccion,FLGHOR02,TOLHOR02,FACHOR02,diaalm10,segnep10,porseg10,
				desmer10,faccom10,conemb10,CERADU74
				FROM 
				#SASTEMP WHERE numcer13=@NUMCERTIFICADO
			END
		END
		
	END
	SET @COUNT = @COUNT + 1
END

SELECT *FROM #SASFINAL
*/
*/
DROP TABLE #SASTEMP
--DROP TABLE #SASFINAL
GO
/****** Object:  StoredProcedure [dbo].[TAR_FILTRO_REPORTE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_FILTRO_REPORTE]
AS
BEGIN

--********************06/11/2014 AOG
DECLARE @tdfilser AS TABLE (codser99 varchar(15))
INSERT INTO @tdfilser (codser99)
Select codser99 From DTFilSer99 Where usufil99= HOST_NAME()

DECLARE @conFiltro INT 
SET @conFiltro = (Select COUNT(*) From @tdfilser)
--********************06/11/2014 AOG

IF @conFiltro >0 
BEGIN
Delete DTDetCom53 where (codcon53 NOT IN (Select codser99 From @tdfilser))
END 
Delete DTCabCom52 where numcer52 NOT IN (select distinct a.numcer52 from DTCabCom52 a inner join DTDetCom53 b on a.numcer52 = b.numcer52)  

END

GO
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.TAR_ORDENES_DE_SERVICIO    Script Date: 08-09-2002 08:44:11 PM ******/
ALTER PROCEDURE [dbo].[TAR_ORDENES_DE_SERVICIO]
@NUMCER VARCHAR(9),
@DETRAC char(1)
AS

Select b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
From DDOrdSer58 a
Inner Join DDDOrSer59 b on a.numord58=b.numord58
Where a.Numcer58=@NUMCER and 
b.codcom50=null and a.flgval58='1' and b.valcob59<>0 and a.detrac58=@DETRAC
Group by b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
GO
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO_2]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[TAR_ORDENES_DE_SERVICIO_2]
@NUMCER VARCHAR(9)
AS

Select b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
From DDOrdSer58 a
Inner Join DDDOrSer59 b on a.numord58=b.numord58
Where a.Numcer58=@NUMCER and 
b.codcom50=null and a.flgval58='1' and b.valcob59<>0
Group by b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
GO
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO_ADU]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_ORDENES_DE_SERVICIO_ADU]        
@NUMCER VARCHAR(9),        
@DETRANS char(1),        
@DETRANC char(1),        
@FECSER VARCHAR(8) = ''        
AS        
BEGIN        
        
--rdelacuba 02/11/2006: Creado para diferenciar las facturas con y sin detracción         
--En el caso de ADUANERO sólo aplica detraccion de transporte, no aplica detrac58        
        
--********************06/11/2014 AOG        
DECLARE @tdfilser AS TABLE (codser99 varchar(15))        
INSERT INTO @tdfilser (codser99)        
Select codser99 From DTFilSer99 Where usufil99= HOST_NAME()        
        
DECLARE @conFiltro INT         
SET @conFiltro = (Select COUNT(*) From @tdfilser)        
--********************06/11/2014 AOG        
/*        
SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)        
FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58        
WHERE a.Numcer58=@NUMCER and         
b.codcom50 is null and         
a.flgval58='1' and         
b.valcob59<>0 and         
isnull(a.dettrans,'N') = @DETRANS and        
isnull(a.dettranc,'N') = @DETRANC        
and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)        
and (a.fecord58 <= @FECSER or @FECSER = '')        
GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59        
*/        
--** 07/01/2015        
    
    
--| FRANKLIN MILLA LUMBE 25-03-2015    
--| REQUERIMIENTO: FACTURACION AUTOMATICA CUANDO NO EXISTE CARGA    
DECLARE @FINSERT CHAR(1)    
SELECT @FINSERT=finser13     
FROM DDCerAdu13 WITH (NOLOCK)    
WHERE numcer13=@NUMCER    
    
IF @FINSERT='1'    
BEGIN    
 SELECT t.CodCon51,t.numuni54,t.cantid59,t.tamctr59        
    ,SUM((CASE WHEN t.valfun>t.valcob THEN t.valfun        
   ELSE t.valcob        
    END)) AS [valcob59]        
   FROM (SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59,b.valcob59,b.uniser59,b.valcob59*b.uniser59 as [valcob]        
   ,ISNULL(dbo.[fn_monto_minimo_x_servicio](LEFT(@NUMCER,1),a.tipcli02,a.codcli02,b.codcon51,a.TIPMON58),b.valcob59) as [valfun]        
  FROM DDOrdSer58 a         
    INNER JOIN DDDOrSer59 b         
    ON a.numord58=b.numord58        
    WHERE a.Numcer58=@NUMCER         
   and b.codcom50 IS null         
   and a.flgval58='1'         
   and b.valcob59<>0         
   and isnull(a.dettrans,'N') = @DETRANS         
   and isnull(a.dettranc,'N') = @DETRANC        
   and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)        
   and (a.fecord58 <= @FECSER or @FECSER = '')      
   AND (a.fecord58>='20150406')      
   ) t        
 GROUP BY t.CodCon51,t.numuni54,t.cantid59,t.tamctr59     
RETURN;     
END       
    
IF @FINSERT='0'    
BEGIN    
 SELECT t.CodCon51,t.numuni54,t.cantid59,t.tamctr59        
    ,SUM((CASE WHEN t.valfun>t.valcob THEN t.valfun        
   ELSE t.valcob        
    END)) AS [valcob59]        
   FROM (SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59,b.valcob59,b.uniser59,b.valcob59*b.uniser59 as [valcob]        
   ,ISNULL(dbo.[fn_monto_minimo_x_servicio](LEFT(@NUMCER,1),a.tipcli02,a.codcli02,b.codcon51,a.TIPMON58),b.valcob59) as [valfun]        
  FROM DDOrdSer58 a         
    INNER JOIN DDDOrSer59 b         
    ON a.numord58=b.numord58        
    WHERE a.Numcer58=@NUMCER         
   and b.codcom50 IS null         
   and a.flgval58='1'         
   and b.valcob59<>0         
   and isnull(a.dettrans,'N') = @DETRANS         
   and isnull(a.dettranc,'N') = @DETRANC        
   and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)        
   and (a.fecord58 <= @FECSER or @FECSER = '')      
   --AND (a.fecord58>='20150325')      
   ) t        
 GROUP BY t.CodCon51,t.numuni54,t.cantid59,t.tamctr59     
RETURN;     
END      
      
END 
GO
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO_GA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[TAR_ORDENES_DE_SERVICIO_GA]
@NUMCER VARCHAR(9)
AS
BEGIN

--rdelacuba 02/11/2006: Creado para diferenciar las facturas con y sin detracción de transporte
--para el cálculo de gasto administrativo en la factura donde no hay conceptos afectos

--********************06/11/2014 AOG
DECLARE @tdfilser AS TABLE (codser99 varchar(15))
INSERT INTO @tdfilser (codser99)
Select codser99 From DTFilSer99 Where usufil99= HOST_NAME()

DECLARE @conFiltro INT 
SET @conFiltro = (Select COUNT(*) From @tdfilser)
--********************06/11/2014 AOG

--Si es ADUANERO sólo aplica detracción de tranporte
IF substring(@NUMCER,1,1) = 'A'
BEGIN

	SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
	FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
	WHERE a.Numcer58=@NUMCER and 
	b.codcom50 IS null and 
	a.flgval58='1' and 
	b.valcob59<>0 and 
	isnull(a.dettranS,'N') = 'S'
	--********************06/11/2014 AOG
	and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)
	--********************06/11/2014 AOG
	GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
	UNION
	SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
	FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
	WHERE a.Numcer58=@NUMCER and 
	b.codcom50 IS null and 
	a.flgval58='1' and 
	b.valcob59<>0 and 
	isnull(a.dettranC,'N') = 'S'
	--********************06/11/2014 AOG
	and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)
	--********************06/11/2014 AOG
	GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
END
ELSE 
BEGIN
	--Si es SIMPLE, aplica a los 2 tipos de detracción
	SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
	FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
	WHERE a.Numcer58=@NUMCER and 
	b.codcom50 IS null and 
	a.flgval58='1' and 
	b.valcob59<>0 and 
	a.detrac58='S' 
	--********************06/11/2014 AOG
	and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)
	--********************06/11/2014 AOG
	GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
	UNION
	SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
	FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
	WHERE a.Numcer58=@NUMCER and 
	b.codcom50 IS null and 
	a.flgval58='1' and 
	b.valcob59<>0 and 
	isnull(a.dettranS,'N') = 'S'
	--********************06/11/2014 AOG
	and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)
	--********************06/11/2014 AOG
	GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
	UNION
	SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
	FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
	WHERE a.Numcer58=@NUMCER and 
	b.codcom50 IS null and 
	a.flgval58='1' and 
	b.valcob59<>0 and 
	isnull(a.dettranC,'N') = 'S'
	--********************06/11/2014 AOG
	and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)
	--********************06/11/2014 AOG
	GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
END


END

GO
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO_SIM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_ORDENES_DE_SERVICIO_SIM]            
@NUMCER VARCHAR(9),            
@DETRAC char(1),            
@DETRANS char(1),            
@DETRANC char(1),            
@FECSER VARCHAR(8) = ''            
AS            
BEGIN            
            
--rdelacuba 02/11/2006: Creado para diferenciar las facturas con y sin detracción de transporte            
            
/*Posibilidades de envío:             
1. @DETRAC = 'N', @DETRANS = 'N', @DETRANC = 'N'            
2. @DETRAC = 'S', @DETRANS = 'N', @DETRANC = 'N'            
3. @DETRAC = 'N', @DETRANS = 'S', @DETRANC = 'N'            
4. @DETRAC = 'N', @DETRANS = 'N', @DETRANC = 'S'            
*/            
            
--********************06/11/2014 AOG            
DECLARE @tdfilser AS TABLE (codser99 varchar(15))            
INSERT INTO @tdfilser (codser99)            
Select codser99 From DTFilSer99 Where usufil99= HOST_NAME()            
            
DECLARE @conFiltro INT             
SET @conFiltro = (Select COUNT(*) From @tdfilser)            
--********************06/11/2014 AOG            
/*            
SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)            
FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58            
WHERE a.Numcer58=@NUMCER and             
b.codcom50 is null and             
a.flgval58='1' and             
b.valcob59<>0 and             
a.detrac58=@DETRAC and            
isnull(a.dettrans,'N') = @DETRANS and            
isnull(a.dettranc,'N') = @DETRANC            
and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)            
and (a.fecord58 <= @FECSER or @FECSER = '')            
GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59            
*/            
--** 07/01/2015        
      
--| FRANKLIN MILLA LUMBE 25-03-2015      
--| REQUERIMIENTO: FACTURACION AUTOMATICA CUANDO NO EXISTE CARGA      
DECLARE @FINSERT CHAR(1)      
SELECT @FINSERT=finser74       
FROM DDCerSim74 WITH (NOLOCK)      
WHERE numcer74=@NUMCER      
      
IF @FINSERT='1'      
BEGIN      
 SELECT t.CodCon51,t.numuni54,t.cantid59,t.tamctr59            
   ,SUM((CASE WHEN t.valfun>t.valcob THEN t.valfun            
     ELSE t.valcob            
   END)) AS [valcob59]            
  FROM (SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59,b.valcob59,b.uniser59,b.valcob59*b.uniser59 as [valcob]            
     ,ISNULL(dbo.[fn_monto_minimo_x_servicio](LEFT(@NUMCER,1),a.tipcli02,a.codcli02,b.codcon51,a.TIPMON58),b.valcob59) as [valfun]            
    FROM DDOrdSer58 a             
   INNER JOIN DDDOrSer59 b             
   ON a.numord58=b.numord58            
   WHERE a.Numcer58=@NUMCER             
     and b.codcom50 IS null             
     and a.flgval58='1'             
     and b.valcob59<>0             
     and a.detrac58=@DETRAC             
     and isnull(a.dettrans,'N') = @DETRANS             
     and isnull(a.dettranc,'N') = @DETRANC            
     and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)            
     and (a.fecord58 <= @FECSER or @FECSER = '')          
     and (a.fecord58>='20150406')        
     ) t           
 GROUP BY t.CodCon51,t.numuni54,t.cantid59,t.tamctr59        
 RETURN;      
END      
      
IF @FINSERT='0'          
BEGIN      
 SELECT t.CodCon51,t.numuni54,t.cantid59,t.tamctr59            
    ,SUM((CASE WHEN t.valfun>t.valcob THEN t.valfun            
   ELSE t.valcob            
    END)) AS [valcob59]            
   FROM (SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59,b.valcob59,b.uniser59,b.valcob59*b.uniser59 as [valcob]            
   ,ISNULL(dbo.[fn_monto_minimo_x_servicio](LEFT(@NUMCER,1),a.tipcli02,a.codcli02,b.codcon51,a.TIPMON58),b.valcob59) as [valfun]            
  FROM DDOrdSer58 a             
    INNER JOIN DDDOrSer59 b             
    ON a.numord58=b.numord58            
    WHERE a.Numcer58=@NUMCER             
   and b.codcom50 IS null             
   and a.flgval58='1'             
   and b.valcob59<>0             
   and a.detrac58=@DETRAC      
   and isnull(a.dettrans,'N') = @DETRANS             
   and isnull(a.dettranc,'N') = @DETRANC            
   and (b.codcon51 IN (Select codser99 From @tdfilser) OR ISNULL(@conFiltro,0)=0)            
   and (a.fecord58 <= @FECSER or @FECSER = '')          
   --and (a.fecord58>='20150320')        
   ) t           
 GROUP BY t.CodCon51,t.numuni54,t.cantid59,t.tamctr59          
 RETURN;        
END       
--|            
END
GO
/****** Object:  StoredProcedure [dbo].[TAR_SALDOS_NIVEL_CERTIFICADO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAR_SALDOS_NIVEL_CERTIFICADO]    
@NUMCER varchar(9),    
@FECINI char(8)    
AS     
Select     
bultot79=SUM(bultot79),pretot79=SUM(pretot79+cuadep79),pesbru79=SUM(pesbru79)    
From     
DDEntMer79 a,DDTicket01 b    
Where     
a.nument79=b.numgui01 And a.numcer13=@numcer and b.fecsal01<@FECINI
GO
/****** Object:  StoredProcedure [dbo].[TAR_TARIFARIO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[TAR_TARIFARIO] AS  
  
Select   
a.DEPOSI52,DESDEP52=case when a.DEPOSI52='A' then 'DEPOSITO ADUANERO' else 'DEPOSITO SIMPLE' end,  
a.CONCEP51,b.DESCON51,a.SERVIC52,a.DESSER52,  
a.TIPMER72,c.desmer72,a.CODEMB06,d.desemb06,  
a.TARIFA52,a.TARIFA52S,a.TARMIN52,a.TARMIN52S,  
a.STATUS52,DESSTA52=case when a.STATUS52='A' then 'ACTIVA' else 'INACTIVA' end,  
a.APLICA52,DESAPL52=case when a.APLICA52='U' then 'UNIDAD' else case when a.APLICA52='M' then 'MONTO' else 'PORCENTAJE' end end  
From ddservic52 a, DQCONCOM51 b,DQTIPMER72 c,DQEMBALA06 d  
Where   
a.CONCEP51=b.CODCON51 and a.TIPMER72=c.TIPMER72 and a.codemb06=d.codemb06 and   
a.VISIBLE52='S' and b.visible51='S'  
Order by a.DEPOSI52,b.DESCON51,a.DESSER52,c.desmer72,d.desemb06


GO
/****** Object:  StoredProcedure [dbo].[usp_busca_certificado_factura]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_busca_certificado_factura] (@codcom50 varchar(2), @numcom50 varchar(10))
AS
BEGIN
	
SELECT numcer52, numper52
FROM DDCabCom52 (NOLOCK)
WHERE codcom50+numcom52 = @codcom50+@numcom50
ORDER BY numcer52

END

GO
/****** Object:  StoredProcedure [dbo].[USP_BUSCA_OS_TD]    Script Date: 07/03/2019 03:08:33 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER PROCEDURE [dbo].[USP_BUSCA_OS_TD]
--(@NRO_PLAREC32 VARCHAR(8))
--AS 
--BEGIN
--	SELECT
--		CLIENTE
--		,cast(FECDESPACHO as datetime) as FECDESPACHO
--		,cast(HORCITA as datetime) as HORCITA
--		,FACTURA
--		,GUIA
--		,UNIDADES
--		,BULTO
--		,PESO
--		,VOLUMEN
--		,PALETA
--		,VALORIZADO
--		,MONEDA
--		,DIRECCION
--		,DISTRITO
--		,ZONA
--	FROM DDPLAREC32
--	WHERE NRO_PLAREC32=@NRO_PLAREC32
--END
--GO
/****** Object:  StoredProcedure [dbo].[usp_ConectarWSAlmafin_AsociarWarrantDuaDeposito]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_ConectarWSAlmafin_AsociarWarrantDuaDeposito] @NroDuDes VARCHAR(13)
	,@NroChasis VARCHAR(20)
	,@Nroserie VARCHAR(4)
	,@CodigoWS VARCHAR(1)
	,@ValorWS VARCHAR(200)
AS
BEGIN
	UPDATE DDSerDep12
	SET numcha12 = @NroChasis
		,flgcons_ws12 = CASE 
			WHEN @CodigoWS = '1'
				THEN '1'
			ELSE (
					CASE WHEN @ValorWS like '%COMPROMETIDO%' THEN '1'
						 ELSE '0'
						 END
				 )
			END
		,warrant12 = CASE 
			WHEN @CodigoWS = '1'
				THEN @ValorWS
			ELSE (
					CASE WHEN @ValorWS like '%COMPROMETIDO%' THEN @ValorWS
						 ELSE ''
						 END
				 )
			END
	WHERE numdui11 = @NroDuDes
		AND numser12 = @Nroserie
		AND desmer12 LIKE '%' + @NroChasis + '%'
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ConectarWSAlmafin_AsociarWarrantDuaDespacho]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_ConectarWSAlmafin_AsociarWarrantDuaDespacho] @NroDuDes VARCHAR(14)
	,@NroChasis VARCHAR(20)
	,@Nroserie VARCHAR(4)
	,@CodigoWS VARCHAR(1)
	,@ValorWS VARCHAR(200)
AS
BEGIN
	UPDATE DDSerDes17
	SET numcha17 = @NroChasis
		,flgcons_ws17 = CASE 
			WHEN @CodigoWS = '1'
				THEN '1'
			ELSE (
					CASE WHEN @ValorWS like '%COMPROMETIDO%' THEN '1'
						 ELSE '0'
						 END
				 )
			END
		,warrant17 = CASE 
			WHEN @CodigoWS = '1'
				THEN @ValorWS
			ELSE (
					CASE WHEN @ValorWS like '%COMPROMETIDO%' THEN '1'
						 ELSE ''
						 END
				 )
			END
	WHERE numdui16 = @NroDuDes
		AND numser12 = @Nroserie
		AND desmer17 LIKE '%' + @NroChasis + '%'
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ConectarWSAlmafin_ListarNroChasisDuaDespacho]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_ConectarWSAlmafin_ListarNroChasisDuaDespacho 'A01089200'  
ALTER PROCEDURE [dbo].[usp_ConectarWSAlmafin_ListarNroChasisDuaDespacho] @NroCer VARCHAR(30)
AS
BEGIN
	SELECT distinct 
		NroChasis = dbo.fn_ConectarWSAlmafin_ObtenerChasis(b.desmer12)
		,NroDuaDeposito = a.numdui11
		,Nro_Serie = b.numser12
		,a.numser12
	FROM DDDCeAdu14 a
	INNER JOIN DDSerDep12 b ON a.numdui11 = b.numdui11
		AND a.NumSer12 = b.NumSer12
	LEFT JOIN DDSerDes17 c ON c.numdui11 = b.numdui11
		AND c.numser12 = b.numser12
		AND a.numcer13 = c.numcer13
	WHERE (a.numbul14 - a.buldes14 + a.pesbru14 - a.pesdes14 + a.valfob14 - a.fobdes14 + a.valfle14 - a.fledes14 + a.valseg14 - a.segdes14) <> 0
		AND a.numcer13 = @NroCer
		AND b.codemb06 = 'VEH'
		AND c.numdui11 IS NULL
	ORDER BY a.numser12
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ConectarWSAlmafin_ListarNroChasisOrdenRetiro]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_ConectarWSAlmafin_ListarNroChasisOrdenRetiro '1181810111111'  
ALTER PROCEDURE [dbo].[usp_ConectarWSAlmafin_ListarNroChasisOrdenRetiro] @NroDuaDes VARCHAR(30)
AS
BEGIN
	SELECT DISTINCT 
	NroChasis = dbo.fn_ConectarWSAlmafin_ObtenerChasis(a.desmer17)
		,NroDuaDespacho = a.numdui16
		,Nro_Serie = a.numser12
		,a.numser17
	FROM DDSerDes17 a
	--Inner Join DDSerDep12 b on a.numdui11=b.numdui11 And a.NumSer12=b.NumSer12    
	INNER JOIN DDDCeAdu14 c ON c.numdui11 = a.numdui11
		AND c.numser12 = c.numser12
		AND a.numcer13 = c.numcer13
	LEFT JOIN DRRetAdu18 d ON d.numdui16 = a.numdui16
	WHERE a.NumDui16 = ltrim(rtrim(@NroDuaDes))
		AND a.codemb06 = 'VEH'
		AND d.numdui16 IS NULL
	ORDER BY a.numser17
END

GO
/****** Object:  StoredProcedure [dbo].[usp_ConectarWSAlmafin_RegistrarTrama]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_ConectarWSAlmafin_RegistrarTrama]  
@NroDua varchar(14)  
,@NroChasis varchar(30)  
,@CodigoWarrant varchar(1)  
,@ResulWarrant varchar(500)  
,@Error varchar(5000)  
,@Tipo varchar(150)  
as  
begin  
 insert into DDTransaccionWSAlmafin00  
 values(@NroDua, @NroChasis, @CodigoWarrant, @ResulWarrant, GETDATE(), USER_NAME(), HOST_NAME(), @Error, @Tipo)  
end  
  
GO
/****** Object:  StoredProcedure [dbo].[USP_DEPOSITO_ALM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_DEPOSITO_ALM]
AS
BEGIN
	SELECT 'A - DEPOSITO CENTRAL' AS VALOR
	UNION
	SELECT 'B - DEPOSITO ANEXO' AS VALOR
	UNION	
	SELECT 'C - TERRANO' AS VALOR	
	UNION	
	SELECT 'D - CENTRAL ANEXO' AS VALOR	
	UNION	
	SELECT 'E - SENASA' AS VALOR	
	UNION	
	SELECT 'F - PAMOLSA' AS VALOR
	UNION
	SELECT 'G - LURIN ANEXO 1' AS VALOR
END

GO
/****** Object:  StoredProcedure [dbo].[usp_Depositos_ConsultarSolicitudAduanera]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
Descripcion: Stored Procedures que devuelve el numero de solicitud aduanera con la DUA  
Fecha: 02-03-2018  
Autor: Franklin Milla  
*/
ALTER PROCEDURE [dbo].[usp_Depositos_ConsultarSolicitudAduanera] @numdui VARCHAR(13)
	,@Id INT OUTPUT
	,@sDescripcion VARCHAR(500) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	--//Validacion de la longitud de la DUA  
	IF LEN(LTRIM(rtrim(@numdui))) <> 13
	BEGIN
		SET @Id = 1
		SET @sDescripcion = 'El Nro. de DUA debe ser de 13 carácteres'

		RETURN;
	END

	--//Validacion si la DUA se encuentra registrada en el sistema  
	IF NOT EXISTS (
			SELECT numsol10
			FROM DDSolAdu10(NOLOCK)
			WHERE ltrim(rtrim(numdui10)) = @numdui
			)
	BEGIN
		SET @Id = 2
		SET @sDescripcion = 'El Nro. de DUA no existe'

		RETURN;
	END

	DECLARE @numsol10 VARCHAR(7)
		,@codalm VARCHAR(1)

	--//Validacion de Consignatario, debe ser solo 20503258901 - MAQUINARIA NACIONAL S.A. PERU , 20506006024 - AUTOMOTORES GILDEMEISTER-PERU S.A., 20519033233 - MOTOR MUNDO SA  
	IF NOT EXISTS (
			SELECT numsol10
			FROM DDSolAdu10(NOLOCK)
			WHERE ltrim(rtrim(numdui10)) = @numdui
				AND codcli02 IN (
					'20506006024'
					,'20503258901'
					,'20519033233'
					)
			)
	BEGIN
		SET @Id = 3
		SET @sDescripcion = 'Consignatario asociado es Incorrecto'

		RETURN;
	END

	--//Validacion de codigo de embalaje  
	IF NOT EXISTS (
			SELECT numsol10
			FROM DDSolAdu10(NOLOCK)
			WHERE ltrim(rtrim(numdui10)) = @numdui
				AND codcli02 IN (
					'20506006024'
					,'20503258901'
					,'20519033233'
					)
				AND codemb06 IN ('VEH')
			)
	BEGIN
		SET @Id = 4
		SET @sDescripcion = 'Embalaje asociado es Incorrecto'

		RETURN;
	END

	SELECT @numsol10 = numsol10
	FROM DDSolAdu10(NOLOCK)
	WHERE ltrim(rtrim(numdui10)) = @numdui
		AND codcli02 IN (
			'20506006024'
			,'20503258901'
			,'20519033233'
			)
		AND codemb06 IN ('VEH')

	SELECT @codalm = codalm99
	FROM DDAlmExp99(NOLOCK)
	WHERE numsol99 = @numsol10

	--//Validacion de Almacen asociado sea (SENASA, PAMOLSA, OPORSA)  
	IF isnull(@codalm, '') NOT IN (
			'F'
			,'E'
			)
	BEGIN
		SET @Id = 5
		SET @sDescripcion = 'Almacen asociado es Incorrecto'

		RETURN;
	END

	SET @Id = 0
	SET @sDescripcion = @numsol10
	SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_Depositos_GenerarTicketIngreso]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*        
Descripcion: Stored Procedures que Genera Ticket de Ingreso para Deposito Aduanero - Vehiculos        
Fecha: 02-03-2018        
Autor: Franklin Milla        
*/

ALTER PROCEDURE [dbo].[usp_Depositos_GenerarTicketIngreso] @sTipoDeposito VARCHAR(1)
	,@sMercaderia VARCHAR(500)
	,@dfechaInicio VARCHAR(14)
	,@sSolicitud VARCHAR(7)
	,@iCantidad INT
	,@sChasis VARCHAR(20)
	,@dPeso DECIMAL(13, 3)
	,@Id INT OUTPUT
	,@sDescripcion VARCHAR(500) OUTPUT
AS
--SET @Id ='2'
--SET @sDescripcion = 'Error al Generar el Ticket de ingreso' --Se desactivo generación de Ticket  

--RETURN

BEGIN
	SET @Id = 0

	IF ltrim(rtrim(@sTipoDeposito)) <> 'A'
	BEGIN
		SET @Id = '1'
		SET @sDescripcion = 'El Tipo de Deposito debe ser Aduanero (A)'

		RETURN;
	END

	IF SUBSTRING(@sMercaderia, 1, 1) <> 'V'
	BEGIN
		SET @Id = '2'
		SET @sDescripcion = 'La Mercadería debe ser VEHICULOS'

		RETURN;
	END

	IF LEN(ltrim(rtrim(@sSolicitud))) = 0
	BEGIN
		SET @Id = '3'
		SET @sDescripcion = 'Debe enviar Nro de Solicitud'

		RETURN;
	END

	IF @iCantidad < 1
	BEGIN
		SET @Id = '4'
		SET @sDescripcion = 'Cantidad de vehículo debe ser mayor a cero'

		RETURN;
	END

	IF LEN(ltrim(rtrim(@sChasis))) = 0
	BEGIN
		SET @Id = '5'
		SET @sDescripcion = 'Debe enviar Nro de chasis'

		RETURN;
	END

	IF @dPeso <= 0
	BEGIN
		SET @Id = '6'
		SET @sDescripcion = 'Peso del vehículo debe ser mayor a cero'

		RETURN;
	END

	--//Validar si existe Nro de Solicitud        
	DECLARE @NroSolicitud VARCHAR(7)

	IF substring(@sSolicitud, 1, 1) = 'A'
	BEGIN
		SET @NroSolicitud = @sSolicitud
	END
	ELSE
	BEGIN
		SET @NroSolicitud = 'A' + (right('000000' + ltrim(rtrim(@sSolicitud)), (6)))
	END

	IF NOT EXISTS (
			SELECT numsol10
			FROM DDSolAdu10(NOLOCK)
			WHERE numsol10 = @NroSolicitud
			)
	BEGIN
		SET @Id = '7'
		SET @sDescripcion = 'Nro de Solicitud no existe'

		RETURN;
	END

	DECLARE @sTipCliente VARCHAR(1)
		,@sCodCliente VARCHAR(11)
		,@sCodAgente VARCHAR(11)
		,@tipest01 VARCHAR

	SET @sTipCliente = ''
	SET @sCodCliente = ''
	SET @sCodAgente = ''

	SELECT @sCodAgente = a.codage19
		,@sTipCliente = a.tipcli02
		,@sCodCliente = a.codcli02
	FROM DDSolAdu10 a(NOLOCK)
		,AAClientesAA b(NOLOCK)
	WHERE a.tipcli02 = b.claseabc
		AND a.codcli02 = b.contribuy
		AND a.numsol10 = @NroSolicitud

	--//Registrar Ticket de Ingreso        
	DECLARE @numtkt01 CHAR(8)
	
	/*
	SELECT @numtkt01 = RIGHT('00000000' + CONVERT(VARCHAR(8), contkt01), 8)
	FROM DCTicket01

	UPDATE DCTicket01
	SET contkt01 = contkt01 + 1

	SET @tipest01 = 'S'

	--BEGIN TRAN        
	INSERT DDTicket01 (
		numtkt01
		,tipope01
		,tipest01
		,tipmer01
		,docaut01
		,numgui01
		,fecing01
		,fecsal01
		,pesbru01
		,pestar01
		,pesnet01
		,tarcon01
		,numpla01
		,numbul01
		,codemb06
		,numcha01
		,tipcli02
		,codcli02
		,codage19
		,nomusu01
		,fecusu01
		,flgdes01
		,flgman01
		,tktter01
		,tarct101
		,tarct201
		)
	VALUES (
		@numtkt01
		,'D'
		,@tipest01
		,SUBSTRING(@sMercaderia, 1, 1)
		,@NroSolicitud
		,NULL
		,@dfechaInicio
		,@dfechaInicio
		,@dPeso
		,0
		,@dPeso
		,0
		,NULL
		,@iCantidad
		,'VEH'
		,@sChasis
		,isnull(@sTipCliente, '')
		,isnull(@sCodCliente, '')
		,isnull(@sCodAgente, '')
		,'Interface'
		,GETDATE()
		,'0'
		,'1'
		,NULL
		,'0'
		,'0'
		)

	IF @@ERROR <> 0
	BEGIN
		SET @Id = '8'
		SET @sDescripcion = 'Error al Generar el Ticket de ingreso'

		--ROLLBACK TRAN        
		RETURN;
	END
	*/
	
	--COMMIT TRAN        
	SET @Id = '0'
	SET @sDescripcion = '' --@numtkt01

	RETURN;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_EnvioAutomatico_GenerarInformacionOrdenesRetiroPendientes]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_EnvioAutomatico_GenerarInformacionOrdenesRetiroPendientes] @TipoCliente VARCHAR(1)
	,@CodCliente VARCHAR(11)
AS
BEGIN
	BEGIN TRAN

	DELETE EnvioAutomatico_DTRetCli99

	INSERT EnvioAutomatico_DTRetCli99
	EXEC REPORTE_ORR_PEN_POR_CLI_SIM @TipoCliente
		,@CodCliente

	INSERT EnvioAutomatico_DTRetCli99
	EXEC REPORTE_ORR_PEN_POR_CLI_ADU @TipoCliente
		,@CodCliente

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
	END

	COMMIT TRAN
END

GO
/****** Object:  StoredProcedure [dbo].[usp_EnvioAutomatico_GenerarInformacionSaldosMercanciasDeposito]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_EnvioAutomatico_GenerarInformacionSaldosMercanciasDeposito]
	@TipoCliente VARCHAR(1)
	,@CodCliente VARCHAR(11)
AS
BEGIN
	BEGIN TRAN
		declare @Fecha varchar(8)
		
		set @Fecha = CONVERT(varchar(8), getdate(), 112)
		
		Delete EnvioAutomatico_DTIngCli44
		Delete EnvioAutomatico_DTSalCli45

		Insert EnvioAutomatico_DTIngCli44 EXEC REPORTE_SLD_CLI_SIM1 @TipoCliente, @CodCliente, @Fecha
		Insert EnvioAutomatico_DTIngCli44 EXEC REPORTE_SLD_CLI_ADU1 @TipoCliente, @CodCliente, @Fecha

		Insert EnvioAutomatico_DTSalCli45 EXEC REPORTE_SLD_CLI_SIM2 @TipoCliente, @CodCliente, @Fecha
		Insert EnvioAutomatico_DTSalCli45 EXEC REPORTE_SLD_CLI_ADU2 @TipoCliente, @CodCliente, @Fecha
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
	END
	
	COMMIT TRAN
END


GO
/****** Object:  StoredProcedure [dbo].[usp_EnvioAutomatico_OrdenesRetiroPendientes]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_EnvioAutomatico_OrdenesRetiroPendientes]
AS
BEGIN
	SELECT numret18
		,fecret18
		,numdui16
		,tipcli02
		,codcli02
		,nomcli02
		,razage19
		,bulsld99
		,cifsld99
		,desmer10
		,numcer13
	FROM EnvioAutomatico_DTRetCli99
	ORDER BY tipcli02 ASC
		,codcli02 ASC
		,fecret18 ASC
		,numret18 ASC
END

GO
/****** Object:  StoredProcedure [dbo].[usp_EnvioAutomatico_SaldosFisicosSerieAduanero]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_EnvioAutomatico_SaldosFisicosSerieAduanero] @TipoCliente VARCHAR(1)
	,@CodCliente VARCHAR(11)
AS
BEGIN
	SELECT d.claseabc
		,d.contribuy
		,d.nombre
		,a.numdui11
		,a.numcer13
		,a.feccer13
		,b.numser12
		,b.numbul14
		,b.bulent14
		,sldbul = b.numbul14 - b.bulent14
		,c.codemb06
		,b.desmer14
		,unidad12 = b.unidad12
		,bulent12 = ISNULL(b.bulent12, 0)
		,sldbulUC = (b.unidad12 - ISNULL(b.bulent12, 0))
	FROM DDCERADU13 a
		,DDDCEADU14 b
		,DDSERDEP12 c
		,AAClientesAA d
	WHERE a.numcer13 = b.numcer13
		AND a.numsol10 = c.numsol10
		AND b.numser12 = c.numser12
		AND a.numbul13 - a.bulent13 >= 0
		--AND b.numbul14 - b.bulent14 > 0
		AND a.tipcli02 = d.claseabc
		AND a.codcli02 = d.contribuy
		AND a.tipcli02 = @TipoCliente
		AND a.codcli02 = @CodCliente
		AND flgval13 = 1
	ORDER BY a.numcer13
		,b.numser12
END

GO
/****** Object:  StoredProcedure [dbo].[usp_EnvioAutomatico_SaldosFisicosSerieSimple]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_EnvioAutomatico_SaldosFisicosSerieSimple] @TipoCliente VARCHAR(1)
	,@CodCliente VARCHAR(11)
AS
SELECT d.claseabc
	,d.contribuy
	,d.nombre
	,a.numcer74
	,a.feccer74
	,b.numser67
	,b.bulrec67
	,b.bulent67
	,sldbul = b.bulrec67 - b.bulent67
	,b.codemb06
	,b.desmer67
FROM DDCerSim74 a
INNER JOIN DDDSoSim67 b ON a.numsol62 = b.numsol62
INNER JOIN AAClientesAA d ON a.tipcli02 = d.claseabc
	AND a.codcli02 = d.contribuy
WHERE 
	a.bultot74 - a.bulent74 > 0
	--AND b.bulrec67 - b.bulent67 > 0
	AND a.flgval74 = 1
	AND a.codcli02 = @CodCliente
ORDER BY a.numcer74
	,b.numser67

GO
/****** Object:  StoredProcedure [dbo].[usp_EnvioAutomatico_SaldosMercanciasDeposito]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_EnvioAutomatico_SaldosMercanciasDeposito]
as
begin
	SELECT
    a.numcer44
    ,a.numdui44
    ,a.tipcli44
    ,a.codcli44
    ,a.nomcli44
    ,a.fecing44
    ,a.buling44
    ,a.codemb44
    ,a.desmer44
    ,a.cifing44
    ,b.bulent45
    ,b.cifent45
    ,'BulSld' = case when b.bulent45 is not null then (a.buling44 - b.bulent45) else a.buling44 end
    ,'CifSld' = case when b.cifent45 is not null then (a.cifing44 - b.cifent45) else a.cifing44 end
		INTO #TEMPORAL
	FROM
    EnvioAutomatico_DTIngCli44 a (nolock)
    LEFT OUTER JOIN EnvioAutomatico_DTSalCli45 b (nolock) ON numcer44 = numdui45
    
    SELECT 
    numcer44
    ,numdui44
    ,tipcli44
    ,codcli44
    ,nomcli44
    ,fecing44
    ,buling44
    ,codemb44
    ,desmer44
    ,cifing44
    ,bulent45
    ,cifent45
    FROM #TEMPORAL
    WHERE BulSld <> 0 or CifSld <>0
    
    drop table #TEMPORAL
end

GO
/****** Object:  StoredProcedure [dbo].[usp_gen_TicketManual_Retiro]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC usp_gen_TicketManual_Retiro 'A','VEHICULOS','126587','93381',1,'KMHST81CBJU834829',1290,'frmilla'    
ALTER PROCEDURE [dbo].[usp_gen_TicketManual_Retiro] @sTipoDeposito VARCHAR(1)
	,@sMercaderia VARCHAR(100)
	,@sEntregaMercaderia VARCHAR(7)
	,@sNroOrden VARCHAR(7)
	,@iCantidad INT
	,@sChasis VARCHAR(150)
	,@iPesoNeto INT
	,@sUser VARCHAR(25)
AS
BEGIN
	--//Seteo de Variables    
	SET @sMercaderia = ltrim(rtrim(@sMercaderia))
	SET @sChasis = ltrim(rtrim(@sChasis))
	SET @sUser = ltrim(rtrim(@sUser))
	SET @sEntregaMercaderia = @sTipoDeposito + right('000000' + ltrim(rtrim(@sEntregaMercaderia)), (6))
	SET @sNroOrden = @sTipoDeposito + right('000000' + ltrim(rtrim(@sNroOrden)), (6))

	--//    
	DECLARE @sNrotkt VARCHAR(8)
		,@sOrden VARCHAR(7)
		,@iPestar INT
		,@sFechaIngreso VARCHAR(14)
		,@iPesoBruto INT
		,@sPlaca VARCHAR(6)
		,@dTotalBultos DECIMAL(12, 3)
		,@sTipoBultos VARCHAR(3)
		,@sTipoCliente VARCHAR(1)
		,@sCodCliente VARCHAR(12)
		,@sCodAgente VARCHAR(4)
		,@sNroCertificado VARCHAR(9)
		,@sUltcer79 VARCHAR(1)
		,@sGsNumDep VARCHAR(13)
		,@sLsCuaDep DECIMAL(15, 3)
		,@dLsBulTotUC DECIMAL(15, 3)
		,@dLsPreTot DECIMAL(15, 3)
		,@sGsNumDes VARCHAR(14)
		,@regpud00 varchar(5000)
		
	IF @sTipoDeposito = 'A'
	BEGIN
		--//Obtener Correlativo del Ticket    
		SELECT @sNrotkt = right('00000000' + ltrim(rtrim(cast(contkt01 AS VARCHAR))), (8))
		FROM DCTicket01(NOLOCK)

		--//Actualizar contador para que lo utilice otra operacion    
		--|1.  
		UPDATE DCTicket01
		SET contkt01 = contkt01 + 1

		--//Obtener la inforacion de la mercaderia    
		SELECT @sOrden = a.numret75
			,@sGsNumDes = a.numdui16
			,@sGsNumDep = a.numdui11
			,@sNroCertificado = a.numcer13
			,@sCodAgente = c.codage19
			,@sTipoCliente = c.tipcli02
			,@sCodCliente = c.codcli02
			--,d.nombre    
			,@sPlaca = a.numpla79
			--,a.numtkt01    
			--,a.bultot79    
			,@sTipoBultos = a.codemb06
			--,a.flgval79    
			--,a.flgemi79    
			,@sUltcer79 = a.ultcer79
		--,a.pesbru79    
		FROM DDEntMer79 a(NOLOCK)
			,DRRetAdu18 b(NOLOCK)
			,DDDuiDes16 c(NOLOCK)
			,AAClientesAA d(NOLOCK)
		WHERE a.numret75 = b.numret18
			AND b.numdui16 = c.numdui16
			AND c.tipcli02 = d.claseabc
			AND c.codcli02 = d.contribuy
			AND a.nument79 = @sEntregaMercaderia

		--//    
		--//Obtener Fecha de ingreso    
		SET @iPestar = 0

		SELECT @iPestar = pestar20
			,@sFechaIngreso = (CONVERT(VARCHAR(8), fecing20, 112) + ' ' + convert(VARCHAR(5), fecing20, 114))
		FROM DDOrdPla20(NOLOCK)
		WHERE nument79 = @sEntregaMercaderia
			AND tipest20 = 'G'

		IF @sFechaIngreso IS NULL
		BEGIN
			SET @sFechaIngreso = (CONVERT(VARCHAR(8), GETDATE(), 112) + ' ' + convert(VARCHAR(5), GETDATE(), 114))
		END

		--//    
		SET @iPesoBruto = @iPestar + @iPesoNeto

		SELECT @dTotalBultos = sum(numbul80)
		FROM DDDEnMer80(NOLOCK)
		WHERE NumEnt79 = @sEntregaMercaderia

		SELECT @dLsBulTotUC = sum(numbul12)
		FROM DDDEnMer80(NOLOCK)
		WHERE NumEnt79 = @sEntregaMercaderia

		SELECT @dLsPreTot = sum(preent80)
		FROM DDDEnMer80(NOLOCK)
		WHERE NumEnt79 = @sEntregaMercaderia

		--|2.  
		--//Generar Ticket Manual de Salida    
		INSERT DDTicket01 (
			numtkt01
			,tipope01
			,tipest01
			,tipmer01
			,docaut01
			,numgui01
			,fecing01
			,fecsal01
			,pesbru01
			,pestar01
			,pesnet01
			,tarcon01
			,numpla01
			,numbul01
			,codemb06
			,numcha01
			,tipcli02
			,codcli02
			,codage19
			,nomusu01
			,fecusu01
			,flgdes01
			,flgman01
			,tktter01
			)
		VALUES (
			@sNrotkt
			,'R'
			,'S'
			,NULL
			,@sOrden
			,@sEntregaMercaderia
			,@sFechaIngreso
			,GETDATE()
			,@iPesoBruto
			,@iPestar
			,@iPesoNeto
			,NULL
			,ISNULL(@sPlaca, '')
			,CAST(@dTotalBultos AS INT)
			,@sTipoBultos
			,NULL
			,@sTipoCliente
			,@sCodCliente
			,isnull(@sCodAgente, '')
			,ltrim(rtrim((@sUser)))
			,getdate()
			,'0'
			,'1'
			,NULL
			)

		--//Obtener Importe DUA    
		IF @sUltcer79 = '1'
		BEGIN
			/*
			CREATE TABLE #IMPORTEDUA (GetCuaDep DECIMAL(15, 3))

			INSERT INTO #IMPORTEDUA
			EXEC SP_CUADRAR_ENTREGA_MERCADERIA_TKT_AUTOMATICO @sGsNumDep

			SELECT @sLsCuaDep = GetCuaDep
			FROM #IMPORTEDUA

			IF ISNULL(@sLsCuaDep, 0) <= 0
			BEGIN
				SET @sLsCuaDep = 0
			END
			*/
			
			/**************************************************/
			DECLARE @GetCuaDep DECIMAL(15, 3)
				,@totser11 INT
				,@numbul11 DECIMAL(15, 3)
				,@valcif11 DECIMAL(15, 3)
				,@totser12 INT
				,@bulent12 DECIMAL(15, 3)
				,@cifent12 DECIMAL(15, 3)
				,@totxpesar INT
				
			SET @GetCuaDep = 0

			--Obtiene los Importes de la DUA de Deposito    
			SELECT @totser11 = totser11
				,@numbul11 = numbul11
				,@valcif11 = valcif11
			FROM DDDuiDep11
			WHERE numdui11 = @sGsNumDep

			--Obtiene el nmero de series depositadas    
			SELECT @totser12 = count(*)
			FROM DDSerDep12
			WHERE numdui11 = @sGsNumDep

			--Obtiene los Montos de lo entregado    
			SELECT @bulent12 = coalesce(sum(b.numbul80), 0)
				,@cifent12 = coalesce(sum(b.preent80), 0)
			FROM DDentmer79 a
				,dddenmer80 b
			WHERE a.nument79 = b.nument79
				AND a.numdui11 = @sGsNumDep
				AND a.flgval79 = '1'
				 
			SELECT @totxpesar = count(*)
			FROM DDentmer79
			WHERE numdui11 = @sGsNumDep
				AND ultcer79 = 1
				--AND numtkt01 IS NULL  
				
			IF (@totser11 = @totser12)
				AND (@numbul11 = @bulent12)
				AND (@totxpesar = 1)
				SELECT @GetCuaDep = @valcif11 - @cifent12
			ELSE
				SELECT @GetCuaDep = 0

			SET @sLsCuaDep = @GetCuaDep
			/**************************************************/
			
			SET @regpud00 = CAST(isnull(@totser11,0) as varchar) + '|' + CAST(isnull(@totser12,0) as varchar) + '|' + CAST(isnull(@numbul11,0) as varchar) + '|' + CAST(isnull(@bulent12,0) as varchar) + '|' +
							CAST(isnull(@totxpesar,0) as varchar) + '|' + CAST(isnull(@valcif11,0) as varchar) + '|' + CAST(isnull(@cifent12,0) as varchar) + '|' +  CAST(isnull(@GetCuaDep,0) as varchar)

			INSERT INTO DDAuditoriaTktAutomatico (
				EntregaMercaderia
				,NumeroDua11
				,NumeroCertificado
				,ultcer79
				,pretot79
				,cuadep79
				,Tipo
				,regpud00
				)
			VALUES (
				@sEntregaMercaderia
				,@sGsNumDep
				,@sNroCertificado
				,@sUltcer79
				,@dTotalBultos
				,@sLsCuaDep
				,'I'
				,@regpud00
				)

			--DROP TABLE #IMPORTEDUA
		END
		ELSE
		BEGIN
			SET @sLsCuaDep = 0

			INSERT INTO DDAuditoriaTktAutomatico (
				EntregaMercaderia
				,NumeroDua11
				,NumeroCertificado
				,ultcer79
				,pretot79
				,cuadep79
				,Tipo
				,regpud00
				)
			VALUES (
				@sEntregaMercaderia
				,@sGsNumDep
				,@sNroCertificado
				,@sUltcer79
				,@dTotalBultos
				,@sLsCuaDep
				,'N'
				,null
				)
		END

		--//    
		--|3.  
		UPDATE DDEntMer79
		SET bultot79 = @dTotalBultos
			,pretot79 = @dLsPreTot
			,cuadep79 = @sLsCuaDep
			,bultot12 = @dLsBulTotUC
			,numpla79 = ISNULL(@sPlaca, '')
			,pesbru79 = @iPesoNeto
			,numtkt01 = @sNrotkt
		WHERE nument79 = @sEntregaMercaderia

		--|4.  
		UPDATE DDDuiDes16
		SET pesent16 = pesent16 + @iPesoNeto
			,bulent16 = bulent16 + CAST(@dTotalBultos AS INT)
			,cifent16 = cifent16 + @dLsPreTot
		WHERE numdui16 = @sGsNumDes

		--//Actualizar Fecha de Salida    
		--|5.  
		UPDATE DDOrdPla20
		SET tipest20 = 'S'
			,fecsal20 = getdate()
		WHERE nument79 = @sEntregaMercaderia

		--//    
		--|6.  
		UPDATE DDCerAdu13
		SET pesent13 = pesent13 + @iPesoNeto
			,bulent13 = bulent13 + CAST(@dTotalBultos AS INT)
			,cifent13 = cifent13 + (@dLsPreTot + @sLsCuaDep)
		WHERE numcer13 = @sNroCertificado

		--|7.  
		UPDATE DDDuiDep11
		SET pesent11 = pesent11 + @iPesoNeto
			,bulent11 = bulent11 + @dTotalBultos
			,cifent11 = cifent11 + (@dLsPreTot + @sLsCuaDep)
		WHERE numdui11 = @sGsNumDep

		--|8.  
		IF @sUltcer79 = '1'
		BEGIN
			IF EXISTS (
					SELECT numcer52
					FROM DDCabCom52(NOLOCK)
					WHERE finper52 >= GETDATE()
						AND numcer52 = @sNroCertificado
						AND flgval52 = '1'
						AND flgemi52 = '1'
					)
			BEGIN
				UPDATE DDCerAdu13
				SET ultent13 = getdate()
					,finalm13 = '1'
					,finser13 = '1'
				WHERE numcer13 = @sNroCertificado
			END
			ELSE
			BEGIN
				UPDATE DDCerAdu13
				SET ultent13 = getdate()
				WHERE numcer13 = @sNroCertificado
			END
		END
	END
END

GO
/****** Object:  StoredProcedure [dbo].[usp_gen_TicketManual_Validacion]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_gen_TicketManual_Validacion]
@sTipoDeposito varchar(1)
,@sMercaderia varchar(100)
,@sEntregaMercaderia varchar(7)
,@sNroOrden varchar(7)
,@iCantidad int
,@sChasis varchar(150)
,@iPesoNeto int
AS
BEGIN
set nocount on;
	declare @mensaje varchar(250)
	set @mensaje = ''
	
	--//Seteo de Variables
	set @sMercaderia = ltrim(rtrim(@sMercaderia))
	set @sChasis = ltrim(rtrim(@sChasis))
	set @sEntregaMercaderia = @sTipoDeposito +  right('000000'+ltrim(rtrim(@sEntregaMercaderia)),(6))
	set @sNroOrden = @sTipoDeposito +  right('000000'+ltrim(rtrim(@sNroOrden)),(6))
	--//
	
	--//Validar Ingreso de datos
	if LEN(RTRIM(ltrim(@sTipoDeposito))) = 0
	begin
		set @mensaje = 'No existe dato del tipo de deposito en el archivo a Cargar'
		select @mensaje as Mensaje
		return;
	end

	if LEN(RTRIM(ltrim(@sEntregaMercaderia))) = 0
	begin
		set @mensaje = 'No existe dato de la entrega de mercaderia en el archivo a Cargar'
		select @mensaje as Mensaje
		return;
	end

	if LEN(RTRIM(ltrim(@sNroOrden))) = 0
	begin
		set @mensaje = 'No existe dato de la orden de retiro en el archivo a Cargar'
		select @mensaje as Mensaje
		return;
	end
	
	if @iCantidad <= 0 
	begin
		set @mensaje = 'La cantidad de bultos debe ser mayor a cero en el archivo a Cargar'
		select @mensaje as Mensaje
		return;
	end
	
	if @iPesoNeto <= 0
	begin
		set @mensaje = 'El peso neto debe ser mayor a cero en el archivo a Cargar'
		select @mensaje as Mensaje
		return;
	end
	--//
	
	--//Validar entrega de mercaderia
	declare @flgval79 varchar(1)
	,@flgemi79 varchar(1)
	,@codcli02 varchar(11)
	,@numret75 varchar(11)
	,@numtkt01 varchar(8)
	
	set @numret75 = ''
	 
	SELECT @numret75 = a.numret75
		,@codcli02 = c.codcli02
		,@flgval79 = a.flgval79
		,@flgemi79 = a.flgemi79
		,@numtkt01 = a.numtkt01
	FROM DDEntMer79 a (nolock)
		,DRRetAdu18 b (nolock)
		,DDDuiDes16 c (nolock)
		,AAClientesAA d (nolock)
	WHERE a.numret75 = b.numret18
		AND b.numdui16 = c.numdui16
		AND c.tipcli02 = d.claseabc
		AND c.codcli02 = d.contribuy
		AND a.nument79 = @sEntregaMercaderia
		
	if ISNULL(@numret75,'') = ''
	begin
		set @mensaje = 'La entrega de mercaderia no existe (' + @sEntregaMercaderia + ')'
		select @mensaje as Mensaje
		return;
	end
	
	if exists (
					select contribuy from aaclientesaa 
					where flgbloqtot='1' and contribuy = @codcli02
			   )
	begin
		set @mensaje = 'Cliente bloqueado (' + @codcli02 + ') ,La Carga ha sido bloqueada de manera total'
		select @mensaje as Mensaje
		return;
	end
	
	if ISNULL(@flgval79,'') = '0'
	begin
		set @mensaje = 'Entrega de mercadería ANULADA (' + @sEntregaMercaderia + ')'
		select @mensaje as Mensaje
		return;
	end
	
	if ISNULL(@flgemi79,'') = '0'
	begin
		set @mensaje = 'Entrega de mercadería NO EMITIDA. (' + @sEntregaMercaderia + ')'
		select @mensaje as Mensaje
		return;
	end
	
	if ISNULL(@numtkt01,'') <> ''
	begin
		set @mensaje = 'Entrega de mercadería tiene Ticket ' + @numtkt01 + ' ASOCIADO'
		select @mensaje as Mensaje
		return;
	end
	--//

	select @mensaje as Mensaje
	
set nocount off;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_CG_ADU_FACTURA_SOLICITUD]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================
-- CREAMOS EL STORED PROCEDURE
--=================================================================================
ALTER PROCEDURE [dbo].[usp_gwc_CG_ADU_FACTURA_SOLICITUD](
@NUMFAC      CHAR(10),
@DEPOSI      CHAR(01)/*,
@DESNAV      VARCHAR(100) OUTPUT*/)
AS
BEGIN

/*rdelacuba 03/11/2006: Se aplican los cambios necesarios para calcular el valor referencial*/
DECLARE @dettranS char(1), @dettranC char(1), @tc decimal(5,3), @tot_fac decimal(15,2), 
	@num_cert varchar(9), @porc_igv decimal(12,2),
	@servicio varchar(8), @val_fac decimal(15,2), @val_ref decimal(12,2), @num_sol varchar(7), @tot_viajes int,
	@valor_referencial decimal(15,2), @aplica int, @val_ref_calc decimal(15,2) , @peso decimal(15,2),@VALREF decimal(15,2)

--Verificando si es factura por detracción de transporte, y si tiene o no valor referencial
SELECT
   @dettranS   = c.dettrans,
   @dettranC   = c.dettranc,
   @tc         = c.tipcam52, 
   @tot_fac    = c.SubTot52 + c.IGVTot52,
   @num_cert   = c.numcer52,
   @porc_igv   = c.porigv52
FROM
   ddcabcom52 c (NOLOCK) 
WHERE
   numcom52 = @NUMFAC

SET @aplica       = 0
SET @val_ref_calc = 0

--Si es SIN valor referencial, verificar si el total facturado es mayor a S/400
--de ser así, indicar que debe figurar glosa fija NUNCA FIGURA MONTO A DETRAER
IF @dettranS = 'S'
   BEGIN
      IF (@tot_fac * @tc) > 400
         BEGIN
            SELECT @valor_referencial = 1
         END
      ELSE
         BEGIN
            SELECT @valor_referencial = 0
      END
   END


IF @dettranC = 'S'
BEGIN
	--Ubicando información del número de viajes
	IF @DEPOSI = 'S'
	BEGIN
		SELECT @num_sol = numsol62
		FROM DDCerSim74 (NOLOCK)
		WHERE numcer74 = @num_cert	
	END

	IF @DEPOSI = 'A'
	BEGIN
		SELECT @num_sol = numsol10 
		FROM ddceradu13 (NOLOCK)
		WHERE numcer13 = @num_cert
	END
	
	SELECT @tot_viajes = count(*) 
	FROM ddticket01 (NOLOCK)
	WHERE docaut01 = @num_sol and tipope01 = 'D'

	--Verificando item por item para encontrar el V.R. por cada servicio
	DECLARE c_items CURSOR FOR 
	SELECT codcon51, valcon53 * (1 + @porc_igv), isnull(valref,0)
	FROM   DDDetCom53 (NOLOCK)  INNER JOIN DDSERVIC52 (NOLOCK) ON DDDetCom53.codcon51 = DDSERVIC52.SERVIC52
	WHERE  numcom52 = @NUMFAC and DEPOSI52 = @DEPOSI
	ORDER BY codcon51

	OPEN c_items

	FETCH NEXT FROM c_items 
	INTO @servicio, @val_fac, @val_ref

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Si el valor facturado supera los S/ 400 APLICA
		IF (@val_fac * @tc) > 400
		BEGIN
			SET @aplica = @aplica + 1
		END
		ELSE -- Si el valor referencial supera los S/ 400 APLICA
		IF (@val_ref * @tot_viajes) > 400
		BEGIN
			SET @aplica = @aplica + 1
		END

		SET @val_ref_calc = @val_ref_calc + (@val_ref * @tot_viajes)

		FETCH NEXT FROM c_items 
   		INTO @servicio, @val_fac, @val_ref
	END

	CLOSE c_items
	DEALLOCATE c_items

	IF @aplica > 0
	BEGIN
		SELECT @valor_referencial = @val_ref_calc
	END
	ELSE
	BEGIN
		SELECT @valor_referencial = 0	 
			
	END
	
END

If Exists ( select 1 
              from DDDetCom53 d
              where codcon51 like 'TRACS%' and numcom52 = @NUMFAC )
    Begin
            if @DEPOSI='A'
	    begin
	       select @Peso = pescer13/1000  from ddceradu13 (NOLOCK) where numcer13 = @num_cert 
	    end
	
	    if @DEPOSI='S'
	    begin
	       select @Peso = pestot74/1000  from ddcersim74 (NOLOCK) where numcer74 = @num_cert 
	    end
	    
            select @VALREF = VALREF from DDSERVIC52 where concep51 = 'TRACS' and deposi52 = @DEPOSI and servic52 = 'TRACS001'  
				
	    if @peso < 7 
	     SET @valor_referencial =  0.04 * @tot_fac  --Caso 2.-  Si la carga es inferior a 7 T, se multiplica el peso máximo que carga un camión (10 Ton) que depende de los ejes  por el factor S/. 12.92  .  
 	    else
	     SET @valor_referencial = @Peso * @VALREF --Caso 1.-   Cuando la carga supera las aprox. 7  T, se multiplica la cantidad de toneladas por el factor S/. 12.92.  Se multiplica el peso * el factor 
   End

--rdelacuba 11/05/2007: Modificar inner join con dqnavier08 por left join
if @DEPOSI='A'
begin
--  Select a.numsol10,c.codnav08,desnav08=d.desnav08+'     VIAJE : '+numvia10,
--	 ValRef = @valor_referencial,b.numcer52
   SELECT
      A.NUMSOL10,
      C.CODNAV08,
      DESNAV08      = D.DESNAV08+'     VIAJE : '+NUMVIA10,
      VALREF        = @VALOR_REFERENCIAL,
      B.NUMCER52
  From ddceradu13 a Inner Join ddcabcom52 b on a.numcer13=b.numcer52
  Inner Join ddsoladu10 c on a.numsol10=c.numsol10
  left Join descarga..dqnavier08 d on c.codnav08=d.codnav08 
  where  b.flgval52='1' and b.numcom52=@NUMFAC
end
if @DEPOSI='S'
begin
--  Select numsol10=a.numsol62,c.codnav08,desnav08=d.desnav08+'     VIAJE : '+numvia62,
--  ValRef = @valor_referencial,b.numcer52
   SELECT
      NUMSOL10       = A.NUMSOL62,
      C.CODNAV08,
      DESNAV08       = D.DESNAV08+'     VIAJE : '+NUMVIA62,
      VALREF         = @VALOR_REFERENCIAL,
      B.NUMCER52
  From DDCerSim74 a Inner Join ddcabcom52 b on a.numcer74=b.numcer52
  Inner Join ddsolsim62 c on a.numsol62=c.numsol62
  left Join descarga..dqnavier08 d on c.codnav08=d.codnav08 
  where b.flgval52='1' and b.numcom52=@NUMFAC
end

END


-- PARA PROBAR
/*

EXECUTE usp_gwc_CG_ADU_FACTURA_SOLICITUD '0150006211','A'

*/
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_consultar_factura_by_numero_sas]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--=================================================================================  
-- CREAMOS EL STORED PROCEDURE  
--=================================================================================  
ALTER PROCEDURE [dbo].[usp_gwc_consultar_factura_by_numero_sas]( @TIPO VARCHAR(02), @NUMERO VARCHAR(10) )  
AS  
BEGIN  
   CREATE TABLE [DBO].[#TEMPORAL](  
      [NUMSOL10] [VARCHAR](09) NULL,  
      [CODNAV04] [VARCHAR](04) NULL,  
      [DESNAV08] [VARCHAR](60) NULL,  
      [VALREF] [DECIMAL](15,2) NULL,  
      [NUMCER52] [VARCHAR](09) NULL  
   )  
   DECLARE @MENSAJE       VARCHAR(200)  
   DECLARE @CERTIFICADO   VARCHAR(009)  
   DECLARE @DEPOSI        CHAR(001)  
   DECLARE @ROW_COUNTER   INT  
  
   ----------------------------------------  
   SET NOCOUNT OFF;          
   --2015.05.16 GBProyectos   
   --ADAPTACION AL BDI  
   DECLARE @BDI_TIPODOC       INT  
   DECLARE @BDI_TIPODOCSZ     CHAR(1)  
   DECLARE @BDINRODOC         VARCHAR(20)  
   DECLARE @BDINRODOCPREFIX   VARCHAR(20)  
    
   --DECLARE @BDI_NRODOC        NVARCHAR(40)  
   DECLARE @BDI_RAZSOC        NVARCHAR(320)  
   DECLARE @BDI_DIRFISCAL     NVARCHAR(200)  
   DECLARE @BDI_EMAIL         NVARCHAR(200)  
   
   SELECT @BDI_TIPODOC    = ISNULL(BDI.cli_tipodocumento,0),  
          --@BDI_NRODOC     = ISNULL(BDI.cli_nrodocumento,''),  
          @BDI_RAZSOC     = ISNULL(BDI.cli_razonsocial,''),  
          @BDI_DIRFISCAL  = ISNULL(BDI.cli_direccionfiscal,''),  
          @BDI_EMAIL      = ISNULL(BDI.cli_ContactoFacturacionE,'')  
   FROM DDCABCOM52 D   
   INNER JOIN [SP3TDA-DBSQL02].[NEP_MSCRM_BDI].[dbo].[Cliente] BDI ON BDI.cli_nrodocumento = D.docdes52    --PROD  
   WHERE D.codcom50 = @TIPO  
      AND D.numcom52 =  @NUMERO  
   
   SET @ROW_COUNTER = @@ROWCOUNT   
     
   SET @BDI_TIPODOCSZ = CASE   
                          WHEN @BDI_TIPODOC = 1 THEN '1'       
                          WHEN @BDI_TIPODOC = 2 THEN '6'   
                          WHEN @BDI_TIPODOC = 3 THEN '4'   
                          WHEN @BDI_TIPODOC = 4 THEN '7'   
                          WHEN @BDI_TIPODOC = 5 THEN '0'   
                          WHEN @BDI_TIPODOC = 6 THEN '0'   
                          ELSE '6'  
                        END;  
                        
    IF @ROW_COUNTER = 0   
      BEGIN  
        SET @BDI_TIPODOCSZ  = '0'  
        SET @BDI_RAZSOC     = ''  
        SET @BDI_DIRFISCAL  = ''  
        SET @BDI_EMAIL      = ''  
  
        SELECT  
          @BDINRODOC = AA.CONTRIBUY,  
          @BDI_RAZSOC = AA.NOMBRE,  
          @BDI_DIRFISCAL = AA.DIRECCION  
        FROM DDCABCOM52 a  
        INNER JOIN AACLIENTESAA AA ON AA.CONTRIBUY= a.docdes52  
        WHERE a.codcom50 = @TIPO  
          AND a.numcom52 =  @NUMERO  
  
        SET @ROW_COUNTER = @@ROWCOUNT  
  
        IF @ROW_COUNTER <> 0  
          BEGIN  
            IF LEN(@BDINRODOC) > 2  
              BEGIN  
                SET @BDINRODOCPREFIX = SUBSTRING(@BDINRODOC,1,2)  
                IF LEN(@BDINRODOC) = 11   
                  BEGIN  
                    IF @BDINRODOCPREFIX = '10' OR @BDINRODOCPREFIX = '20'  
                      BEGIN   
                        SET @BDI_TIPODOCSZ  = '6'   --RUC  
                    END  
                END  
                ELSE IF LEN(@BDINRODOC) = 8  
                  BEGIN  
                    SET @BDI_TIPODOCSZ  = '1'   --DNI  
                END   
            END  
        END  
    END  
   SET NOCOUNT ON;          
   ---------------------------------------   
     
   BEGIN TRY  
      SELECT  
         @CERTIFICADO = ISNULL(NUMCER52,'')  
      FROM  
         DDDETCOM53  
      WHERE  
         DDDETCOM53.CODCOM50 = @TIPO  
         AND DDDETCOM53.NUMCOM52 = @NUMERO  
   END TRY  
   BEGIN CATCH  
      SET @MENSAJE='Ocurrió el siguiente error : ' + ERROR_MESSAGE()  
   END CATCH  
     
   IF LEN(RTRIM(LTRIM(@CERTIFICADO)))>0  
      BEGIN  
         BEGIN TRY  
            SELECT  
               @DEPOSI = SUBSTRING(numcer52,1,1)  
            FROM  
               DDCABCOM52  
            WHERE  
               DDCABCOM52.CODCOM50 = @TIPO  
               AND DDCABCOM52.NUMCOM52 = @NUMERO  
         END TRY  
         BEGIN CATCH  
            SET @MENSAJE='Ocurrió el siguiente error : ' + ERROR_MESSAGE()  
         END CATCH  
           
         BEGIN TRY  
            INSERT #TEMPORAL EXEC USP_GWC_CG_ADU_FACTURA_SOLICITUD @NUMERO,@DEPOSI  
         END TRY  
         BEGIN CATCH  
            SET @MENSAJE='Ocurrió el siguiente error : ' + ERROR_MESSAGE()  
         END CATCH  
         BEGIN TRY  
            SELECT  
               ISNULL(DDCabCom52.codcom50,'') AS codcom50,   
               ISNULL(DDCabCom52.numcom52,'') AS numcom52,   
               CONVERT(VARCHAR(MAX),ISNULL(DDCabCom52.feccom52,GETDATE()),120) AS feccom52,   
               ISNULL(DDCabCom52.numper52,'') AS numper52,
               CASE WHEN DDCabCom52.iniper52 IS NULL THEN '' 
                    ELSE CONVERT(VARCHAR(MAX),DDCabCom52.iniper52,120) END AS iniper52,
               CASE WHEN DDCabCom52.finper52 IS NULL THEN '' 
                    ELSE CONVERT(VARCHAR(MAX),DDCabCom52.finper52,120) END AS finper52,
               ISNULL(DDCabCom52.numcer52,'') AS numcer52,   
               ISNULL(DDCabCom52.numdep52,'') AS numdep52,   
               ISNULL(DDCabCom52.faccom52,'') AS faccom52,   
               ISNULL(DDCabCom52.conemb52,'') AS conemb52,   
               ISNULL(DDCabCom52.cifdep52,0)  AS cifdep52,   
               ISNULL(DDCabCom52.merdep52,'') AS merdep52,   
               ISNULL(DDCabCom52.docdes52,'') AS docdes52,   
               ISNULL(DDCabCom52.nomdes52,'') AS nomdes52,   
               ISNULL(DDCabCom52.dirdes52,'') AS dirdes52,   
               ISNULL(DDCabCom52.subtot52,0)  AS subtot52,   
               ISNULL(DDCabCom52.igvtot52,0)  AS igvtot52,   
               ISNULL(DDCabCom52.tipcam52,0)  AS tipcam52,   
               ISNULL(DDCabCom52.Detrac52,'') AS Detrac52,   
               ISNULL(DDCabCom52.dettrans,'') AS dettrans,   
               ISNULL(DDCabCom52.dettranc,'') AS dettranc,   
               ISNULL(DDCabCom52.TIPMON52,'') AS TIPMON52,  
               ISNULL(DDDetCom53.codcon51,'') AS codcon51,   
               ISNULL(DDDetCom53.descon53,'') AS descon53,   
               ISNULL(DDDetCom53.valcon53,0)  AS valcon53,   
               ISNULL(DDDetCom53.obscon53,'') AS obscon53,  
               ISNULL(#TEMPORAL.NUMSOL10,'')  AS NUMSOL10,  
               ISNULL(#TEMPORAL.CODNAV04,'')  AS CODNAV04,  
               ISNULL(#TEMPORAL.DESNAV08,'')  AS DESNAV08,  
               ISNULL(#TEMPORAL.VALREF,0)     AS VALREF,  
               ISNULL(#TEMPORAL.NUMCER52,'')  AS NUMCER52,  
               @BDI_TIPODOCSZ                     TipoDocumento,  
               @BDI_EMAIL                         ContactoEmail,  
               @BDI_RAZSOC                        RazonSocial,          
               @BDI_DIRFISCAL                     Direccion  
      FROM  
      DDCABCOM52 (NOLOCK) INNER JOIN DDDETCOM53 (NOLOCK)  
      ON  DDCABCOM52.CODCOM50 = DDDETCOM53.CODCOM50  
               AND DDCABCOM52.NUMCOM52 = DDDETCOM53.NUMCOM52  
               AND DDCABCOM52.NUMCER52 = DDDETCOM53.NUMCER52  
          LEFT JOIN #TEMPORAL   
      ON  DDCABCOM52.NUMCER52 = #TEMPORAL.NUMCER52  
         WHERE  
            DDCABCOM52.CODCOM50 = @TIPO  
            AND DDCABCOM52.NUMCOM52 = @NUMERO  
         END TRY  
         BEGIN CATCH  
            SET @MENSAJE='Ocurrió el siguiente error : ' + ERROR_MESSAGE()  
         END CATCH  
      END  
   ELSE  
      BEGIN TRY  
         SELECT  
            ISNULL(DDCabCom52.codcom50,'') AS codcom50,   
            ISNULL(DDCabCom52.numcom52,'') AS numcom52,   
            CONVERT(VARCHAR(MAX),ISNULL(DDCabCom52.feccom52,GETDATE()),120) AS feccom52,   
            ISNULL(DDCabCom52.numper52,'') AS numper52,   
            CASE WHEN DDCabCom52.iniper52 IS NULL THEN '' 
                 ELSE CONVERT(VARCHAR(MAX),DDCabCom52.iniper52,120) END AS iniper52,
            CASE WHEN DDCabCom52.finper52 IS NULL THEN '' 
                 ELSE CONVERT(VARCHAR(MAX),DDCabCom52.finper52,120) END AS finper52,
            ISNULL(DDCabCom52.numcer52,'') AS numcer52,   
            ISNULL(DDCabCom52.numdep52,'') AS numdep52,   
            ISNULL(DDCabCom52.faccom52,'') AS faccom52,   
            ISNULL(DDCabCom52.conemb52,'') AS conemb52,   
            ISNULL(DDCabCom52.cifdep52,0)  AS cifdep52,   
            ISNULL(DDCabCom52.merdep52,'') AS merdep52,   
            ISNULL(DDCabCom52.docdes52,'') AS docdes52,   
            ISNULL(DDCabCom52.nomdes52,'') AS nomdes52,   
            ISNULL(DDCabCom52.dirdes52,'') AS dirdes52,   
            ISNULL(DDCabCom52.subtot52,0)  AS subtot52,   
            ISNULL(DDCabCom52.igvtot52,0)  AS igvtot52,   
            ISNULL(DDCabCom52.tipcam52,0)  AS tipcam52,   
            ISNULL(DDCabCom52.Detrac52,'') AS Detrac52,   
            ISNULL(DDCabCom52.dettrans,'') AS dettrans,   
            ISNULL(DDCabCom52.dettranc,'') AS dettranc,   
            ISNULL(DDCabCom52.TIPMON52,'') AS TIPMON52,  
            ISNULL(DDDetCom53.codcon51,'') AS codcon51,   
            ISNULL(DDDetCom53.descon53,'') AS descon53,   
            ISNULL(DDDetCom53.valcon53,0)  AS valcon53,   
            ISNULL(DDDetCom53.obscon53,'') AS obscon53,  
            ISNULL(#TEMPORAL.NUMSOL10,'')  AS NUMSOL10,  
            ISNULL(#TEMPORAL.CODNAV04,'')  AS CODNAV04,  
            ISNULL(#TEMPORAL.DESNAV08,'')  AS DESNAV08,  
            ISNULL(#TEMPORAL.VALREF,0)     AS VALREF,  
            ISNULL(#TEMPORAL.NUMCER52,'')  AS NUMCER52,  
            @BDI_TIPODOCSZ                     TipoDocumento,  
            @BDI_EMAIL                         ContactoEmail,  
            @BDI_RAZSOC                        RazonSocial,          
            @BDI_DIRFISCAL                     Direccion  
         FROM  
      DDCABCOM52 (NOLOCK) INNER JOIN DDDETCOM53 (NOLOCK)  
      ON  DDCABCOM52.CODCOM50 = DDDETCOM53.CODCOM50  
               AND DDCABCOM52.NUMCOM52 = DDDETCOM53.NUMCOM52  
   LEFT JOIN #TEMPORAL   
      ON  DDCABCOM52.NUMCER52 = #TEMPORAL.NUMCER52  
         WHERE  
            DDCABCOM52.CODCOM50 = @TIPO  
            AND DDCABCOM52.NUMCOM52 = @NUMERO  
      END TRY  
      BEGIN CATCH  
         SET @MENSAJE='Ocurrió el siguiente error : ' + ERROR_MESSAGE()  
      END CATCH  
   
END  
GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_insert_fe]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[usp_gwc_insert_fe]
(
  @codcom50          varchar(2),
	@numcom52          varchar(10),
	@PrefixFE          varchar(4),
	@PDF417            varchar(1000),
	@ValorResumen      varchar(100),	
	@OperaGratuita     decimal(18,2),
	@OperaExonerada    decimal(18,2),
	@OperaInafecta     decimal(18,2),
	@OperaGravada      decimal(18,2),
	@TotalDscto        decimal(18,2),
	@TotalIgv          decimal(18,2),
	@ImporteTotal      decimal(18,2),	
	@RESULTADO         int OUTPUT,
	@MESSAGE           varchar(100) OUTPUT
)
AS
  DECLARE @NFILAS      INT
   
  SET @MESSAGE = ''
  SET @NFILAS    = 0
  SET @RESULTADO = 0
   
  SELECT
	  @NFILAS = COUNT(*)
  FROM
    FAC_FacturaElectronica_SAS
  WHERE
    codcom50 = @codcom50 AND
    numcom52 = @numcom52;
   
  IF @NFILAS > 0
    BEGIN
  BEGIN TRY
    BEGIN TRAN 
      UPDATE [FAC_FacturaElectronica_SAS]
        SET
          PrefixFE       = @PrefixFE          ,
          PDF417         = @PDF417            ,
          ValorResumen   = @ValorResumen      ,	
          OperaGratuita  = @OperaGratuita     ,
          OperaExonerada = @OperaExonerada    ,
          OperaInafecta  = @OperaInafecta     ,
          OperaGravada   = @OperaGravada      ,
          TotalDscto     = @TotalDscto        ,
          TotalIgv       = @TotalIgv          ,
          ImporteTotal   = @ImporteTotal
        WHERE 
          codcom50 = @codcom50 AND
          numcom52 = @numcom52;
       COMMIT
    
       SET @RESULTADO=0
       SET @MESSAGE = 'DOCUMENTO ACTUALIZADO SATISFACTORIAMENTE'
    END TRY
    BEGIN CATCH
      ROLLBACK
      SET @RESULTADO = -1  
      SET @MESSAGE   = 'ERROR : ' + ERROR_MESSAGE()
    END CATCH
  END
  ELSE
    BEGIN
    BEGIN TRY
      BEGIN TRAN 
      INSERT INTO [FAC_FacturaElectronica_SAS]
      VALUES(
      @codcom50          ,
      @numcom52          ,
	    @PrefixFE          ,
	    @PDF417            ,
	    @ValorResumen      ,	
	    @OperaGratuita     ,
	    @OperaExonerada    ,
	    @OperaInafecta     ,
	    @OperaGravada      ,
	    @TotalDscto        ,
	    @TotalIgv          ,
	    @ImporteTotal      
	    )
	    COMMIT
	    SET @RESULTADO=0
      SET @MESSAGE = 'DOCUMENTO INSERTADO SATISFACTORIAMENTE'
	  END TRY
	  BEGIN CATCH
	    ROLLBACK
	    SET @RESULTADO = -1  
	    SET @MESSAGE='ERROR : ' + ERROR_MESSAGE()
	  END CATCH
  END

GO
/****** Object:  StoredProcedure [dbo].[usp_gwc_newdata_sunat]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_gwc_newdata_sunat](  
 @Ident_Documento varchar(10) --Nro de Fatura (Serie + Numero)  
)  
AS  
BEGIN  
  SELECT '' AS TIPO_OPERACION, '0001' AS CODIGO_ESTABLECIMIENTO, '2.0' AS VERSION_UBL  
END  
GO
/****** Object:  StoredProcedure [dbo].[USP_HABILITAR_OR_PROLONGADA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_HABILITAR_OR_PROLONGADA]
@NUMORD VARCHAR(7)
,@USUARIO VARCHAR(50)
AS
BEGIN
	SET @USUARIO = LTRIM(RTRIM(@USUARIO))
	DECLARE @CODUSUARIO VARCHAR(11)
	
	DECLARE @fecha VARCHAR(8)
	DECLARE @fechatotal VARCHAR(15)

	SET @fecha = convert(VARCHAR(8), DATEADD(day, 1, GETDATE()), 112)
	SET @fechatotal = @fecha + ' 08:00'
	
	IF SUBSTRING(@NUMORD,1,1) = 'A'
	BEGIN
		SELECT @CODUSUARIO = LTRIM(RTRIM(b.codcli02))
		FROM DRRetAdu18 a
		INNER JOIN DDDuiDes16 b ON a.numdui16 = b.numdui16
		WHERE a.numret18 = @NUMORD
	END
	ELSE
	BEGIN
		SELECT @CODUSUARIO = LTRIM(RTRIM(b.codcli02))
		FROM DDRetSim75 a
		INNER JOIN DDCerSim74 b ON (a.numcer74 = b.numcer74)
		WHERE a.numret75 = @NUMORD
	END
	
	IF (UPPER(@USUARIO) = 'FRMILLA' OR UPPER(@USUARIO) = 'NFRANCO')
	--AND (@CODUSUARIO = '')
	BEGIN
		INSERT INTO DDHABORDRET(numret, fecini, fecsig, codusu, codcliente)
		VALUES(@NUMORD, GETDATE(), @fechatotal, @USUARIO, @CODUSUARIO)
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[usp_imprimir_anexo_solicitud_aduanera]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_imprimir_anexo_solicitud_aduanera](@numsol CHAR(7))
AS
BEGIN

SELECT 
a.numsol10,a.numdui10,a.tipcli02,a.codcli02,a.codage19,
NombreC=b.nombre,b.direccion,NombreA=c.nombre,
d.numctr65,d.tamctr65
FROM
DDSOLADU10 a,AAClientesAA b,AAClientesAA c,DDCtrDep65 d
WHERE 
a.numsol10=@numsol and a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
a.codage19=c.cliente and a.numsol10 = d.numsol62
ORDER BY d.numctr65

END

GO
/****** Object:  StoredProcedure [dbo].[usp_imprimir_anexo_solicitud_simple]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_imprimir_anexo_solicitud_simple](@numsol CHAR(7))    
AS    
BEGIN    
    
SELECT    
a.numsol62,a.tipcli02,a.codcli02,a.codage19,a.obssol62,a.bultot62,    
NombreC=c.nombre,c.direccion,NombreA=d.nombre,    
g.numctr65,g.tamctr65    
FROM     
DDSolSim62 a  
inner join AAClientesAA c on (a.tipcli02=c.claseabc and a.codcli02=c.contribuy)  
left  join AAClientesAA d on (a.codage19=d.cliente and a.codage19 <> '')  
left  join DDCtrDep65 g  on (a.numsol62 = g.numsol62)  
WHERE     
a.numsol62=@numsol       
ORDER BY g.numctr65    
    
END    
GO
/****** Object:  StoredProcedure [dbo].[USP_IMPRIMIR_RETIRO_LIBERACION_INMOV]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--NUEVOS SPs PARA REPORTES
ALTER PROCEDURE [dbo].[USP_IMPRIMIR_RETIRO_LIBERACION_INMOV]  
@numsol10 varchar(7),
@correlativo int  
AS  
BEGIN

SELECT DISTINCT  b.fecliber,g.numdui11,g.numcer13,b.tipo,d.cliente,NombreA=d.nombre,  
     coddep=i.contribuy, NombreB=i.nombre,b.correlativo,b.cantbultos,b.descmer,b.pesoBruto
FROM DDSolAdu10 a (NOLOCK)
INNER JOIN DETINMOVXDUA b (NOLOCK) ON a.numsol10 = b.numsol10
INNER JOIN AAClientesAA d (NOLOCK) on a.codage19 = d.cliente  COLLATE database_default
INNER JOIN AAClientesAA e (NOLOCK) on a.codcli02 = e.contribuy COLLATE database_default 
INNER JOIN DDDuiDep11 g (NOLOCK) on a.numdui10 = g.numdui11  COLLATE database_default 
INNER JOIN AAClientesAA i (NOLOCK) on a.codcli02 = i.contribuy  COLLATE database_default
WHERE a.numsol10 = @numsol10 and b.correlativo = @correlativo

END 

GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_STA_DESP]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_INSERT_STA_DESP]    
 @NRO_PLAREC32 VARCHAR(8)     
 ,@FECLLEG VARCHAR(50)     
 ,@FECSAL VARCHAR(50)     
 ,@STAT_FAC_GUIA VARCHAR(50)    
 ,@RESPON VARCHAR (100)    
 ,@OBSERVACION VARCHAR (250)    
 ,@UNIDADES_VUELTA DECIMAL (10,3)    
 ,@TIP_DEVO VARCHAR(50)    
 ,@MOT_DEVO VARCHAR(50)    
 ,@OTD VARCHAR(50)    
 ,@RES_OTD  VARCHAR(100)    
 ,@OBSER_OTD  VARCHAR(250)  
 ,@OPCION VARCHAR(1)  
 ,@OBSERVACIONDATO VARCHAR(250)    
AS    
BEGIN  
 --|SETEO DE VARIABLES  
 SET @FECLLEG=LTRIM(RTRIM(@FECLLEG))  
 SET @FECSAL=LTRIM(RTRIM(@FECSAL))  
 SET @STAT_FAC_GUIA=LTRIM(RTRIM(@STAT_FAC_GUIA))  
 SET @RESPON=LTRIM(RTRIM(@RESPON))  
 SET @OBSERVACION=LTRIM(RTRIM(@OBSERVACION))  
 SET @TIP_DEVO=LTRIM(RTRIM(@TIP_DEVO))  
 SET @MOT_DEVO=LTRIM(RTRIM(@MOT_DEVO))  
 SET @OTD=LTRIM(RTRIM(@OTD))  
 SET @RES_OTD=LTRIM(RTRIM(@RES_OTD))  
 SET @OBSER_OTD=LTRIM(RTRIM(@OBSER_OTD))  
 SET @OBSERVACIONDATO=LTRIM(RTRIM(@OBSERVACIONDATO))  
 --|    
   
 --|INSERT  
 IF @OPCION='I'  
 BEGIN  
  INSERT INTO DDSTADESP32    
  (NRO_PLAREC32,FECALLEG32,FECSAL32,STAT_FAC_GUIA32,RESPON32,OBSERVACION32,UNIDADES_VUELTA32,  
  TIP_DEVO32,MOT_DEVO32,OTD32,RES_OTD32,OBSER_OTD32,OBSERVDATO32)     
  VALUES    
  (@NRO_PLAREC32,@FECLLEG,@FECSAL,@STAT_FAC_GUIA,@RESPON,@OBSERVACION,@UNIDADES_VUELTA,  
  @TIP_DEVO,@MOT_DEVO,@OTD,@RES_OTD,@OBSER_OTD,@OBSERVACIONDATO)     
    RETURN;  
    END   
    --|  
      
    --|UPDATE  
    IF @OPCION='I'  
 BEGIN  
  UPDATE DDSTADESP32  
  SET    
  FECALLEG32=@FECLLEG  
  ,FECSAL32=@FECSAL  
  ,STAT_FAC_GUIA32=@STAT_FAC_GUIA  
  ,RESPON32=@RESPON  
  ,OBSERVACION32=@OBSERVACION  
  ,UNIDADES_VUELTA32=@UNIDADES_VUELTA  
  ,TIP_DEVO32=@TIP_DEVO  
  ,MOT_DEVO32=@MOT_DEVO  
  ,OTD32=@OTD  
  ,RES_OTD32=@RES_OTD  
  ,OBSER_OTD32=@OBSER_OTD  
  ,OBSERVDATO32=@OBSERVACIONDATO     
  WHERE NRO_PLAREC32=@NRO_PLAREC32   
    RETURN;  
    END  
    --|  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_INSERTPLA_REC]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_INSERTPLA_REC]  
(  
 @CODCLIENTE VARCHAR(50)   
 ,@FECDESPACHO VARCHAR(8)   
 ,@FECCITA VARCHAR(50)  
   
 ,@FACTURA VARCHAR(15)   
 ,@GUIA VARCHAR(15)   
 ,@UNIDADES  VARCHAR(50)  
   
 ,@BULTO VARCHAR(50)   
 ,@PESO DECIMAL (10,3)   
 ,@VOLUMEN DECIMAL(10,3)  
 ,@TIPOUNIDAD VARCHAR(50)  
   
 ,@PALETA VARCHAR(50)   
 ,@VALORIZADO DECIMAL(10,3)   
 ,@MONEDA VARCHAR(3)   
   
 ,@DIRECCION VARCHAR(200)    
 ,@DISTRITO VARCHAR(100)   
 ,@ZONA VARCHAR(100)
    
 --Para diferenciar update o insert   
 ,@OPSQL VARCHAR(1)  
 ,@NRO_PLAREC VARCHAR(8)   
 
  ,@CONSIGNTARIO VARCHAR(250)
  ,@UNIDADMEDIDA VARCHAR(50) 
  ,@CERTIFICADO VARCHAR(10)
  ,@OBSERVACION VARCHAR(250)
)  
AS  
BEGIN  
   --|SETEO DE VARIABLES  
   SET @CODCLIENTE=LTRIM(RTRIM(@CODCLIENTE))  
   SET @FECCITA=LTRIM(RTRIM(@FECCITA))  
   SET @FACTURA=LTRIM(RTRIM(@FACTURA))  
   SET @GUIA=LTRIM(RTRIM(@GUIA))  
   SET @UNIDADES=LTRIM(RTRIM(@UNIDADES))  
   SET @BULTO=LTRIM(RTRIM(@BULTO))  
   SET @TIPOUNIDAD=LTRIM(RTRIM(@TIPOUNIDAD))  
   SET @PALETA=LTRIM(RTRIM(@PALETA))  
   SET @DIRECCION=LTRIM(RTRIM(@DIRECCION))  
   SET @DISTRITO=LTRIM(RTRIM(@DISTRITO))  
   SET @ZONA=LTRIM(RTRIM(@ZONA))  
   
   DECLARE @FLGUNID CHAR(1)
   IF LEN(@TIPOUNIDAD)=0
   BEGIN
	SET @FLGUNID='0'			
   END
   ELSE
   BEGIN
	SET @FLGUNID='1'			
   END
   --|INSERT  
   IF @OPSQL='I'   
   BEGIN  
		  DECLARE @ID INT;  
		  INSERT INTO DDPLAREC32(CODCLIENTE,FECDESPACHO,FECCITA,FACTURA,GUIA,UNIDADES,BULTO,PESO,VOLUMEN,TIPOUNIDAD,  
		  PALETA,VALORIZADO,MONEDA,DIRECCION,DISTRITO,ZONA,FECPLAREC32,CODUSU17,FECUSU00,CONSIG32,UNIDMEDIDA32,NUMCER32,OBSERVACION32,FLAGUNID32,FLGREC32)  
		    
		  VALUES(@CODCLIENTE,@FECDESPACHO,@FECCITA,@FACTURA,@GUIA,@UNIDADES,@BULTO,@PESO,@VOLUMEN,@TIPOUNIDAD,  
		  @PALETA,@VALORIZADO,@MONEDA,@DIRECCION,@DISTRITO,@ZONA,GETDATE(),USER,GETDATE(),@CONSIGNTARIO,@UNIDADMEDIDA,@CERTIFICADO,@OBSERVACION,@FLGUNID,'R')  
		     
		  SET @ID=@@IDENTITY  
		     
		  SELECT  NRO_PLAREC32,ID_PLAREC32   
		  FROM DDPLAREC32 WITH (NOLOCK)  
		  WHERE ID_PLAREC32=@ID  	 
   END  
     
   --|UPDATE   
   IF @OPSQL='U'  
   BEGIN  
		  UPDATE DDPLAREC32 SET   
		  CODCLIENTE=@CODCLIENTE  
		  ,FECDESPACHO=@FECDESPACHO  
		  ,FECCITA=@FECCITA  
		  ,FACTURA=@FACTURA  
		  ,GUIA=@GUIA  
		  ,UNIDADES=@UNIDADES  
		  ,BULTO=@BULTO  
		  ,PESO=@PESO  
		  ,VOLUMEN=@VOLUMEN  
		  ,TIPOUNIDAD=@TIPOUNIDAD  
		  ,PALETA=@PALETA  
		  ,VALORIZADO=@VALORIZADO  
		  ,MONEDA=@MONEDA  
		  ,DIRECCION=@DIRECCION  
		  ,DISTRITO=@DISTRITO  
		  ,ZONA=@ZONA
		  ,CONSIG32=@CONSIGNTARIO
		  ,UNIDMEDIDA32=@UNIDADMEDIDA
		  ,NUMCER32=@CERTIFICADO
		  ,OBSERVACION32=@OBSERVACION  
		  WHERE NRO_PLAREC32=@NRO_PLAREC  
		    
		  SELECT  NRO_PLAREC32,ID_PLAREC32   
		  FROM DDPLAREC32 WITH (NOLOCK)  
		  WHERE NRO_PLAREC32=@NRO_PLAREC  
   END   
END 



GO
/****** Object:  StoredProcedure [dbo].[USP_INSERTPLA_REC_DET]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_INSERTPLA_REC_DET]  
(   
 @NRO_PLAREC VARCHAR(8)   
 ,@NRO_VUELTA INT   
 ,@TRANSPORTE VARCHAR(50)   
 ,@PLACA VARCHAR(10)   
 ,@CAPACIDAD DECIMAL(10,3)  
 ,@FECCARGUIO VARCHAR(50)   
 ,@CUSTODIA VARCHAR(2)   
 ,@COST_CUSTODIA DECIMAL(10,3)  
 ,@CUADRILLA VARCHAR(2)  
 ,@CANTCUADRILLA INT  
 ,@COSTCUADRILLA DECIMAL(10,3)  
 ,@FLGTODO VARCHAR(1)  
 ,@OPSQL VARCHAR(1) 
 
 ,@TIPOUNIDAD VARCHAR(50)
 ,@CAPACIDADM3 DECIMAL(10,3)
 ,@OBSERVACION VARCHAR(250)
 
)  
AS  
BEGIN  
 --|SETEO DE VARIABLES  
 SET @TRANSPORTE=LTRIM(RTRIM(@TRANSPORTE))  
 SET @PLACA=LTRIM(RTRIM(@PLACA))  
 SET @CAPACIDAD=LTRIM(RTRIM(@CAPACIDAD))  
 SET @FECCARGUIO=LTRIM(RTRIM(@FECCARGUIO))  
   
 --|OBTENER FLGA TODOS LOS REGISTROS LLENOS  
 DECLARE @FLGESTADO VARCHAR(1)  
 IF @FLGTODO='1'  
 BEGIN  
	SET @FLGESTADO='P'  
 END  
 ELSE  
 BEGIN  
	SET @FLGESTADO='R'  
 END  
   
 --|OBTENER ID DE LA CABECERA OT  
 DECLARE @ID INT  
 SELECT @ID=ID_PLAREC32  
 FROM DDPLAREC32 WITH (NOLOCK)   
 WHERE NRO_PLAREC32=@NRO_PLAREC  
   
 UPDATE DDPLAREC32 SET FLGREC32=@FLGESTADO  
 WHERE ID_PLAREC32=@ID  
 
 DECLARE @FLGUNID CHAR(1)
 IF LEN(@TIPOUNIDAD)=0
 BEGIN
	SET @FLGUNID='0'
 END
 ELSE
 BEGIN
	SET @FLGUNID='1'
 END
   
 --|INSERT  
 IF @OPSQL='I'  
 BEGIN  
	  INSERT INTO DDDETREC33(ID_PLAREC32,NRO_VUELTA33,TRANSPORTE33,PLACA33,CAPACIDAD33,FECCARGUIO33,CUSTODIA33,  
	  COSTCUST33,CUADRILLA33,CANTCUADR33,COSTCUADR33,TIPOUNIDAD33,CAPACIDADM33,OBSERVACION33,FLGUNIDAD33)  
	    
	  VALUES(@ID,@NRO_VUELTA,@TRANSPORTE,@PLACA,@CAPACIDAD,@FECCARGUIO,@CUSTODIA,  
	  @COST_CUSTODIA,@CUADRILLA,@CANTCUADRILLA,@COSTCUADRILLA,@TIPOUNIDAD,@CAPACIDADM3,@OBSERVACION,@FLGUNID)  
 END  
   
 --|UPDATE  
 IF @OPSQL='U'  
 BEGIN 
	  IF NOT EXISTS(SELECT TOP 1 *FROM DDDETREC33 WHERE ID_PLAREC32=@ID)
	  BEGIN
		  INSERT INTO DDDETREC33(ID_PLAREC32,NRO_VUELTA33,TRANSPORTE33,PLACA33,CAPACIDAD33,FECCARGUIO33,CUSTODIA33,  
		  COSTCUST33,CUADRILLA33,CANTCUADR33,COSTCUADR33,TIPOUNIDAD33,CAPACIDADM33,OBSERVACION33,FLGUNIDAD33)  
		    
		  VALUES(@ID,@NRO_VUELTA,@TRANSPORTE,@PLACA,@CAPACIDAD,@FECCARGUIO,@CUSTODIA,  
		  @COST_CUSTODIA,@CUADRILLA,@CANTCUADRILLA,@COSTCUADRILLA,@TIPOUNIDAD,@CAPACIDADM3,@OBSERVACION,@FLGUNID)		
	  END
	  ELSE
	  BEGIN
		  UPDATE DDDETREC33 SET  
		  NRO_VUELTA33=@NRO_VUELTA  
		  ,TRANSPORTE33=@TRANSPORTE  
		  ,PLACA33=@PLACA  
		  ,CAPACIDAD33=@CAPACIDAD  
		  ,FECCARGUIO33=@FECCARGUIO  
		  ,CUSTODIA33=@CUSTODIA  
		  ,COSTCUST33=@COST_CUSTODIA  
		  ,CUADRILLA33=@CUADRILLA  
		  ,CANTCUADR33=@CANTCUADRILLA  
		  ,COSTCUADR33=@COSTCUADRILLA
		  ,TIPOUNIDAD33=@TIPOUNIDAD
		  ,CAPACIDADM33=@CAPACIDADM3
		  ,OBSERVACION33=@OBSERVACION  
		  WHERE ID_PLAREC32=@ID  
	  END
 END  
END  
 
GO
/****** Object:  StoredProcedure [dbo].[USP_JOB_REGULARIZAICON_OR_SAS]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_JOB_REGULARIZAICON_OR_SAS]
AS
BEGIN
	SELECT DATA.*
		INTO #ORDENESRETIRO
	FROM (
		--||DEPOSITO SIMPLE
		SELECT a.numret75 AS ORDEN
		,DEPOSITO = 'S' 
		FROM DDRetSim75 a (NOLOCK)
		INNER JOIN DDCerSim74 b (NOLOCK) ON (a.numcer74 = b.numcer74)
		WHERE LTRIM(RTRIM(b.codcli02)) IN ( 
		'20462793791 '
		)
		AND fecret75 >= CONVERT(VARCHAR(8),dateadd(day,-1,getdate()),112)

		UNION
		--||DEPOSITO ADUANERO
		SELECT a.numret18 AS ORDEN
		,DEPOSITO = 'A' 
		FROM DRRetAdu18 a (NOLOCK)
		INNER JOIN DDDuiDes16 b (NOLOCK) ON a.numdui16 = b.numdui16
		WHERE LTRIM(RTRIM(b.codcli02)) IN ( 
		'20462793791 '
		)
		AND fecret18 >= CONVERT(VARCHAR(8),dateadd(day,-1,getdate()),112)

	) DATA


	UPDATE DDRetSim75
		SET fecret75 = GETDATE(),numvig75 = numvig75 + 1
	WHERE numret75 IN (
						SELECT ORDEN
						FROM #ORDENESRETIRO
						WHERE DEPOSITO = 'S'
					   )

	UPDATE DRRetAdu18
		SET fecret18 = GETDATE(), numvig18 = numvig18 + 1
	WHERE numret18 IN (
						SELECT ORDEN
						FROM #ORDENESRETIRO
						WHERE DEPOSITO = 'A'
					   )

	DROP TABLE #ORDENESRETIRO
END
GO
/****** Object:  StoredProcedure [dbo].[USP_LISTA_PLA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_LISTA_PLA]    
@OT VARCHAR(8),
@ESTADO VARCHAR(25)  
AS    
BEGIN    
SET NOCOUNT ON;  
	 DECLARE @FLGESTADO VARCHAR(1)
	 
	 SET @OT=LTRIM(RTRIM(@OT))  
	 
	 SET @FLGESTADO=SUBSTRING(@ESTADO,1,1)
	 
	 IF @FLGESTADO='T'
	 BEGIN
		SET @FLGESTADO=''
	 END
	   
	 SELECT  
	 A.NRO_PLAREC32,
	 A.FECDESPACHO,
	 A.FECCITA,
	 CLIENTE=(SELECT LTRIM(RTRIM(D.NOMBRE)) FROM AACLIENTESAA D WHERE D.CONTRIBUY=A.CODCLIENTE),
	 ISNULL(A.FACTURA,'') AS FACTURA,
	 ISNULL(A.GUIA,'') AS GUIA,
	 ISNULL(A.UNIDADES,'') AS UNIDADES,
	 ISNULL(A.BULTO,'') AS BULTO,
	 ISNULL(A.UNIDMEDIDA32,'') AS UNIDMEDIDA32,
	 ISNULL(A.CONSIG32,'') AS CONSIG32,
	 ISNULL(A.PESO,0) AS PESO,
	 ISNULL(A.VOLUMEN,0) AS VOLUMEN,
	 ISNULL(A.PALETA,'') AS PALETA,
	 ISNULL(A.VALORIZADO,0) AS VALORIZADO,
	 ISNULL(A.MONEDA,'') AS MONEDA,
	 ISNULL(A.DIRECCION,'') AS DIRECCION,
	 ISNULL(A.DISTRITO,'') AS DISTRITO,
	 ISNULL(A.ZONA,'') AS ZONA,
	 ISNULL(A.NUMCER32,'') AS NUMCER32,
	 ISNULL(B.NRO_VUELTA33,0) AS NRO_VUELTA33,  
	 ISNULL(B.TRANSPORTE33,'') AS TRANSPORTE33,
	 CASE WHEN ISNULL(A.TIPOUNIDAD,'')=''
		  THEN ISNULL(B.TIPOUNIDAD33,'')
		  ELSE ISNULL(A.TIPOUNIDAD,'')
		  END AS TIPO,
	 ISNULL(B.PLACA33,'') AS PLACA33,  
	 ISNULL(B.CAPACIDAD33,0) AS CAPACIDAD33,  
	 ISNULL(B.CAPACIDADM33,0) AS CAPACIDADM33, 
	 ISNULL(B.FECCARGUIO33,'19990101') AS FECCARGUIO33,  
	 ISNULL(B.CUSTODIA33,'') AS CUSTODIA33,
	 ISNULL(B.COSTCUST33,0) AS COSTCUST33,
	 ISNULL(B.CUADRILLA33,'') AS CUADRILLA33,
	 ISNULL(B.CANTCUADR33,0) AS CANTCUADR33, 
	 ISNULL(B.COSTCUADR33,0) AS COSTCUADR33, 
	 CASE WHEN A.FLGREC32='R' THEN 'REGISTRADO'  
	      WHEN A.FLGREC32='P' THEN 'PENDIENTE'
	      WHEN A.FLGREC32='F' THEN 'FINALIZADO'  
		  WHEN A.FLGREC32='A' THEN 'ANULADA'  
		  END AS 'estado',
	 ISNULL(A.NUMORD58,'') AS NUMORD58             
	 FROM     
	 DDPLAREC32 A WITH (NOLOCK)    
	 LEFT JOIN DDDETREC33 B WITH (NOLOCK) ON A.ID_PLAREC32=B.ID_PLAREC32    
	 LEFT JOIN DDORDSER58 C WITH (NOLOCK) ON C.numord58=A.numord58  
	 WHERE A.NRO_PLAREC32 LIKE '%' + @OT + '%'
	 AND A.FLGREC32 LIKE '%' + @FLGESTADO + '%'
	 AND A.FLGREC32 IN ('R','P','F','A')    
SET NOCOUNT OFF;  
END


GO
/****** Object:  StoredProcedure [dbo].[USP_OBTENER_QUIEBRE]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_OBTENER_QUIEBRE] @TIPDOC CHAR(2)
	,@NUMDOC CHAR(10)
	,@TIPDEP CHAR(1)
AS
BEGIN
	--SET NOCOUNT ON;    
	--SET ANSI_NULLS ON;    
	--SET ANSI_WARNINGS ON;    
	DECLARE @RUC_CLIENTE VARCHAR(11)
		,@QUIEBRE VARCHAR(6)

	SET @QUIEBRE = ''

	--SELECT '41000' AS quiebre      
	SELECT DISTINCT @RUC_CLIENTE = docdes52
	FROM ddcabcom52
	WHERE codcom50 = @TIPDOC
		AND numcom52 = @NUMDOC

	--//CUANDO EL CLIENTE ES BDP INTERNATIONAL S.A.C.  
	IF @RUC_CLIENTE = '20601370621'
	BEGIN
		SELECT DISTINCT @RUC_CLIENTE = codcli02
		FROM ddcabcom52
		WHERE codcom50 = @TIPDOC
			AND numcom52 = @NUMDOC
			
		--//OBTENER QUIEBRE      
		SELECT @QUIEBRE = CO_QUIEBRE
		FROM [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT
		WHERE LTRIM(RTRIM(CO_CLIE)) = LTRIM(RTRIM(@RUC_CLIENTE))
			AND ESTADO = 'A'
	END
	ELSE IF @RUC_CLIENTE = '20511501718'
	--//CUANDO EL CLIENTE ES Expeditors Perú SAC
	BEGIN
		SELECT DISTINCT @RUC_CLIENTE = codcli02
		FROM ddcabcom52
		WHERE codcom50 = @TIPDOC
			AND numcom52 = @NUMDOC
			
		IF @RUC_CLIENTE = '20501977439'
		BEGIN
			--//OBTENER QUIEBRE      
			SELECT @QUIEBRE = CO_QUIEBRE
			FROM [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT
			WHERE LTRIM(RTRIM(CO_CLIE)) = LTRIM(RTRIM(@RUC_CLIENTE))
				AND ESTADO = 'A'
		END
		ELSE
		BEGIN
			SET @QUIEBRE = '41000'
		END
	END
	ELSE
	BEGIN
		--//OBTENER QUIEBRE      
		SELECT @QUIEBRE = CO_QUIEBRE
		FROM [SP3TDA-DBSQL02].OFIRECA.dbo.TMCLIE_NEPT
		WHERE LTRIM(RTRIM(CO_CLIE)) = LTRIM(RTRIM(@RUC_CLIENTE))
			AND ESTADO = 'A'
	END
	
	IF ISNULL(@QUIEBRE, '') = ''
	BEGIN
		SELECT quiebre = '41000'

		RETURN;
	END

	SELECT quiebre = @QUIEBRE
		--//      
		--SET NOCOUNT OFF;    
		--SET ANSI_NULLS OFF;    
		--SET ANSI_WARNINGS OFF;    
END

GO
/****** Object:  StoredProcedure [dbo].[USP_REPORTE_MERCADERIA_INMOVILIZADA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_REPORTE_MERCADERIA_INMOVILIZADA]  
@tipo char(1),
@flgcer char(1),
@numcer varchar(9),
@fecfin char(8)
AS  
BEGIN

SET NOCOUNT ON

DECLARE @mes int, @desc_mes varchar(12), @anho int, @filtro_tipo char(1),
	@item int, @numsol varchar(7), @corr int

SET @mes = month(@fecfin)
SET @anho = year(@fecfin)

SELECT @desc_mes = 
CASE @mes
WHEN 1 THEN 'ENERO'
WHEN 2 THEN 'FEBRERO'
WHEN 3 THEN 'MARZO'
WHEN 4 THEN 'ABRIL'
WHEN 5 THEN 'MAYO'
WHEN 6 THEN 'JUNIO'
WHEN 7 THEN 'JULIO'
WHEN 8 THEN 'AGOSTO'
WHEN 9 THEN 'SETIEMBRE'
WHEN 10 THEN 'OCTUBRE'
WHEN 11 THEN 'NOVIEMBRE'
WHEN 12 THEN 'DICIEMBRE'
END

SELECT @filtro_tipo = CASE @tipo WHEN 'C' THEN 'C' WHEN 'A' THEN 'A' ELSE '%' END

CREATE TABLE #temp_lista
(
numsol10 varchar(7) NOT NULL,
correlativo int NOT NULL,
dua varchar(16) NOT NULL,
fecdui11 datetime NULL,
manif1 varchar(4) NULL,
manif2 varchar(6) NULL,
conemb10 varchar(20) NULL,
priing69 datetime NULL,
fecinmov datetime NULL,
nombre varchar(80) NULL,
descmer varchar(250) NULL,
cantbultos decimal(15,2) NULL,
pesobruto decimal(15,3) NULL,
estado varchar(25) NULL,
titulo varchar(150) NULL,
item int NULL
)

--Para ver todos los certificados o uno específico
IF @flgcer = 'T'
BEGIN
	INSERT INTO #temp_lista(numsol10,correlativo,dua,fecdui11,manif1,manif2,conemb10,priing69,
				fecinmov,nombre,descmer,cantbultos,pesobruto,estado,titulo)
	SELECT d.numsol10,d.correlativo,
	substring(d.numdui11,1,3)+'-'+substring(d.numdui11,4,2)+'-'+substring(d.numdui11,6,2)+'-'+substring(d.numdui11,8,6) as dua,
	i.fecdui11,
	substring(s.numman10,4,4) as manif1,substring(s.numman10,8,6) as manif2,s.conemb10,r.priing69,d.fecinmov,
	c.nombre,d.descmer,d.cantBultos,d.pesoBruto,
	CASE d.estadoMerc 
	WHEN 'B' THEN CASE d.tipo WHEN 'C' THEN 'Bueno/Comiso' ELSE 'Bueno/Abandono' END
	WHEN 'R' THEN CASE d.tipo WHEN 'C' THEN 'Regular/Comiso' ELSE 'Regular/Abandono' END
	WHEN 'M' THEN CASE d.tipo WHEN 'C' THEN 'Malo/Comiso' ELSE 'Malo/Abandono' END
	END as estado,
	CASE @filtro_tipo 
	WHEN 'C' THEN 'RELACION DE MERCANCIAS EN COMISO AL MES DE '+@desc_mes+' DE '+cast(@anho as varchar) 
	WHEN 'A' THEN 'RELACION DE MERCANCIAS EN SITUACION DE ABANDONO LEGAL ACUMULADA AL MES DE '+@desc_mes+' DE '+cast(@anho as varchar) 
	ELSE 'RELACION DE MERCANCIAS INMOVILIZADAS AL MES DE '+@desc_mes+' DE '+cast(@anho as varchar) 
	END as titulo
	FROM DETINMOVXDUA d (NOLOCK) INNER JOIN DDSolAdu10 s (NOLOCK) ON d.numsol10 = s.numsol10
			     	INNER JOIN DDDuiDep11 i (NOLOCK) ON s.numsol10 = i.numsol10
			     	INNER JOIN DDRecMer69 r (NOLOCK) ON s.numsol10 = r.numsol62
			     	INNER JOIN AAClientesAA c (NOLOCK) on s.codcli02 = c.contribuy  COLLATE database_default
	WHERE d.estado = 'I' and r.flgval69 = 1 and d.tipo like @filtro_tipo and d.fecinmov <= @fecfin
	ORDER BY i.fecdui11,d.numdui11,d.numsol10,d.correlativo
END
ELSE
BEGIN
	INSERT INTO #temp_lista(numsol10,correlativo,dua,fecdui11,manif1,manif2,conemb10,priing69,
				fecinmov,nombre,descmer,cantbultos,pesobruto,estado,titulo)
	SELECT d.numsol10,d.correlativo,
	substring(d.numdui11,1,3)+'-'+substring(d.numdui11,4,2)+'-'+substring(d.numdui11,6,2)+'-'+substring(d.numdui11,8,6) as dua,
	i.fecdui11,
	substring(s.numman10,4,4) as manif1,substring(s.numman10,8,6) as manif2,s.conemb10,r.priing69,d.fecinmov,
	c.nombre,d.descmer,d.cantBultos,d.pesoBruto,
	CASE d.estadoMerc 
	WHEN 'B' THEN CASE d.tipo WHEN 'C' THEN 'Bueno/Comiso' ELSE 'Bueno/Abandono' END
	WHEN 'R' THEN CASE d.tipo WHEN 'C' THEN 'Regular/Comiso' ELSE 'Regular/Abandono' END
	WHEN 'M' THEN CASE d.tipo WHEN 'C' THEN 'Malo/Comiso' ELSE 'Malo/Abandono' END
	END as estado,
	CASE @filtro_tipo 
	WHEN 'C' THEN 'RELACION DE MERCANCIAS EN COMISO AL MES DE '+@desc_mes+' DE '+cast(@anho as varchar) 
	WHEN 'A' THEN 'RELACION DE MERCANCIAS EN SITUACION DE ABANDONO LEGAL ACUMULADA AL MES DE '+@desc_mes+' DE '+cast(@anho as varchar) 
	ELSE 'RELACION DE MERCANCIAS INMOVILIZADAS AL MES DE '+@desc_mes+' DE '+cast(@anho as varchar) 
	END as titulo
	FROM DETINMOVXDUA d (NOLOCK) INNER JOIN DDSolAdu10 s (NOLOCK) ON d.numsol10 = s.numsol10
			     	INNER JOIN DDDuiDep11 i (NOLOCK) ON s.numsol10 = i.numsol10
			     	INNER JOIN DDRecMer69 r (NOLOCK) ON s.numsol10 = r.numsol62
			     	INNER JOIN AAClientesAA c (NOLOCK) on s.codcli02 = c.contribuy  COLLATE database_default
	WHERE d.estado = 'I' and r.flgval69 = 1 and d.tipo like @filtro_tipo and i.numcer13 = @numcer and d.fecinmov <= @fecfin
	ORDER BY i.fecdui11,d.numdui11,d.numsol10,d.correlativo
END

SET @item = 1

DECLARE c_items CURSOR FOR
SELECT numsol10,correlativo
FROM #temp_lista
ORDER BY fecdui11,dua,numsol10,correlativo

OPEN c_items

FETCH NEXT FROM c_items INTO @numsol, @corr

WHILE @@FETCH_STATUS = 0
BEGIN

 UPDATE #temp_lista
 SET item = @item
 WHERE numsol10 = @numsol and correlativo = @corr

 SET @item = @item + 1

 FETCH NEXT FROM c_items INTO @numsol, @corr

END

CLOSE c_items
DEALLOCATE c_items

SELECT 	item,numsol10,correlativo,dua,fecdui11,manif1,manif2,conemb10,priing69,fecinmov,
	nombre,descmer,cantbultos,pesobruto,estado,titulo
FROM #temp_lista
ORDER BY item

DROP TABLE #temp_lista

SET NOCOUNT OFF

END

GO
/****** Object:  StoredProcedure [dbo].[USP_REPORTE_SUSTENTO_DETRACCION]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_REPORTE_SUSTENTO_DETRACCION]
@NUMFAC CHAR(10),
@DEPOSI CHAR(1)
AS
BEGIN

DECLARE @dir_dest varchar(150), @direc_ter varchar(150), @num_cer varchar(10),@num_sol varchar(7), @tot_viajes int,
	@serv varchar(8), @tot_fact decimal(15,2), @val_ref decimal(12,2), @porc_igv decimal(5,2), @fecha datetime,@tipmon char(1)

--UBICANDO NEPTUNIA S.A. QUE SIEMPRE ES DESTINO
SELECT @dir_dest = direcTer 
FROM DQTERADU09 
WHERE CodTer09 = '3033'  

--Ubicando el certificado
SELECT @num_cer = numcer52,@tipmon = tipmon52
FROM ddcabcom52 (NOLOCK)
WHERE numcom52 = @NUMFAC

--Ubicando el número de solicitud para encontrar los tickets
IF @DEPOSI = 'S'
BEGIN
	SELECT @num_sol = numsol62
	FROM DDCerSim74 (NOLOCK)
	WHERE numcer74 = @num_cer

	SELECT @direc_ter = b.direcTer
	FROM DDSolSim62 a (NOLOCK) LEFT OUTER JOIN DQTERADU09 b (NOLOCK) ON a.codTer = b.CodTer09
	WHERE  a.numsol62 = @num_sol
END	

IF @DEPOSI = 'A'
BEGIN
	SELECT @num_sol = numsol10 
	FROM ddceradu13 (NOLOCK)
	WHERE numcer13 = @num_cer

	SELECT @direc_ter = b.direcTer
	FROM DDDuiDep11 a (NOLOCK) LEFT OUTER JOIN DQTERADU09 b (NOLOCK) ON a.codTer09 = b.CodTer09
	WHERE  a.numsol10 = @num_sol
END	

--Ubicando el total de viajes, total facturado y servicio cobrado
SELECT @tot_viajes = count(*)
FROM ddticket01 (NOLOCK)
WHERE tipope01 = 'D' and docaut01 = @num_sol

SELECT @tot_fact = isnull(subtot52,0)+ isnull(igvtot52,0),
       @porc_igv = porigv52
FROM ddcabcom52 (NOLOCK)
WHERE numcom52 = @NUMFAC

--Resultado del reporte
IF exists (SELECT * from DDOrdSer58 WHERE numcom52 = @NUMFAC)
BEGIN
	SELECT @fecha = fecord58
	FROM DDOrdSer58 (NOLOCK)
	WHERE numcom52 = @NUMFAC
END	
ELSE
BEGIN
	SET @fecha = getdate()
END

SELECT  @fecha AS fecha, 
	condicion = CASE WHEN isnull(COND,'') = 'L' THEN 'LLENO'
			 WHEN isnull(COND,'') = 'V' THEN 'VACIO'
			 ELSE '' END,
	dir_origen = CASE WHEN isnull(COND,'') = 'L' THEN @direc_ter 
			  WHEN isnull(COND,'') = 'V' THEN @dir_dest
			  ELSE '' END,
	dir_destino = CASE WHEN isnull(COND,'') = 'L' THEN @dir_dest 
			  WHEN isnull(COND,'') = 'V' THEN 'OTROS TERMINALES'
			  ELSE '' END,
	val_fact = isnull(valcon53,0) * (1 + @porc_igv), 
	val_ref = isnull(valref,0) * @tot_viajes,
        tipmon = @tipmon
FROM   DDDetCom53 (NOLOCK) INNER JOIN DDSERVIC52 (NOLOCK) ON DDDetCom53.codcon51 = DDSERVIC52.SERVIC52
WHERE  numcom52 = @NUMFAC and DEPOSI52 = @DEPOSI

END


GO
/****** Object:  StoredProcedure [dbo].[USP_TIPO_ALM]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_TIPO_ALM]
AS
BEGIN
	SELECT 'A - ALMACEN' AS VALOR
	UNION
	SELECT 'Z - ZONA' AS VALOR
END
GO
--/****** Object:  StoredProcedure [dbo].[USP_VISUALIZA_CLIENTE]    Script Date: 07/03/2019 03:08:33 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER PROCEDURE [dbo].[USP_VISUALIZA_CLIENTE]
--(@NRO_PLAREC32 VARCHAR(8))
--AS
--BEGIN
--	SELECT CLIENTE FROM DDPLAREC32 WHERE NRO_PLAREC32=@NRO_PLAREC32
--END
--GO
/****** Object:  StoredProcedure [web].[BUSCAR_USER_SAAWEB]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[BUSCAR_USER_SAAWEB]
@cuenta varchar(50)
AS
SELECT cuenta , password , razonsocial , emailAduana ,emailContactos , nombreAduana
FROM  DINFOSUSERSAAWEB
WHERE cuenta = @cuenta


GO
/****** Object:  StoredProcedure [web].[SearchAllTables]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [web].[SearchAllTables]
(
@SearchStr nvarchar(100)
)
AS
BEGIN

CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

SET NOCOUNT ON

DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
SET  @TableName = ''
SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')

WHILE @TableName IS NOT NULL
BEGIN
SET @ColumnName = ''
SET @TableName = 
(
SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
AND QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
AND OBJECTPROPERTY(
OBJECT_ID(
QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
), 'IsMSShipped'
       ) = 0
)

WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
BEGIN
SET @ColumnName =
(
SELECT MIN(QUOTENAME(COLUMN_NAME))
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@TableName, 2)
AND TABLE_NAME = PARSENAME(@TableName, 1)
AND DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
AND QUOTENAME(COLUMN_NAME) > @ColumnName
)

IF @ColumnName IS NOT NULL
BEGIN
INSERT INTO #Results
EXEC
(
'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
FROM ' + @TableName + ' (NOLOCK) ' +
' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
)
END
END 
END

SELECT ColumnName, ColumnValue FROM #Results
END


GO
/****** Object:  StoredProcedure [web].[sp_ActualizaMontosDUA_DESPACHO]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Actualiza montos Dua despacho detalle.
--LHV. 17.02.14
ALTER PROCEDURE [web].[sp_ActualizaMontosDUA_DESPACHO]
(
@numcer13	char(9),
@numser12	char(4),
@buldes14	int,
@pesdes14	decimal(9,3),
@fobdes14	decimal(9,3),
@fledes14	decimal(9,3),
@segdes14	decimal(9,3)
)
AS
BEGIN

UPDATE DDDCeAdu14 SET buldes14 = buldes14 + @buldes14, pesdes14 = pesdes14 + @pesdes14, fobdes14 = fobdes14 + @fobdes14, 
	   fledes14 = fledes14 + @fledes14, segdes14 = segdes14 + @segdes14 
WHERE numcer13 = @numcer13 
  and numser12 = @numser12

END	   

GO
/****** Object:  StoredProcedure [web].[sp_ActualizaMontosDUA_DESPACHO_Servicios]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Actualiza montos Dua despacho servicios.
--LHV. 17.02.14
ALTER PROCEDURE [web].[sp_ActualizaMontosDUA_DESPACHO_Servicios]
(
@numdui11	char(13),
@numser12	varchar(4),
@buldes12	decimal(9,3),
@pesdes12	decimal(9,3),
@fobdes12	decimal(9,3)
)
AS
BEGIN

UPDATE DDSerDep12 SET 
	   buldes12=buldes12+@buldes12, pesdes12=pesdes12+@pesdes12, fobdes12=fobdes12+@fobdes12
WHERE numdui11=@numdui11 
  and numser12=@numser12

END

GO
/****** Object:  StoredProcedure [web].[SP_CALCULA_PRODUC_NO_NACIONAL]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[SP_CALCULA_PRODUC_NO_NACIONAL]  
@numCert varchar(20),  
@Ruc  varchar(20),  
@NameProd varchar(200)  
  
AS  
Begin  
DECLARE  
 @contribuy varchar(20),  
 @numdui11 varchar(20),  
 @numcer13 varchar(10),  
 @feccer13 datetime ,  
 @numser12 varchar(10),  
 @numbul14 int ,  
 @bulent14 int ,  
 @sldBul   int ,  
 @codemb06 varchar(5),   
 @desmer14 varchar(200),  
 @cantidaNacional int  
  
   
  
BEGIN  TRANSACTION
  
/*drop table #serie_Disp   
drop table #Reporte    
drop table #Nacional*/

 /*create table serie_Disp  
 (  
    serie varchar(4),  
    ruc   varchar(12),  
    numcer varchar(11)  
 )  

  create table Nacional  
 (  
    Deposito   varchar(20),   
    certificado varchar(10) ,  
    serie varchar(4),       
    Nacional int,  
    codemb06 varchar(5) ,     
    desmer17 varchar(200)  
     
 )  
  
  create table Reporte  
 (  
    contribuy varchar(20),  
    numdui11 varchar(30),  
    numcer13 varchar(10),  
    feccer13 datetime,  
    numser12 varchar(4),  
    numbul14 int,  
    bulent14 int,  
    sldBul int,  
    codemb06 varchar(10),  
    desmer14 varchar(200),   
    Nacional int  ,
    NoNacional int
     
 )  */
 
 Delete From Reporte  where contribuy = @Ruc

 insert into serie_Disp  
       Select serie= b.numser12, ruc = @Ruc , Certificado = a.numcer13  
	 From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d           
	 Where           
	  a.numcer13=b.numcer13 and   
	  a.numsol10=c.numsol10 and   
	  b.numser12=c.numser12 and   
	  a.numbul13-a.bulent13>=0 and   
	  b.numbul14-b.bulent14>0 and           
	  a.tipcli02=d.claseabc and a.codcli02=d.contribuy   
	 and a.codcli02=@Ruc and flgval13 = 1       
	 AND (a.numcer13 = @numCert or '0' = @numCert) --like  'A00540900%'     
	 order by a.numcer13, a.obscer13   

  
 insert into Nacional  
 select numdui11, numcer13 , numser12,sum(numbul17),codemb06,desmer17   
        from DDSerDes17 d, serie_Disp s where d.numdui16 in (  
  Select a.numdui16  
  From   
  DRRetAdu18 a,DDDuiDes16 b,DDCerAdu13 g,DDSolAdu10 e,DQMaeRep77 c,AAClientesAA d,AAClientesAA f   
  Where   
  a.numdui16=b.numdui16 and b.numcer13=g.numcer13 and g.numsol10=e.numsol10    
  and a.flgval18='1' and a.flgemi18='1' and a.codrep77=c.codrep11 and b.tipcli02=d.claseabc and b.codcli02=d.contribuy and b.CodAge19=f.cliente   
                and b.tipcli02=4 and b.codcli02=  @Ruc   
  and (b.numcer13 = @numCert or '0' = @numCert) )  
                and s.serie = d.numser12  
                and s.numcer =  d.numcer13  
        group by   numdui11,numcer13 , numser12, codemb06, desmer17    
  
   
  
  --select * from #Nacional  
  --select * from #Reporte  
    
    DECLARE  C_DISP_X_NACIONALIZAR CURSOR FOR   
     Select d.contribuy,a.numdui11,a.numcer13,a.feccer13,b.numser12,b.numbul14,b.bulent14, sldbul=b.numbul14-b.bulent14,  
            c.codemb06,b.desmer14          
 From DDCERADU13 a,DDDCEADU14 b,DDSERDEP12 c,AAClientesAA d           
 Where           
 a.numcer13=b.numcer13 and   
 a.numsol10=c.numsol10 and   
 b.numser12=c.numser12 and   
 a.numbul13-a.bulent13>=0 and   
 b.numbul14-b.bulent14>0 and           
 a.tipcli02=d.claseabc and a.codcli02=d.contribuy --and a.tipcli02=@TIPCLI     
 and a.codcli02= @Ruc and flgval13 = 1       
 AND (a.numcer13 = @numCert  or '0' =  @numCert)  
        and desmer14 like '%' + @NameProd +'%'   
 order by a.numcer13, a.obscer13   
  
  
   OPEN C_DISP_X_NACIONALIZAR   
   Fetch Next From C_DISP_X_NACIONALIZAR into @contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14  
   While @@FETCH_STATUS = 0  
   Begin   
  print 'Entro Cursos'  
       SET @cantidaNacional = 0  
       select @cantidaNacional = isnull(Nacional ,0)  
         from Nacional   
        where serie =  @numser12 and certificado = @numcer13  
  
    if @numbul14 - @cantidaNacional > 0
     insert into Reporte values(@contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14 , @cantidaNacional - @bulent14 ,@numbul14 - @cantidaNacional )  

    
   Fetch Next From  C_DISP_X_NACIONALIZAR into @contribuy,@numdui11,@numcer13,@feccer13,@numser12,@numbul14,@bulent14,@sldBul,@codemb06, @desmer14  
   End  
   Close C_DISP_X_NACIONALIZAR  
   deallocate C_DISP_X_NACIONALIZAR  
    
  
  
  Delete from  serie_Disp     
  Delete from  Nacional  
   Select numdui11 , Numcer13, CONVERT(varchar,Feccer13,103) as Feccer13, numser12,numbul14,bulent14,codemb06,desmer14,Nacional,NoNacional  from  Reporte  where contribuy = @Ruc

     if @@error <> 0
	begin
		rollback transaction
		return -1
	end
	commit transaction
END  

GO
/****** Object:  StoredProcedure [web].[SP_IMPRIMIR_RECEPCION_ADUANERA]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[SP_IMPRIMIR_RECEPCION_ADUANERA]  
@NUMREC CHAR(7)  
    
AS    
    
Select     
a.numrec69,a.fecrec69,a.priing69,a.fining69,a.bultot69,a.codemb06,a.obsrec69,a.guirem69,    
a.pesnet69,a.codubi71,    
b.tipcli02,b.codcli02,b.codage19,    
c.numser70,c.numbul70,c.codemb06,c.desmer70,    
d.desubi71,    
NombreC=e.nombre,    
NombreA=f.nombre,    
g.numdui11    
From     
DDRECMER69 a  
 inner join DDSOLADU10 b on (a.numsol62=b.numsol10)  
 inner join DDDREMER70 c on (a.numrec69=c.numrec69)  
 inner join DQTIPUBI71 d on (a.codubi71=d.codubi71)  
 inner join AACLIENTESAA e on (b.tipcli02=e.claseabc and b.codcli02=e.contribuy)    
 inner join DDDUIDEP11 g on (b.numsol10=g.numsol10)  
 left  join AACLIENTESAA f on (b.codage19=f.cliente)    
Where     
a.numrec69=@NUMREC and f.cliente<>''    
Order by c.numser70  
 
GO
/****** Object:  StoredProcedure [web].[sp_Inserta_DUA_DESPACHO_Cabezera]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [web].[sp_Inserta_DUA_DESPACHO_Cabezera]
(
@numdui16	varchar(14),
@fecdui16	smalldatetime,
@feccan16	smalldatetime,
@tipcli02	char(1),
@codcli02	varchar(11),	
@codage19	varchar(4),
@totser16	smallint,
@numbul16	int,
@pesbru16	decimal(9,3),
@valfob16	decimal(9,3),
@valfle16	decimal(9,3),
@valseg16	decimal(9,3),
@valcif16	decimal(9,3),
@numdui11	char(13),
@numcer13	char(9),
@nomusu16	varchar(15),
@canaldua16	char(1),
@FecCanal16	datetime,
@HoraCanal16 datetime
)
AS
BEGIN

Insert Into DDDuiDes16
(numdui16, fecdui16, feccan16, tipcli02, codcli02, codage19, totser16, numbul16, pesbru16, valfob16, valfle16, valseg16, valcif16, flgret16, 
nument16, bulent16, cifent16, pesent16, numdui11, numcer13, flgdui16, flgver16, parara16, fecver16, nomusu16, fecusu16, flglev16, canaldua16, 
FecCanal16, HoraCanal16)
Values 
(@numdui16, @fecdui16, @feccan16, @tipcli02, @codcli02, @codage19, @totser16, @numbul16, @pesbru16, @valfob16, @valfle16, @valseg16, @valcif16, '0', 
0, 0, 0, 0, @numdui11, @numcer13, '1', '0', '0', Null, @nomusu16, getdate(), '0', @canaldua16, @FecCanal16, @HoraCanal16)

END 

GO
/****** Object:  StoredProcedure [web].[sp_Inserta_DUA_DESPACHO_Detalle]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Inserta Dua despacho detalle.
--LHV. 17.02.14
ALTER PROCEDURE [web].[sp_Inserta_DUA_DESPACHO_Detalle]
(
@numdui16	varchar(14),	@numser17	varchar(4),
@numcer13	varchar(9),		@numdui11	varchar(13),
@numser12	varchar(4),		@numbul17	decimal(9,3),
@codemb06	varchar(3),		@desmer17	varchar(100),
@parara17	varchar(10),	@pesbru17	decimal(9,3),
@valfob17	decimal(9,3),		@valfle17	decimal(9,3),
@valseg17	decimal(9,3),		@cifuni17	decimal(9,3),
@valcif17	decimal(9,3),		@bulent17	decimal(9,3),
@cifent17	decimal(9,3),		@unidad12	decimal(9,3),
@tipuni12	varchar(2)
)
AS
BEGIN

Insert Into DDSerDes17 
(numdui16, numser17, numcer13, numdui11, numser12, numbul17, codemb06, desmer17, parara17, pesbru17, valfob17,
valfle17, valseg17, cifuni17, valcif17, bulent17, cifent17, unidad12,tipuni12) 
Values 
(@numdui16, @numser17, @numcer13, @numdui11, @numser12, @numbul17, @codemb06, @desmer17, @parara17, @pesbru17,
@valfob17, @valfle17, @valseg17, @cifuni17, @valcif17, @bulent17, @cifent17, @unidad12, @tipuni12)

END

GO
/****** Object:  StoredProcedure [web].[TAR_FACTURAS_FACTURAR_EWMN]    Script Date: 07/03/2019 03:08:33 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER PROCEDURE [web].[TAR_FACTURAS_FACTURAR_EWMN]
@DEPADU VARCHAR(3),
@DEPSIM VARCHAR(3),
@PORCER VARCHAR(3),
@PORCLI VARCHAR(3),
@NUMCER VARCHAR(9),
@TIPCLI VARCHAR(3),
@CODCLI VARCHAR(13)
AS

Declare @SelectA1 varchar(255) 
Declare @SelectA2 varchar(255)
Declare @SelectA3 varchar(255)
Declare @FromA1 varchar(255)
Declare @WhereA1 varchar(500)
Declare @WhereA2 varchar(255)
Declare @Union varchar(50)
Declare @SelectS1 varchar(255)
Declare @SelectS2 varchar(255)
Declare @SelectS3 varchar(255)
Declare @SelectS4 varchar(255)
Declare @FromS1 Varchar(255)
Declare @WhereS1 varchar(500)
Declare @WhereS2 varchar(255)

Select @SelectA1 ='' 
Select @SelectA2 ='' 
Select @SelectA3 ='' 
Select @FromA1 ='' 
Select @WhereA1 ='' 
Select @WhereA2 ='' 
Select @Union ='' 
Select @SelectS1 ='' 
Select @SelectS2 ='' 
Select @SelectS3 ='' 
Select @SelectS4 ='' 
Select @FromS1 ='' 
Select @WhereS1 ='' 
Select @WhereS2 ='' 

--Este SP Selecciona todos aquellos Certificados que aun deben ser Facturados

If @DEPADU='1'
Begin
    Select @SelectA1="Select a.numcer13,a.numdui11,a.numsol10,a.perfac13,a.inifac13,a.finalm13,a.ultent13,a.numbul13,a.cifcer13,a.pescer13,a.flgtar13,a.numtar68,a.finser13,a.ultfac13,"
    Select @SelectA2="tipcli02C=a.tipcli02,codcli02C=a.codcli02,tipcli02=a.ticlfa13,codcli02=a.coclfa13,b.nombre,b.direccion,FLGHOR02=substring(b.cadena,11,1),TOLHOR02=b.diasabast,FACHOR02=b.diaspromat,"
    Select @SelectA3="c.diaalm10,c.segnep10,c.porseg10,c.desmer10,c.faccom10,c.conemb10,CERADU74='' " 
    Select @FromA1="From DDCerAdu13 a,AAClientesAA b,DDSolAdu10 c "
--    Select @WhereA1="Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and 	a.numsol10=c.numsol10 and a.flgval13='1' and a.flgfac13='1' and substring(b.cadena,12,1)='1' and a.finser13='0' and a.flstfa13='N' "
    Select @WhereA1="Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and a.numsol10=c.numsol10 and a.flgval13='1' and substring(b.cadena,12,1)='1' and a.finser13='0' and a.flstfa13='N'  and a.numsol10 not in (Select a.numsol10 From ddceradu13 a,ddcabcom52 b where a.numcer13=b.numcer52 and b.flgval52='1' and flstfa13='S') and b.contribuy not in (select contribuy from DQCLIPROY00) "

    IF @PORCER='1'
        Select @WhereA2=" and a.numcer13='" + @NUMCER + "'"
    IF @PORCLI='1'
        Select @WhereA2=" and b.claseabc='" + @TIPCLI + "' and b.contribuy='" + @CODCLI + "' "
End

If @DEPADU='1' And @DEPSIM='1'
    Select @Union=" UNION ALL "

If @DEPSIM='1'
Begin
    Select @SelectS1="Select numcer13=a.numcer74,numdui11=c.numdui11,numsol10=a.numsol62,perfac13=a.perfac74,inifac13=a.inifac74,finalm13=a.finalm74,ultent13=a.ultent74,numbul13=a.bultot74,"
    Select @SelectS2="cifcer13=a.pretot74,pescer13=a.pestot74,flgtar13=a.flgtar74,a.numtar68,finser13=a.finser74,ultfac13=a.ultfac74,tipcli02C=a.tipcli02,codcli02C=a.codcli02,"    
    Select @SelectS3="TipCli02=a.ticlfa74,CodCli02=a.coclfa74,b.nombre,b.direccion,FLGHOR02=substring(b.cadena,11,1),TOLHOR02=b.diasabast,FACHOR02=b.diaspromat,"    
    Select @SelectS4="diaalm10=c.diaalm62,segnep10=c.segnep62,porseg10=c.porseg62,desmer10=c.desmer62,faccom10=c.FACTCOMER,conemb10=c.codemb62,CERADU74=a.ceradu74 "
    Select @FromS1="From DDCerSim74 a,AAClientesAA b, DDSolSim62 c "
--    Select @WhereS1="Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74='1' and a.flgfac74='1' and substring(b.cadena,12,1)='1' and a.finser74='0' and a.flstfa74='N'  "
    Select @WhereS1="Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74='1'  and substring(b.cadena,12,1)='1' and a.finser74='0' and a.flstfa74='N'  and c.diaalm62>0 and  a.numsol62 not in (Select a.numsol62 From DDCerSim74 a,ddcabcom52 b where a.numcer74=b.numcer52 and b.flgval52='1' and flstfa74='S') and b.contribuy not in (select contribuy from DQCLIPROY00)  "
    IF @PORCER='1'
        Select @WhereS2=@WhereS2 + " and a.numcer74='" + @NUMCER + "' "
    IF @PORCLI='1'
        Select @WhereS2=@WhereS2 + " and b.claseabc='" + @TIPCLI + "' and b.contribuy='" + @CODCLI + "' "
End


Print(@SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2)

Execute(@SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2)

/*
EXEC TAR_FACTURAS_FACTURAR '1','0','1','0','A00172400','',''
*/



GO
