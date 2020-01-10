SELECT Distinct sys.Name0 AS 'Name'
		,IPSN.IP_Subnets0 as IP_Subnet
		,BD.DisplayName as Boundary
		,bg.Name as BoundaryGroup
	
	
FROM v_RA_System_IPSubnets AS IPSN
	inner join v_GS_COMPUTER_SYSTEM as Sys on ipsn.ResourceID = sys.ResourceID
	inner join vSMS_Boundary as BD on ipsn.IP_Subnets0 = bd.Value
	inner join vSMS_BoundaryGroupMembers as BGM on BGM.BoundaryID = bd.BoundaryID
	inner join vSMS_BoundaryGroup as BG on bg.GroupID = bgm.GroupID

WHERE sys.name0 like 'evr01303nb'


ORDER BY sys.Name0