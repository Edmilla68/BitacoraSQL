USE [NEPT3_Depositos]
GO
/****** Object:  View [dbo].[DQBancos49]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  View dbo.DQBancos49    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[DQBancos49]
as
select * from descarga..DQBANCOS49
GO
/****** Object:  View [dbo].[DQTipPag48]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.DQTipPag48    Script Date: 08-09-2002 08:44:02 PM ******/  
ALTER VIEW [dbo].[DQTipPag48]  as  select * from terminal.dbo.dqtippag48  
  
GO
/****** Object:  View [dbo].[vAboCtaCli]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View [dbo].[DQRegime15]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.DQRegime15    Script Date: 08-09-2002 08:44:02 PM ******/  
ALTER VIEW [dbo].[DQRegime15]  as  Select codreg15=codreg56, desreg15=desreg56 from terminal.dbo.DQREGIME56  
  
GO
/****** Object:  View [dbo].[DVRetAdu33_112]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_r_abandono_legal_1]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[fn_r_abandono_legal_1] (@FECINI char(8),@FECFIN char(8))    
RETURNS TABLE     
AS  
  
RETURN  
Select a.numdui11,a.fecdui11,b.numman10,d.codadu02,b.conemb10,c.priing69,a.tipcam11,a.valcif11,a.abaleg11,b.desmer10,a.numbul11,a.codemb06,c.pesnet69,e.nombre  
From DDDUiDep11 a  
Inner Join DDSolAdu10 b on b.numsol10=a.numsol10   
Inner Join DDRecMer69 c on c.numsol62=b.numsol10  
Inner Join terminal.dbo.DQPuerto02 d on d.codpue02=b.codpue03  
Inner Join AAClientesAA e on e.contribuy=b.codcli02  
Where CONVERT(CHAR(8),a.abaleg11,112) between @FECINI and @FECFIN and c.flgval69='1' and c.flgemi69='1'    
  
  
GO
/****** Object:  UserDefinedFunction [dbo].[fn_r_facturacion_por_almacenes]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[Paul]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Paul] ()
RETURNS table
AS
return (Select * from ddsoladu10)
GO
/****** Object:  View [dbo].[DDGUIREM01]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DQCtaDep50]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.DQCtaDep50    Script Date: 08-09-2002 08:44:02 PM ******/  
ALTER VIEW [dbo].[DQCtaDep50]  AS  Select * from terminal.dbo.DQCTADEP50  
  
GO
/****** Object:  View [dbo].[DQPAISES07]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.DQPAISES07    Script Date: 08-09-2002 08:44:02 PM ******/  
ALTER VIEW [dbo].[DQPAISES07]  as  Select codpai07, despai07, nacpai07 from terminal.dbo.DQPAISES07  
  
GO
/****** Object:  View [dbo].[DQTipCam28]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DTSALREC39_VIEW]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVDRESIM86]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVEntSer24]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVIngAdu21]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVIngAdu21_NEW]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVIngCer36_11]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVIngDep84]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVIngSim91_11]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVLevAba94]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVPesIng85]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVPreRec87]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVSalAdu23_11_11]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVSALCER37_VIEW]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVSalRec39]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVSalSer38]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVSalSer40]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVSalSim92_11]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[DVSERVIC52]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[ODItems06]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View dbo.ODItems06    Script Date: 08-09-2002 08:44:02 PM ******/
ALTER VIEW [dbo].[ODItems06]
As
	Select * from Descarga..ODItems06
GO
/****** Object:  View [dbo].[ORUsrItm11]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.ORUsrItm11    Script Date: 08-09-2002 08:44:02 PM ******/  
ALTER VIEW [dbo].[ORUsrItm11]  As   Select * from terminal.dbo.ORUsrItm11  
  
GO

/****** Object:  View [dbo].[SERVICIOS_ORS_SER]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--ALTER VIEW [dbo].[SERVICIOS_ORS_SER] AS  -- FMCR
--  
--SELECT numacu53=coalesce(b.numacu53,''),gloacu53=coalesce(b.gloser53,''),a.*,  
--DETRAC51=(Select detrac51 from dqconcom51 where codcon51=a.CONCEP51 and visible51='S'),  
--DETTRANS=(Select dettrans from dqconcom51 where codcon51=a.CONCEP51 and visible51='S')  
--FROM ddservic52 a (NOLOCK), ddacuerd53 b (NOLOCK)  
--WHERE   
--a.servic52*=b.codser53 and a.deposi52*=b.tipdep53 and a.STATUS52='A' and a.VISIBLE52='S' and   
--b.ESTADO53='A' and a.APLICA52<>'P'  
--
--GO
/****** Object:  View [dbo].[SIP_SERVICIOS_ORS_SER]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER VIEW [dbo].[SIP_SERVICIOS_ORS_SER] AS -- FMCR
--
--Select numacu53=coalesce(b.numacu53,''),gloacu53=coalesce(b.gloser53,''),cliente53=coalesce(b.CODCLI53,''),a.*,
--nombre53=coalesce((Select nombre from AAclientesAA where contribuy=b.codcli53),''),
--desmed52=(Select unimed54 from PDUNIMED54 where numuni54=a.unimed52),
--HORLIB53=coalesce(b.horlib53,0)
--From Pdservic52 a, Pdacuerd53 b
--Where 
--a.servic52*=b.codser53 and 
--a.STATUS52='A' and a.VISIBLE52='S' and b.ESTADO53='A' 




GO
/****** Object:  View [dbo].[TARIFAS_CERTIFICADO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[TM_CLIENTES]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TM_CLIENTES]  
AS  
select * from terminal.dbo.aaclientesaa  
GO
/****** Object:  View [dbo].[TM_EMBALAJE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[TM_EMBALAJE]

AS

select * from terminal.dbo.DQEMBALA06

GO
/****** Object:  View [dbo].[Ubicaciones]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  View [dbo].[vMovCtaCli]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[AVISO_A_ALMACEN_ADUANERO]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.AVISO_A_ALMACEN_ADUANERO    Script Date: 08-09-2002 08:44:03 PM ******/    
--ALTER PROCEDURE [dbo].[AVISO_A_ALMACEN_ADUANERO]   -- FMCR    
--@FLAG tinyint    
--AS    
--Declare    
--@SelectA1 varchar(255),    
--@SelectA2 varchar(255),    
--@FromA varchar(255),    
--@WhereA1 varchar(255),    
--@WhereA2 varchar(255),    
--@WhereA3 varchar(255),    
--@CondicA varchar(30),    
--    
--@SelectS1 varchar(255),    
--@SelectS2 varchar(255),    
--@FromS varchar(255),    
--@WhereS1 varchar(255),    
--@WhereS2 varchar(255),    
--@WhereS3 varchar(255),    
--@CondicS varchar(30)    
--/*    
--Select @SelectA1="SELECT     
--distinct m.numret18,m.fecvig18,a.numdui16,b.numdui11,b.numcer13,l.codubi71,    
--b.numbul16,d.cliente,NombreA=d.nombre,coddep=i.contribuy, NombreB=i.nombre,"    
--    
--Select @SelectA2="coddes=e.contribuy,NombreC=e.nombre,    
--k.numser12,k.numbul17,k.bulent17,sldbul17=(k.numbul17-k.bulent17),k.codemb06,k.desmer17 "    
--    
--Select @FromA="FROM    
--DRRetAdu18 a,DDDuiDes16 b,AAClientesAA d,AAClientesAA e,    
--DDDuiDep11 g,DDSolAdu10 h,AAClientesAA i,DDSERDES17 k,DDRecMer69 l,DRVIGADU18 m,    
--DDENTMER79 n "    
--    
--Select @WhereA1="WHERE    
--a.NUMRET18=m.NUMRET18 and a.flgval18='1' and     
--convert(char(8),FECVIG18,112)=convert(char(8),getdate(),112) and     
--a.numdui16 = b.numdui16 AND b.codage19 = d.cliente AND    
--b.codcli02 = e.contribuy AND "    
--    
--Select @WhereA2="b.numdui11=g.numdui11 AND g.numsol10=h.numsol10 AND    
--h.codcli02=i.contribuy AND "    
--    
--Select @WhereA3="k.numdui16=a.numdui16 and h.numsol10=l.numsol62 and     
--CONVERT(CHAR(8),n.fecent79,112)=CONVERT(CHAR(8),GETDATE(),112) AND n.flgval79='1' and     
--m.numret18 not in (Select numret75 from DDENTMER79) "    
--    
--Select @CondicA="and m.IMPAVI18='0' "    
--    
--/******************************************************************************************/    
--    
--Select @SelectS1="Select     
--NUMRET18=b.numret75,b.fecvig18,'','',NUMCER13=a.numcer74,e.codubi71,    
--numbul16=0,CLIENTE=a.codage19,NOMBREA=g.nombre,coddep=c.codcli02,NOMBREB=f.nombre,"     
--    
--Select @SelectS2="CODDES='',NOMBREC='',    
--NUMSER12=h.numser67,NUMBUL17=h.bultot76,BULENT17=h.bulret76,SLDBUL17=(h.bultot76-h.bulret76),    
--i.codemb06,DESMER17=i.desmer67 "    
--    
--Select @FromS="From     
--DDRETSIM75 a,DDVIGSIM75 b,DDCerSim74 c,DDSolSim62 d,DDRecMer69 e,AAClientesAA f,    
--terminal.dbo.AAClientesAA g,DDDReSim76 h,DDDSoSim67 i "    
--    
--Select @WhereS1="Where     
--a.numret75=b.numret75 and a.flgval75='1' and     
--convert(char(8),b.fecvig18,112)=convert(char(8),getdate(),112) and "    
--     
--    
--Select @WhereS2="a.numcer74=c.numcer74 and c.numsol62=d.numsol62 and d.numsol62=e.numsol62 and     
--c.tipcli02=f.claseabc and c.codcli02=f.contribuy and "    
--     
--Select @WhereS3="a.codage19*=g.cliente and g.cliente<>'' and     
--a.numret75=h.numret75 and h.numser67=i.numser67 and d.numsol62=i.numsol62 and     
--b.numret75 not in (Select numret75 from DDENTMER79) "    
--    
--Select @CondicS="and b.IMPAVI75='0' "    
--    
--/*****************************************************************************************    
--    
--if @FLAG=1    
--Execute (@SelectA1+@SelectA2+@FromA+@WhereA1+@WhereA2+@WhereA3+@CondicA+"UNION ALL "+    
--         @SelectS1+@SelectS2+@FromS+@WhereS1+@WhereS2+@WhereS3+@CondicS)    
--else    
--Execute (@SelectA1+@SelectA2+@FromA+@WhereA1+@WhereA2+@WhereA3+" UNION ALL "+    
--         @SelectS1+@SelectS2+@FromS+@WhereS1+@WhereS2+@WhereS3)  
--*/  
--GO
/****** Object:  StoredProcedure [dbo].[BALANZA_ENTREGA_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[BALANZA_ENTREGA_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[BUSCAR_USER_SAAWEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CERTIFICADO_SUSPENDIDOS_EN_FAC]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CERTIFICADO_SUSPENDIDOS_EN_FAC    Script Date: 08-09-2002 08:44:05 PM ******/
--ALTER PROCEDURE [dbo].[CERTIFICADO_SUSPENDIDOS_EN_FAC] AS --FMCR
--
--Select 
--CERTIFICADO=a.numcer13,FECHA=a.feccer13,TIPCLIENTE=a.ticlfa13,CODCLIENTE=a.coclfa13,
--NOMBRE=b.nombre
--From 
--ddceradu13 a, AAClientesAA b
--Where 
--a.flgval13='1' and a.flstfa13='S' and a.ticlfa13*=b.claseabc and a.coclfa13*=b.contribuy
--UNION ALL
--Select 
--CERTIFICADO=a.numcer74,FECHA=a.feccer74,TIPCLIENTE=a.ticlfa74,CODCLIENTE=a.coclfa74,
--NOMBRE=b.nombre
--From 
--ddcersim74 a, AAClientesAA b
--Where a.flgval74='1' and a.flstfa74='S' and a.ticlfa74*=b.claseabc and a.coclfa74*=b.contribuy
--order by certificado
--GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ACTA_APERTURA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_ACTA_INVENTARIO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_CERTIFICADO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_CONTENEDOR]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_DUADEP]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_DUADES]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_DUADES_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_ENTMER_ORDRET]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_ENTMER_ORDRET    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_ENTMER_ORDRET]
@ORDRET CHAR(8),
@DEPOSI CHAR(1)
AS

Select NUMDOC=substring(nument79,1,1)+'-'+substring(nument79,3,6),FECEMI=fecusu79,USU=nomusu79,IMP=flgemi79
From DDENTMER79
where flgval79='1' and numret75=substring(@ORDRET,1,1)+substring(@ORDRET,3,6)
order by nument79
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_ENTREGA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_ENTREGA_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_FACTURA]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CG_ADU_FACTURA    Script Date: 08-09-2002 08:44:07 PM ******/
ALTER PROCEDURE [dbo].[CG_ADU_FACTURA]
@NUMSOL CHAR(6),
@DEPOSI CHAR(1)
AS

if @DEPOSI='A' 
Select NUMDOC=substring(b.numcom52,1,3)+'-'+substring(b.numcom52,4,7),FECEMI=b.fecusu52,USU=b.nomusu52,IMP=b.flgemi52 
From ddceradu13 a,ddcabcom52 b 
where a.numcer13=b.numcer52 and b.flgval52='1' and 
a.numsol10=@DEPOSI+@NUMSOL
order by b.feccom52
else
Select NUMDOC=substring(b.numcom52,1,3)+'-'+substring(b.numcom52,4,7),FECEMI=b.fecusu52,USU=b.nomusu52,IMP=b.flgemi52 
From DDCerSim74 a,ddcabcom52 b 
where a.numcer74=b.numcer52 and b.flgval52='1' and 
a.numsol62=@DEPOSI+@NUMSOL
order by b.feccom52
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_FACTURA_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDENRETIRO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDENRETIRO_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDENSERVICIO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDENSERVICIO_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_ORDRET_DUADES]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_RECEPCION]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_SOLDEP_SOLDEP]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_TICKETD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CG_ADU_TICKETD_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CG_ADU_TICKETD_SOLICITUD    Script Date: 08-09-2002 08:44:08 PM ******/
--ALTER PROCEDURE [dbo].[CG_ADU_TICKETD_SOLICITUD]  --FMCR
--@NUMTKT CHAR(8)  
--AS
--
--Select
--a.*,numsol10=a.docaut01,NombreC=b.nombre,NombreA=c.nombre,d.desemb06,e.numctr65,e.tamctr65
--From 
--DDTICKET01 a,AAclientesAA b,AAclientesAA c,DQEMBALA06 d,DDCTRDEP65 e
--Where
--a.numtkt01=@NUMTKT and a.tipope01='D' and 
--a.tipcli02=b.claseabc and a.codcli02=b.contribuy and
--a.codage19*=c.cliente and c.cliente<>'' and a.codemb06=d.codemb06 and 
--a.numtkt01*=e.numtkt01
--order by a.numtkt01
--GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_TICKETR]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.CG_ADU_TICKETR    Script Date: 08-09-2002 08:44:13 PM ******/  
ALTER PROCEDURE [dbo].[CG_ADU_TICKETR]  
@NUMSOL CHAR(6),  
@DEPOSI CHAR(1)  
AS  
  
if @DEPOSI='A'   
Select NUMDOC=d.numtkt01,FECEMI=d.fecusu01,USU=d.nomusu01,IMP=case when flgman01='1'  then '2' else '1' end  
From ddduides16 a,DRRetAdu18 b,Ddduidep11 c,DDTicket01 d   
Where a.numdui16=b.numdui16 and 
a.numdui11=c.numdui11 and   
d.docaut01=b.numret18 and 
b.flgval18='1' and   
d.tipope01 = 'R' and
c.numsol10=@DEPOSI+@NUMSOL  
order by d.numtkt01  
else  
Select NUMDOC=b.numtkt01,FECEMI=b.fecusu01,USU=b.nomusu01,IMP=case when flgman01='1'  then '2' else '1' end  
From DDRetSim75 a,DDTicket01 b,DDCersim74 c  
Where b.docaut01=a.numret75 and 
a.numcer74=c.numcer74 and   
a.flgval75='1' and 
c.flgval74='1' and   
b.tipope01 = 'R' and
c.numsol62=@DEPOSI+@NUMSOL  
order by b.numtkt01
GO
/****** Object:  StoredProcedure [dbo].[CG_ADU_TICKETR_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CONSULTA_DE_TICKET_BUSCAR]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CORRELATIVO_DE_ENTREGA_DE_MERCADERIAS]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CORRELATIVO_DE_ORDENES_DE_RETIRO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[CORRELATIVO_DE_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
    t.tamctr65 as tamactr, a.faccom10 as FactComer --13072007 / rtello /Factura Comercial
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
    t.tamctr65 as tamactr, a.factcomer as FactComer --13072007 / rtello /Factura Comercial
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
/****** Object:  StoredProcedure [dbo].[DAT_ADI_CTR]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[DAT_ADI_CTR]   
@NUMTKT varchar(8)  
AS  
Select distinct a.nrotkt28,a.codcon63,b.nrotar63,b.codtam09   
From   
terminal.dbo.drblcont15 a inner join terminal.dbo.ddcontar63 b on   
a.navvia11=b.navvia11 and a.codcon63=b.codcon63  
Where a.nrotkt28 =@NUMTKT
GO
/****** Object:  StoredProcedure [dbo].[DAT_GEN_CTR]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DAT_GEN_CTR]  
@NUMTKT varchar(8)  
AS  
  
Select   
nropla18,pesbrt18,pestar18,pesnet18,fecsal18,codemb06,bulret18   
From terminal.dbo.ddticket18   
Where nrotkt18=@NUMTKT
GO
/****** Object:  StoredProcedure [dbo].[DH_EnviaAlertas_Attach]    Script Date: 10/03/2019 02:40:09 PM ******/
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
     @server    = 'calw3mem001'       

GO
/****** Object:  StoredProcedure [dbo].[dt_verstamp003]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_INGRESOS_ADU_AM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_INGRESOS_ADU_PM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_INGRESOS_SIM_AM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_INGRESOS_SIM_PM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_SALIDAS_AM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[HORAS_EXTRAS_SALIDAS_PM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[insertar_Detalleticket]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[INSERTAR_USER_SAAWEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[INTERFACE_ADU_CABEC]    Script Date: 10/03/2019 02:40:09 PM ******/
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

Select @SUBTOT=sum(subtot52),@IGVTOT=sum(igvtot52) from ddcabcom52 Where codcom50=@TIPDOC and numcom52=@NUMDOC

Select @FACESP=facesp52 from ddcabcom52 Where codcom50=@TIPDOC and numcom52=@NUMDOC
if @FACESP='N'
Begin
	IF @TIPDEP='A'
	BEGIN
	    Select a.*,ruc_age_adu=d.contribuy,nom_age_adu=d.nombre,nom_cliente=e.nombre
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
	    From ddcabcom52 a, ddcersim74 b,aaclientesaa e 
	    Where a.codcom50=@TIPDOC and a.numcom52=@NUMDOC and a.numcer52=b.numcer74 and 
	    a.tipcli02=e.claseabc and a.codcli02=e.contribuy
	END 
	
	IF @TIPDEP=''
	BEGIN
	    Select a.*,ruc_age_adu='00000000099',nom_age_adu='',nom_cliente=e.nombre
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
	    From ddcabcom52 
	    Where codcom50=@TIPDOC and numcom52=@NUMDOC 
	END
	
	IF @TIPDEP='S'
	BEGIN
	    Select distinct numcer52,numcom52,feccom52,docdes52,nomdes52,SUBTOT52=@SUBTOT,IGVTOT52=@IGVTOT,codcom50,codcli02,ruc_age_adu='00000000099',nom_age_adu='',nom_cliente=nomdes52,Detrac52,TIPMON52
	    From ddcabcom52 
	    Where codcom50=@TIPDOC and numcom52=@NUMDOC 
	END 
End

