USE CM_E01

SELECT CG.CollectionName AS 'Collection Name'
	,CG.SITEID AS 'Collection ID'
	,CASE VC.CollectionType
		WHEN 0 THEN 'Other'
		WHEN 1 THEN 'User'
		WHEN 2 THEN 'Device'
		ELSE 'Unknown' END AS 'Collection Type'
	,vc.ObjectPath AS 'Path'
	,CASE
		WHEN CG.Schedule like '%0102000%' THEN 'Every 1 minute'
		WHEN CG.Schedule like '%010A000%' THEN 'Every 5 mins'
		WHEN CG.Schedule like '%0114000%' THEN 'Every 10 mins'
		WHEN CG.Schedule like '%011E000%' THEN 'Every 15 mins'
		WHEN CG.Schedule like '%0128000%' THEN 'Every 20 mins'
		WHEN CG.Schedule like '%0132000%' THEN 'Every 25 mins'
		WHEN CG.Schedule like '%013C000%' THEN 'Every 30 mins'
		WHEN CG.Schedule like '%0150000%' THEN 'Every 40 mins'
		WHEN CG.Schedule like '%015A000%' THEN 'Every 45 mins'
		WHEN CG.Schedule like '%0100100%' THEN 'Every 1 hour'
		WHEN CG.Schedule like '%0100200%' THEN 'Every 2 hours'
		WHEN CG.Schedule like '%0100300%' THEN 'Every 3 hours'
		WHEN CG.Schedule like '%0100400%' THEN 'Every 4 hours'
		WHEN CG.Schedule like '%0100500%' THEN 'Every 5 hours'
		WHEN CG.Schedule like '%0100600%' THEN 'Every 6 hours'
		WHEN CG.Schedule like '%0100700%' THEN 'Every 7 hours'
		WHEN CG.Schedule like '%0100B00%' THEN 'Every 11 Hours'
		WHEN CG.Schedule like '%0100C00%' THEN 'Every 12 Hours'
		WHEN CG.Schedule like '%0101000%' THEN 'Every 16 Hours'
		WHEN CG.Schedule like '%0100008%' THEN 'Every 1 days'
		WHEN CG.Schedule like '%0100010%' THEN 'Every 2 days'
		WHEN CG.Schedule like '%0100028%' THEN 'Every 5 days'
		WHEN CG.Schedule like '%0100038%' THEN 'Every 7 Days'
		WHEN CG.Schedule like '%0192000%' THEN '1 week'
		WHEN CG.Schedule like '%0080000%' THEN 'Update Once'
		WHEN CG.SChedule = '' THEN 'Manual'
		ELSE 'Unknown' END AS 'Update Schedule'
	,CASE VC.RefreshType
		WHEN 1 THEN 'Manual'
		WHEN 2 THEN 'Scheduled'
		WHEN 4 THEN 'Incremental'
		WHEN 6 THEN 'Scheduled and Incremental'
		ELSE 'Unknown' END AS 'RefreshType'
	,VC.MemberCount AS 'Member Count'
	,(SELECT COUNT(CollectionID) FROM v_CollectionRuleQuery CRQ WHERE CRQ.CollectionID = VC.SiteID) AS 'RuleQueryCount'
	,(SELECT COUNT(CollectionID) FROM v_CollectionRuleDirect CRD WHERE CRD.CollectionID = VC.SiteID) AS 'RuleDirectCount'

FROM collections_g AS CG
	LEFT JOIN v_collections AS VC on VC.SiteID = CG.SiteID

ORDER BY CG.Schedule DESC