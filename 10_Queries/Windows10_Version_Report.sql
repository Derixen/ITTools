Use CM_E01

DECLARE @ComputerName nvarchar(30)
SET @ComputerName = 'COMPUTER01'

SELECT sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.User_Name0 AS 'Last Logon User'
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
	,os.Caption0 AS 'OS'
	,CASE os.Version0
		WHEN '10.0.10240' THEN '1507'
		WHEN '10.0.10586' THEN '1511'
		WHEN '10.0.14393' THEN '1607'
		WHEN '10.0.15063' THEN '1703'
		WHEN '10.0.16299' THEN '1709'
		WHEN '10.0.17134' THEN '1803'
		WHEN '10.0.17763' THEN '1809'
		WHEN '10.0.18362' THEN '1903'
		ELSE 'Unknown' END AS 'Version'
	--,os.Version0 AS 'Version'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
	ELSE 'Not Active' END AS 'Status'
	,ch.ClientStateDescription AS 'Client State'
	--,ch.LastMPServerName AS 'Management Point'
	,SWSCAN.LastScanDate
	,HWSCAN.LastHWScan
	,*

FROM v_R_System AS sys
 left JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
 left JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
 LEFT JOIN v_GS_LastSoftwareScan AS SWSCAN on SYS.ResourceID = SWSCAN.ResourceID
 LEFT JOIN v_GS_WORKSTATION_STATUS AS HWSCAN on SYS.ResourceID = HWSCAN.ResourceID
 LEFT JOIN v_CH_ClientSummary AS ch ON ch.ResourceID = sys.ResourceID

WHERE os.Version0 like '10.%' and sys.Operating_System_Name_and0 not like '%server%'
	and sys.name0 = @ComputerName
