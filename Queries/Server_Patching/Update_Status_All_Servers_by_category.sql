USE CM_E01

SELECT sys.name0 AS 'Name'
	--,sys.managedBy0 AS 'Managed By'
	,os.Caption0 AS 'OS'
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
	,SUM(CASE WHEN sn.StateName = 'Detection state unknown' THEN 1 ELSE 0 END) AS 'Detection state unknown'
	,SUM(CASE WHEN sn.StateName = 'Update is not required' THEN 1 ELSE 0 END) AS 'Update is not required'
	,SUM(CASE WHEN sn.StateName = 'Update is required' THEN 1 ELSE 0 END) AS 'Update is required'
	,SUM(CASE WHEN sn.StateName = 'Update is installed' THEN 1 ELSE 0 END) AS 'Update is installed'
	--,SUM(CASE WHEN sn.StateName = 'Update is required' and ui.IsDeployed = 1 THEN 1 ELSE 0 END) AS 'Update is required (Deployed)'
	,COUNT(*) AS 'Total'

FROM v_Update_ComplianceStatusAll AS UCS
	--JOIN v_UpdateInfo AS ui on UCS.CI_ID = ui.CI_ID
	JOIN v_CICategories_All AS catall2 on catall2.CI_ID = UCS.CI_ID
	JOIN v_CategoryInfo AS cat ON cat.categoryinstance_uniqueID = catall2.categoryinstance_uniqueID
	JOIN v_StateNames AS SN ON SN.TopicType = 500 and sn.StateID = UCS.Status
	JOIN v_R_System AS sys ON sys.ResourceID = UCS.ResourceID
	LEFT JOIN v_GS_COMPUTER_SYSTEM AS cs ON cs.ResourceID = sys.resourceID
	LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID

WHERE sys.Active0 = 1 
	and sys.Operating_System_Name_and0 like '%server%'
	and cat.categoryinstancename in ('Critical Updates','Security Updates','Updates','Update Rollups','Definition Updates')

GROUP BY sys.name0
	,cs.Manufacturer0
	,cs.Model0
	,os.Caption0

ORDER BY 'Update is required' DESC

/* LIST ALL UPADETE CATEGORIES
select CategoryInstanceName 
from v_CategoryInfo 
where categorytypename like 'UpdateClassification' 
Order by CategoryInstanceName
*/