GO
/****** Object:  StoredProcedure [dbo].[INTERFACE_ADU_DETAL]    Script Date: 10/03/2019 02:40:09 PM ******/
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
	Select a.*,codsbd03 = case when @CODMON = 'D' then b.codsbd03 else b.codsbd03s end,b.flguni51,b.descon51,b.cencos51,b.sucimp51
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
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL0]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL2]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
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
Inner Join terminal.dbo.DQPuerto02 d on d.codpue02=b.codpue03  
Where   
CONVERT(CHAR(8),a.abaleg11,112) between @FECINI and @FECFIN and --a.numbul11<>a.bulent11 AND --ojo con la ultima condicion 03/07/2003  
c.flgval69='1' and c.flgemi69='1'  
  
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL3]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_ABANDONO_LEGAL4]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_ING_CLI_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_ING_CLI_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_LEVANTE_ABANDONO_LEGAL3]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_ORR_PEN_POR_CLI_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_ORR_PEN_POR_CLI_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER PROCEDURE [dbo].[REPORTE_ORR_PEN_POR_CLI_SIM]
--@TIPCLI CHAR(1),
--@CODCLI VARCHAR(11)
--
--AS
--Select 
--numret18=a.numret75,fecret18=a.fecret75,numdui16='',a.tipdoc55,a.codrep77,c.nomrep77,obsret18=a.obsret75,b.tipcli02,b.codcli02,d.nombre,
--b.codage19,f.nombre,bulsld=a.bultot75-a.bulret75,cifsld=a.pretot75-a.preret75,e.desmer62,numdui11='',numcer13=a.numcer74 
--From 
--DDRetSim75 a,DDCerSim74 b,DQMaeRep77 c,AAClientesAA d,DDSolSim62 e,AAClientesAA f 
--Where 
--a.numcer74=b.numcer74 and a.bultot75-a.bulret75>0 and a.flgval75='1' and a.flgemi75='1' and a.codrep77=c.codrep11 and 
--b.tipcli02=d.claseabc and b.codcli02=d.contribuy and b.numsol62=e.numsol62 and b.codage19*=f.cliente and f.cliente<>'' and 
--b.tipcli02=@TIPCLI and b.codcli02=@CODCLI
--GO
/****** Object:  StoredProcedure [dbo].[REPORTE_ORR_PEN_TOD_CLI_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_ORR_PEN_TOD_CLI_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER PROCEDURE [dbo].[REPORTE_ORR_PEN_TOD_CLI_SIM]
--
--AS
--Select 
--numret18=a.numret75,fecret18=a.fecret75,numdui16='',a.tipdoc55,a.codrep77,c.nomrep77,obsret18=a.obsret75,b.tipcli02,b.codcli02,d.nombre,
--b.codage19,f.nombre,bulsld=a.bultot75-a.bulret75,cifsld=a.pretot75-a.preret75,e.desmer62,numdui11='',numcer13=a.numcer74 
--From 
--DDRetSim75 a,DDCerSim74 b,DQMaeRep77 c,AAClientesAA d,DDSolSim62 e,AAClientesAA f 
--Where 
--a.numcer74=b.numcer74 and a.bultot75-a.bulret75>0 and a.flgval75='1' and a.flgemi75='1' and a.codrep77=c.codrep11 and 
--b.tipcli02=d.claseabc and b.codcli02=d.contribuy and b.numsol62=e.numsol62 and b.codage19*=f.cliente and f.cliente<>'' 
--
--GO
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_ING_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_ING_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_ING2_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_SAL_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_POR_DEPOSITO_SAL_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_SAL_CLI_ADU1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_SAL_CLI_ADU2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_SAL_CLI_SIM1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_SAL_CLI_SIM2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_SLD_CLI_ADU1]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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
GO
/****** Object:  StoredProcedure [dbo].[REPORTE_SLD_CLI_ADU2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_SLD_CLI_SIM1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[REPORTE_SLD_CLI_SIM2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_CERTIFICADOS_FACTURAR]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_CONTROLAR_ALMAN]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_CONTROLAR_GASAD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_CONTROLAR_SEGCA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_CONTROLAR_TARIFAS]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_DESCUADRES_EM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_DESCUADRES_EM_1]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[ROCKY_DESCUADRES_EM_1]
AS


Update ddentmer79 set e_mail79='S' 
where cuadep79<>0 and flgval79='1' and e_mail79='N'
GO
/****** Object:  StoredProcedure [dbo].[ROCKY_DESTINATARIOS]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_EMAIL_SOLICITUD_DEPOSITO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_ENTREGA_DE_MERCADERIA_ADUANERA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_ENTREGA_DE_MERCADERIA_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_RANKING_CIF]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ROCKY_RANKING_FACTURACION]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SIG_RANKING_FACTURACION    Script Date: 08-09-2002 08:44:08 PM ******/
ALTER PROCEDURE [dbo].[ROCKY_RANKING_FACTURACION] 
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
exec NEPTUNIA9.bd_nept..ROCKY_RANKING_FACTURACION_PROY @FECINI,@FECFIN

Update SIG_FACTURAPRO set nombre=b.nombre
from SIG_FACTURAPRO a, aaclientesaa b
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'

Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),
REPORTE="facturacion.rpt"
From SIG_FACTURAPRO

Where Usuario=user_name()
group by nombre
Order by 2 desc
GO
/****** Object:  StoredProcedure [dbo].[SIG_CONTENEDORES_CLIENTE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIG_CONTENEDORES_MENSUAL]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE] 
@RUC varchar(11),
@DEUVEN char(2)
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
EXEC NEPTUNIA9.DATAWAREHOUSE..SIG_DEUDA_PENDIENTE_CLIENTE @RUC,@DEUVEN,'CLDA',@USERID,@AUTORIZACION

--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.
--===========================================================================
if @DEUVEN='NO' EXEC NEPTUNIA9.DATAWAREHOUSE..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'
GO
/****** Object:  StoredProcedure [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE_NEW]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIG_DEUDA_PENDIENTE_CLIENTE_NEW]
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
EXEC NEPTUNIA9.BD_NEPT..SIG_DEUDA_PENDIENTE_CLIENTE_NEW @RUC,@DEUVEN,'CLDA',@USERID,@AUTORIZACION

--(NO) - Es utilizado por los sistemas de NEPTUNIA para consultar la deuda no vencida de un cliente.
--          Es usado para mostrar la deuda no vencida cuando el cliente retira todo el saldo pendiente de su mercaderia
--          Con esta linea es posible consultar la deuda solo en los horarios de atencion.
--===========================================================================
if @DEUVEN='NO' EXEC NEPTUNIA9.BD_NEPT..SIG_DEUDA_NO_PENDIENTE_CLIENTE @RUC,'NO'
GO
/****** Object:  StoredProcedure [dbo].[SIG_ESTACIONALIDAD_CIF]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIG_ESTACIONALIDAD_CLIENTES]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SIG_ESTACIONALIDAD_CLIENTES    Script Date: 08-09-2002 08:44:08 PM ******/
ALTER PROCEDURE [dbo].[SIG_ESTACIONALIDAD_CLIENTES] 
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
exec NEPTUNIA9.bd_nept..SIG_ESTACIONALIDAD_CLIENTES_PR @ANIO

Update SIG_FACTESTAPRO set nombre=b.nombre
from SIG_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'


Select nomdes52=nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep),OCT=sum(oct),NOV=sum(nov),DIC=sum(dic),TOT=sum(total),
anio=@ANIO,fecha=getdate(),reporte="estacionalidad_factura.rpt"
From SIG_FACTESTAPRO
where usuario=user_name()
group by nombre
order by 14 desc
GO
/****** Object:  StoredProcedure [dbo].[SIG_ESTACIONALIDAD_CLIENTES_PR]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SIG_ESTACIONALIDAD_CLIENTES_PR    Script Date: 08-09-2002 08:44:08 PM ******/
ALTER PROCEDURE [dbo].[SIG_ESTACIONALIDAD_CLIENTES_PR]
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
exec NEPTUNIA9.bd_nept..SIG_ESTACIONALIDAD_CLIENTES_PR @ANIO

Update SIG_FACTESTAPRO set nombre=b.nombre
from SIG_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'


Select nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep),OCT=sum(oct),NOV=sum(nov),DIC=sum(dic),TOTAL=sum(total),
anio=@ANIO,fecha=getdate(),reporte="estacionalidad_factura_proyectada.rpt"
From SIG_FACTESTAPRO
where usuario=user_name()
group by nombre
order by 14 desc
GO
/****** Object:  StoredProcedure [dbo].[SIG_ESTADISTICA_DE_ESTANCIA_POR_DEPOSITO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIG_ESTADISTICA_DE_ESTANCIA_POR_RETIRO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIG_RANKING_FACTURACION_PROY]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SIG_RANKING_FACTURACION_PROY    Script Date: 08-09-2002 08:44:08 PM ******/
ALTER PROCEDURE [dbo].[SIG_RANKING_FACTURACION_PROY] 
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
exec NEPTUNIA9.bd_nept..SIG_RANKING_FACTURACION_PROY @FECINI,@FECFIN

Update SIG_FACTURAPRO set nombre=b.nombre
from SIG_FACTURAPRO a, aaclientesaa b
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'

Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),REPORTE="facturacion_proyectada.rpt"
From SIG_FACTURAPRO

Where Usuario=user_name()
group by nombre
Order by 2 desc
GO
/****** Object:  StoredProcedure [dbo].[SIG_SIP_ESTACIONALIDAD_CLIENTES]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIG_SIP_ESTACIONALIDAD_CLIENTES] 
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
exec NEPTUNIA9.bd_nept..SIG_SIP_ESTACIONALIDAD_CLIENTES_PR @ANIO

Update SIG_FACTESTAPRO set nombre=b.nombre
from SIG_FACTESTAPRO a (NOLOCK), aaclientesaa b (NOLOCK)
where rtrim(substring(a.nombre,4,14))=rtrim(b.contribuy) and a.nombre like 'RUC%'


Select nomdes52=nombre,ENE=sum(ene),FEB=sum(feb),MAR=sum(mar),ABR=sum(abr),MAY=sum(may),JUN=sum(jun),
JUL=sum(jul),AGO=sum(ago),SEP=sum(sep),OCT=sum(oct),NOV=sum(nov),DIC=sum(dic),TOT=sum(total),
anio=@ANIO,fecha=getdate(),reporte="estacionalidad_factura.rpt"
From SIG_FACTESTAPRO
where usuario=user_name()
group by nombre
order by 14 desc
GO
/****** Object:  StoredProcedure [dbo].[SIG_SIP_RANKING_FACTURACION]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIG_SIP_RANKING_FACTURACION] 
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
exec NEPTUNIA9.bd_nept..SIG_SIP_RANKING_FACTURACION_PROY @FECINI,@FECFIN

Update SIG_FACTURAPRO set nombre=b.nombre
from SIG_FACTURAPRO a, aaclientesaa b
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'

Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),
REPORTE="facturacion.rpt"
From SIG_FACTURAPRO

Where Usuario=user_name()
group by nombre
Order by 2 desc
GO
/****** Object:  StoredProcedure [dbo].[SIG_TOTAL_MENSUAL_CIF]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIG_TOTAL_MENSUAL_FAC_PROY]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SIG_TOTAL_MENSUAL_FAC_PROY    Script Date: 08-09-2002 08:44:08 PM ******/
ALTER PROCEDURE [dbo].[SIG_TOTAL_MENSUAL_FAC_PROY]
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
EXEC NEPTUNIA9.BD_NEPT..SIG_TOTAL_MENSUAL_FAC_PROY @ANIO


Select 
NUMMES,NOMMES,TOTAL=sum(TOTAL),anio=@ANIO,fecha=getdate(),reporte="facturacion_mensual_proyectada.rpt"
From SIG_FACMENPRO
where usuario=user_name()
group by NUMMES,NOMMES
order by NUMMES
GO
/****** Object:  StoredProcedure [dbo].[SIG_TOTAL_MENSUAL_FACTURACION]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SIG_TOTAL_MENSUAL_FACTURACION    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SIG_TOTAL_MENSUAL_FACTURACION]
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
EXEC NEPTUNIA9.BD_NEPT..SIG_TOTAL_MENSUAL_FAC_PROY @ANIO


Select NUM_MES=NUMMES,NOM_MES=NOMMES,TOTAL=sum(TOTAL),anio=@ANIO,fecha=getdate(),
reporte="facturacion_mensual.rpt"
From SIG_FACMENPRO
where usuario=user_name()
group by NUMMES,NOMMES
order by NUMMES
GO
/****** Object:  StoredProcedure [dbo].[SIP_CONSULTAR_DOCUMENTO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIP_CONSULTAR_ORDSER]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIP_ESTACIONALIDAD_CLIENTES]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIP_ESTACIONALIDAD_CLIENTES] 
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
exec NEPTUNIA9.bd_nept..SIG_ESTACIONALIDAD_CLIENTES_PR @ANIO
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
GO
/****** Object:  StoredProcedure [dbo].[SIP_IMPRIMIR_FACTURA]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
Inner Join terminal.dbo.DQNAVIER08 e on a.navord58=e.codnav08  
where a.flgeje58='1' and a.numord58=@NUMORD
GO
/****** Object:  StoredProcedure [dbo].[SIP_IMPRIMIR_ORDEN_DE_SERVICIO]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
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
Inner Join terminal.dbo.dqnavier08 e on a.navord58=e.codnav08  
Inner Join PDUNIMED54 f on b.numuni54=f.NUMUNI54  
Inner Join  PDMUELLE60 g on a.muelle58=g.MUELLE60  
Inner Join PDMAQUIN61 h on  b.maquin59=h.codmaq61  
where a.numord58=@NUMORD
GO
/****** Object:  StoredProcedure [dbo].[SIP_INTERFACE_ADU_CABEC]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIP_INTERFACE_ADU_DETAL]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIP_RANKING_FACTURACION]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIP_RANKING_FACTURACION] 
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
--exec NEPTUNIA9.bd_nept..SIP_RANKING_FACTURACION_PROY @FECINI,@FECFIN

Update SIP_FACTURAPRO set nombre=b.nombre
from SIP_FACTURAPRO a, aaclientesaa b
where substring(a.nombre,4,14)=b.contribuy and a.nombre like 'RUC%'

Select nomdes52=nombre,total=sum(total),DESDE=@FECINI,HASTA=@FECFIN,FECHA=getdate(),
REPORTE="facturacion.rpt"
From SIP_FACTURAPRO

Where Usuario=user_name()
group by nombre
Order by 2 desc
GO
/****** Object:  StoredProcedure [dbo].[SIP_RESUMEN_CONCEPTOS]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--ALTER PROCEDURE [dbo].[SIP_RESUMEN_CONCEPTOS]  --FMCR
--@CODCOM CHAR(2),
--@NUMSER CHAR(3),
--@FECINI CHAR(8),
--@FECFIN CHAR(8),
--@CONDIC CHAR(1),
--@TIPCLI CHAR(1),
--@CODCLI VARCHAR(11)
--AS


--if @CONDIC='0' 
--Select 
--    descon53=e.descon51,c.numcom52,docdes52=c.codcli02,d.nombre,valcon53=a.valcob59,
--    DOLARES=convert(decimal(15,2),a.valcob59),
--    SOLES=a.igvser59,numcer52=c.numord58,e.descon51
--    From 
--    Pddorser59 a,PDORDSER58 c,AAClientesAA d,PQCONCOM51 e
--    Where 
--    a.numord58=c.numord58 and c.flgval58='1' and c.flgemi58='1' and 
--    c.tipcli02=d.claseabc and c.codcli02=d.contribuy and 
--    convert(char(8),c.fecemi52,112) between @FECINI and @FECFIN and substring(c.numcom52,1,3)=@NUMSER and 
--    left(a.codcon51,5)=e.codcon51
--    Order by 
--    a.descon53,d.nombre,a.numcom52
--else
--    Select 
--    descon53=e.descon51,c.numcom52,docdes52=c.codcli02,d.nombre,valcon53=a.valcob59,
--    DOLARES=convert(decimal(15,2),a.valcob59),
--    SOLES=a.igvser59,numcer52=c.numord58,e.descon51
--    From 
--    Pddorser59 a,PDORDSER58 c,AAClientesAA d,PQCONCOM51 e
--    Where 
--     a.numord58=c.numord58 and c.flgval58='1' and c.flgemi58='1' and 
--    c.tipcli02=d.claseabc and c.codcli02=d.contribuy and 
--    convert(char(8),c.fecemi52,112) between @FECINI and @FECFIN and 
--    substring(c.numcom52,1,3)=@NUMSER and left(a.codcon51,5)=e.codcon51 and
--    c.tipcli02=@TIPCLI and c.codcli02=@CODCLI
--    Order by 
--    a.descon53,d.nombre,a.numcom52
--GO
/****** Object:  StoredProcedure [dbo].[SIP_TAR_TARIFARIO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SIP_TOTAL_MENSUAL_FACTURACION]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SIP_TOTAL_MENSUAL_FACTURACION]
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
EXEC NEPTUNIA9.BD_NEPT..SIG_TOTAL_MENSUAL_FAC_PROY @ANIO
*/

