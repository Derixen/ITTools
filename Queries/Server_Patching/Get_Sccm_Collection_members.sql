SELECT distinct sys.name0 AS 'Name'
	,sys.Resource_Domain_OR_Workgr0 AS Domain
	,os.Caption0 AS 'OS'
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
	,SUBSTRING(left(sys.managedBy0, charindex(',', sys.managedBy0)-1),4,len(sys.managedBy0)) as 'ManagedBy'
	--,ip.IP_Addresses0 AS IPv4
	,sys.Distinguished_Name0 As DN_name

FROM v_R_System AS sys
	LEFT JOIN v_GS_COMPUTER_SYSTEM AS cs ON cs.ResourceID = sys.resourceID
	LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID
	JOIN v_FullCollectionMembership AS fcm on fcm.ResourceID = sys.ResourceID
	join v_RA_System_IPAddresses AS Ip on ip.ResourceID = sys.ResourceID

WHERE sys.Active0 = 1
	and fcm.CollectionID = 'CAS0026F'
	-----CAS0023A HU, CAS00234   DE----- -CAS000A8 test servers