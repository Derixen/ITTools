USE CM_E01

DECLARE @CollectionID nvarchar(30)
SET @CollectionID = 'E010079D'

SELECT col.SiteID AS 'Collection ID'
	,col.CollectionName AS 'Collection Name'
	,col.MemberCount AS 'Member Count'
	,col.IncludeExcludeCollectionsCount AS 'Collection Members'
	,SUM(CASE WHEN cr.RuleType = 1 THEN 1 ELSE 0 END) AS 'Direct Members'
	,col.LimitToCollectionID AS 'Limited to Collection ID'
	,col.LimitToCollectionName AS 'Limited to Collection Name'
	,col.ObjectPath AS 'Console Path'

FROM vCollections AS col
	JOIN Collection_Rules AS cr ON cr.CollectionID = col.CollectionID

WHERE col.SiteID = @CollectionID

GROUP BY col.SiteID
	,col.CollectionName
	,col.MemberCount
	,col.IncludeExcludeCollectionsCount
	,col.LimitToCollectionID
	,col.LimitToCollectionName
	,col.ObjectPath

	
SELECT col.SiteID AS 'Collection ID'
	,col.CollectionName AS 'Collection Name'
	,CASE RuleType
		WHEN 1 THEN 'Direct Rule'
		WHEN 2 THEN 'Query Rule'
		WHEN 3 THEN 'Include Collection'
		WHEN 4 THEN 'Exclude Collection'
		ELSE 'Device Rule' 
	END AS 'Rule Type'
	,cr.QueryName AS 'Member Name'
	,CASE WHEN RuleType = 1 THEN CAST(cr.MachineID AS nvarchar(30) )
		WHEN RuleType = 2 THEN 'n/a'
		WHEN Ruletype in (3,4) THEN col2.SiteID END AS 'Member ID'
,*
FROM vCollections AS col
	JOIN Collection_Rules AS cr ON cr.CollectionID = col.CollectionID
	LEFT JOIN (SELECT SiteID, CollectionName FROM vCollections) AS col2 ON col2.CollectionName = cr.QueryName

WHERE col.SiteID = @CollectionID

ORDER BY cr.RuleType DESC, cr.QueryName