Select NUM_MES=NUMMES,NOM_MES=NOMMES,TOTAL=sum(TOTAL),anio=@ANIO,fecha=getdate(),
reporte="facturacion_mensual.rpt"
From SIP_FACMENPRO
where usuario=user_name()
group by NUMMES,NOMMES
order by NUMMES
GO
/****** Object:  StoredProcedure [dbo].[SP_ABOCARFEC]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ABONOCLIE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_ABONOCLIE    Script Date: 08-09-2002 08:44:05 PM ******/
--ALTER PROCEDURE [dbo].[SP_ABONOCLIE]  --FMCR
--@FECINI CHAR(8),
--@FECFIN CHAR(8),
--@TIPCLIE CHAR(1),
--@CLIENTE VARCHAR(11)
--AS
--
--
--Select 
--a.tipdes52,a.docdes52,a.fecpag56,a.nropag56,c.destip48,b.nomban49,a.nrodoc56,a.monpag56,d.nombre
--From 
--ddpagos56 a,DQBANCOS49 b,dqtippag48 c,AAClientesAA d
--Where 
--a.codtip48=c.codtip48 and a.codban49*=b.codban49 and 
--a.tipdes52=@TIPCLIE and (a.docdes52=@CLIENTE or a.docdes52=substring(@CLIENTE,3,8)) and 
--(convert(char(8),a.fecpag56,112)>=@FECINI and convert(char(8),a.fecpag56,112)<=@FECFIN) and 
--(a.docdes52=d.contribuy or a.docdes52=d.catcliente)
--GO
/****** Object:  StoredProcedure [dbo].[SP_ActaApertura_Ins]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ActaInventario_Ins]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_Actualiza_Acta_Aper_Det]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZA_NRO_RETIRO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZA_NRO_RETIROADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_MERCADERIA_EN_ALMACEN]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_OrdRetiroAduanaWeb]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ACTUALIZAR_OrdretiroClienteWeb]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ASIGNAR_CONTENEDOR_ADUANERO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ASIGNAR_CONTENEDOR_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_ADU1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_ADU2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_ENTREGA_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_ENTREGA_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_SIM1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_BALANZA_SIM2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_Borrar_IMAGEN]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_BUSCAR_DESCUENTOS]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CA_CompletaVerifica]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CALCULA_PRODUC_NO_NACIONAL_SAA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CALCULA_PRODUC_NO_NACIONAL1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CALCULA_PRODUC_REPORT]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_cancelacion]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_cancelacion    Script Date: 08-09-2002 08:44:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_cancelacion    Script Date: 28/04/2000 8:36:18 PM ******/
/****** Object:  Stored Procedure dbo.sp_cancelacion    Script Date: 18/04/2000 9:19:01 AM ******/
--ALTER PROCEDURE [dbo].[sp_cancelacion]  -- FMCR
--		@fec_i varchar(8),
--		@fec_f varchar(8)
--
--as
--
--/********* Para cancelaciones *********/		
--
--/****** Para la cuenta 104 *****/
--
--select nropag56='', codsbd03=d.codsbd03, coddoc07='', codmon30=b.tipmon56, fecmov12=getdate(), codcue01= d.codcue01, serdoc12= '',
--numdoc12= '', codcco06='', codcco07='', desmov12= '', nrocan04='', codana02='', 
--
--impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,3),a.monpag57)) else sum(convert(decimal(15,3),(a.monpag57*b.tipcam56))) end,
--impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,3),a.monpag57)) else 0.00 end, 
--ticadi12= 0.000, descan04= '', tipaut12 = '',
--sistem12='D', flagdh12 = 'D', flglei12='N', fecven12='' 
--into #tmp010011
--from ddpagcom57 a (nolock),
--ddpagos56 b (nolock),
--ddcabcom52 c (nolock),
--drbancos49 d (nolock),
--dqclient02 f (nolock)
--
--where (b.nropag56=a.nropag56)
--and (d.codcta50=b.codcta50)
--
--and (a.numcom52=c.numcom52)
--and (c.codcli02*=f.codcli02)
--and (b.flglei56='N')
--and (b.fecpag56 >= @fec_i
--
--and b.fecpag56 < @fec_f)
--
--group by d.codsbd03, d.codcue01, b.tipmon56
--if @@error <> 0 GOTO E_Select_Error
--
--/****** para la cuenta 12 ******/
--
--
--select codsbd03=d.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56, 
--codcue01= g.codcue01, serdoc12= substring(c.numcom52,1,3), numdoc12=substring(c.numcom52,4,7),
--
--codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01', 
--impmna12= case when b.tipmon56 = 'S' then convert(decimal(15,3),sum(a.monpag57)) else convert(decimal(15,3),sum(a.monpag57*b.tipcam56)) end,
--impmex12= case when b.tipmon56 = 'D' then convert(decimal(15,3),sum(a.monpag57)) else 0.000 end,
--ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,3),b.tipcam56) else 0.000 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',
--sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='', b.nropag56
--into #tmp010012
--from ddpagcom57 a (nolock),
--
--ddpagos56 b (nolock),
--ddcabcom52 c (nolock),
--drbancos49 d (nolock),
--crtipdoc02 e (nolock),
--dqclient02 f (nolock),
--crconcep01 g (nolock)
--
--where (b.nropag56=a.nropag56)
--and (b.codcta50=d.codcta50 and b.tipmon56=d.tipmon49)
--
--and (a.numcom52=c.numcom52)
--and (c.codcom50=e.codtip02)
--and (c.codcli02*=f.codcli02)
--
--and (e.tipapp02='D')
--and (b.flglei56='N')
--and (b.fecpag56 >= @fec_i
--and b.fecpag56 < @fec_f)
--and (b.tipmon56=g.codcon14 and tipapp01='D')
--group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,
--c.docdes52, b.tipcam56, g.codcue01, b.nropag56
--
--if @@error <> 0 GOTO E_Select_Error
--
--
--
--begin transaction
--
--
--
--INSERT INTO CDMOVIMI15
--(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12 from #tmp010011
--
--if @@error <> 0 GOTO E_General_Error
--
--INSERT INTO CDMOVIMI15
--(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)
--
--select codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12 from #tmp010012
--
--if @@error <> 0 GOTO E_General_Error
--
--update ddpagos56 set flglei56='S' where nropag56 in (select nropag56 from #tmp010012) 
--if @@error <> 0 GOTO E_General_Error
--
--commit transaction
--return 0
--
--E_General_Error:
--
--raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror
--rollback transaction
--return 2
--
--E_Select_Error:
--raiserror('No se pudo crear la tabla temporal',1,2) with seterror
--return 2
--GO
/****** Object:  StoredProcedure [dbo].[sp_cancelacion2]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_cancelacion2    Script Date: 08-09-2002 08:44:06 PM ******/
--ALTER PROCEDURE [dbo].[sp_cancelacion2]  -- FMCR
--		@fec_i varchar(8),
--		@fec_f varchar(8),
--		@fec_s varchar(8)
--
--as
--
--/********* Para cancelaciones *********/		
--
--/****** Para la cuenta 104 *****/
--
--select nropag56='', codsbd03=d.codsbd03, coddoc07='', codmon30=b.tipmon56, fecmov12=getdate(), codcue01= d.codcue01, serdoc12= '',
--numdoc12= '', codcco06='', codcco07='', desmov12= '', nrocan04='', codana02='', 
--
--impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),a.monpag57)) else sum(convert(decimal(15,2),(a.monpag57*b.tipcam56))) end,
--impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end, 
--ticadi12= 0.00, descan04= '', tipaut12 = '',
--sistem12='D', flagdh12 = 'D', flglei12='N', fecven12='' 
--into #tmp010011
--from ddpagcom57 a (nolock),
--ddpagos56 b (nolock),
--ddcabcom52 c (nolock),
--dqctadep50 d (nolock),
--dqclient02 f (nolock)
--
--where (b.nropag56=a.nropag56)
--and (d.codcta50=b.codcta50)
--
--and (a.numcom52=c.numcom52)
--and (c.codcli02*=f.codcli02)
--and (b.codtip48<>'07')
--and (b.flglei56='N')
--and (b.fecpag56 >= @fec_i
--
--and b.fecpag56 < @fec_f)
--and (c.feccom52 >= @fec_s)
--
--group by d.codsbd03, d.codcue01, b.tipmon56
--if @@error <> 0 GOTO E_Select_Error
--
--/****** para la cuenta 12 ******/
--
--
--select codsbd03=d.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56, 
--codcue01= g.codcue01, serdoc12= substring(c.numcom52,1,3), numdoc12=substring(c.numcom52,4,7),
--
--codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01', 
--impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),a.monpag57)) else convert(decimal(15,2),sum(a.monpag57*b.tipcam56)) end,
--impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,
--ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,2),b.tipcam56) else 0.00 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',
--sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='', b.nropag56
--into #tmp010012
--from ddpagcom57 a (nolock),
--
--ddpagos56 b (nolock),
--ddcabcom52 c (nolock),
--dqctadep50 d (nolock),
--dqcompag50 e (nolock),
--dqclient02 f (nolock),
--dqconcom51 g (nolock)
--
--where (b.nropag56=a.nropag56)
--and (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)
--
--and (a.numcom52=c.numcom52)
--and (c.codcom50=e.codcom50)
--and (c.codcli02*=f.codcli02)
--and (b.codtip48<>'07')
--
--and (b.flglei56='N')
--and (b.fecpag56 >= @fec_i
--and b.fecpag56 < @fec_f)
--and (b.tipmon56=g.codcon51)
--and (c.feccom52 >= @fec_s)
--group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,
--
--c.docdes52, b.tipcam56, g.codcue01, b.nropag56
--
--if @@error <> 0 GOTO E_Select_Error
--
--
--begin transaction
--
--INSERT INTO CDMOVIMI15
--(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12 from #tmp010011
--
--if @@error <> 0 GOTO E_General_Error
--
--INSERT INTO CDMOVIMI15
--(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)
--
--select codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12 from #tmp010012
--
--if @@error <> 0 GOTO E_General_Error
--
--update ddpagos56 set flglei56='S' where nropag56 in (select nropag56 from #tmp010012) 
--if @@error <> 0 GOTO E_General_Error
--
--commit transaction
--return 0
--
--E_General_Error:
--
--raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror
--rollback transaction
--return 2
--
--E_Select_Error:
--raiserror('No se pudo crear la tabla temporal',1,2) with seterror
--
--return 2
--GO
--/****** Object:  StoredProcedure [dbo].[sp_cancelacion3]    Script Date: 10/03/2019 02:40:09 PM ******/
--SET ANSI_NULLS OFF
--GO
--SET QUOTED_IDENTIFIER OFF
--GO

/****** Object:  Stored Procedure dbo.sp_cancelacion3    Script Date: 08-09-2002 08:44:06 PM ******/
--ALTER PROCEDURE [dbo].[sp_cancelacion3]  -- FMCR
--		@fec_i varchar(8),
--		@fec_f varchar(8),
--		@fec_s varchar(8)
--
--as
--
--/********* Para cancelaciones *********/		
--
--/****** Para la cuenta 104 *****/
--
--select codsbd03=d.codsbd03, coddoc07=case when b.codtip48 in ('07','04') then h.coddoc07 else '' end, codmon30=b.tipmon56, fecmov12=getdate(),
--codcue01= case when b.codtip48 in ('07','04') then g.codcue01 else d.codcue01 end, serdoc12= '', 
--numdoc12=case when b.codtip48 in ('07','04') then b.nrodoc56 else '' end,
--
--codcco06= '', codcco07='', desmov12='', nrocan04='', codana02='', 
--impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),a.monpag57)) else convert(decimal(15,2),sum(a.monpag57*b.tipcam56)) end,
--impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,
--ticadi12= 0.00, descan04='', tipaut12 = '',
--sistem12='D', flagdh12 = 'D', flglei12='N', fecven12='', b.nropag56, b.codcta50
--into #tmp010011
--from ddpagcom57 a (nolock),
--
--ddpagos56 b (nolock),
--ddcabcom52 c (nolock),
--dqctadep50 d (nolock),
--dqcompag50 e (nolock),
--dqclient02 f (nolock),
--dqconcom51 g (nolock),
--dqtippag48 h (nolock)
--where (b.nropag56=a.nropag56)
--and (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)
--
--and (b.codtip48=h.codtip48)
--and (a.numcom52=c.numcom52)
--and (c.codcom50=e.codcom50)
--and (c.codcli02*=f.codcli02)
--and (b.flglei56='N')
--and (b.codtip48 not in ('07','04') or a.numcom52 in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 not in ('07','04')
--and b.numcom52 in (select b.numcom52
--FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 in ('07','04'))
--GROUP BY B.NUMCOM52)) 
--
--and (g.codcon51='NOTAS')
--and (b.fecpag56 >= @fec_i
--and b.fecpag56 < @fec_f)
--and (c.feccom52 >= @fec_s)
--group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,
--
--c.docdes52, b.tipcam56, b.nropag56, b.codcta50, g.codcue01, b.codtip48, h.coddoc07, a.numcom52,
--b.nrodoc56
--
--if @@error <> 0 GOTO E_Select_Error
--
--
--/****** para la cuenta 46 ******/
--
--select codsbd03=d.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56, 
--codcue01= g.codcue01, serdoc12= '', numdoc12=b.nrodoc56,
--
--codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01', 
--impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),a.monpag57)) else convert(decimal(15,2),sum(a.monpag57*b.tipcam56)) end,
--impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,
--ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,2),b.tipcam56) else 0.00 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',
--sistem12='D', flagdh12 = 'D', flglei12='N', fecven12='', b.nropag56
--into #tmp010012
--from ddpagcom57 a (nolock),
--
--ddpagos56 b (nolock),
--ddcabcom52 c (nolock),
--dqctadep50 d (nolock),
--dqtippag48 e (nolock),
--dqclient02 f (nolock),
--
--dqconcom51 g (nolock)
--
--where (b.nropag56=a.nropag56)
--and (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)
--
--and (a.numcom52=c.numcom52)
--and (b.codtip48=e.codtip48)
--and (c.codcli02*=f.codcli02)
--and (b.codtip48 in ('07','04') and a.numcom52 not in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 not in ('07','04')
--and b.numcom52 in (select b.numcom52
--FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 in ('07','04'))
--GROUP BY B.NUMCOM52)) 
--and (b.flglei56='N')
--and (b.fecpag56 >= @fec_i
--and b.fecpag56 < @fec_f)
--and (b.tipmon56=g.codcon51)
--and (c.feccom52 >= @fec_s)
--group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, b.nrodoc56,
--
--c.docdes52, b.tipcam56, g.codcue01, b.nropag56
--
--if @@error <> 0 GOTO E_Select_Error
--
--/****** para la cuenta 12 de la 46 ******/
--
--
--select codsbd03=g.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56, 
--codcue01= g.codcue01, serdoc12= substring(c.numcom52,1,3), numdoc12=substring(c.numcom52,4,7),
--
--codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01', 
--impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),(a.monpag57/b.tipcam56)*c.tipcam52)) else convert(decimal(15,2),sum(a.monpag57*c.tipcam52)) end,
--impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,
--ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,2),c.tipcam52) else 0.00 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',
--sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='', b.nropag56, b.codcta50
--into #tmp010013
--from ddpagcom57 a (nolock),
--
--ddpagos56 b (nolock),
--ddcabcom52 c (nolock),
--dqctadep50 d (nolock),
--dqtippag48 e (nolock),
--dqclient02 f (nolock),
--dqconcom51 g (nolock)
--
--where (b.nropag56=a.nropag56)
--and (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)
--
--and (a.numcom52=c.numcom52)
--
--and (a.codcom50=e.codtip48)
--and (b.codtip48 in ('07','04') and a.numcom52 not in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 not in ('07','04')
--
--and b.numcom52 in (select b.numcom52
--FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 in ('07','04'))
--GROUP BY B.NUMCOM52)) 
--and (c.codcli02*=f.codcli02)
--
--and (b.flglei56='N')
--and (b.fecpag56 >= @fec_i
--and b.fecpag56 < @fec_f)
--and (b.tipmon56=g.codcon51)
--and (c.feccom52 >= @fec_s)
--group by g.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,
--
--c.docdes52, c.tipcam52, g.codcue01, b.nropag56, b.codcta50
--
--if @@error <> 0 GOTO E_Select_Error
--
--
--/****** para la cuenta 12 sin la 46 ******/
--
--
--select codsbd03=g.codsbd03, coddoc07=e.coddoc07, codmon30=b.tipmon56, fecmov12=b.fecpag56, 
--codcue01= g.codcue01, serdoc12= substring(c.numcom52,1,3), numdoc12=substring(c.numcom52,4,7),
--
--codcco06= '', codcco07='', desmov12=f.nomcli02, nrocan04=c.docdes52, codana02='01', 
--impmna12= case when b.tipmon56 = 'S' then sum(convert(decimal(15,2),(a.monpag57/b.tipcam56)*c.tipcam52)) else convert(decimal(15,2),sum(a.monpag57*c.tipcam52)) end,
--impmex12= case when b.tipmon56 = 'D' then sum(convert(decimal(15,2),a.monpag57)) else 0.00 end,
--ticadi12= case when b.tipmon56 = 'D' then convert(decimal(15,2),c.tipcam52) else 0.00 end, descan04=case when f.nomcli02=null then '' else f.nomcli02 end, tipaut12 = '',
--sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='', b.nropag56, b.codcta50
--into #tmp010014
--from ddpagcom57 a (nolock),
--
--ddpagos56 b (nolock),
--ddcabcom52 c (nolock),
--dqctadep50 d (nolock),
--dqcompag50 e (nolock),
--
--dqclient02 f (nolock),
--dqconcom51 g (nolock)
--
--where (b.nropag56=a.nropag56)
--and (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)
--
--and (a.numcom52=c.numcom52)
--and (c.codcom50=e.codcom50)
--and (b.codtip48 not in ('07','04') or a.numcom52 in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 not in ('07','04')
--and b.numcom52 in (select b.numcom52
--FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 in ('07','04'))
--GROUP BY B.NUMCOM52)) 
--and (c.codcli02*=f.codcli02)
--
--and (b.flglei56='N')
--and (b.fecpag56 >= @fec_i
--and b.fecpag56 < @fec_f)
--and (b.tipmon56=g.codcon51)
--and (c.feccom52 >= @fec_s)
--group by g.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,
--
--c.docdes52, c.tipcam52, g.codcue01, b.nropag56, b.codcta50
--
--if @@error <> 0 GOTO E_Select_Error
--
--
--/***** Para la Diferencia de Cambio de la 46 ***********/
--
--select codsbd03=d.codsbd03, coddoc07='', codmon30='S', fecmov12=getdate(), 
--codcue01= '', serdoc12= '', numdoc12='',
--
--codcco06= '', codcco07='', desmov12='', nrocan04='', codana02='', 
--impmna12= case when b.tipmon56='S' then sum(convert(decimal(15,2),a.monpag57) - convert(decimal(15,2),(a.monpag57/b.tipcam56)*c.tipcam52))
--else sum(convert(decimal(15,2),a.monpag57*b.tipcam56) - convert(decimal(15,2),a.monpag57*c.tipcam52)) end,
--
--impmex12= 0.00, ticadi12= 0.00, descan04='', tipaut12 = '',
--sistem12='D', flagdh12 = case when (sum(convert(decimal(15,2),a.monpag57*b.tipcam56))-sum(convert(decimal(15,2),a.monpag57*c.tipcam52))) > 0 then 'H' else 'D' end, 
--flglei12='N', fecven12=getdate(), b.nropag56, b.codcta50, 
--concepto=case when (sum(convert(decimal(15,2),a.monpag57*b.tipcam56))-sum(convert(decimal(15,2),a.monpag57*c.tipcam52))) > 0 then 'GANDC' else 'PERDC' end 
--into #tmp010015
--from ddpagcom57 a (nolock),
--
--ddpagos56 b (nolock),
--ddcabcom52 c (nolock),
--dqctadep50 d (nolock),
--dqtippag48 e (nolock),
--dqclient02 f (nolock),
--dqconcom51 g (nolock)
--
--where (b.nropag56=a.nropag56)
--and (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)
--
--and (a.numcom52=c.numcom52)
--
--and (a.codcom50=e.codtip48)
--and (b.codtip48 in ('07','04') and a.numcom52 not in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 not in ('07','04')
--
--and b.numcom52 in (select b.numcom52
--FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 in ('07','04'))
--GROUP BY B.NUMCOM52)) 
--/*and (b.tipmon56='D')*/
--and (b.flglei56='N')
--and (c.codcli02*=f.codcli02)
--and (b.fecpag56 >= @fec_i
--and b.fecpag56 < @fec_f)
--and (b.tipmon56=g.codcon51)
--and (c.feccom52 >= @fec_s)
--group by d.codsbd03, e.coddoc07, b.tipmon56, b.fecpag56, d.codcue01, f.nomcli02, c.numcom52,
--
--c.docdes52, c.tipcam52, g.codcue01, b.nropag56, b.codcta50, b.tipcam56
--
--
--
--/***** Para la Diferencia de Cambio sin la 46 ***********/
--
--select codsbd03=d.codsbd03, coddoc07='', codmon30='S', fecmov12=getdate(), 
--codcue01= '', serdoc12= '', numdoc12='',
--
--codcco06= '', codcco07='', desmov12='', nrocan04='', codana02='', 
--impmna12= case when b.tipmon56='S' then sum(convert(decimal(15,2),a.monpag57) - convert(decimal(15,2),(a.monpag57/b.tipcam56)*c.tipcam52))
--else sum(convert(decimal(15,2),a.monpag57*b.tipcam56) - convert(decimal(15,2),a.monpag57*c.tipcam52)) end,
--impmex12= 0.00, ticadi12= 0.00, descan04='', tipaut12 = '',
--sistem12='D', flagdh12 = case when (sum(convert(decimal(15,2),a.monpag57*b.tipcam56))-sum(convert(decimal(15,2),a.monpag57*c.tipcam52))) > 0 then 'H' else 'D' end, 
--flglei12='N', fecven12=getdate(), b.nropag56, b.codcta50, 
--concepto=case when (sum(convert(decimal(15,2),a.monpag57*b.tipcam56))-sum(convert(decimal(15,2),a.monpag57*c.tipcam52))) > 0 then 'GANDC' else 'PERDC' end 
--
--into #tmp010016
--from ddpagcom57 a (nolock),
--
--ddpagos56 b (nolock),
--
--ddcabcom52 c (nolock),
--dqctadep50 d (nolock),
--dqcompag50 e (nolock),
--dqclient02 f (nolock),
--dqconcom51 g (nolock)
--
--where (b.nropag56=a.nropag56)
--and (b.codcta50=d.codcta50 and b.tipmon56=d.moncta50)
--
--and (a.numcom52=c.numcom52)
--
--and (a.codcom50=e.codcom50)
--and (b.codtip48 not in ('07','04') or a.numcom52 in (select b.numcom52 FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 not in ('07','04')
--
--and b.numcom52 in (select b.numcom52
--FROM DDPAGOS56 A, DDPAGCOM57 B 
--WHERE A.NROPAG56=B.NROPAG56 AND B.FECPAG56 >= @fec_i AND B.FECPAG56 < @fec_f
--and a.codtip48 in ('07','04'))
--GROUP BY B.NUMCOM52)) 
--/*and (b.tipmon56='D')*/
--and (b.flglei56='N')
--and (c.codcli02*=f.codcli02)
--
--and (b.fecpag56 >= @fec_i
--and b.fecpag56 < @fec_f)
--and (b.tipmon56=g.codcon51)
--and (c.feccom52 >= @fec_s)
--group by d.codsbd03, b.fecpag56, f.nomcli02, b.nropag56, b.codcta50, b.tipmon56
--
--
--
--begin transaction
--
--
--/* INSERTO LA 10 */
--INSERT INTO CDMOVIMI15
--(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--
--select codsbd03=b.codsbd03, a.coddoc07, a.codmon30, fecmov12= getdate(), a.codcue01, a.serdoc12, a.numdoc12, codcco06='', codcco07='', desmov12='', nrocan04='', codana02='', impmna12=sum(a.impmna12), impmex12=sum(a.impmex12), ticadi12=0.00, descan04='', tipaut12='', a.sistem12, a.flagdh12, a.flglei12, fecven12='' 
--from #tmp010011 a, dqctadep50 b
--where (a.codcta50=b.codcta50 and a.codmon30=b.moncta50)
--group by b.codsbd03, codmon30, a.codcue01, sistem12, flagdh12, flglei12, a.coddoc07, a.serdoc12, a.numdoc12
--if @@error <> 0 GOTO E_General_Error
--
--
--
--/* INSERTO LA 46 */
--
--INSERT INTO CDMOVIMI15
--(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12) 
--select codsbd03=b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12, a.numdoc12, codcco06='', codcco07='', a.desmov12, a.nrocan04, a.codana02, a.impmna12, a.impmex12, ticadi12=0.00, a.descan04, tipaut12='', a.sistem12, a.flagdh12, a.flglei12, fecven12='' 
--from #tmp010012 a, dqconcom51 b
--where b.codcon51='CANJE'
--
--
--/* INSERTO LA 12 DE LA 46 */
--INSERT INTO CDMOVIMI15
--(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)
--
--select codsbd03=b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.codcue01, a.serdoc12, a.numdoc12, a.codcco06, a.codcco07, a.desmov12, a.nrocan04, a.codana02, a.impmna12, a.impmex12, a.ticadi12, a.descan04, a.tipaut12, a.sistem12, a.flagdh12, a.flglei12, a.fecven12
--
--from #tmp010013 a, dqconcom51 b
--where b.codcon51='CANJE'
--if @@error <> 0 GOTO E_General_Error
--
--
--
--/* INSERTO LA 12 SIN LA 46 */
--INSERT INTO CDMOVIMI15
--
--(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)
--
--select codsbd03=b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.codcue01, a.serdoc12, a.numdoc12, a.codcco06, a.codcco07, a.desmov12, a.nrocan04, a.codana02, a.impmna12, a.impmex12, a.ticadi12, a.descan04, a.tipaut12, a.sistem12, a.flagdh12, a.flglei12, a.fecven12
--
--from #tmp010014 a, dqctadep50 b
--where (a.codcta50=b.codcta50 and a.codmon30=b.moncta50)
--if @@error <> 0 GOTO E_General_Error
--
--/* INSERTO LA DIFERENCIA DE CAMBIO DE LA 46*/
--INSERT INTO CDMOVIMI15
--
--
--(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)
--
--select codsbd03=b.codsbd03, coddoc07='', a.codmon30, a.fecmov12, codcue01=c.codcue01, serdoc12='', numdoc12='', codcco06='', codcco07='', desmov12='DIFERENCIA DE CAMBIO', nrocan04='', codana02='', sum(a.impmna12), a.impmex12, a.ticadi12, descan04='', tipaut12='', a.sistem12, a.flagdh12, a.flglei12, a.fecven12
--
--from #tmp010015 a, dqconcom51 b, dqconcom51 c
--where b.codcon51='CANJE' and c.codcon51=a.concepto
--group by b.codsbd03, a.codmon30, a.fecmov12, c.codcue01, a.impmex12, a.ticadi12, a.sistem12, a.flagdh12, a.flglei12, a.fecven12
--/*where b.codcon51=a.concepto*/
--
--if @@error <> 0 GOTO E_General_Error
--
--/* INSERTO LA DIFERENCIA DE CAMBIO SIN LA 46*/
--INSERT INTO CDMOVIMI15
--
--(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12, numdoc12, codcco06, codcco07, desmov12, nrocan04, codana02, impmna12, impmex12, ticadi12, descan04, tipaut12, sistem12, flagdh12, flglei12, fecven12)
--
--select a.codsbd03, coddoc07='', a.codmon30, a.fecmov12, codcue01=b.codcue01, serdoc12='', numdoc12='', codcco06='', codcco07='', desmov12='DIFERENCIA DE CAMBIO', nrocan04='', codana02='', sum(a.impmna12), a.impmex12, a.ticadi12, descan04='', tipaut12='', a.sistem12, a.flagdh12, a.flglei12, a.fecven12
--
--from #tmp010016 a, dqconcom51 b
--where b.codcon51=a.concepto
--group by a.codsbd03, a.codmon30, a.fecmov12, b.codcue01, a.impmex12, a.ticadi12, a.sistem12, a.flagdh12, a.flglei12, a.fecven12
--if @@error <> 0 GOTO E_General_Error
--
--update ddpagos56 set flglei56='S' where nropag56 in (select nropag56 from #tmp010013) 
--
--if @@error <> 0 GOTO E_General_Error
--
--update ddpagos56 set flglei56='S' where nropag56 in (select nropag56 from #tmp010014) 
--if @@error <> 0 GOTO E_General_Error
--
--commit transaction
--
--return 0
--
--E_General_Error:
--
--raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror
--rollback transaction
--
--return 2
--
--E_Select_Error:
--raiserror('No se pudo crear la tabla temporal',1,2) with seterror
--
--
--return 2
--GO
/****** Object:  StoredProcedure [dbo].[SP_CARGA_IMAGEN]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CARGA_SUELTA_X_SOL_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_CARGA_SUELTA_X_SOL_ADU    Script Date: 08-09-2002 08:44:09 PM ******/
ALTER PROCEDURE [dbo].[SP_CARGA_SUELTA_X_SOL_ADU]
@NUMSOL CHAR(6)
AS

SELECT
a.numsol10,a.fecsol10,a.numdui10,a.desmer10,
b.claseabc,b.contribuy,b.nombre,
c.numtkt01,c.fecing01,c.fecsal01,c.pesbru01,c.pestar01,c.pesnet01,c.numbul01,c.codemb06,c.numpla01
From 
DDTICKET01 c,DDSOLADU10 a,AAClientesAA b
WHERE
a.numsol10='A'+@NUMSOL and a.numsol10=c.docaut01 and c.tipope01='D' and 
a.tipcli02=b.claseabc and a.codcli02=b.contribuy
GO
/****** Object:  StoredProcedure [dbo].[SP_CARGA_SUELTA_X_SOL_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CER_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CER_DEP_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_CER_DEP_SIM    Script Date: 08-09-2002 08:44:12 PM ******/
--ALTER PROCEDURE [dbo].[SP_CER_DEP_SIM]  -- FMCR
--@NUMCER VARCHAR(8)
--AS
--
--Select 
--a.*,numsol10=a.numsol62, c.fecsol62,NombreC=b.nombre, c.bultot62,NombreA=d.nombre,c.cobalm62
--From 
--DDCerSim74 a, AAClientesAA b, DDSolSim62 c, AAClientesAA d
--Where 
--a.codcli02=b.contribuy and 
--a.codage19*=d.cliente and d.cliente<>'' and a.numsol62=c.numsol62 and a.numcer74=@NUMCER
--GO
/****** Object:  StoredProcedure [dbo].[SP_COMPCANEL]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_COMPENPAG]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_COMPENPAGTOD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_FACTURA]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_CONSULTA_FACTURA    Script Date: 08-09-2002 08:44:09 PM ******/
--ALTER PROCEDURE [dbo].[SP_CONSULTA_FACTURA]   -- FMCR
--@TIPCOM CHAR(2),
--@NUMCOM CHAR(10)
--AS
--
--
--Select 
--a.*,b.nombre 
--From 
--DDCabCom52 a,AAClientesAA b 
--Where 
--a.tipcli02*=b.claseabc and a.codcli02*=b.contribuy and 
--a.codcom50=@TIPCOM and a.numcom52=@NUMCOM
--GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_FACTURA_DETALLE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETADU_WEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETADU_WEB_SAA]    Script Date: 10/03/2019 02:40:09 PM ******/
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





GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETIRO_ADUANA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETIRO_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETSIM_WEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDEN_RETSIM_WEB_SAA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ORDRET_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_CONSULTA_ORDRET_ADU    Script Date: 08-09-2002 08:44:13 PM ******/
ALTER PROCEDURE [dbo].[SP_CONSULTA_ORDRET_ADU]
@ORDRET CHAR(7)
AS

Select 
a.*,b.numdui11,b.fecdui16,b.tipcli02,b.codcli02,b.codage19,NombreA=d.nombre,e.nomrep77,
b.numbul16,b.pesbru16,b.valfob16,b.valfle16,b.valcif16,b.valseg16,NombreC=f.nombre,l.codubi71,DEPOSITANTE=h.codcli02
From 
DRRetAdu18 a,DDDuiDes16 b,AAClientesAA d,DQMaeRep77 e,AAClientesAA f,DDDuiDep11 g,DDSolAdu10 h, 
DDRecMer69 l
Where 
a.numret18=@ORDRET and 
a.numdui16=b.numdui16 and b.codage19=d.cliente and a.codrep77=e.codrep11 and
b.tipcli02=f.claseabc and b.codcli02=f.contribuy and 
b.numdui11 = g.numdui11 and g.numsol10 = h.numsol10 and 
h.numsol10 = l.numsol62 and l.flgval69 = '1'
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_SOLICITUD]    Script Date: 10/03/2019 02:40:09 PM ******/
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
AAClientesAA e,terminal.dbo.DQPAISES07 f,terminal.dbo.DQPUERTO02 g,    
terminal.dbo.DQNAVIER08 h,DDAlmExp99 i,DQAlmDep99 j    
Where     
a.numsol10=@NUMSOL and     
a.tipcli02=b.claseabc and a.codcli02=b.contribuy and     
a.codage19=c.cliente and a.codemb06=d.codemb06 and a.CodEmp04=e.contribuy and    
a.codpai07=f.codpai07 and a.codpue03=g.codpue02 and a.codnav08=h.codnav08 and     
a.numsol10=i.numsol99 and i.codalm99=j.codalm99    
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_DETALLE_OR_S]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_DOCUMENTOS_AUTORIZADOS]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_CONSULTAR_DOCUMENTOS_AUTORIZADOS]
@FECINI char(8),
@FECFIN char(8),
@CONTRYBUY varchar(11)
AS

