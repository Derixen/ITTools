USE CM_E01

SELECT sys.name0 AS 'Name'
	,MAX (sys.Operating_System_Name_and0) AS OS
	,MAX (sys.Resource_Domain_OR_Workgr0) As Domain
	,SUM(CASE WHEN sn.StateName = 'Update is required' THEN 1 ELSE 0 END) AS 'Update is required'
	,SUM(CASE WHEN sn.StateName = 'Update is installed' THEN 1 ELSE 0 END) AS 'Update is installed'
	,SUM(CASE WHEN sn.StateName = 'Update is required' and ui.IsDeployed = 1 THEN 1 ELSE 0 END) AS 'Update is required (Deployed)'
	,MAX (sys.Active0) AS 'Client is Active'
	,MAX (sys.Client_Version0) AS 'Client Version'
	,MAX (sys.siemensResponsible0) AS SiemensResponsible
	
FROM v_R_System AS sys
	JOIN v_Update_ComplianceStatusAll AS UCS ON sys.ResourceID = UCS.ResourceID
	join v_UpdateInfo ui on UCS.CI_ID = ui.CI_ID and ui.IsUserDefined = 0
	JOIN v_StateNames AS SN ON SN.TopicType = 500 and sn.StateID = UCS.Status

WHERE sys.Operating_System_Name_and0 like '%Server%' 
	and (  sys.AD_Site_Name0 = 'Nuernberg' or sys.AD_Site_Name0 = 'H-DEMCH-01' or sys.AD_Site_Name0 like 'S-DE%' or sys.AD_Site_Name0 = 'S-ATENT-01')
	AND sys.Active0 = 1

GROUP BY sys.name0
ORDER BY 'Update is required' DESC