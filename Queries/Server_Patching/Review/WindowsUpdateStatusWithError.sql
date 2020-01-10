USE CM_E01

DECLARE @ComputerName nvarchar(30)
DECLARE @ComputerID nvarchar(30)

--Itt add meg keresett gép nevét evh05463ws EVH04267WS
SET @ComputerName = 'EVH06545NB'

SELECT WUA.Name0
	,WUA.UpdateTitle
	,WUA.StateName
	,WUA.LastErrorCode
	,CASE WHEN WUA.IsDeployed = 1 THEN 'Available' ELSE 'Not Available' END AS 'Deployment'
	,CASE WHEN MAX(WUA.IsDeployedToThisComputer) = 1 THEN 'Assigned' ELSE 'Not assigned' END AS 'Update Assignment' 
	
FROM

(SELECT DISTINCT uss.Name0
	,aliloc.DisplayName As SoftwareUpdateGroup
	,uss.BulletinID
	,uss.ArticleID
	,loc.DisplayName AS 'UpdateTitle'
	,loc.CIInformativeURL As 'InfoURL'
	,sn.StateName
	,uss.LastErrorCode
	,uss.IsDeployed
	,CAST(MAX(CASE WHEN cm.MachineID IS NOT NULL THEN 1 ELSE 0 END) AS int) AS IsDeployedToThisComputer

	FROM
	(
		SELECT uci.CI_ID, s.ResourceID, uci.ArticleID, uci.BulletinID, ui.IsDeployed, s.Name0
			, CASE
				WHEN cs.[Status] = 2 AND LastEnforcementMessageID > 0 THEN 402
				WHEN ISNULL(cs.Status, case when ss.ScanPackageVersion>=uci.MinSourceVersion then 1 else 0 end) != 2 OR LastEnforcementMessageID IS NULL or LastEnforcementMessageID = 0 THEN 500
			END As StateType
			, CASE
				WHEN cs.[Status] = 2 AND LastEnforcementMessageID > 0 THEN LastEnforcementMessageID
				WHEN ISNULL(cs.Status, case when ss.ScanPackageVersion>=uci.MinSourceVersion then 1 else 0 end) != 2 OR LastEnforcementMessageID IS NULL or LastEnforcementMessageID = 0 THEN ISNULL(cs.Status, case when ss.ScanPackageVersion>=uci.MinSourceVersion then 1 else 0 end)
			END As StateId
			, CASE
				WHEN cs.[Status] = 2 AND LastEnforcementMessageID > 0 THEN LastEnforcementMessageTime
				WHEN ISNULL(cs.Status, case when ss.ScanPackageVersion>=uci.MinSourceVersion then 1 else 0 end) != 2 OR LastEnforcementMessageID IS NULL or LastEnforcementMessageID = 0 THEN ISNULL(cs.LastStatusCheckTime, ss.ScanTime)
			END As StateTime
			, cs.LastErrorCode
		FROM CI_UpdateCIs uci
		INNER JOIN CI_ConfigurationItems (NOLOCK) AS ci ON uci.CI_ID = ci.CI_ID AND ci.CIType_ID IN (1, 8) AND ci.IsHidden = 0 AND ci.IsTombstoned = 0
		INNER JOIN Update_ComplianceStatus cs ON uci.CI_ID = cs.CI_ID AND cs.[Status] > 0
		INNER JOIN v_UpdateInfo ui on cs.CI_ID = ui.CI_ID
		LEFT JOIN v_R_System s ON cs.MachineID = s.ResourceID
		INNER JOIN Update_ScanStatus ss ON uci.UpdateSource_ID = ss.UpdateSource_ID AND s.ResourceID = ss.MachineID
	) AS uss
	INNER JOIN v_CIRelation cr ON uss.CI_ID = cr.ToCIID
	INNER JOIN CI_ConfigurationItems ali ON cr.FromCIID = ali.CI_ID AND ali.IsHidden=0 AND ali.CIType_ID=9
	INNER JOIN v_LocalizedCIProperties_SiteLoc aliloc on ali.CI_ID = aliloc.CI_ID
	INNER JOIN v_StateNames sn ON uss.StateType = sn.TopicType AND uss.StateID = sn.StateID
	INNER JOIN CI_AssignmentTargetedCIs (NOLOCK) atci ON uss.CI_ID = atci.CI_ID
	INNER JOIN CI_CIAssignments (NOLOCK) a ON atci.AssignmentID = a.AssignmentID
	INNER JOIN Collections_G (NOLOCK) c ON a.TargetCollectionID = c.CollectionID
	LEFT JOIN CollectionMembers (NOLOCK) cm ON c.SiteID = cm.SiteID AND cm.MachineID = uss.ResourceID
	INNER JOIN v_LocalizedCIProperties_SiteLoc loc ON uss.CI_ID = loc.CI_ID

	WHERE NOT (uss.StateType = 500 AND (uss.StateId = 1 OR uss.StateId = 3)) and uss.Name0 = @ComputerName 

	GROUP BY uss.Name0
		,aliloc.[DisplayName]
		,uss.BulletinID
		,uss.ArticleID
		,loc.[DisplayName]
		,loc.CIInformativeURL
		,sn.StateName
		,uss.LastErrorCode
		,uss.IsDeployed
) AS WUA

--WHERE WUA.IsDeployedToThisComputer = 1

GROUP BY WUA.Name0
	,WUA.UpdateTitle
	,WUA.StateName
	,WUA.LastErrorCode
	,WUA.IsDeployed


SELECT sys.name0 AS 'Name'
	,sys.Resource_Domain_OR_Workgr0 AS 'Domain'
	,os.Caption0 AS 'OS'
	,SUM(CASE WHEN sn.StateName = 'Detection state unknown' THEN 1 ELSE 0 END) AS 'Detection state unknown'
	,SUM(CASE WHEN sn.StateName = 'Update is not required' THEN 1 ELSE 0 END) AS 'Update is not required'
	,SUM(CASE WHEN sn.StateName = 'Update is required' and ui.IsDeployed = 1 THEN 1 ELSE 0 END) AS 'Update is required'
	,SUM(CASE WHEN sn.StateName = 'Update is installed' THEN 1 ELSE 0 END) AS 'Update is installed'
	--,SUM(CASE WHEN sn.StateName = 'Update is required' THEN 1 ELSE 0 END) AS 'Update is required'
	,COUNT(*) AS 'Total'

FROM v_R_System AS sys
	JOIN v_Update_ComplianceStatusAll AS UCS ON sys.ResourceID = UCS.ResourceID
	join v_UpdateInfo ui on UCS.CI_ID = ui.CI_ID and ui.IsUserDefined = 0
	JOIN v_StateNames AS SN ON SN.TopicType = 500 and sn.StateID = UCS.Status
	left JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID

WHERE sys.name0 = @ComputerName
	AND sys.Active0 = 1
	and ui.IsUserDefined = 0
	--and ui.IsSuperseded = 0
	--and ui.Title in (select title from v_UpdateInfo where IsDeployed = 1 )

GROUP BY sys.name0
	,sys.Resource_Domain_OR_Workgr0
	,os.Caption0