DECLARE @TITULO as varchar(255)
DECLARE @SUBTITULO as varchar(255)

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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_DUADES]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_CONSULTAR_DUADES    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_CONSULTAR_DUADES]
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ENTREGA_ADUANERA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ENTREGA_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_CONSULTAR_ENTREGA_SIMPLE    Script Date: 08-09-2002 08:44:09 PM ******/
--ALTER PROCEDURE [dbo].[SP_CONSULTAR_ENTREGA_SIMPLE]  -- FMCR
--@NUMENT CHAR(7)
--AS
--
--Select 
--a.fecent79,a.numret75,b.fecret75,c.numsol62,c.obscer74,b.codage19,NombreA=f.nombre,
--c.tipcli02,c.codcli02,NombreC=d.nombre,a.tipdoc55,a.codrep77,e.nomrep77,a.codemb06,
--a.numpla79,a.flgval79,a.flgemi79,a.obsent79,a.pesbal79
--From 
--DDEntMer79 a,DDRetSim75 b,DDCerSim74 c,AAClientesAA d,DQMaeRep77 e,
--AAClientesAA f 
--Where 
--a.nument79=@NUMENT and 
--a.numret75=b.numret75 and b.numcer74=c.numcer74 and 
--c.tipcli02=d.claseabc and c.codcli02=d.contribuy and 
--b.codage19*=f.cliente and f.cliente<>'' and a.codrep77=e.codrep11
--GO
/****** Object:  StoredProcedure [dbo].[sp_Consultar_FechasContabiliza]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Consultar_FechasContabiliza]    
as    
set nocount on;
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_OR_SERVICIO_X_ORRETIRO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ORDSER_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ORDSER_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[SP_CONSULTAR_ORDSER_SIM] -- FMCR
--@NUMORD CHAR(6)
--AS
--
--Select 
--a.*, c.contribuy,NombreC=c.nombre, d.cliente,NombreA=d.nombre,ORDOT1 = isnull(a.ORDOT,0)
--From 
--DDOrdSer58 a,AAClientesAA c,AAClientesAA d
--Where 
--a.numord58=@NUMORD and
--a.tipcli02=c.claseabc and a.codcli02=c.contribuy
--and a.codage19*=d.cliente and d.cliente<>''
--GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_SALDO_POR_RETIRAR_S]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONTENEDOR]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONTENEDORES_X_SOL_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_CONTENEDORES_X_SOL_ADU    Script Date: 08-09-2002 08:44:09 PM ******/  
ALTER PROCEDURE [dbo].[SP_CONTENEDORES_X_SOL_ADU]  @NUMSOL CHAR(6)  AS    
Select  a.numsol10,a.fecsol10,a.numdui10,b.numctr65,b.tamctr65,b.numtkt01,c.
claseabc,c.contribuy,  c.nombre,d.numpla01,d.pesbru01,d.pestar01,d.pesnet01,d.tarcon01,d.fecing01,d.fecsal01  
From   DDSOLADU10 a,DDCTRDEP65 b,terminal.dbo.AACLIENTESAA c,DDTICKET01 d  
Where  a.numsol10=b.numsol62 and b.numsol62='A'+@NUMSOL 
and  a.tipcli02=c.claseabc and a.codcli02=c.contribuy and   b.numtkt01=d.numtkt01 and a.flgval10='1'  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_CONTENEDORES_X_SOL_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONTROL_LIMPIA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CONTROL_SALIDA2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_crear_Orden_Retiro_Simple]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CUADRAR_ENTREGA_MERCADERIA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_Deposito_Manifiesto_Elimina_Bl]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_Deposito_Manifiesto_Genera_Bl]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_Deposito_Manifiesto_Modifica_Bl]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_Depot_Balanza_Genera_Tkt_Manual]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DETALLE_CERTIFICADO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DETALLE_ORDEN_RETIRO_EN_ENTREGA_MERCADERIA]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_DETALLE_ORDEN_RETIRO_EN_ENTREGA_MERCADERIA]   
@DUIDES varchar(14)  
  
AS  
  
  
Select   
a.numdui11,a.numcer13,a.numser12,a.numser17,a.numbul17,SldOrd17=a.numbul17-  
 (Select coalesce(sum(d.numbul80),0) From ddentmer79 c Inner Join DDDEnMer80 d on c.nument79=d.nument79   
 where c.NumDui16=@DUIDES and c.flgval79=1 and d.numser70=a.numser12),  
a.codemb06,a.desmer17,a.cifuni17,sldcif17=a.valcif17-  
 (Select coalesce(sum(preent80),0) From ddentmer79 c Inner Join DDDEnMer80 d on c.nument79=d.nument79   
 where c.NumDui16=@DUIDES and c.flgval79=1 and d.numser70=a.numser12),  
a.unidad12,a.tipuni12,   
SldAlm14=b.numbul14-  
 (Select coalesce(sum(d.numbul80),0) From ddentmer79 c Inner Join DDDEnMer80 d on c.nument79=d.nument79   
 where c.NumDui16=@DUIDES and c.flgval79=1 and d.numser70=a.numser12),  
b.bulblo14  
From DDSerDes17 a  
Inner Join DDDCeAdu14 b on a.numdui11=b.numdui11 and a.numser12=b.numser12  
Where 
a.valcif17-  
(Select coalesce(sum(preent80),0) From ddentmer79 c Inner Join DDDEnMer80 d on c.nument79=d.nument79 where c.NumDui16=@DUIDES and c.flgval79=1 and d.numser70=a.numser12)>0 and   
a.NumDui16=@DUIDES  
Order by numser17
GO
/****** Object:  StoredProcedure [dbo].[SP_DEUDA_PENDIENTE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DIRECCION_ZONA_WEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DISTRITOS_ZONA_WEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DOCUMENTOS_AUTORIZADOS]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DUADES_ORDRET_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_DUADES_ORDRET_ADU    Script Date: 08-09-2002 08:44:14 PM ******/
ALTER PROCEDURE [dbo].[SP_DUADES_ORDRET_ADU]
@DUIDES CHAR(14)
AS

Select 
a.*,NombreA=c.nombre,NombreC=b.nombre,e.codubi71
From 
DDDuiDes16 a,AAClientesAA b,AAClientesAA c,DDceradu13 d,DDrecmer69 e 
Where a.NumDui16=@DUIDES and 
a.codage19=c.cliente and a.tipcli02=b.claseabc and 
a.codcli02=b.contribuy and 
a.numcer13=d.numcer13 and d.flgval13='1' and 
d.numsol10=e.numsol62 and e.flgval69='1'
GO
/****** Object:  StoredProcedure [dbo].[SP_DUIDEP_DUIDEP]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_DUIDEP_DUIDEP    Script Date: 08-09-2002 08:44:12 PM ******/
ALTER PROCEDURE [dbo].[SP_DUIDEP_DUIDEP]
@NUMDEP CHAR(13)
AS

Select a.*,b.*,c.*,NombreC=c.nombre,d.*,NombreA=d.nombre
From DDDuiDep11 a,DDSolAdu10 b,AAClientesAA c,AAClientesAA d
Where a.numsol10=b.numsol10 and
b.tipcli02=c.claseabc and b.codcli02=c.contribuy and
b.codage19=d.cliente and a.NumDui11=@NUMDEP
GO
/****** Object:  StoredProcedure [dbo].[SP_EliminaCarrito]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_ADUANA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
                       @TO                 = N'juan.noel@gruponeptunia.com;johnston.paredes@gruponeptunia.com;alfredo.viayrada@gruponeptunia.com;augusto.erazo@gruponeptunia.com;adeposito@gruponeptunia.com',
                       @replyto            = N'rtello@neptunia.com.pe;waniya@neptunia.com.pe',
                       @CC                 = N'waniya@neptunia.com.pe;liz.herrera@gruponeptunia.com;vadim.suarez@gruponeptunia.com;lita.souza-ferreira@gruponeptunia.com',
                       @BCC                = N'rtello@neptunia.com.pe',
                       @priority           = N'NORMAL',
                       @subject            = @titulo,
                       @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,
                       @messagefile        = N'',
                       @type               = N'text/Html',
                       @attachment         = N'',
                       @attachments        = N'',
                       @codepage           = 0,
                       @server             = N'CALW3MEM001.neptunia.com.pe'--N'mail.mydomain.com'


END
GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_ADUANA_NO_TRA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
              @TO                 = N'juan.noel@gruponeptunia.com;johnston.paredes@gruponeptunia.com;alfredo.viayrada@gruponeptunia.com;augusto.erazo@gruponeptunia.com;adeposito@gruponeptunia.com',
               @replyto            = N'rtello@neptunia.com.pe;waniya@neptunia.com.pe;',
               @CC                 = N'liz.herrera@gruponeptunia.com;waniya@neptunia.com.pe;vadim.suarez@gruponeptunia.com;lita.souza-ferreira@gruponeptunia.com;miguel.benites@gruponeptunia.com',
               @BCC                = N'rtello@neptunia.com.pe',
               @priority           = N'NORMAL',
               @subject            = @Titulo,
               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,
               @messagefile        = N'',
               @type               = N'text/Html',
               @attachment         = N'',
               @attachments        = N'',
               @codepage           = 0,
               @server             = N'CALW3MEM001.neptunia.com.pe'--N'mail.mydomain.com'


END






GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
                                                               @replyto            = N'rtello@neptunia.com.pe',--@correoCliente,--'rtello@neptunia.com.pe;waniya@neptunia.com.pe',
                                                               @CC                 = N'Liz.herrera@gruponeptunia.com;waniya@neptunia.com.pe;vadim.suarez@gruponeptunia.com;lita.souza-ferreira@gruponeptunia.com;rtello@neptunia.com.pe',
                                                               @BCC                = N'',
                                                               @priority           = N'NORMAL',
                                                               @subject            = @titulo,
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,
                                                               @messagefile        = N'',
                                                               @type               = N'text/Html',
                                                               @attachment         = N'',
                                                               @attachments        = N'',
                                                               @codepage           = 0,
                                                               @server             = N'CALW3MEM001.neptunia.com.pe'--N'mail.mydomain.com'


END





GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE_CONDEUDA]    Script Date: 10/03/2019 02:40:09 PM ******/
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

        set @message = 'Estimado Usuario. <br> Cliente ' + @ruc + ' '+ @razon + ' tiene una orden de Retiro creada por el sistema Servicio Logístico Web <br><br>' + convert(varchar,@NUMORD) +'<br><table width=80% border=1><tr bgcolor=#DBE3EA><td>PRODUCTO</td><td>TIPO</td><td>CERTIFICADO</td><td>SERIE</td><td>DESPACHAR</td> </tr>' + @correo + '</table><br><br>' + @MESSDEUDA
	
	    set @titulo = 'ORDEN RETIRO ' + convert(varchar,@NUMORD)

                                               exec @rc = master.dbo.xp_smtp_sendmail
                                                               @FROM              = N'DepositoAduaneroSimple@neptunia.com.pe', --N'MyEmail@MyDomain.com',
                                                               @FROM_NAME         = N'DepositoAduaneroSimple', --N'Joe Mailman',
                                                               @TO                = N'nadienka.franco@gruponeptunia.com;miguel.benites@gruponeptunia.com;',
                                                               @replyto            = N'',
                                                               @CC                 = N'Liz.herrera@gruponeptunia.com;wendy.aniya@gruponeptunia.com;lita.souza@gruponeptunia.com;vadim.suarez@gruponeptunia.com',
                                                               @BCC                = N'renzo.tello@gruponeptunia.com',
                                                               @priority           = N'NORMAL',
                                                               @subject            = @titulo ,
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,
                                                               @messagefile        = N'',
                                                               @type               = N'text/Html',
                                                               @attachment         = N'',
                                                               @attachments        = N'',
                                                               @codepage           = 0,
                                                               @server             = N'CALW3MEM001.neptunia.com.pe'--N'mail.mydomain.com'


END










GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE_DESPACHAR]    Script Date: 10/03/2019 02:40:09 PM ******/
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
                                                               @CC                 = N'Liz.herrera@gruponeptunia.com;wendy.aniya@gruponeptunia.com;vadim.suarez@gruponeptunia.com;lita.souza-ferreira@gruponeptunia.com;',
                                                               @BCC                = N'renzo.tello@gruponeptunia.com',
                                                               @priority           = N'NORMAL',
                                                               @subject            = @titulo,
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,
                                                               @messagefile        = N'',
                                                               @type               = N'text/Html',
                                                               @attachment         = N'',
                                                               @attachments        = N'',
                                                               @codepage           = 0,
                                                               @server             = N'CALW3MEM001.neptunia.com.pe'--N'mail.mydomain.com'


END













GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE_DUA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
                                                               @replyto            = N'rtello@neptunia.com.pe',
                                                               @CC                 = N'Liz.herrera@gruponeptunia.com;waniya@neptunia.com.pe;vadim.suarez@gruponeptunia.com;lita.souza-ferreira@gruponeptunia.com',
                                                               @BCC                = N'',
                                                               @priority           = N'NORMAL',
                                                               @subject            = @titulo,
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,
                                                               @messagefile        = N'',
                                                               @type               = N'text/Html',
                                                               @attachment         = N'',
                                                               @attachments        = N'',
                                                               @codepage           = 0,
                                                               @server             = N'CALW3MEM001.neptunia.com.pe'--N'mail.mydomain.com'


END














GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_CLIENTE_PRUEBA]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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
                                                               @replyto            = N'Al.Porras@gruponeptunia.com',--@correoCliente,--'rtello@neptunia.com.pe;waniya@neptunia.com.pe',
                                                               @CC                 = N'Al.Porras@gruponeptunia.com',
                                                               @BCC                = N'',
                                                               @priority           = N'NORMAL',
                                                               @subject            = @titulo,
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,
                                                               @messagefile        = N'',
                                                               @type               = N'text/Html',
                                                               @attachment         = N'',
                                                               @attachments        = N'',
                                                               @codepage           = 0,
                                                               @server             = N'CALW3MEM001.neptunia.com.pe'--N'mail.mydomain.com'


END





GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_CORREO_OPERACIONES]    Script Date: 10/03/2019 02:40:09 PM ******/
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
                                                               @TO                 = N'miguel.benites@gruponeptunia.com;nadienka.franco@gruponeptunia.com',--@mailclie, --N'MyFriend@HisDomain.com',
                                                               @replyto            = N'rtello@neptunia.com.pe;',
                                                               @CC                 = N'liz.herrera@gruponeptunia.com;wendy.aniya@gruponeptunia.com;lita.souza-ferreira@gruponeptunia.com;vadim.suarez@gruponeptunia.com',
                                                               @BCC                = N'rtello@neptunia.com.pe',
                                                               @priority           = N'NORMAL',
                                                               @subject            = @titulo,
                                                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,
                                                               @messagefile        = N'',
                                                               @type               = N'text/Html',
                                                               @attachment         = N'',
                                                               @attachments        = @ruta,
                                                               @codepage           = 0,
                                                               @server             = N'CALW3MEM001.neptunia.com.pe'--N'mail.mydomain.com'


END





