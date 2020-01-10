USE CM_E01

DECLARE @PackageID nvarchar(30)
SET @PackageID = 'E01003CB'

SELECT tsp.name AS 'Task Sequence Name'
	,tsp.packageid AS 'Task Sequence ID'
	,tsr.referencename AS 'Package Name'
	,tsr.referencepackageid AS 'Package ID'

FROM v_tasksequenceReferencesInfo AS tsr
	JOIN v_tasksequencePackage AS tsp ON tsr.packageID = tsp.packageid

WHERE tsr.referencepackageid = @PackageID