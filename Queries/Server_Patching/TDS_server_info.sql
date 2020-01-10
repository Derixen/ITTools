SELECT Distinct sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	--,sys.managedBy0 AS 'Managed by'
	,CASE WHEN usr.User_Name0 is NULL THEN sys.managedBy0 ELSE usr.Name0 END AS 'Managedby'
	,usr.Mail0 AS 'Email (managedby)'
	,CONVERT(char(10), sys.Last_Logon_Timestamp0,126) AS 'Last Logon'
	,sys.AD_Site_Name0 AS 'Site'
	,sys.location0 AS 'Location'
	,CASE WHEN LEFT(sys.Name0,2) = 'DE' THEN 'Germany'
		WHEN LEFT(sys.Name0,3) = 'EVG' THEN 'Germany'
		WHEN LEFT(sys.Name0,3) = 'EVO' THEN 'Germany'
		WHEN LEFT(sys.Name0,2) = 'RO' THEN 'Romanian'
		WHEN LEFT(sys.Name0,3) = 'EVR' THEN 'Romanian'
		WHEN LEFT(sys.Name0,2) = 'TR' THEN 'Turkey'
		WHEN LEFT(sys.Name0,3) = 'EVT' THEN 'Turkey'
		WHEN LEFT(sys.Name0,2) = 'HU' THEN 'Hungary'
		WHEN LEFT(sys.Name0,3) = 'EVH' THEN 'Hungary'
		WHEN LEFT(sys.Name0,3) = 'BUD' THEN 'Hungary'
		ELSE 'Unknown' END AS 'Country'
	,sys.Description0 AS Description
	,Sys.Last_Logon_Timestamp0 AS ADLastLogon
	,sys.whenCreated0 as ADCreationDate
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
	,os.Caption0 AS 'OS'
	,CASE os.Version0
		WHEN '10.0.10240' THEN '1507'
		WHEN '10.0.10586' THEN '1511'
		WHEN '10.0.14393' THEN '1607'
		WHEN '10.0.15063' THEN '1703'
		WHEN '10.0.16299' THEN '1709'
		WHEN '10.0.17134' THEN '1803'
		WHEN '10.0.17763' THEN '1809'
		WHEN '10.0.18317' THEN '1903'
		ELSE os.Version0 END AS 'OS Version'
	,CASE os.OSLanguage0
		WHEN 1033 THEN 'English'
		WHEN 1031 THEN 'German'
		ELSE 'Other'
	END AS 'OS Language'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
	ELSE 'Not Active' END AS 'Status'
	,ch.ClientStateDescription AS 'Client State'
	,CONVERT(char(10), cds.DeploymentEndTime,126) AS 'Client Install Date'
	--,ch.LastMPServerName AS 'Management Point'
	,CONVERT(char(10), SWSCAN.LastScanDate,126) AS 'SW Scan'
	,CONVERT(char(10), HWSCAN.LastHWScan,126) AS 'HW Scan'
--	,prc.Name0 as Processor
--	,prc.NumberOfCores0 as CpuCores
	,ci.CNLastOnlineTime as SCCM_LastOnlineTime
	,ci.[LastMPServerName] [Last MP Server]
	,ci.[LastStatusMessage] [Last Status Message]
	,ci.IsVirtualMachine as [Is VM?]
	,case ci.ClientState
		WHEN 0 THEN 'NO'
		When 1 THEN 'Configuration Manager'
		When 2 THEN 'File Rename'
		When 3 THEN 'Configuration Manager, File Rename'
		When 4 THEN 'Windows Update'
		When 5 THEN 'Configuration Manager, Windows Update'
		When 6 THEN 'File Rename, Windows Update'
		When 7 THEN 'Configuration Manager, File Rename, Windows Update'
		When 8 THEN 'Add or Remove Feature'
		When 9 THEN 'Configuration Manager, Add or Remove Feature'
		When 10 THEN 'File Rename, Add or Remove Feature'
		When 11 THEN 'Configuration Manager, File Rename, Add or Remove Feature'
		When 12 THEN 'Windows Update, Add or Remove Feature'
		When 13 THEN 'Configuration Manager, Windows Update, Add or Remove Feature'
		When 14 THEN 'File Rename, Windows Update, Add or Remove Feature'
		When 15 THEN 'Configuration Manager, File Rename, Windows Update, Add or Remove Feature'
		ELSE 'Unknown' END AS 'Pending Resart'
	--,COUNT(prc.DeviceID0) AS CPUs
	--,disk.Model0 As PhisicalDiskType
	--,disk.Name0 as PhisicalDiskID
	--,disk.Size0 as PhisicalSize
	--,diskvol.Caption0 As DriveLetter
	--,DiskVol.Size0 As DriveSize
	--,Diskvol.FreeSpace0 as DriveFreespace
	--,nic.IPAddress0 as IPs
	--,NIC.DefaultIPGateway0 as GW
	--,nic.MACAddress0 as MAC
	--,nic.ServiceName0 as Device

	
FROM vSMS_CombinedDeviceResources ci
	LEFT JOIN v_R_System SYS on ci.MachineID = SYS.ResourceID
	 left JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
	 left JOIN v_GS_DISK As Disk On disk.ResourceID = sys.resourceID
	 left join v_GS_LOGICAL_DISK as DiskVol On DiskVol.ResourceID = sys.resourceID
	 left join v_GS_SERVER_FEATURE as SrvFt on srvft.ResourceID = sys.resourceID
	 left join v_GS_NETWORK_ADAPTER_CONFIGURATION as NIC on nic.ResourceID = sys.resourceID
	 left JOIN v_GS_SYSTEM_ENCLOSURE as se ON se.resourceID	= sys.resourceID
	 left JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
	 left join v_UpdateState_Combined as UpdateInfo on UpdateInfo.ResourceID = sys.ResourceID
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
	LEFT JOIN v_ClientDeploymentState as cds on cds.SMSID = sys.SMS_Unique_Identifier0
	LEFT JOIN v_r_user AS usr on usr.Distinguished_Name0 = sys.managedBy0
	LEFT JOIN v_r_user AS usr2 on usr2.User_Name0 = sys.User_Name0


WHERE sys.name0 like 'HUBUDADMINTOOL'

ORDER BY sys.Name0
