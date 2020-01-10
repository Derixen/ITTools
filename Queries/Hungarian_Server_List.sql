Use CM_E01

SELECT sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.AD_Site_Name0 AS 'Site'
	,sys.User_Name0 AS 'Last Logon User'
	,sys.managedBy0 AS 'Managed by'
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
	,os.Caption0 AS 'OS'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
	ELSE 'Not Active' END AS 'Status'
	,ch.ClientStateDescription AS 'Client State'
	--,ch.LastMPServerName AS 'Management Point'
	,SWSCAN.LastScanDate
	,HWSCAN.LastHWScan

FROM v_R_System AS sys
 LEFT JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
 LEFT JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
 LEFT JOIN v_GS_LastSoftwareScan AS SWSCAN on SYS.ResourceID = SWSCAN.ResourceID
 LEFT JOIN v_GS_WORKSTATION_STATUS AS HWSCAN on SYS.ResourceID = HWSCAN.ResourceID
 LEFT JOIN v_CH_ClientSummary AS ch ON ch.ResourceID = sys.ResourceID

WHERE sys.Operating_System_Name_and0 like '%server%' and sys.AD_Site_Name0 in ('Budapest','Miskolc','S-HUBUD-04','Szeged')
