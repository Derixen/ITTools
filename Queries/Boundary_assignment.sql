USE CM_E01

SELECT GroupName.Name AS 'Boundary Group'
	,count(ip_subnets0) AS 'Machine Count'

FROM v_RA_System_IPSubnets
	LEFT JOIN vSMS_Boundary AS bondary ON v_RA_System_IPSubnets.ip_subnets0 = bondary.Value
	LEFT JOIN vSMS_BoundaryGroupMembers AS GroupMembers on bondary.BoundaryID = GroupMembers.BoundaryID 
	LEFT JOIN vSMS_BoundaryGroup AS GroupName ON GroupMembers.GroupID = GroupName.GroupID 

GROUP BY GroupName.Name

ORDER BY 'Machine Count' DESC