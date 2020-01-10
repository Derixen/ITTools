USE CM_E01

SELECT WUA.Name0
	,WUA.Full_Domain_Name0
	,WUA.Operating_System_Name_and0
	,WUA.UpdateTitle
	,WUA.StateName
	,WUA.LastErrorCode
	,CASE WHEN WUA.IsDeployed = 1 THEN 'Deployed' ELSE 'Not Deployed' END AS 'Deployment'
	,CASE WHEN MAX(WUA.IsDeployedToThisComputer) = 1 THEN 'Assigned' ELSE 'Not assigned' END AS 'Update Assignment' 
	
FROM

(SELECT DISTINCT uss.Name0
	,uss.ResourceID
	,uss.Operating_System_Name_and0
	,uss.Full_Domain_Name0
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
		SELECT uci.CI_ID 
			,s.ResourceID
			,s.Operating_System_Name_and0
			,s.Full_Domain_Name0
			,uci.ArticleID
			,uci.BulletinID
			,ui.IsDeployed
			,s.Name0
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

	WHERE NOT (uss.StateType = 500 AND (uss.StateId = 1 OR uss.StateId = 3))

	GROUP BY uss.Name0
		,aliloc.[DisplayName]
		,uss.BulletinID
		,uss.ArticleID
		,loc.[DisplayName]
		,loc.CIInformativeURL
		,sn.StateName
		,uss.LastErrorCode
		,uss.IsDeployed
		,uss.ResourceID
		,uss.Operating_System_Name_and0
		,uss.Full_Domain_Name0
) AS WUA

--WHERE WUA.IsDeployedToThisComputer = 0

GROUP BY WUA.Name0
	,WUA.UpdateTitle
	,WUA.StateName
	,WUA.LastErrorCode
	,WUA.IsDeployed
	,WUA.Operating_System_Name_and0
	,WUA.Full_Domain_Name0
