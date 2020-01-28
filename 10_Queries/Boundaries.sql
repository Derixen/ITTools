USE CM_E01

SELECT DisplayName
	,SiteSystemName
	,DefaultSiteCode

FROM vSMS_Boundary
	INNER JOIN v_BoundarySiteCode ON vSMS_Boundary.BoundaryID = v_BoundarySiteCode.BoundaryID 
	LEFT OUTER JOIN v_BoundarySiteSystems ON v_BoundarySiteCode.BoundaryID = v_BoundarySiteSystems.BoundaryID

ORDER BY DisplayName
