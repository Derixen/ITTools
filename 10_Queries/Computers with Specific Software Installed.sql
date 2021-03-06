Use CM_E01

CREATE TABLE #temptable
(Computer varchar(15))

INSERT INTO #temptable (Computer)
VALUES 
('COMPUTER01'),('COMPUTER02'),('COMPUTER03'),('COMPUTER04'),('COMPUTER05')

SELECT Distinct tmp.computer AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.User_Name0 AS 'Last Logon User'
	,ou.OU
	,cs.Manufacturer0 AS 'Manufacturer'
	,CASE 
	WHEN cs.Model0 = '20J9S0DL16' THEN 'ThinkPad L570'
	WHEN cs.Model0 = '20J9S0DL01' THEN 'ThinkPad L570'
	WHEN cs.Model0 = '20HJS0D21F' THEN 'ThinkPad P51'
	WHEN cs.Model0 = '20HJS0D201' THEN 'ThinkPad P51'
	WHEN cs.Model0 = '20HMS17T1Q' THEN 'ThinkPad X270'
	WHEN cs.Model0 = '20HMS17T01' THEN 'ThinkPad X270'
	WHEN cs.Model0 = '30BGS01B0U' THEN 'ThinkStation P320'
	WHEN cs.Model0 = '20JJS13601' THEN 'ThinkPad Yoga 370'
		ELSE cs.Model0 END AS 'Model'
	,prc.NumberofCores0 AS 'Cores'
	,os.Caption0 AS 'OS'
	,CASE os.OSLanguage0
		WHEN 1033 THEN 'English'
		WHEN 1031 THEN 'German'
		ELSE 'Other'
	END AS 'OS Language'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
	ELSE 'Not Active' END AS 'Status'
	,ch.ClientStateDescription AS 'Client State'
	--,ch.LastMPServerName AS 'Management Point'
	,SWSCAN.LastScanDate
	,HWSCAN.LastHWScan
	,arp.displayname0
	,arp.installdate0

FROM  #temptable AS tmp
	left JOIN v_R_System AS sys ON tmp.computer = sys.name0 
 left JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
 left JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
 LEFT JOIN v_GS_LastSoftwareScan AS SWSCAN on SYS.ResourceID = SWSCAN.ResourceID
 LEFT JOIN v_GS_WORKSTATION_STATUS AS HWSCAN on SYS.ResourceID = HWSCAN.ResourceID
 LEFT JOIN v_CH_ClientSummary AS ch ON ch.ResourceID = sys.ResourceID
 LEFT JOIN v_GS_PROCESSOR AS prc ON prc.ResourceID = sys.ResourceID and prc.NumberOfCores0 is not null
 LEFT JOIN (select sys.ResourceID, sys.Netbios_Name0, 
    (select top 1 ou2.System_OU_Name0 from v_RA_System_SystemOUName ou2
     where ou.ResourceID = ou2.ResourceID and LEN(ou2.System_OU_Name0) = MAX(LEN(ou.System_OU_Name0))) AS OU
	from v_R_System_Valid sys
	inner join v_RA_System_SystemOUName ou on sys.ResourceID = ou.ResourceID
	group by sys.Netbios_Name0, ou.ResourceID, sys.ResourceID) AS OU ON OU.ResourceID = sys.ResourceID
	LEFT JOIN v_Add_Remove_Programs AS arp ON arp.resourceid = sys.resourceid and arp.DisplayName0 = 'APPLICATIONNAME'

ORDER BY tmp.computer

Drop table #temptable
