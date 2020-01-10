USE CM_E01

SELECT sys.Name0 AS 'Name'
	,sys.AD_Site_Name0 AS 'Site'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.User_Name0 AS 'Last Logon User'
	,sys.managedBy0 AS 'Managed by'
	,sys.Obsolete0 AS 'Obsolete'
	,sys.Operating_System_Name_and0 AS 'OS'
	,cs.LastMPServerName AS 'Management Point'
	,sys.Last_Logon_Timestamp0 AS 'Last Logon TIMESTAMP (AD)'
	,cs.ClientStateDescription AS 'Client State'
	,cs.LastHW AS 'Last Hardware Inventory'
	,cs.LastStatusMessage AS 'Last Status Message'
	,cs.LastPolicyRequest AS 'Last Policy Request'
	,cs.LastActiveTime AS 'Last Active Time'

FROM v_R_System AS sys
	LEFT JOIN v_CH_ClientSummary AS cs ON cs.ResourceID = sys.ResourceID

WHERE sys.Name0 = 'EVG01014NB'

ORDER BY sys.Name0