GO
/****** Object:  StoredProcedure [dbo].[SP_ENVIAR_DISTRIBUCCION]    Script Date: 10/03/2019 02:40:09 PM ******/
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
                               @TO                 = N'fernando.fernandez@gruponeptunia.com',--@mailclie, --N'MyFriend@HisDomain.com',
                               @replyto            = N'rtello@neptunia.com.pe',
                               @CC                 = N'liz.herrera@gruponeptunia.com;waniya@gruponeptunia.com;vadim.suarez@gruponeptunia.com;lita.souza-ferreira@gruponeptunia.com;rtello@neptunia.com.pe',
                               @BCC                = N'rtello@neptunia.com.pe',
                               @priority           = N'NORMAL',
                               @subject            = @titulo,
                               @message            = @message,--'Se genero la Orden de Servicio ', --+ @nroOrden,
                               @messagefile        = N'',
                               @type               = N'text/Html',
                               @attachment         = N'',
                               @attachments        = N'',
                               @codepage           = 0,
                               @server             = N'CALW3MEM001.neptunia.com.pe'--N'mail.mydomain.com'


END









GO
/****** Object:  StoredProcedure [dbo].[SP_ESTCOMEMI]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ExisteRango]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_FacPa_AgregarMaquinaria]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_FacPa_ListaMaquinas]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_FacPa_ListaTipoMaquinas]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_FacPa_ModificarMaquinaria]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_FRMDUIDES_SERIES_DUADEP]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[SP_FRMDUIDES_SERIES_DUADEP]
@NUMCER varchar(9)
AS

Select a.numser12,bulsld=a.numbul14-a.buldes14,b.codemb06,pessld=a.pesbru14-a.pesdes14,fobsld=a.valfob14-a.fobdes14,a.desmer14,b.parara12,
flesld=a.valfle14-a.fledes14,segsld=a.valseg14-a.segdes14,a.unidad12,a.tipuni12 
From DDDCeAdu14 a
Inner Join DDSerDep12 b on a.numdui11=b.numdui11 And a.NumSer12=b.NumSer12
Where 
(a.numbul14-a.buldes14+a.pesbru14-a.pesdes14+a.valfob14-a.fobdes14+a.valfle14-a.fledes14+a.valseg14-a.segdes14)<>0 and 
a.numcer13 =@NUMCER
Order by a.numser12
GO
/****** Object:  StoredProcedure [dbo].[sp_getfec]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_getfec    Script Date: 08-09-2002 08:44:04 PM ******/
ALTER PROCEDURE [dbo].[sp_getfec]
as
	select fecser=getdate()
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInfo]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_Graba_Carga_Solicitud_Aut]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_Graba_Carga_Tkt_Manual]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_GRABAR_RUTADUADESPACHO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_HABILITAR_AGENTE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_Imprimir_Acta_Apertura_Rep]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_Imprimir_Acta_Inventario_Rep]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_CER_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_CERTIFICADO_ADUANE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE   
[dbo].[SP_IMPRIMIR_CERTIFICADO_ADUANE]    
@NUMCER CHAR(9)  AS      
Select  a.numcer13,a.numdui11,a.pesbru13,a.pescer13,a.fobcer13,a.cifcer13,a.feccer13,a.obscer13,  NombreC=g.nombre,g.direccion,g.claseabc,g.contribuy,  j.despai07,  NombreT=i.nombre,   b.conemb10,b.faccom10,b.fecfac10,  f.priing69,  c.abaleg11,c.fecdui11,
  NombreA=h.nombre,  d.numser12,d.numbul14,d.desmer14,d.numbul14,   
 e.codemb06,e.parara12    
From  DDCerAdu13 a,DDSolAdu10 b,DDDuiDep11 c,DDDCeAdu14 d,DDSerDep12 e,DDRecMer69 f,    
AAClientesAA g,AAClientesAA h,AAClientesAA i,  terminal.dbo.DQPaises07 j    
Where     
a.numcer13=@NUMCER and   a.numcer13=d.numcer13 and a.numdui11=c.numdui11 and a.numsol10=b.numsol10 and     
a.tipcli02=g.claseabc and a.codcli02=g.contribuy and     
b.numsol10=f.numsol62 and b.codage19=h.cliente and b.codemp04=i.contribuy and   b.codpai07=j.codpai07 and     
d.numdui11=e.numdui11 and d.numser12=e.numser12 and    
f.flgval69='1'  
  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_CERTIFICADO_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_CERTIFICADO_SIMPLE    Script Date: 08-09-2002 08:44:07 PM ******/
--ALTER PROCEDURE [dbo].[SP_IMPRIMIR_CERTIFICADO_SIMPLE] -- FMCR
--@NUMCER CHAR(7)
--AS
--
--Select 
--a.*,NombreC=b.nombre,b.direccion,NombreA=c.nombre,d.pesbru85,d.pesnet85,
--e.numser67,e.bulrec67,e.codemb06,e.desmer67,e.preuni67,e.pretot67
--From 
--DDCERSIM74 a,AAClientesAA b,AAClientesAA c,dvpesing85 d,DDDSOSIM67 e
--Where 
--a.numcer74=@NUMCER and 
--a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
--a.codage19*=c.cliente and c.cliente<>'' and
--a.numsol62=d.numsol62 and a.numsol62=e.numsol62
--GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_CTRS_EN_ORDEN_SERVICIO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ENTREGA_ADUANERA]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_ENTREGA_ADUANERA]  
@NUMENT CHAR(7)  
AS  
  
Select   
distinct
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ENTREGA_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_FACTURA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_FACTURA_ESPECIAL]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_FACTURA_ESPECIAL_ANEXO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_FACTURA_ESPECIAL_DET]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ORDEN_DE_SERVICIO]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--ALTER PROCEDURE [dbo].[SP_IMPRIMIR_ORDEN_DE_SERVICIO]  --FMCR
--@NUMORD CHAR(6)
--AS
--
--Declare @Filas integer
--Declare @Cer_Sol varchar(9)
--Declare @Tip_Dep char(1)
--Declare @Num_Sol varchar(7)
--Declare @Num_Cer varchar(9)
--Declare @name varchar(250)
--Declare @Ord_Ser varchar(6)
--Declare @Cadena varchar(1000) 
--
--Select @Ord_Ser=@NUMORD
--Select @Cadena=''
--
--Select @Num_Cer=a.numcer58,@Num_Sol=a.numsol58,@FILAS=count(b.numord58) 
--From ddordser58 a Inner Join DDDOrSer59 b on a.numord58=b.numord58
--Where a.numord58=@Ord_Ser and b.numuni54>0
--Group by a.numcer58,a.numsol58
--
--if @Filas>0
--Begin
--	Select @Cer_Sol=case when numsol58 is null then 'C' else 'S' end From ddordser58 where numord58=@Ord_Ser
--	if @Cer_Sol='C'
--	Begin
--		Select @Tip_Dep=left(numcer58,1) from ddordser58 where numord58=@Ord_Ser
--		if @Tip_Dep='A'
--			Begin
--				Select @Num_Sol=numsol10 from DDceradu13 where numcer13=@Num_Cer
--			End
--		else
--			Begin
--				Select @Num_Sol=numsol62 from DDcersim74 where numcer74=@Num_Cer	
--			End
--	End
--
--	Begin
--		DECLARE CUR_DEP CURSOR FOR
--		select numctr65 from DDCtrDep65 where numsol62=@Num_Sol
--		OPEN CUR_DEP
--		FETCH NEXT FROM CUR_DEP INTO @name
--		WHILE (@@fetch_status <> -1)
--		Begin
--			Select @cadena=@cadena+@name+' / '
--			FETCH NEXT FROM CUR_DEP INTO @name
--		End
--		
--		CLOSE CUR_DEP
--		DEALLOCATE CUR_DEP
--	End
--End
--
----Select Cadena=@cadena
--
--
--Select Cadena=@cadena,
--a.numord58,a.fecord58,a.resser58,a.numcer58,a.tipmon58,a.tipcli02,a.codcli02,a.codage19,a.obsord58,
--a.resser58,
--b.uniser59,b.codcon51,b.obsser59,b.valcob59,b.uniser59,c.desser52,
--NombreC=d.nombre,NombreA=e.nombre,f.numdui11
--From
--DDORDSER58 a,DDDORSER59 b,DDSERVIC52 c,AAClientesAA d,AAClientesAA e,DDCERADU13 f
--Where
--a.numord58=@NUMORD and
--a.numord58=b.numord58 and a.tipcli02=d.claseabc and a.codcli02=d.contribuy and 
--
--a.codage19*=e.cliente and e.cliente<>'' and b.codcon51=c.servic52 and 
--a.numcer58*=f.numcer13 and (substring(a.numcer58,1,1)=c.deposi52 or substring(a.numsol58,1,1)=c.deposi52)
--
--GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_ORDENES_DE_SERVICIO]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_IMPRIMIR_ORDENES_DE_SERVICIO]
AS

Select a.numord58,a.fecord58,a.codage19,b.nombre as nombreAgencia,a.codcli02,c.nombre as nombreCliente
From DDOrdSer58 a
Inner Join AAClientesAA b on b.cliente=a.codage19
Inner Join AAClientesAA c on c.contribuy=a.codcli02 
Where a.codage19<>''
UNION
select a.numord58,a.fecord58,a.codage19,'' as nombreAgencia,a.codcli02,c.nombre as nombreCliente
from DDOrdSer58 a
Inner Join AAClientesAA c on c.contribuy=a.codcli02 
where a.codage19 = ''
Order by a.fecord58 desc, a.numord58 desc
GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_RECEPCION_ADUANERA]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[SP_IMPRIMIR_RECEPCION_ADUANERA]  --FMCR
--@NUMREC CHAR(7)  
--AS  
--  
--Select   
--a.numrec69,a.fecrec69,a.priing69,a.fining69,a.bultot69,a.codemb06,h.desemb06,a.obsrec69,a.guirem69,  
--a.pesnet69,a.codubi71,  
--b.tipcli02,b.codcli02,b.codage19,  
--c.numser70,c.numbul70,c.codemb06,c.desmer70,  
--d.desubi71,  
--NombreC=e.nombre,  
--NombreA=f.nombre,  
--g.numdui11,q.NomDoc55  
--From   
--DDRECMER69 a,DDSOLADU10 b,DDDREMER70 c,DQTIPUBI71 d,AACLIENTESAA e,  
--AACLIENTESAA f,DDDUIDEP11 g,DQTipDoc55 q,DQEMBALA06 h       
--Where   
--a.numrec69=@NUMREC and   
--a.numsol62=b.numsol10 and b.numsol10=g.numsol10 and a.numrec69=c.numrec69 and   
--a.codubi71=d.codubi71 and   
--b.tipcli02=e.claseabc and b.codcli02=e.contribuy and   
--b.codage19*=f.cliente and f.cliente<>'' and b.tipcli02=q.tipdoc55 and
--a.codemb06=h.codemb06
--
--Order by c.numser70
--GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_RECEPCION_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_RECEPCION_SIMPLE    Script Date: 08-09-2002 08:44:14 PM ******/
--ALTER PROCEDURE [dbo].[SP_IMPRIMIR_RECEPCION_SIMPLE] --FMCR
--@NUMREC CHAR(7)
--AS
--
--Select 
--a.numrec69,a.fecrec69,a.priing69,a.fining69,a.bultot69,a.codemb06,a.obsrec69,a.guirem69,
--a.pesnet69,a.codubi71,
--b.tipcli02,b.codcli02,b.codage19,
--c.numser70,c.numbul70,c.codemb06,c.desmer70,
--d.desubi71,
--NombreC=e.nombre,
--NombreA=f.nombre
--From 
--DDRECMER69 a,DDSOLSIM62 b,DDDREMER70 c,DQTIPUBI71 d,AACLIENTESAA e,
--AACLIENTESAA f
--Where 
--a.numrec69=@NUMREC and 
--a.numsol62=b.numsol62 and 
--b.tipcli02=e.claseabc and b.codcli02=e.contribuy and 
--b.codage19*=f.cliente and f.cliente<>'' and a.numrec69=c.numrec69 and 
--a.codubi71=d.codubi71
--Order by c.numser70
--GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_RETIRO_ADUANERO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_RETIRO_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_IMPRIMIR_RETIRO_SIMPLE    Script Date: 08-09-2002 08:44:14 PM ******/
--ALTER PROCEDURE [dbo].[SP_IMPRIMIR_RETIRO_SIMPLE]  --FMCR
--@NUMRET CHAR(7)
--AS
--
--Select distinct 
--a.fecret75,a.numcer74,a.numret75,a.codage19,a.bultot75,
--a.pretot75,a.codrep77,a.obsret75,a.numvig75,
--NombreC=b.nombre,b.claseabc,b.contribuy,
--NombreA=c.nombre,
--d.bultot74,d.numret74,
--e.numser67,e.bultot76,e.bulret76,SALDO=e.bultot76-e.bulret76,e.codemb06,e.desmer67,pretot76,
--f.nomrep77,e.codubi71,d.numsol62
--From 
--DDRETSIM75 a,AACLIENTESAA b,AACLIENTESAA c,DDCERSIM74 d,DVDRESIM86 e,DQMAEREP77 f
--Where 
--a.numret75=@NUMRET and 
--a.numret75=e.numret75 and a.codrep77=f.codrep11 and a.codage19*=c.cliente and c.cliente<>'' and 
--a.numcer74=d.numcer74 and d.tipcli02=b.claseabc and 
--d.codcli02=b.contribuy and d.flgval74='1'
--GO
/****** Object:  StoredProcedure [dbo].[SP_IMPRIMIR_SOLICITUD_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[SP_IMPRIMIR_SOLICITUD_SIMPLE] -- FMCR 
--@NUMSOL CHAR(7)  
--AS  
--BEGIN  
--  
----rdelacuba 29/12/2006: Se incluye la nave  
--Select  
--a.numsol62,a.tipcli02,a.codcli02,a.codage19,a.obssol62,a.bultot62,  
--b.numbul67,b.codemb06,desmer67=b.numser67+' - '+b.desmer67,  
--NombreC=c.nombre,c.direccion,NombreA=d.nombre,f.desnav08  
--From   
--DDSolSim62 a,DDDSoSim67 b,AAClientesAA c,AAClientesAA d,neptunia1.terminal.dbo.DQNAVIER08 f  
--Where   
--a.numsol62=@NUMSOL and   
--a.numsol62=b.numsol62 and a.tipcli02=c.claseabc and   
--a.codcli02=c.contribuy and   
--a.codage19*=d.cliente and d.cliente<>'' and   
--a.codnav08*=f.codnav08  
--order by b.numser67  
--  
--END  
--  
--  
--GO
/****** Object:  StoredProcedure [dbo].[SP_ING_CAM_1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ING_CAM_2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INGRESOS_POR_CERTIFICADO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INGRESOS_POR_CERTIFICADO_S]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERTA_PLACA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_CARRITOCOMPRAS]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_CARRITOCOMPRAS_SAA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_DIRECCION_DISTRITO_ZONAS]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERTAR_ORDRETADUANAWEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_Integracion]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_DESPACHOxCLIENTE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_NACIONALxCLIENTE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_LISTAR_ORDRETADUANAWEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_nologdeposito]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_nologdeposito    Script Date: 08-09-2002 08:44:04 PM ******/
--ALTER PROCEDURE [dbo].[sp_nologdeposito] -- FMCR
--AS
--dump transaction depositos with no_log
--dbcc checktable(syslogs)
--GO
/****** Object:  StoredProcedure [dbo].[SP_NUEVA_ENTREGA_ADUANERA]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_NUEVA_ENTREGA_ADUANERA    Script Date: 08-09-2002 08:44:14 PM ******/  
ALTER PROCEDURE [dbo].[SP_NUEVA_ENTREGA_ADUANERA]  
@NUMORD CHAR(7)  
AS  
  
