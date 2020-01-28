USE CM_E01

SELECT col.SiteID AS 'Collection ID'
	,col.CollectionName AS 'Collection Name'
	,col.MemberCount AS 'Member Count'
	,col.IncludeExcludeCollectionsCount AS 'Collection Members'
	,SUM(CASE WHEN cr.RuleType = 1 THEN 1 ELSE 0 END) AS 'Direct Members'
	,col.LimitToCollectionID AS 'Limited to Collection ID'
	,col.LimitToCollectionName AS 'Limited to Collection Name'
	,col.ObjectPath AS 'Console Path'

FROM vCollections AS col
	LEFT JOIN Collection_Rules AS cr ON cr.CollectionID = col.CollectionID
WHERE
	col.MemberCount=0

GROUP BY col.SiteID
	,col.CollectionName
	,col.MemberCount
	,col.IncludeExcludeCollectionsCount
	,col.LimitToCollectionID
	,col.LimitToCollectionName
	,col.ObjectPath