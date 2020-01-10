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
	,SUM(CASE WHEN sn.StateName = 'Update is required' and ui.IsDeployed = 1 THEN 1 ELSE 0 END) AS 'Update is required (Deployed)'
	,COUNT(*) AS 'Total'

FROM v_R_System AS sys
	JOIN v_Update_ComplianceStatusAll AS UCS ON sys.ResourceID = UCS.ResourceID
	JOIN v_UpdateInfo AS ui on UCS.CI_ID = ui.CI_ID and ui.IsUserDefined = 0
	JOIN v_StateNames AS SN ON SN.TopicType = 500 and sn.StateID = UCS.Status
	LEFT JOIN v_GS_COMPUTER_SYSTEM AS cs ON cs.ResourceID = sys.resourceID
	LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID
	JOIN v_FullCollectionMembership AS fcm on fcm.ResourceID = sys.ResourceID

WHERE sys.Active0 = 1
	--and sys.Operating_System_Name_and0 like '%server%'
	and fcm.CollectionID = 'CAS00234'

GROUP BY sys.name0
	,cs.Manufacturer0
	,cs.Model0
	,os.Caption0

ORDER BY 'Update is required (Deployed)' DESC