Select   
a.fecret18,a.numdui16,  
b.tipcli02,b.codcli02,  
NombreC=c.nombre,b.codage19,  
NombreA=d.nombre,a.tipdoc55,a.codrep77,e.nomrep77,b.valcif16,  
--b.cifent16,  
cifent16=(Select coalesce(sum(pretot79+cuadep79),0) from ddentmer79 where numdui16=a.numdui16 and flgval79='1'),  
a.flgval18,a.flgemi18,f.obscer13   
From   
DRRetAdu18 a  
Inner Join DDDuiDes16 b on a.numdui16=b.numdui16   
Inner Join AAClientesAA c on b.tipcli02=c.claseabc and b.codcli02=c.contribuy   
Inner Join AAClientesAA d on b.codage19=d.cliente   
Inner Join DQMaeRep77 e on a.codrep77=e.codrep11   
Inner Join DDCerAdu13 f on b.numcer13=f.numcer13   
Where   
a.numret18=@NumOrd 
and convert(char(8),a.fecret18,112)=convert(char(8),getdate(),112)
GO
/****** Object:  StoredProcedure [dbo].[SP_NUEVA_ENTREGA_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_NUEVA_ENTREGA_SIMPLE    Script Date: 08-09-2002 08:44:10 PM ******/
--ALTER PROCEDURE [dbo].[SP_NUEVA_ENTREGA_SIMPLE]  -- FMCR
--@NUMORD CHAR(7)
--AS
--
--Select 
--a.fecret75,a.numcer74,b.NumSol62,b.obscer74,a.codage19,NombreA=e.nombre,
--a.tipdoc55,a.codrep77,c.nomrep77,a.bultot75,a.pretot75,a.bulret75,a.preret75,
--a.flgval75,a.flgemi75,b.tipcli02,b.codcli02,NombreC=d.nombre 
--From 
--DDRetSim75 a,DDCerSim74 b,DQMaerep77 c,AAClientesAA d,AAClientesAA e 
--Where 
--a.numret75=@NumOrd and
--a.numcer74=b.numcer74 and a.codrep77=c.codrep11 and 
--a.codage19*=e.cliente and e.cliente<>'' and
--b.tipcli02=d.claseabc and b.codcli02=d.contribuy and 
--convert(char(8),a.fecret75,112)=convert(char(8),getdate(),112)
--GO
/****** Object:  StoredProcedure [dbo].[SP_NUMSOL_CEPDEP_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ObtenerOrdAduaneroWeb]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ObtieneOrdenRetiro]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_ORDEN_RETSIM]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_ORDEN_RETSIM    Script Date: 08-09-2002 08:44:12 PM ******/
--ALTER PROCEDURE [dbo].[SP_ORDEN_RETSIM]  -- FMCR
--@NUMORD CHAR(7)
--AS
--
--Select 
--a.fecret75,a.numcer74,a.codage19,NombreA=e.nombre,a.tipdoc55,a.codrep77,d.nomrep77,b.feccer74,
--b.numsol62,b.tipcli02,b.codcli02,NombreC=c.nombre,a.pretot75,a.obsret75,a.flgval75,a.flgemi75,
--f.codubi71
--From 
--DDRetSim75 a,DDCerSim74 b,AAClientesAA c,DQMaeRep77 d,AAClientesAA e,DDrecmer69 f
--Where 
--a.numret75=@NUMORD and 
--a.codrep77=d.codrep11 and b.tipcli02=c.claseabc and 
--b.codcli02=c.contribuy and 
--a.numcer74=b.numcer74 and b.flgval74='1' and 
--b.numsol62=f.numsol62 and f.flgval69='1' and 
--a.numcer74=b.numcer74 and a.codage19*=e.cliente and e.cliente<>''
--GO
/****** Object:  StoredProcedure [dbo].[SP_PERMISOS_ACCIONES]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_PERMISOS_OPCIONES]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_PLACA_DESTARE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ProcesoIvan]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_provision]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_provision    Script Date: 08-09-2002 08:44:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_provision    Script Date: 28/04/2000 8:36:49 PM ******/
/****** Object:  Stored Procedure dbo.sp_provision    Script Date: 18/04/2000 9:19:30 AM ******/
--ALTER PROCEDURE [dbo].[sp_provision]   -- FMCR
--		@fec_i varchar(8),
--		@fec_f varchar(8)
--
--as
--
--/********* Para provisiones *********/		
--
--/****** Para la cuenta 70 *****/
--/*substring(convert(char(12),getdate(),114),1,2) + substring(convert(char(12),getdate(),114),4,2) + substring(convert(char(12),getdate(),114),7,2) + substring(convert(char(12),getdate(),114),10,3)*/
--
--select codsbd03=c.codsbd03, coddoc07=d.coddoc07, codmon30='D', fecmov12= a.feccom52, 
--codcue01=c.codcue01, serdoc12=substring(a.numcom52,1,3), numdoc12=substring(a.numcom52,4,8),
--codcco06='', codcco07='', desmov12=b.descon53, nrocan04=a.docdes52, codana02='01', 
--impmna12= convert(decimal(15,3),(b.valcon53*a.tipcam52)), impmex12=convert(decimal(15,3),b.valcon53), ticadi12= convert(decimal(15,3),a.tipcam52), IGV=(convert(decimal(15,3),b.valcon53)*0.180), 
--descan04=case when e.nomcli02=null then '' else e.nomcli02 end, tipaut12 = case when f.flgigv50 = '1' then 'GS1' else 'EXO' end, 
--sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='' 
--into #tmp010011
--
--from ddcabcom52 a (nolock),
--dddetcom53 b (nolock),
--crconcep01 c (nolock),
--crtipdoc02 d (nolock),
--dqclipro99 e (nolock),
--dqcompag50 f (nolock)
--where (a.codcom50=b.codcom50 and a.numcom52=b.numcom52)
--and (a.flgcan52='0' and a.flgemi52='1' and a.flgval52 = '1')
--and (b.codcon51=c.codcon14 and c.tipapp01='D')
--and (a.codcom50=d.codtip02 and d.tipapp02='D')
--and (a.codcom50*=f.codcom50)
--and (a.codcli02*=e.codcli02)
--and (a.flglei52='N')
--and (a.feccom52 >= @fec_i
--and a.feccom52 < @fec_f)
--
--group by c.codsbd03, d.coddoc07, a.feccom52, c.codcue01, a.numcom52, b.descon53, a.docdes52,
--b.valcon53, a.tipcam52, e.nomcli02, f.flgigv50  
--if @@error <> 0 goto E_Select_Error
--
--/****** para la cuenta 12 ******/
--
--select codsbd03=b.codsbd03, coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12,
--a.numdoc12, codcco06='', codcco07='', desmov12=a.descan04, a.nrocan04, a.codana02,
--impmna12= case when a.codmon30 = 'D' then ((sum(a.impmex12)+sum(a.igv))*a.ticadi12) else 0 end, 
--impmex12= case when a.codmon30 = 'D' then sum(a.impmex12)+sum(a.igv) else 0 end, 
--
--a.ticadi12, a.descan04, tipaut12='', a.sistem12, flagdh12='D', a.flglei12, fecven12=''
--into #tmp010012
--
--from #tmp010011 a,
--
--crconcep01 b
--where a.codmon30=b.codcon14 and b.tipapp01='D'
--group by b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.nrocan04, a.codana02, a.ticadi12, b.codcue01,
--a.serdoc12, a.numdoc12, a.descan04, a.sistem12, a.flagdh12, a.flglei12
--if @@error <> 0 goto E_Select_Error
--
--
--/****** para la cuenta 40 ******/
--
--select codsbd03=b.codsbd03, coddoc07='', codmon30='D', fecmov12='',
--
--/*codcue01='40110000', serdoc12='', numdoc12='',*/
--codcue01=b.codcue01, serdoc12='', numdoc12='',
--codcco06='', codcco07='', desmov12='IGV', nrocan04='', codana02='',
--
--impmna12= sum(convert(decimal(15,3),igv*ticadi12)), impmex12=sum(convert(decimal(15,3),igv)), ticadi12=0.00,
--descan04='', tipaut12='', sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='' 
--into #tmp010013
--from #tmp010011 a,
--crconcep01 b
--where (b.codcon14='IGV' and b.tipapp01='D')
--group by b.codsbd03, a.codana02, b.codcue01
--
--if @@error <> 0 goto E_Select_Error
--
--begin transaction
--
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010011
--
--
--if @@error <> 0 goto E_General_Error
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12, codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010012
--
--if @@error <> 0 goto E_General_Error
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010013
--
--if @@error <> 0 goto E_General_Error
--
--update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010012) 
--if @@error <> 0 GOTO E_General_Error
--
--commit transaction
--return 0
--
--E_General_Error:
--raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror
--rollback transaction
--return 2
--
--
--E_Select_Error:
--raiserror('No se pudo crear la tabla temporal',1,2) with seterror
--return 2
--GO
/****** Object:  StoredProcedure [dbo].[sp_provision2]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_provision2    Script Date: 08-09-2002 08:44:07 PM ******/
--ALTER PROCEDURE [dbo].[sp_provision2]   -- FMCR
--		@fec_i varchar(8),
--		@fec_f varchar(8)
--
--as
--
--/********* Para provisiones *********/		
--
--/****** Para la cuenta 70 *****/
--/*substring(convert(char(12),getdate(),114),1,2) + substring(convert(char(12),getdate(),114),4,2) + substring(convert(char(12),getdate(),114),7,2) + substring(convert(char(12),getdate(),114),10,3)*/
--
--select codsbd03=c.codsbd03, coddoc07=d.coddoc07, codmon30='D', fecmov12= a.feccom52, 
--codcue01=c.codcue01, serdoc12=substring(a.numcom52,1,3), numdoc12=substring(a.numcom52,4,8),
--codcco06='', codcco07='', desmov12=b.descon53, nrocan04=a.docdes52, codana02='01', 
--impmna12= convert(decimal(15,2),(b.valcon53*a.tipcam52)), impmex12=convert(decimal(15,2),b.valcon53), ticadi12= convert(decimal(15,5),a.tipcam52), IGV=convert(decimal(15,2),b.valcon53*0.18), 
--descan04=case when e.nomcli02=null then '' else e.nomcli02 end, tipaut12 = case when d.flgigv50 = '1' then 'GS1' else 'EXO' end, 
--sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='' 
--into #tmp010011
--
--from ddcabcom52 a (nolock),
--dddetcom53 b (nolock),
--dqconcom51 c (nolock),
--dqcompag50 d (nolock),
--dqclient02 e (nolock)
--where (a.codcom50=b.codcom50 and a.numcom52=b.numcom52)
--and (a.flgemi52='1' and a.flgval52 = '1')
--and (b.codcon51=c.codcon51)
--and (a.codcom50=d.codcom50)
--and (a.codcli02*=e.codcli02)
--and (a.flglei52='N')
--and (a.feccom52 >= @fec_i
--and a.feccom52 < @fec_f)
--
--group by c.codsbd03, d.coddoc07, a.feccom52, c.codcue01, a.numcom52, b.descon53, a.docdes52,
--b.valcon53, a.tipcam52, e.nomcli02, d.flgigv50  
--if @@error <> 0 goto E_Select_Error
--
--/****** para la cuenta 12 ******/
--
--select codsbd03=b.codsbd03, coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12,
--a.numdoc12, codcco06='', codcco07='', desmov12=a.descan04, a.nrocan04, a.codana02,
--impmna12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),((a.impmex12+a.igv)*a.ticadi12))) else 0.00 end, 
--impmex12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),(a.impmex12+a.igv))) else 0 end, 
--
--a.ticadi12, a.descan04, tipaut12='', a.sistem12, flagdh12='D', a.flglei12, fecven12=''
--into #tmp010012
--
--from #tmp010011 a,
--
--dqconcom51 b
--where a.codmon30=b.codcon51
--group by b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.nrocan04, a.codana02, a.ticadi12, b.codcue01,
--a.serdoc12, a.numdoc12, a.descan04, a.sistem12, a.flagdh12, a.flglei12
--if @@error <> 0 goto E_Select_Error
--
--
--/****** para la cuenta 40 ******/
--
--select codsbd03=b.codsbd03, coddoc07='', codmon30='D', fecmov12='',
--
--codcue01=b.codcue01, serdoc12='', numdoc12='',
--codcco06='', codcco07='', desmov12='IGV', nrocan04='', codana02='',
--
--impmna12= sum(convert(decimal(15,2),(a.igv*a.ticadi12))), impmex12=sum(convert(decimal(15,2),a.igv)), ticadi12=0.00,
--descan04='', tipaut12='', sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='' 
--into #tmp010013
--from #tmp010011 a,
--dqconcom51 b
--where b.codcon51='IGV'
--group by b.codsbd03, a.codana02, b.codcue01
--
--if @@error <> 0 goto E_Select_Error
--
--begin transaction
--
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010011
--
--
--if @@error <> 0 goto E_General_Error
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12, codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010012
--
--if @@error <> 0 goto E_General_Error
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010013
--
--if @@error <> 0 goto E_General_Error
--
--update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010012) 
--if @@error <> 0 GOTO E_General_Error
--
--commit transaction
--return 0
--
--E_General_Error:
--raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror
--rollback transaction
--return 2
--
--
--E_Select_Error:
--raiserror('No se pudo crear la tabla temporal',1,2) with seterror
--return 2
--GO
/****** Object:  StoredProcedure [dbo].[sp_provision3]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.sp_provision3    Script Date: 08-09-2002 08:44:07 PM ******/
--ALTER PROCEDURE [dbo].[sp_provision3]  -- FMCR
--		@fec_i varchar(8),
--		@fec_f varchar(8)
--as
--
--/********* Para provisiones *********/		
--
--/****** para la cuenta 70 ******/
--
--select codsbd03=c.codsbd03, coddoc07=d.coddoc07, codmon30='D', fecmov12= a.feccom52, 
--codcue01=c.codcue01, serdoc12=substring(a.numcom52,1,3), numdoc12=substring(a.numcom52,4,8),
--codcco06='', codcco07='', desmov12=b.descon53, nrocan04=a.docdes52, codana02='01', 
--impmna12= convert(decimal(15,2),(b.valcon53*a.tipcam52)), impmex12=b.valcon53, ticadi12= a.tipcam52, IGV=convert(decimal(15,2),(b.valcon53*0.18)), 
--descan04=case when e.nomcli02=null then '' else e.nomcli02 end, tipaut12 = case when d.flgigv50 = '1' then 'GS1' else 'EXO' end, 
--sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='' 
--into #tmp010011
--
--from ddcabcom52 a (nolock),
--dddetcom53 b (nolock),
--dqconcom51 c (nolock),
--dqcompag50 d (nolock),
--dqclient02 e (nolock)
--where (a.codcom50=b.codcom50 and a.numcom52=b.numcom52)
--and (a.flgemi52='1' and a.flgval52 = '1')
--and (b.codcon51=c.codcon51)
--and (a.codcom50=d.codcom50)
--and (a.codcli02*=e.codcli02)
--and (a.flglei52='N')
--and (a.feccom52 >= @fec_i
--and a.feccom52 < @fec_f)
--
--group by c.codsbd03, d.coddoc07, a.feccom52, c.codcue01, a.numcom52, b.descon53, a.docdes52,
--b.valcon53, a.tipcam52, e.nomcli02, d.flgigv50  
--if @@error <> 0 goto E_Select_Error
--
--/****** para la cuenta 12 ******/
--select codsbd03=b.codsbd03, coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12,
--a.numdoc12, codcco06='', codcco07='', desmov12=a.descan04, a.nrocan04, a.codana02,
--impmna12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),((a.impmex12+a.igv)*a.ticadi12))) else 0.00 end, 
--impmex12= case when a.codmon30 = 'D' then sum(a.impmex12+a.igv) else 0 end, 
--
--a.ticadi12, a.descan04, tipaut12='', a.sistem12, flagdh12='D', a.flglei12, fecven12=''
--into #tmp010012
--
--from #tmp010011 a,
--
--dqconcom51 b
--where a.codmon30=b.codcon51
--group by b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.nrocan04, a.codana02, a.ticadi12, b.codcue01,
--a.serdoc12, a.numdoc12, a.descan04, a.sistem12, a.flagdh12, a.flglei12
--if @@error <> 0 goto E_Select_Error
--
--/****** para la cuenta 40 ******/
--
--select codsbd03=b.codsbd03, coddoc07='', codmon30='D', fecmov12='',
--
--codcue01=b.codcue01, serdoc12='', numdoc12='',
--codcco06='', codcco07='', desmov12='IGV', nrocan04='', codana02='',
--
--impmna12= sum(convert(decimal(15,2),(a.igv*a.ticadi12))), impmex12=sum(a.igv), ticadi12=0.00,
--descan04='', tipaut12='', sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='' 
--into #tmp010013
--from #tmp010011 a,
--dqconcom51 b
--where b.codcon51='IGV'
--group by b.codsbd03, a.codana02, b.codcue01
--
--if @@error <> 0 goto E_Select_Error
--
--
--/****** Para la cuenta 70 de las Notas de crédito*****/
--
--select codsbd03=c.codsbd03, coddoc07=d.coddoc07, codmon30='D', fecmov12= a.feccom52, 
--codcue01=c.codcue01, serdoc12='', numdoc12=a.numcom52,
--codcco06='', codcco07='', desmov12=b.descon53, nrocan04=a.docdes52, codana02='01', 
--impmna12= convert(decimal(15,2),(b.valcon53*a.tipcam52)), impmex12=convert(decimal(15,2),b.valcon53), ticadi12= convert(decimal(15,5),a.tipcam52), IGV=convert(decimal(15,2),b.valcon53*0.18), 
--descan04=case when e.nomcli02=null then '' else e.nomcli02 end, tipaut12 = case when d.flgigv50 = '1' then 'GS1' else 'EXO' end, 
--sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='' 
--into #tmp010014
--from ddcabcom52 a (nolock),
--dddetcom53 b (nolock),
--dqconcom51 c (nolock),
--dqcompag50 d (nolock),
--dqclient02 e (nolock)
--where (a.codcom50=b.codcom50 and a.numcom52=b.numcom52)
--and (a.flgemi52='1' and a.flgval52 = '1')
--/*and (b.codcon51=c.codcon51)*/
--and ('NOTAS'=c.codcon51)
--and (a.codcom50=d.codcom50)
--and (a.codcli02*=e.codcli02)
--and (a.codcom50='NC')
--and (a.flglei52='N')
--and (a.feccom52 >= @fec_i
--and a.feccom52 < @fec_f)
--group by c.codsbd03, d.coddoc07, a.feccom52, c.codcue01, a.numcom52, b.descon53, a.docdes52,
--b.valcon53, a.tipcam52, e.nomcli02, d.flgigv50  
--if @@error <> 0 goto E_Select_Error
--
--
--/****** para la cuenta 46 de las notas de crédito******/
--
--select codsbd03=b.codsbd03, coddoc07, a.codmon30, a.fecmov12, codcue01=b.codcue01, a.serdoc12,
--a.numdoc12, codcco06='', codcco07='', desmov12=a.descan04, a.nrocan04, a.codana02,
--
--impmna12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),((a.impmex12+a.igv)*a.ticadi12))) else 0.00 end, 
--impmex12= case when a.codmon30 = 'D' then sum(convert(decimal(15,2),(a.impmex12+a.igv))) else 0 end, 
--a.ticadi12, a.descan04, tipaut12='', a.sistem12, flagdh12='D', a.flglei12, fecven12=''
--into #tmp010015
--from #tmp010014 a,
--dqconcom51 b
--where 'NOTAS'=b.codcon51
--group by b.codsbd03, a.coddoc07, a.codmon30, a.fecmov12, a.nrocan04, a.codana02, a.ticadi12, b.codcue01,
--a.serdoc12, a.numdoc12, a.descan04, a.sistem12, a.flagdh12, a.flglei12
--if @@error <> 0 goto E_Select_Error
--
--/****** para la cuenta 40 de las notas de crédito******/
--
--select codsbd03=b.codsbd03, coddoc07='', codmon30='D', fecmov12='',
--codcue01=b.codcue01, serdoc12='', numdoc12='',
--codcco06='', codcco07='', desmov12='IGV', nrocan04='', codana02='',
--impmna12= sum(convert(decimal(15,2),(a.igv*a.ticadi12))), impmex12=sum(convert(decimal(15,2),a.igv)), ticadi12=0.00,
--descan04='', tipaut12='', sistem12='D', flagdh12 = 'H', flglei12='N', fecven12='' 
--into #tmp010016
--from #tmp010014 a,
--dqconcom51 b
--where b.codcon51='IGV'
--group by b.codsbd03, a.codana02, b.codcue01
--if @@error <> 0 goto E_Select_Error
--
--
--/****** para la cuenta 70 de documentos anulados******/
--
--select codsbd03='500', coddoc07=d.coddoc07, codmon30='S', fecmov12= a.feccom52, 
--codcue01='70760300', serdoc12=substring(a.numcom52,1,3), numdoc12=substring(a.numcom52,4,8),
--codcco06='', codcco07='', desmov12='ANULADO', nrocan04='', codana02='', 
--impmna12= 0.00, impmex12=0.00, ticadi12= 0.00, IGV=0.00, 
--descan04='ANULADO', tipaut12 = 'GS1', 
--sistem12='D', flagdh12 = 'D', flglei12='N', fecven12=getdate() 
--into #tmp010019
--
--from ddcabcom52 a (nolock),
--dddetcom53 b (nolock),
--dqconcom51 c (nolock),
--dqcompag50 d (nolock),
--dqclient02 e (nolock)
--where (a.codcom50=b.codcom50 and a.numcom52=b.numcom52)
--and (a.flgemi52='1' and a.flgval52 = '0')
--and (b.codcon51=c.codcon51)
--and (a.codcom50=d.codcom50)
--and (a.codcli02*=e.codcli02)
--and (a.flglei52='N')
--and (a.feccom52 >= @fec_i
--and a.feccom52 < @fec_f)
--
--group by d.coddoc07, a.feccom52, a.numcom52 
--if @@error <> 0 goto E_Select_Error
--
--begin transaction
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010011
--
--
--if @@error <> 0 goto E_General_Error
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12, codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010012
--
--if @@error <> 0 goto E_General_Error
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010013
--
--if @@error <> 0 goto E_General_Error
--
--/*para las notas de credito*/
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010014
--if @@error <> 0 goto E_General_Error
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12, codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010015
--if @@error <> 0 goto E_General_Error
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010016
--if @@error <> 0 goto E_General_Error
--
--INSERT INTO CDMOVIMI15(codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03,coddoc07,codmon30,fecmov12,codcue01,serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12 from #tmp010019
--if @@error <> 0 goto E_General_Error
--
--
--update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010019) 
--if @@error <> 0 GOTO E_General_Error
--
--update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010012) 
--if @@error <> 0 GOTO E_General_Error
--
--update ddcabcom52 set flglei52='S' where numcom52 in (select numcom52=serdoc12+numdoc12 from #tmp010015) 
--if @@error <> 0 GOTO E_General_Error
--
--
--commit transaction
--
--
--/*Cálculo de Redondeo*/
--
--select codsbd03, D=case when flagdh12='D' then sum(impmna12) else 0.00 end, 
--H=case when flagdh12='H' then sum(impmna12) else 0.00 end 
--into #tmp010017
--from cdmovimi15 
--GROUP BY codsbd03, FLAGDH12
--
--select a.codsbd03, codmon30='S', fecmov12=getdate(), 
--codcue01='', desmov12='', impmna12=(sum(a.d)-sum(a.h)), sistem12='D', 
--flagdh12= case when (sum(a.d)-sum(a.h)) > 0.00 then 'H' else 'D' end, flglei12='N', fecven12=getdate(), 
--concepto=case when (sum(a.d)-sum(a.h)) > 0.00 then 'GANRE' else 'PERRE' end
--into #tmp010018
--from #tmp010017 a
--group by a.codsbd03
--
--INSERT INTO CDMOVIMI15(codsbd03, coddoc07, codmon30, fecmov12, codcue01, serdoc12,numdoc12,codcco06, codcco07, desmov12,nrocan04,codana02,impmna12,impmex12,ticadi12,descan04,tipaut12,sistem12,flagdh12,flglei12,fecven12) 
--select codsbd03=a.codsbd03, coddoc07='', a.codmon30, a.fecmov12, codcue01=b.codcue01, serdoc12='', numdoc12='', codcco06='', codcco07='', a.desmov12, nrocan04='', codana02='',
--impmna12=abs(a.impmna12), impmex12=0.00, ticadi12=0.00, descan04='', tipaut12='', a.sistem12, a.flagdh12, a.flglei12, a.fecven12
--from #tmp010018 a, dqconcom51 b
--where b.codcon51=a.concepto and a.impmna12 <> 0.00
--
--return 0
--E_General_Error:
--raiserror('Ocurrio un error al generar las provisiones',1,2) with seterror
--rollback transaction
--return 2
--E_Select_Error:
--raiserror('No se pudo crear la tabla temporal',1,2) with seterror
--return 2
--GO
/****** Object:  StoredProcedure [dbo].[SP_RANKING_CIF]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_RECEPCION_ADUANERA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_RECEPCION_ADUANERA_CON]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_RECEPCION_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RECEPCION_SIMPLE    Script Date: 08-09-2002 08:44:10 PM ******/
--ALTER PROCEDURE [dbo].[SP_RECEPCION_SIMPLE]  -- FMCR
--@NUMSOL CHAR(7)
--AS
--
--Select 
--a.numrec62,a.fecsol62,a.tipcli02,a.codage19,nombrea=d.nombre,a.codcli02,fecing01=Min(b.fecing01),
--fecsal01=Max(b.fecsal01),pesbru01=SUM(b.pesnet01),pesnet01=SUM(b.pesnet01-b.tarcon01),a.flgcer62,
--nombrec=e.nombre
--From 
--ddsolsim62 a,ddticket01 b,AAClientesAA d,AAClientesAA e
--Where 
--a.numsol62=b.docaut01 and a.codage19*=d.cliente and 
--a.numsol62=@NUMSOL and b.tipope01='D' and b.tipest01='S' and b.numgui01=null and 
--a.tipcli02=e.claseabc and a.codcli02=e.contribuy
--Group by 
--a.numrec62,a.fecsol62,a.tipcli02,a.codcli02,a.codage19,d.nombre,a.flgcer62,e.nombre
--GO
/****** Object:  StoredProcedure [dbo].[SP_RECEPCION_SIMPLE_CON]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RECEPCION_SIMPLE_CON    Script Date: 08-09-2002 08:44:10 PM ******/
--ALTER PROCEDURE [dbo].[SP_RECEPCION_SIMPLE_CON]  -- FMCR
--@NUMREC CHAR(7)
--AS
--
--Select 
--a.fecrec69,a.numsol62,numsol10=a.numsol62,b.fecsol62,b.codage19,d.nombre,b.tipcli02,b.codcli02,a.codubi71,e.desubi71,
--a.codemb06,a.PriIng69,a.fining69,a.pesbru69,a.pesnet69,a.guirem69,a.obsrec69,a.flgval69,
--a.flgemi69,NombreC=f.nombre
--From 
--DDRecMer69 a,DDSolSim62 b,AAClientesAA d,DQTipUbi71 e,AAClientesAA f
--Where 
--a.numsol62=b.numsol62 and b.codage19*=d.cliente and a.codubi71=e.codubi71 and 
--b.tipcli02=f.claseabc and b.codcli02=f.contribuy and 
--NumRec69=@NUMREC
--GO
/****** Object:  StoredProcedure [dbo].[sp_RegVen]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.sp_RegVen    Script Date: 08-09-2002 08:44:10 PM ******/  
ALTER PROCEDURE [dbo].[sp_RegVen]  @FECINI CHAR(8),  @FECFIN CHAR(8),  @SERIE CHAR(3),  @DOCUM CHAR(2)  AS    
Delete from CDREGVEN23 where userid=user_name() and hostid=host_name()  
Delete from CDREGVEN24 where userid=user_name() and hostid=host_name()    /* Lleno primera tabla temporal a.razage19 DESCAN04,*/  
INSERT INTO terminal..CDREGVEN23   (FECMOV12,CODDOC07,SERDOC12,NUMDOC12,DESCAN04,NROCAN04,IMPMNA12,TICADI12,TOTDOL,  IMPINA,IMPAFE,IMPIGV,TOTGEN,USERID,HOSTID)  
SELECT convert(char(8),c.feccom52,112) FECMOV12,c.codcom50 CODDOC07,substring(c.numcom52,1,3) SERDOC12,  
substring(c.numcom52,4,7) NUMDOC12,  'DESCAN04'= CASE WHEN c.flgval52='0' then    'A  N  U  L  A D  O'       
ELSE           c.nomdes52       END,  'NROCAN04'=CASE WHEN c.flgval52='0' then    ''       else    c.docdes52       END,  (c.monpag52*f.camleg28) IMPMNA12,  
'TICADI12'= CASE WHEN c.flgval52='0' then    0       ELSE    f.camleg28       END,  'T
OTDOL'= CASE WHEN c.flgval52='1' THEN      (c.subtot52+c.igvtot52)     ELSE    0     END,  'IMPINA'= 0,  
'IMPAFE'= CASE WHEN c.flgval52='0' THEN    0     ELSE    convert(decimal(20,2),c.subtot52*f.camleg28)      END,  'IMPIGV'= CASE WHEN c.flgval52='1' 
THEN    convert(decimal(20,2),c.igvtot52*f.camleg28)    ELSE    0     END,  
'TOTGEN'= CASE WHEN c.flgval52='1' THEN    convert(decimal(20,2),c.igvtot52*f.camleg28)+convert(decimal(20,2),c.subtot52*f.camleg28)     ELSE    0     END,  
user_name() USERID,host_name() HOSTID  
From DDCABCOM52 c (NOLOCK),terminal..dqtipcam28 f (NOLOCK)  
Where   (convert(char(8),c.feccom52,112)>=@FECINI and convert(char(8),c.feccom52,112)<=@FECFIN ) and   convert(char(8),c.feccom52,112)=f.fecfor28 and   
substring(c.numcom52,1,3)=@SERIE and c.codcom50=@DOCUM   
Order by c.codcom50,c.numcom52       
INSERT INTO terminal..CDREGVEN24   (CODDOC07,SERDOC12,NUMDOC12,DESCAN04,FECMOV12,NROCAN04,TICADI12,IMPMNA12,TOTDOL,  IMPAFE,IMPINA,IMPIGV,TOTGEN,USERID,HOSTID)  
SELECT CODDOC07,SERDOC12,NUMDOC12,DESCAN04,convert(char(8),FECMOV12,112),NROCAN04,TICADI12,  
SUM(IMPMNA12) AS TOTALSOLES, SUM(TOTDOL) AS TOTALDOLARES,SUM(IMPAFE) AS MAFECTO,   SUM(IMPINA) AS MINAFECTO, SUM(IMPIGV) AS MONTOIGV,TOTGEN,user_name(),host_name()  
FROM terminal..CDREGVEN23 (NOLOCK)  WHERE USERID=user_name() and HOSTID=host_name()  
GROUP BY CODDOC07,SERDOC12,NUMDOC12,DESCAN04,convert(char(8),FECMOV12,112),NROCAN04,TICADI12,TOTGEN  ORDER BY CODDOC07,SERDOC12,NUMDOC12  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_REINDEXAR_TABLA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_DE_MOVIMIENTO_DE_CONTENEDORES]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
Inner Join terminal.dbo.dqnavier08 d on b.codnav08=d.codnav08  
Inner Join AAclientesAA e on e.contribuy=b.codcli02  
Where c.fecing01 between @FECINI and @FECFIN and c.tipope01='D'  
Union   
Select a.numsol62,b.codnav08,d.desnav08,b.numvia62,b.fecsol62,a.numctr65,a.tamctr65,a.numtkt01,FECHA=getdate(),Importador=e.nombre,  
SUBTITULO='DESDE : '+right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'  HASTA  : '+right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4)  
From DDCtrDep65 a  
Inner Join ddsolsim62 b on a.numsol62=b.numsol62  
Inner Join terminal.dbo.dqnavier08 d on b.codnav08=d.codnav08  
Inner Join AAclientesAA e on e.contribuy=b.codcli02  
Where b.fecsol62 between @FECINI and @FECFIN and a.numtkt01 is null  
UNION ALL  
Select a.numsol62,b.codnav08,d.desnav08,b.numvia10,c.fecing01,a.numctr65,a.tamctr65,a.numtkt01,FECHA=getdate(),Importador=e.nombre,  
SUBTITULO='DESDE : '+right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'  HASTA  : '+right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4)  
From DDCtrDep65 a  
Inner Join DDSolAdu10 b on a.numsol62=b.numsol10  
Inner Join terminal.dbo.dqnavier08 d on b.codnav08=d.codnav08  
left Join ddticket01 c on a.numtkt01=c.numtkt01  
Inner Join AAclientesAA e on e.contribuy=b.codcli02  
Where c.fecing01 between @FECINI and @FECFIN and c.tipope01='D'  
Union  
Select a.numsol62,b.codnav08,d.desnav08,b.numvia10,b.fecsol10,a.numctr65,a.tamctr65,a.numtkt01,FECHA=getdate(),Importador=e.nombre,  
SUBTITULO='DESDE : '+right(@FECINI,2)+'/'+substring(@FECINI,5,2)+'/'+left(@FECINI,4)+'  HASTA  : '+right(@FECFIN,2)+'/'+substring(@FECFIN,5,2)+'/'+left(@FECFIN,4)  
From DDCtrDep65 a  
Inner Join DDSolAdu10 b on a.numsol62=b.numsol10  
Inner Join terminal.dbo.dqnavier08 d on b.codnav08=d.codnav08  
Inner Join AAclientesAA e on e.contribuy=b.codcli02  
Where b.fecsol10 between @FECINI and @FECFIN and a.numtkt01 is null  
Order by c.fecing01,numctr65
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_INGRESO_ADUANERO]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.SP_REPORTE_INGRESO_ADUANERO    Script Date: 08-09-2002 08:44:12 PM ******/
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
From DDSolAdu10 a
Inner Join DDRecMer69 b on b.numsol62=a.numsol10
Inner Join DDduidep11 c on c.numsol10=a.numsol10 
Inner Join AAClientesAA d on d.claseabc=a.tipcli02 and d.contribuy=a.codcli02
Inner Join DDserdep12 e on e.numdui11=c.numdui11
Where convert(char(8),b.priing69,112) between @FECINI and @FECFIN and b.flgval69='1' and b.flgemi69='1' 
Order by b.numrec69
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_INGRESO_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_MOV_GEN_ADU_T1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_MOV_GEN_ADU_T2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_SALIDAS_ADUANERO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
Order by a.numcer13,a.numret75,a.nument79
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORTE_SALIDAS_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_RESUMEN_CONCEPTOS]    Script Date: 10/03/2019 02:40:09 PM ******/
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
     dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal.dbo.dqtipcam28 e  
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
     dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal.dbo.dqtipcam28 e  
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
    dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal.dbo.dqtipcam28 e  
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
    dddetcom53 a,ddcabcom52 c,AAClientesAA d,terminal.dbo.dqtipcam28 e  
    Where   
    a.numcom52=c.numcom52 and c.numcer52=a.numcer52 and c.flgval52='1' and c.flgemi52='1' and   
    c.tipdes52=d.claseabc and c.docdes52=d.contribuy and   
    convert(char(8),c.feccom52,112) between @FECINI and @FECFIN and   
    substring(a.numcom52,1,3)=@NUMSER and a.CodCom50=@CODCOM and   
    e.fecfor28=convert(char(8),c.feccom52,112) and c.tipdes52=@TIPCLI and c.docdes52=@CODCLI and c.facesp52='S'  
    Order by a.descon53,d.nombre,a.numcom52  
  
