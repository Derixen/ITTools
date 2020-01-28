 USE CM_E01
 
 SELECT DISTINCT v_Package.PackageID
    ,v_Package.Name AS 'Package Name'
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
    ELSE 'Unknown' END AS 'Package Type'
	,v_Package.PkgSourcePath AS 'PAth'
    ,v_DeploymentSummary.SoftwareName
    ,v_AdvertisementInfo.AdvertisementID
    ,CASE
        WHEN v_DeploymentSummary.DeploymentIntent = 1 THEN 'Required'
        WHEN v_DeploymentSummary.DeploymentIntent = 2 THEN 'Available'
    ELSE 'Unknown' END AS 'Deployment Intent'
    ,v_Collection.CollectionID
    ,v_Collection.Name AS 'Collection Name'
    ,v_Collection.MemberCount
    ,v_DeploymentSummary.AssignmentID
    ,v_DeploymentSummary.ModelID
	,CASE WHEN v_CollectionRuleQuery.QueryExpression like '%EVOSOFT\%' THEN SUBSTRING(v_CollectionRuleQuery.QueryExpression, CHARINDEX('EVOSOFT\',v_CollectionRuleQuery.QueryExpression),LEN(v_CollectionRuleQuery.QueryExpression) - CHARINDEX('EVOSOFT\',v_CollectionRuleQuery.QueryExpression)-1) 
	WHEN v_CollectionRuleQuery.QueryExpression like '%AD001\%' THEN SUBSTRING(v_CollectionRuleQuery.QueryExpression, CHARINDEX('AD001\',v_CollectionRuleQuery.QueryExpression),LEN(v_CollectionRuleQuery.QueryExpression) - CHARINDEX('AD001\',v_CollectionRuleQuery.QueryExpression)-1) 
	ELSE '-' END AS 'AD Install Group'
	,ISNULL(c.SecurityGroup,'-') AS 'AD Exclude Group'

FROM v_Package
    LEFT JOIN v_DeploymentSummary ON v_Package.PackageID = v_DeploymentSummary.PackageID
    INNER JOIN v_CollectiON ON v_DeploymentSummary.CollectionID = v_Collection.CollectionID
    LEFT JOIN v_AdvertisementInfo ON v_AdvertisementInfo.PackageID = v_Package.PackageID
	LEFT JOIN  v_CollectionRuleQuery ON v_CollectionRuleQuery.CollectionID = v_Collection.CollectionID
	LEFT JOIN (SELECT DISTINCT cr.CollectionID
		,CASE WHEN crq.QueryExpression like '%EVOSOFT\%' THEN SUBSTRING(crq.QueryExpression, CHARINDEX('EVOSOFT\',crq.QueryExpression),LEN(crq.QueryExpression) - CHARINDEX('EVOSOFT\',crq.QueryExpression)-1) 
		WHEN crq.QueryExpression like '%AD001\%' THEN SUBSTRING(crq.QueryExpression, CHARINDEX('AD001\',crq.QueryExpression),LEN(crq.QueryExpression) - CHARINDEX('AD001\',crq.QueryExpression)-1) 
		ELSE 'N/A' END AS 'SecurityGroup'
	
		FROM Collection_Rules AS cr
			LEFT JOIN v_CollectionRuleQuery AS crq ON crq.CollectionID = cr.ReferencedCollectionID

		WHERE cr.ruletype in (4) ) AS c ON c.CollectionID = v_CollectiON.CollID AND c.SecurityGroup <> 'N/A'
 
Where v_Package.Name like '7-Zip 18.05%'


ORDER BY v_Package.Name

SELECT app.DisplayName AS ApplicationName,
    dt.DisplayName AS DeploymentTypeName,
    dt.PriorityInLatestApp, dt.Technology
	,*
FROM dbo.fn_ListDeploymentTypeCIs(1033) AS dt INNER JOIN
    dbo.fn_ListLatestApplicationCIs(1033) AS app ON dt.AppModelName = app.ModelName
WHERE (dt.IsLatest = 1) 
 and app.DisplayName like '7-Zip 18.05%'
order by ApplicationName



