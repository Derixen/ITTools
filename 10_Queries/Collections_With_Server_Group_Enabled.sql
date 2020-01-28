USE CM_E01

SELECT CEP_CollectionExtendedProperties.CollectionID
	,Collections.SiteID
	,Collections.CollectionName

FROM CEP_CollectionExtendedProperties
	JOIN Collections on Collections.CollectionID = CEP_CollectionExtendedProperties.CollectionID

WHERE ISNULL( CEP_CollectionExtendedProperties.UseCluster, 0 ) = 1 