GO
/****** Object:  StoredProcedure [dbo].[SP_RETIRO_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_RETIRO_SIMPLE    Script Date: 08-09-2002 08:44:13 PM ******/
--ALTER PROCEDURE [dbo].[SP_RETIRO_SIMPLE]  -- FMCR
--@NUMCER CHAR(7)
--AS
--
--Select 
--a.numsol62,a.feccer74,a.tipcli02,a.codcli02,NombreC=b.nombre,a.codage19,NombreA=c.nombre,
--d.codubi71
--From 
--DDCerSim74 a,AAClientesAA b,AAClientesAA c,DDrecmer69 d
--
--Where a.numcer74=@NUMCER and
--a.tipcli02=b.claseabc and 
--a.codcli02=b.contribuy and a.codage19*=c.cliente and 
--a.numsol62=d.numsol62 and 
--c.cliente<>'' and a.flgval74='1' and d.flgval69 ='1'
--GO
/****** Object:  StoredProcedure [dbo].[SP_SALDO_FISICO_POR_SERIE_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
Select d.claseabc,d.contribuy,d.nombre,a.numdui11,a.numcer13,a.feccer13,b.numser12,b.numbul14,b.bulent14,sldbul=b.numbul14-b.bulent14,c.codemb06,b.desmer14      
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
/****** Object:  StoredProcedure [dbo].[sp_SALDO_FISICO_POR_SERIE_ADU_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
c.codemb06 as Embalaje,
b.desmer14 as Mercadería,
'ADUANERO' as Tipo_Operacion
From DDCERADU13 AS a 
INNER JOIN DDDCEADU14 AS b ON a.numcer13=b.numcer13
INNER JOIN DDSERDEP12 AS c ON b.numser12=c.numser12 AND a.numsol10=c.numsol10
INNER JOIN AAClientesAA AS d ON a.tipcli02=d.claseabc AND a.codcli02=d.contribuy 
Where     
a.numbul13-a.bulent13>0 and b.numbul14-b.bulent14>0 and a.tipcli02=@TIPCLI and a.codcli02=@CODCLI and flgval13 = 1  
union
Select 
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
b.codemb06 AS Embalaje,
b.desmer67 AS Mercadería, 
'SIMPLE' AS Tipo_Operacion
From DDCerSim74 a  
Inner Join DDDSoSim67 b on a.numsol62=b.numsol62  
Inner Join AAClientesAA d on a.tipcli02=d.claseabc and a.codcli02=d.contribuy  
Where a.bultot74-a.bulent74>0 and b.bulrec67-b.bulent67>0 
and a.flgval74=1 and a.codcli02=@CODCLI  
order by Certificado 
return 0

GO
/****** Object:  StoredProcedure [dbo].[SP_SALDO_FISICO_POR_SERIE_ADU_WEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SALDO_FISICO_POR_SERIE_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SALDO_MERCADERIAS_1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
		--**ORIGINAL 
        /*
        Delete DTSalAdu35  
        Insert DTSalAdu35       
        Select numdui11,bulent=sum(COALESCE(bultot79,0)),cifent=sum(COALESCE(pretot79,0)+COALESCE(cuadep79,0)),host_name()      
        From DDEntMer79 d      
        Where convert(char(8),fecent79,112) between @FECINI and @FECFIN and numdui11 is not NULL and flgval79='1' and flgemi79 = '1'     
        and Exists (Select 1 from ddticket01 where docaut01 = d.numret75 and convert(char(8),fecusu01,112) between @FECINI and @FECFIN ) 
        Group by numdui11
        */
        --**ORIGINAL
        Delete DTSalAdu35
        Insert DTSalAdu35
        SELECT numdui11,SUM(bulent),SUM(cifent),host_name()
		FROM (
			Select numdui11,bulent=sum(COALESCE(bultot79,0)),cifent=sum(COALESCE(pretot79,0)+COALESCE(cuadep79,0)),host_name() nomhost     
			From DDEntMer79 d      
			Where convert(char(8),fecent79,112) between @FECINI and @FECFIN and numdui11 is not NULL and flgval79='1' and flgemi79 = '1'     
			and Exists (Select 1 from ddticket01 where docaut01 = d.numret75 and convert(char(8),fecusu01,112) between @FECINI and @FECFIN) 
			Group by numdui11
			union
			Select '1181370004408',CASE WHEN @FECFIN >= '20140530' AND @FECFIN < '20140701' THEN 30.00 ELSE 0 END,CASE WHEN @FECFIN >= '20140530' AND @FECFIN < '20140701' THEN 26894.483 ELSE 0 END,host_name()
			union
			Select '1181370003078',CASE WHEN @FECFIN >= '20140629' AND @FECFIN < '20140701' THEN 8.00 ELSE 0 END,CASE WHEN @FECFIN >= '20140629' AND @FECFIN < '20140701' THEN 617.279 ELSE 0 END,host_name()
			union
			Select '1181370004454',CASE WHEN @FECFIN >= '20140629' AND @FECFIN < '20140701' THEN 5.00 ELSE 0 END,CASE WHEN @FECFIN >= '20140629' AND @FECFIN < '20140701' THEN 202.835 ELSE 0 END,host_name()
			union
			Select '1181370004408',CASE WHEN @FECFIN >= '20140530' THEN 1.00 ELSE 0 END,CASE WHEN @FECFIN >= '20140530' THEN 918.758 ELSE 0 END,host_name()
		) T
		GROUP BY numdui11
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
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_POR_SERIE_ADUANERO]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
a.nument79=b.nument79 and a.nument79=c.numgui01 and c.tipope01='R' and   
SUBSTRING(a.nument79,1,1)='A'  and flgval79='1'
group by   
b.numcer13,b.numser70,a.nument79,c.fecsal01,a.obsent79,d.nombre  
Order by a.nument79,c.fecsal01
GO
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_POR_SERIE_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_1]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_3]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SALDOS_X_TIPO_MERCADERIA_4]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SALIDAS_POR_CERTIFICADO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SALIDAS_POR_CERTIFICADO_S]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SALIDAS_POR_CERTIFICADO_S    Script Date: 08-09-2002 08:44:11 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SERIES_A_BLOQUEAR]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SERIES_A_BLOQUEAR_DET]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SOL_CERSIM]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_SOL_CERSIM    Script Date: 08-09-2002 08:44:13 PM ******/
--ALTER PROCEDURE [dbo].[SP_SOL_CERSIM]  -- FMCR
--@NUMSOL CHAR(7)
--AS
--
--Select 
--a.fecsol62,a.tipcli02,a.codcli02,NombreC=b.nombre,a.codage19,NombreA=c.nombre,
--flgcer62=case when (Select count(*) from ddcersim74 where numsol62=@NUMSOL and flgval74='1')>=1 then 
--    '1' 
--else 
--    '0' 
--end,
--a.numrec62,a.bultot62,a.totrec62,a.PesTot62,a.cobalm62
--From 
--DDSolSim62 a,AAClientesAA b,AAClientesAA c 
--Where 
--a.tipcli02=b.claseabc and a.codcli02=b.contribuy and
--
--a.codage19*=c.cliente and a.numsol62=@NUMSOL
--GO
/****** Object:  StoredProcedure [dbo].[SP_SOLICITUD_DUA_DEP]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SOLICITUD_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[SP_SOLICITUD_SIMPLE] -- FMCR
--@NUMSOL CHAR(7)
--AS
--
----rdelacuba 31/10/2006: Incluir el dato de terminal
--SELECT 
--a.*, factComercial = isnull(a.FACTCOMER,'') , NombreC=b.nombre,NombreA=c.nombre,e.codalm99,e.desalm99, isnull(f.NomTer09,'') as nomter , isnull(de20,'') as  de20c ,isnull(de40,'') as de40c,isnull(cgsuelta10,'0') as cgsuelta10c
--FROM 
--DDSolSim62 a,AAClientesAA b,AAClientesAA c,DDAlmExp99 d,DQAlmDep99 e, DQTerAdu09 f
--WHERE
--a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
--a.codage19*=c.cliente and a.numsol62=d.numsol99 and d.codalm99=e.codalm99 and 
--a.CodTer *= f.codter09 and
--a.NumSol62=@NUMSOL
--
--GO
/****** Object:  StoredProcedure [dbo].[SP_SOLUCITUD_ADUANERA]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SOLUCITUD_ADUANERA]    
@NUMSOL CHAR(7)    
AS    
Select     
a.*,NombreC=b.nombre,b.direccion,NombreA=c.nombre,d.despai07,e.despue02,f.desnav08,q.NomDoc55     
From    
DDSOLADU10 a,AAClientesAA b,AAClientesAA c,terminal.dbo.DQPAISES07 d,    
terminal.dbo.DQPUERTO02 e,terminal.dbo.DQNAVIER08 f,DQTipDoc55 q     
Where     
a.numsol10=@NUMSOL and a.tipcli02=b.claseabc and a.codcli02=b.contribuy and     
a.codage19=c.cliente and a.codpai07=d.codpai07 and a.codpue03=e.codpue02 and     
a.codnav08=f.codnav08  and a.tipcli02=q.tipdoc55
GO
/****** Object:  StoredProcedure [dbo].[SP_SQLSERIE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SQLTARJA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SSI_INSOrden_Servicio_Web_SAA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TARIFA_DEPOSITO_ADUANERO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TARIFA_DEPOSITO_SIMPLE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TCKMAN_CON_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TCKMAN_CON_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TICKET]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TICKET    Script Date: 08-09-2002 08:44:11 PM ******/
--ALTER PROCEDURE [dbo].[SP_TICKET]  -- FMCR
--@NUMTKT CHAR(8)
--AS
--
--
--Select
--a.*,numsol10=a.docaut01,NombreC=b.nombre,NombreA=c.nombre,d.desemb06,e.numctr65,e.tamctr65
--From 
--DDTICKET01 a,AAclientesAA b,AAclientesAA c,DQEMBALA06 d,DDCTRDEP65 e
--Where
--a.numtkt01=@NUMTKT and a.tipcli02=b.claseabc and a.codcli02=b.contribuy and
--a.codage19*=c.cliente and c.cliente<>'' and a.codemb06=d.codemb06 and a.numtkt01*=e.numtkt01
--GO
/****** Object:  StoredProcedure [dbo].[SP_TICKET_TER_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TICKET_TER_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SP_TICKET_TER_SIM    Script Date: 08-09-2002 08:44:11 PM ******/
--ALTER PROCEDURE [dbo].[SP_TICKET_TER_SIM]  -- FMCR
--@NUMSOL CHAR(7)
--AS
--
--Select 
--a.desmer62,a.fecsol62,a.codage19,NombreA=c.nombre,a.tipcli02,a.codcli02,NombreC=b.nombre,
--a.flgval62,a.flgemi62,a.flgctr62,a.flgcer62 
--From 
--DDSolSim62 a,AAClientesAA b,AAClientesAA c
--
--Where 
--a.tipcli02=b.claseabc and a.codcli02=b.contribuy and 
--a.codage19*=c.cliente and a.numsol62=@NUMSOL
--GO
/****** Object:  StoredProcedure [dbo].[SP_TIPO_DE_CAMBIO]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.SP_TIPO_DE_CAMBIO    Script Date: 08-09-2002 08:44:05 PM ******/  
ALTER PROCEDURE [dbo].[SP_TIPO_DE_CAMBIO]  
@FECHA CHAR(8)  
  
AS  
  
  
Select fecfor28, fecnor28, camleg28  
from Terminal.dbo.DQTIPCAM28  
where fecfor28=@FECHA
GO
/****** Object:  StoredProcedure [dbo].[SP_TKTMAN_VEH_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TKTMAN_VEH_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_Valida_Carga_Solicitud_Aut]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_Valida_Cuadre_Carga_Solicitud_Aut]    Script Date: 10/03/2019 02:40:09 PM ******/
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
	set @msg='NRO DE LA SOLICITUD INVALIDO '

if @CodTip<>@aCodTip
	set @msg= @msg + 'EMBALAJE NO COINCIDE CON EL DE LA SOLICITUD '

if @CanBul<>@aCanBul
	set @msg= @msg + 'CANTIDAD DE BULTOS NO COINCIDE CON EL DE LA SOLICITUD '

if @Fob<>@aFob
	set @msg= @msg + 'VALOR FOB NO COINCIDE CON EL DE LA SOLICITUD '

if @Flete<>@aFlete
	set @msg= @msg + 'VALOR FLETE NO COINCIDE CON EL DE LA SOLICITUD '

if @Seguro<>@aSeguro
	set @msg= @msg + 'VALOR SEGURO NO COINCIDE CON EL DE LA SOLICITUD '

if @aCanSer01<>@aCanSer01
	set @msg= @msg + 'CANTIDAD DE SERIES NO COINCIDE CON EL DE LA SOLICITUD '


/*
if @PesBrt01<>a@PesBrt01
	set @msg= @msg + 'EL PESO NO COINCIDE CON EL DE LA SOLICITUD '
*/
select @msg

