 USE CM_E01
 

USE CM_E01

DECLARE @ComputerName nvarchar(30)
SET @ComputerName = 'evh08669NB'

SELECT pkg.PackageName
	,pkg.MemberCount
	,*
FROM v_Collection AS COL
	JOIN v_FullCollectionMembership AS FCM ON COL.CollectionID = FCM.CollectionID
	JOIN (
		 SELECT DISTINCT v_Package.PackageID
			,v_Package.Name AS 'PackageName'
			,CASE
				WHEN v_Package.PackageType = 0 THEN 'Software Distribution Package'
				WHEN v_Package.PackageType = 3 THEN 'Driver Package'
				WHEN v_Package.PackageType = 4 THEN 'Task Sequence Package'
				WHEN v_Package.PackageType = 5 THEN 'Software Update Package'
				WHEN v_Package.PackageType = 6 THEN 'Device Setting Package'
				WHEN v_Package.PackageType = 7 THEN 'Virtual Package'
				WHEN v_Package.PackageType = 8 THEN 'Application'
				WHEN v_Package.PackageType = 257 THEN 'Image Package'
				WHEN v_Package.PackageType = 258 THEN 'Boot Image Package'
				WHEN v_Package.PackageType = 259 THEN 'Operating System Install Package' 
			ELSE 'Unknown' END AS 'PackageType'
			,v_Package.PkgSourcePath AS 'Path'
			,v_DeploymentSummary.SoftwareName
			,v_AdvertisementInfo.AdvertisementID
			,CASE
				WHEN v_DeploymentSummary.DeploymentIntent = 1 THEN 'Required'
				WHEN v_DeploymentSummary.DeploymentIntent = 2 THEN 'Available'
			ELSE 'Unknown' END AS 'DeploymentIntent'
			,v_Collection.CollectionID
			,v_Collection.Name AS 'CollectionName'
			,v_Collection.MemberCount
			,v_DeploymentSummary.AssignmentID


		FROM v_Package
			LEFT JOIN v_DeploymentSummary ON v_Package.PackageID = v_DeploymentSummary.PackageID
			INNER JOIN v_CollectiON ON v_DeploymentSummary.CollectionID = v_Collection.CollectionID
			LEFT JOIN v_AdvertisementInfo ON v_AdvertisementInfo.PackageID = v_Package.PackageID
			LEFT JOIN  v_CollectionRuleQuery ON v_CollectionRuleQuery.CollectionID = v_Collection.CollectionID
			
		) AS pkg ON pkg.CollectionID = COL.CollectionID

WHERE FCM.Name like '%' + @ComputerName + '%'

ORDER BY 1--PackageName