USE CM_E01
SET ANSI_WARNINGS OFF;

SELECT sys.name0 AS 'Name' , MAX (OS.Caption0) AS OS, MAX (OS.BuildNumber0 )AS 'OS Build'
	,SUM(CASE WHEN sn.StateName = 'Update is required' THEN 1 ELSE 0 END) AS 'Update is required'
	,SUM(CASE WHEN sn.StateName = 'Update is installed' THEN 1 ELSE 0 END) AS 'Update is installed'
	,SUM(CASE WHEN sn.StateName = 'Update is required' and ui.IsDeployed = 1 THEN 1 ELSE 0 END) AS 'Update is required (Deployed)'
	--,(STR((SUM(CASE WHEN UCS2.status=3 THEN 1 ELSE 0 END) *100.0/SUM(CASE WHEN ((UCS2.status=2) or (UCS2.status=3)) THEN 1 ELSE 0 END) ),5)) + '%' AS 'Compliance'
	,(STR((SUM(CASE WHEN sn.StateName = 'Update is installed' THEN 1 ELSE 0 END) *100.0/SUM(CASE WHEN ((sn.StateName = 'Update is required') or (sn.StateName = 'Update is installed')) THEN 1 ELSE 0 END) ),5)) + '%' AS 'Compliance'
	,MAX (sys.Active0) AS 'Client is Active'
	,MAX (sys.Client_Version0) AS 'Client Version'
	,MAX (sys.siemensResponsible0) AS SiemensResponsible
	,MAX (lss.LastScanDate) AS 'Last Inventory date'
		
FROM v_R_System AS sys
	JOIN v_Update_ComplianceStatusAll AS UCS ON sys.ResourceID = UCS.ResourceID
	--JOIN v_UpdateComplianceStatus AS UCS2 on sys.ResourceID = UCS2.ResourceID
	join v_UpdateInfo ui on UCS.CI_ID = ui.CI_ID and ui.IsUserDefined = 0
	JOIN v_StateNames AS SN ON SN.TopicType = 500 and sn.StateID = UCS.Status
	JOIN v_Gs_Operating_System OS on sys.resourceid = OS.ResourceID
	Join v_GS_LastSoftwareScan LSS on sys.resourceid = LSS.ResourceID

WHERE sys.Operating_System_Name_and0 like '%Server%' 
	and (  sys.AD_Site_Name0 = 'Nuernberg' or sys.AD_Site_Name0 = 'H-DEMCH-01' or sys.AD_Site_Name0 like 'S-DE%' or sys.AD_Site_Name0 = 'S-ATENT-01')

GROUP BY sys.name0
ORDER BY 'Update is required' DESC