GO
/****** Object:  StoredProcedure [dbo].[SPW_SALDO_DEP]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.SPW_SALDO_DEP    Script Date: 08-09-2002 08:44:07 PM ******/
--ALTER PROCEDURE [dbo].[SPW_SALDO_DEP]   -- FMCR
--as
--
--Select a.numcer44, a.numdui44, a.fecing44, 
--        Case when b.bulent45=null then a.buling44 else a.buling44-b.bulent45 end, a.codemb44, a.desmer44, 
--	Case when b.cifent45=null then a.cifing44 else a.cifing44-b.cifent45 end 
--From DTIngcli44 a, DTsalcli45 b 
--where a.numdui44*=b.numdui45 and Case when b.bulent45=null then a.buling44 else a.buling44-b.bulent45 end > 0 
--order by a.numcer44 desc
--GO
/****** Object:  StoredProcedure [dbo].[TAR_ACUERDOS_TARIFARIOS]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[TAR_ACUERDOS_TARIFARIOS] AS  
Select   
TIPDEP53=case when a.TIPDEP53='A' then 'DEPOSITO ADUANERO' else 'DEPOSITO SIMPLE' end,  
a.TIPCLI53,a.CODCLI53,b.nombre, f.TIPMON54, 
MONEDA=case when f.TIPMON54='D' then 'DOLARES' else 'SOLES' end,
a.CODSER53,c.desser52,c.TIPMER72,d.desmer72,c.CODEMB06,e.desemb06,
TARIFA52 = case when f.TIPMON54='D' then c.TARIFA52 else  c.TARIFA52S end,
TARMIN52 = case when f.TIPMON54='D' then c.TARMIN52 else  c.TARMIN52S end,  
APLICA52=case when c.APLICA52='P' then 'PORCENTAJE' else case when c.aplica52='U' then 'UNIDAD' else 'MONTO' end end,  
a.gloser53,  
CLAACU53=case when a.CLAACU53='D' then 'DESCUENTO' else 'INCREMENTO' end,  
VALACU53 = case when f.TIPMON54='D' then a.VALACU53 else a.VALACU53S end,  
TARMIN53 = case when f.TIPMON54='D' then a.TARMIN53 else a.TARMIN53S end, 
ESTADO53=case when a.ESTADO53='A' then 'ACTIVO' else 'INACTIVO' end,  
APLMIN53=case when a.APLMIN53='S' then 'SI' else 'NO' end,  
a.NUMACU53  
From   
ddacuerd53 a, aaclientesaa b, ddservic52 c, DQTipMer72 d, DQEMBALA06 e, DDCLIMON54 f
Where   
a.TIPCLI53=b.claseabc and a.CODCLI53=b.contribuy and 
f.TIPCLI54=a.TIPCLI53 and f.CODCLI54=a.CODCLI53 and  
a.codser53=c.servic52 and a.tipdep53=c.deposi52 and c.VISIBLE52='S' and a.ESTADO53='A' and   
c.tipmer72=d.tipmer72 and c.codemb06=e.codemb06  
Order by a.TIPDEP53,b.nombre,c.desser52,a.NUMACU53

GO
/****** Object:  StoredProcedure [dbo].[TAR_CALCULA_TIPO_CAMBIO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[TAR_CERTIFICADO_EN_DESCUENTOS]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[TAR_COBRAR_ALMACENAJE]    Script Date: 10/03/2019 02:40:09 PM ******/
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
    f.tipcli53 = a.tipcli02 and f.codcli53 = a.codcli02  and f.TIPDEP53 = 'S' --'Rtello
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
/****** Object:  StoredProcedure [dbo].[TAR_COBRAR_ALMACENAJE_SER]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[TAR_COBRAR_GASTO_ADMINISTRATIV]    Script Date: 10/03/2019 02:40:09 PM ******/
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

if substring(@NUMCER,1,1)='A'
  BEGIN	

   	    SELECT @tipo = ticlfa13, @codigo = coclfa13  FROM DDCerAdu13 (nolock) WHERE numcer13=@NUMCER
	    SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo

	    Select 
	    a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72,
	    servic52=coalesce(d.servic52,''),
	    aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),
	    claacu53=coalesce((Select claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),''),
	    tipacu53=coalesce((Select tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),''),
	    valacu53=coalesce((Select valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),0),
	    aplmin53=coalesce((Select aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'S'),
	    tarmin53=coalesce((Select (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'GASAD%'),'0')
	    From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d
	    Where a.numcer13=@NUMCER and 
	    a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and 
	    (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and
	    d.status52='A' and d.visible52='S' and d.concep51='GASAD' and deposi52='A'
  END
else
  BEGIN

	    SELECT @tipo = ticlfa74, @codigo = coclfa74  FROM DDCerSim74 (nolock) WHERE numcer74=@NUMCER
	    SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo

	    Select 
	    a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,
	    servic52=coalesce(d.servic52,''),
	    aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),
	    claacu53=coalesce((Select claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),''),
	    tipacu53=coalesce((Select tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),''),
	    valacu53=coalesce((Select valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),0),
	    aplmin53=coalesce((Select aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),'S'),
	    tarmin53=coalesce((Select (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'GASAD%'),'0')
	    From DDCerSim74 a,DDDSoSim67 b,DDservic52 d
	    Where a.numcer74=@NUMCER and a.numsol62=b.numsol62 and 
	    (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and
	    d.status52='A' and d.visible52='S' and d.concep51='GASAD' and deposi52='S'
  END

GO
/****** Object:  StoredProcedure [dbo].[TAR_COBRAR_SEGURO]    Script Date: 10/03/2019 02:40:09 PM ******/
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

if substring(@NUMCER,1,1)='A'
    BEGIN
	    SELECT @tipo = ticlfa13, @codigo = coclfa13  FROM DDCerAdu13 (nolock) WHERE numcer13=@NUMCER
	    SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo
	
	    Select 
	    a.tipcli02,a.codcli02,b.numser12,b.numbul14,c.codemb06,c.tipmer72,
	    servic52=coalesce(d.servic52,''),
	    aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end) ,0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),
	    claacu53=coalesce((Select Distinct claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),
	    tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),''),
	    valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),0),
	    aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'S'),
	    tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end)  from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='A' and codser53 like 'SEGCA%'),'0'),
	    tipmon =  @tipmon
	    From DDCerAdu13 a,DDDCeAdu14 b,DDSerDep12 c,DDservic52 d
	    Where a.numcer13=@NUMCER and 
	    a.numcer13=b.numcer13 and a.numsol10=c.numsol10 and b.numser12=c.numser12 and 
	    (c.codemb06=d.codemb06 or d.codemb06='TDO') and (c.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and
	    d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='A'
    END
else
    BEGIN
	    SELECT @tipo = ticlfa74, @codigo = coclfa74  FROM DDCerSim74 (nolock) WHERE numcer74=@NUMCER
	    SELECT @tipmon = tipmon54 FROM DDCLIMON54 WHERE  tipcli54 = @tipo AND codcli54 = @codigo
	
	    Select 
	    a.tipcli02,a.codcli02,b.numser67,b.numbul67,b.codemb06,b.tipmer72,
	    servic52=coalesce(d.servic52,''),
	    aplica52=coalesce(d.aplica52,''),tarifa52=coalesce((case when @tipmon = 'D' then d.tarifa52 else d.tarifa52s end),0),tarmin52=coalesce((case when @tipmon = 'D' then d.tarmin52 else d.tarmin52s end),0),
	    claacu53=coalesce((Select Distinct  claacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),
	    tipacu53=coalesce((Select Distinct tipacu53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),''),
	    valacu53=coalesce((Select distinct valacu53=(case when CLAACU53='D' then (case when @tipmon = 'D' then valacu53 else valacu53s end)*-1 else (case when @tipmon = 'D' then valacu53 else valacu53s end) end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),0),
	    aplmin53=coalesce((Select Distinct aplmin53 from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'S'),
	    tarmin53=coalesce((Select Distinct (case when @tipmon = 'D' then tarmin53 else tarmin53s end) from DDacuerd53 where tipcli53=a.tipcli02 and codcli53=a.codcli02 and codser53=d.servic52 and estado53='A' and tipdep53='S' and codser53 like 'SEGCA%'),'0'),
	    tipmon =  @tipmon
	    From DDCerSim74 a,DDDSoSim67 b,DDservic52 d
	    Where a.numcer74=@NUMCER and a.numsol62=b.numsol62 and 
	    (b.codemb06=d.codemb06 or d.codemb06='TDO') and (b.tipmer72=d.tipmer72 or d.tipmer72='TODOS') and
	    d.status52='A' and d.visible52='S' and d.concep51='SEGCA' and deposi52='S'
    END
GO
/****** Object:  StoredProcedure [dbo].[TAR_ENTREGAS_X_SERIE_DEPOSIT_A]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[TAR_FACTURAS_FACTURAR]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[TAR_FACTURAS_FACTURAR]
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
Declare @WhereA1 varchar(255)
Declare @WhereA2 varchar(255)
Declare @Union varchar(50)
Declare @SelectS1 varchar(255)
Declare @SelectS2 varchar(255)
Declare @SelectS3 varchar(255)
Declare @SelectS4 varchar(255)
Declare @FromS1 Varchar(255)
Declare @WhereS1 varchar(255)
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
    Select @WhereA1="Where a.ticlfa13=b.claseabc and a.coclfa13=b.contribuy and 	a.numsol10=c.numsol10 and a.flgval13='1' and a.flgfac13='1' and substring(b.cadena,12,1)='1' and a.finser13='0' and a.flstfa13='N' "
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
    Select @SelectS2="cifcer13=a.pretot74,pescer13=a.pestot74,flgtar13=a.flgtar74,a.numtar68,finser13=a.finser74,ultfac13=a.ultfac74,tipcli02C=a.tipcli02,codcli02C=a.codcli02,"    Select @SelectS3="TipCli02=a.ticlfa74,CodCli02=a.coclfa74,b.nombre,b.direccion,FLGHOR02=substring(b.cadena,11,1),TOLHOR02=b.diasabast,FACHOR02=b.diaspromat,"    Select @SelectS4="diaalm10=c.diaalm62,segnep10=c.segnep62,porseg10=c.porseg62,desmer10=c.desmer62,faccom10=c.FACTCOMER,conemb10=c.codemb62,CERADU74=a.ceradu74 "
    Select @FromS1="From DDCerSim74 a,AAClientesAA b, DDSolSim62 c "
    Select @WhereS1="Where a.ticlfa74=b.claseabc and a.coclfa74=b.contribuy and a.numsol62=c.numsol62 and a.flgval74='1' and a.flgfac74='1' and substring(b.cadena,12,1)='1' and a.finser74='0' and a.flstfa74='N' "
    IF @PORCER='1'
        Select @WhereS2=@WhereS2 + " and a.numcer74='" + @NUMCER + "' "
    IF @PORCLI='1'
        Select @WhereS2=@WhereS2 + " and b.claseabc='" + @TIPCLI + "' and b.contribuy='" + @CODCLI + "' "
End

Execute(@SelectA1+@SelectA2+@SelectA3+@FromA1+@WhereA1+@WhereA2+@Union+@SelectS1+@SelectS2+@SelectS3+@SelectS4+@FromS1+@WhereS1+@WhereS2)
GO
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO_2]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO_ADU]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*7. Emisión de Facturas*/

ALTER PROCEDURE [dbo].[TAR_ORDENES_DE_SERVICIO_ADU]
@NUMCER VARCHAR(9),
@DETRANS char(1),
@DETRANC char(1)
AS
BEGIN

--rdelacuba 02/11/2006: Creado para diferenciar las facturas con y sin detracción 
--En el caso de ADUANERO sólo aplica detraccion de transporte, no aplica detrac58

SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
WHERE a.Numcer58=@NUMCER and 
b.codcom50 is null and 
a.flgval58='1' and 
b.valcob59<>0 and 
isnull(a.dettrans,'N') = @DETRANS and
isnull(a.dettranc,'N') = @DETRANC
GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59

END
GO
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO_GA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
	GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
	UNION
	SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
	FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
	WHERE a.Numcer58=@NUMCER and 
	b.codcom50 IS null and 
	a.flgval58='1' and 
	b.valcob59<>0 and 
	isnull(a.dettranC,'N') = 'S'
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
	GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
	UNION
	SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
	FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
	WHERE a.Numcer58=@NUMCER and 
	b.codcom50 IS null and 
	a.flgval58='1' and 
	b.valcob59<>0 and 
	isnull(a.dettranS,'N') = 'S'
	GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
	UNION
	SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
	FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
	WHERE a.Numcer58=@NUMCER and 
	b.codcom50 IS null and 
	a.flgval58='1' and 
	b.valcob59<>0 and 
	isnull(a.dettranC,'N') = 'S'
	GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59
END


END
GO
/****** Object:  StoredProcedure [dbo].[TAR_ORDENES_DE_SERVICIO_SIM]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[TAR_ORDENES_DE_SERVICIO_SIM]
@NUMCER VARCHAR(9),
@DETRAC char(1),
@DETRANS char(1),
@DETRANC char(1)
AS
BEGIN

--rdelacuba 02/11/2006: Creado para diferenciar las facturas con y sin detracción de transporte

/*Posibilidades de envío: 
1. @DETRAC = 'N', @DETRANS = 'N', @DETRANC = 'N'
2. @DETRAC = 'S', @DETRANS = 'N', @DETRANC = 'N'
3. @DETRAC = 'N', @DETRANS = 'S', @DETRANC = 'N'
4. @DETRAC = 'N', @DETRANS = 'N', @DETRANC = 'S'
*/
SELECT b.CodCon51,b.numuni54,b.cantid59,b.tamctr59, valcob59 = Sum(b.valcob59*b.uniser59)
FROM DDOrdSer58 a INNER Join DDDOrSer59 b ON a.numord58=b.numord58
WHERE a.Numcer58=@NUMCER and 
b.codcom50 IS null and 
a.flgval58='1' and 
b.valcob59<>0 and 
a.detrac58=@DETRAC and
isnull(a.dettrans,'N') = @DETRANS and
isnull(a.dettranc,'N') = @DETRANC
GROUP BY b.CodCon51,b.numuni54,b.cantid59,b.tamctr59

END
GO
/****** Object:  StoredProcedure [dbo].[TAR_SALDOS_NIVEL_CERTIFICADO]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.TAR_SALDOS_NIVEL_CERTIFICADO    Script Date: 08-09-2002 08:44:12 PM ******/
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
/****** Object:  StoredProcedure [dbo].[TAR_TARIFARIO]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_busca_certificado_factura]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_imprimir_anexo_solicitud_aduanera]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_imprimir_anexo_solicitud_simple]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER PROCEDURE [dbo].[usp_imprimir_anexo_solicitud_simple]  -- FMCR
--(@numsol CHAR(7))
--AS
--BEGIN
--
--SELECT
--a.numsol62,a.tipcli02,a.codcli02,a.codage19,a.obssol62,a.bultot62,
--NombreC=c.nombre,c.direccion,NombreA=d.nombre,
--g.numctr65,g.tamctr65
--FROM 
--DDSolSim62 a,AAClientesAA c,AAClientesAA d,DDCtrDep65 g
--WHERE 
--a.numsol62=@numsol and 
--a.tipcli02=c.claseabc and 
--a.codcli02=c.contribuy and 
--a.codage19*=d.cliente and 
--d.cliente<>'' and 
--a.numsol62 *= g.numsol62
--ORDER BY g.numctr65
--
--END
GO
/****** Object:  StoredProcedure [dbo].[USP_IMPRIMIR_RETIRO_LIBERACION_INMOV]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[USP_INSERTAR_CLIENTECRM]    Script Date: 10/03/2019 02:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_INSERTAR_CLIENTECRM]  
@CONTRIBUY VARCHAR(11)  
AS  
BEGIN 
 DECLARE @SECTOR INT
 SET @CONTRIBUY = LTRIM(RTRIM(@CONTRIBUY))  
  
 IF NOT EXISTS(SELECT *FROM TERMINAL.DBO.AACLIENTESAA A
			   INNER JOIN SECTOR_ECONOMICO B ON A.SECTOR = B.ID_SECTOR
			   WHERE A.CONTRIBUY = @CONTRIBUY)
 BEGIN
	SET @SECTOR = 0
 END
 
 IF NOT EXISTS (SELECT * FROM AACLIENTESAA WHERE CONTRIBUY = @CONTRIBUY )  
 BEGIN  
  insert into aaclientesaa  
  select   
  CLIENTE,  
  NOMBRE,  
  ALIAS,  
  CONTACTO,  
  CARGO,  
  substring(DIRECCION,1,90),  
  DISTRITO,  
  TELEFONO1,  
  TELEFONO2,  
  FAX,  
  CONTRIBUY,  
  FECHINGRES,  
  CLIENTEVIP,  
  MONEDA,  
  SALDO,  
  SALDODOLAR,  
  SALDOLOCAL,  
  SALDOCRED,  
  SALDONOCAR,  
  LIMITECRED,  
  EXCEDLIM,  
  TASAINTER,  
  TASAINTMOR,  
  FECHULTMOR,  
  FECHULTMOV,  
  @SECTOR,  
  NIVELPREC,  
  DESCUENTO,  
  CIUDAD,  
  PROVINCIA,  
  PAIS,  
  DEPARTAMENTO,  
  RUTA,  
  VENDEDOR,  
  COBRADOR,  
  ACEPTAFRAC,  
  ACTIVO,  
  EXENTOIMP,  
  EXENTOIMP1,  
  EXENTOIMP2,  
  COBROJUD,  
  CATCLIENTE,  
  CLASEABC,  
  DIASABAST,  
  USATARJETA,  
  TARJETACRE,  
  TIPOTARJ,  
  FECHVENTAR,  
  EMAIL,  
  REQUIEREOC,  
  TIENECONVE,  
  NOTAS,  
  DIASPROMAT,  
  CADENA,  
  apppasw,  
  relsucur,  
  relpwds,  
  Analista,  
  Customer,  
  credito,  
  FecVigCred,  
  CODAGEMAR,  
  CODAGECAR  
  from terminal.dbo.aaclientesaa WITH (NOLOCK)  
  where contribuy = @CONTRIBUY  
 END  
 ELSE  
 BEGIN  
  UPDATE AACLIENTESAA  
  SET   
  CLIENTE=A.CLIENTE,  
  NOMBRE=A.NOMBRE,  
  ALIAS=A.ALIAS,  
  CONTACTO=A.CONTACTO,  
  CARGO=A.CARGO,  
  DIRECCION=substring(A.DIRECCION,1,90),  
  DISTRITO=A.DISTRITO,  
  TELEFONO1=A.TELEFONO1,  
  TELEFONO2=A.TELEFONO2,  
  FAX=A.FAX,  
  FECHINGRES=A.FECHINGRES,  
  CLIENTEVIP=A.CLIENTEVIP,  
  MONEDA=A.MONEDA,  
  SALDO=A.SALDO,  
  SALDODOLAR=A.SALDODOLAR,  
  SALDOLOCAL=A.SALDOLOCAL,  
  SALDOCRED=A.SALDOCRED,  
  SALDONOCAR=A.SALDONOCAR,  
  LIMITECRED=A.LIMITECRED,  
  EXCEDLIM=A.EXCEDLIM,  
  TASAINTER=A.TASAINTER,  
  TASAINTMOR=A.TASAINTMOR,  
  FECHULTMOR=A.FECHULTMOR,  
  FECHULTMOV=A.FECHULTMOV,  
  SECTOR=@SECTOR,  
  NIVELPREC=A.NIVELPREC,  
  DESCUENTO=A.DESCUENTO,  
  CIUDAD=A.CIUDAD,  
  PROVINCIA=A.PROVINCIA,  
  PAIS=A.PAIS,  
  DEPARTAMENTO=A.DEPARTAMENTO,  
  RUTA=A.RUTA,  
  VENDEDOR=A.VENDEDOR,  
  COBRADOR=A.COBRADOR,  
  ACEPTAFRAC=A.ACEPTAFRAC,  
  ACTIVO=A.ACTIVO,  
  EXENTOIMP=A.EXENTOIMP,  
  EXENTOIMP1=A.EXENTOIMP1,  
  EXENTOIMP2=A.EXENTOIMP2,  
  COBROJUD=A.COBROJUD,  
  CATCLIENTE=A.CATCLIENTE,  
  CLASEABC=A.CLASEABC,  
  DIASABAST=A.DIASABAST,  
  USATARJETA=A.USATARJETA,  
  TARJETACRE=A.TARJETACRE,  
  TIPOTARJ=A.TIPOTARJ,  
  FECHVENTAR=A.FECHVENTAR,  
  EMAIL=A.EMAIL,  
  REQUIEREOC=A.REQUIEREOC,  
  TIENECONVE=A.TIENECONVE,  
  NOTAS=A.NOTAS,  
  DIASPROMAT=A.DIASPROMAT,  
  CADENA=A.CADENA,  
  apppasw=A.apppasw,  
  relsucur=A.relsucur,  
  relpwds=A.relpwds,  
  Analista=A.Analista,  
  Customer=A.Customer,  
  credito=A.credito,  
  FecVigCred=A.FecVigCred,  
  CODAGEMAR=A.CODAGEMAR,  
  CODAGECAR=A.CODAGECAR  
  from   
  AACLIENTESAA B   
  INNER JOIN terminal.dbo.aaclientesaa A  
  on B.CONTRIBUY = A.CONTRIBUY  
  where B.CONTRIBUY = @CONTRIBUY  
 END  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_REPORTE_MERCADERIA_INMOVILIZADA]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [dbo].[USP_REPORTE_SUSTENTO_DETRACCION]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [web].[BUSCAR_USER_SAAWEB]    Script Date: 10/03/2019 02:40:09 PM ******/
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
/****** Object:  StoredProcedure [web].[SP_CALCULA_PRODUC_NO_NACIONAL]    Script Date: 10/03/2019 02:40:09 PM ******/
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
