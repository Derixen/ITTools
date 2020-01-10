USE CM_E01

IF OBJECT_ID('tempdb..#TempTable01') IS NOT NULL DROP TABLE #TempTable01

SELECT sys.name0 AS 'Name'
	,sys.siemensResponsible0 AS SiemensResponsible
	,os.Caption0 AS 'OS'
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
	,CAST(SUM(CASE WHEN sn.StateName = 'Detection state unknown' THEN 1 ELSE 0 END) AS float) AS 'DetectionStateUnknown'
	,CAST(SUM(CASE WHEN sn.StateName = 'Update is not required' THEN 1 ELSE 0 END) AS float) AS 'UpdatesNotRequired'
	,CAST(SUM(CASE WHEN sn.StateName = 'Update is required' THEN 1 ELSE 0 END) AS float) AS 'UpdatesRequired'
	,CAST(SUM(CASE WHEN sn.StateName = 'Update is installed' THEN 1 ELSE 0 END) AS float) AS 'UpdatesInstalled'
	,CAST(SUM(CASE WHEN sn.StateName = 'Update is required' and ui.IsDeployed = 1 THEN 1 ELSE 0 END) AS float) AS 'UpdatesRequiredDeployed'
	,CAST(COUNT(*) AS float) AS 'Total'

INTO #TempTable01
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
	,sys.siemensResponsible0
	,cs.Manufacturer0
	,cs.Model0
	,os.Caption0

SELECT *
	,CAST(ROUND(CASE WHEN UpdatesRequired = 0 THEN 100 ELSE 100-(UpdatesRequired/((UpdatesInstalled + UpdatesRequired)/100)) END,2) AS varchar) + '%' AS 'Compliance' 

FROM #TempTable01