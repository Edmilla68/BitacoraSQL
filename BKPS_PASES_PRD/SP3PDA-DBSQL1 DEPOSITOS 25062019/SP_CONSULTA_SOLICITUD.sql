

CREATE PROCEDURE [dbo].[SP_CONSULTA_SOLICITUD] @NUMSOL CHAR(7)

AS

SELECT a.*

	,NombreC = b.nombre

	,NombreA = c.nombre

	,d.desemb06

	,NombreT = e.Nombre

	,f.despai07

	,g.despue02

	,h.desnav08

	,i.codalm99

	,j.desalm99

	,isnull(de20, '') AS de20c

	,isnull(de40, '') AS de40c

	,isnull(cgsuelta10, '0') AS cgsuelta10c

	,NroDetalle = isnull(a.nrodetalle10, '')

FROM DDSolAdu10 a

	,AAClientesAA b

	,AAClientesAA c

	,DQEmbala06 d

	,AAClientesAA e

	,Descarga..DQPAISES07 f

	,Descarga..DQPUERTO02 g

	,Descarga..DQNAVIER08 h

	,DDAlmExp99 i

	,DQAlmDep99 j

WHERE a.numsol10 = @NUMSOL

	AND a.tipcli02 = b.claseabc

	AND a.codcli02 = b.contribuy

	AND a.codage19 = c.cliente

	AND a.codemb06 = d.codemb06

	AND a.CodEmp04 = e.contribuy

	AND a.codpai07 = f.codpai07

	AND a.codpue03 = g.codpue02

	AND a.codnav08 = h.codnav08

	AND a.numsol10 = i.numsol99

	AND i.codalm99 = j.codalm99


