USE CM_E01

select cr.QueryName AS 'Collection Name'
	,cr.ReferencedCollectionID AS 'Collection ID'
	,c.CollectionName AS 'Excluded from - Name'
	,c.SiteID AS 'Excluded from - ID'

from Collection_Rules as cr
	join vCollections as c on c.CollectionID = cr.CollectionID

where RuleType = 4 
	and QueryName = 'COLLECTIONQUERYNAME'