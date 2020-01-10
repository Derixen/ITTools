Use CM_E01

SELECT sys.Name0 AS 'Host Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.User_Name0 AS 'Last Logon User'
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
	,os.Caption0 AS 'OS'
	,sys.Last_Logon_Timestamp0 AS 'Last Logon TIMESTAMP (AD)'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
		ELSE 'Not Active' END AS 'SCCM Client Status'
	,CASE WHEN sys.Obsolete0 = 1 THEN 'Yes'
		ELSE 'No' END AS 'Obsolete'
	,ch.LastMPServerName AS 'Management Point'
	,ch.ClientStateDescription AS 'Client State'
	,ch.LastHW AS 'Last Hardware Inventory'
	,ch.LastStatusMessage AS 'Last Status Message'
	,ch.LastPolicyRequest AS 'Last Policy Request'
	,ch.LastActiveTime AS 'Last Active Time'

FROM v_R_System AS sys
	JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
	JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
	LEFT JOIN v_CH_ClientSummary AS ch ON ch.ResourceID = sys.ResourceID