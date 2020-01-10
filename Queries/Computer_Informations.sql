Use CM_E01

DECLARE @ComputerName nvarchar(30)
SET @ComputerName = 'EVG01896NB'

DECLARE @UserName nvarchar(30)
SET @UserName = 'Thomas.Woehrle'

SELECT Distinct sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.User_Name0 AS 'Last Logon User'
	,usr2.Mail0 AS 'Last Logon User mail'
	--,sys.managedBy0 AS 'Managed by'
	,CASE WHEN usr.User_Name0 is NULL THEN sys.managedBy0 ELSE usr.Name0 END AS 'Managedby'
	,usr.Mail0 AS 'Email (managedby)'
	,CONVERT(char(10), sys.Last_Logon_Timestamp0,126) AS 'Last Logon'
	,CASE 
		WHEN LEFT(sys.Name0,2) = 'DE' THEN 'Germany' 
		WHEN LEFT(sys.Name0,3) = 'EVG' THEN 'Germany' 
		WHEN LEFT(sys.Name0,3) = 'EVO' THEN 'Germany' 
		WHEN LEFT(sys.Name0,2) = 'RO' THEN 'Romanian' 
		WHEN LEFT(sys.Name0,3) = 'EVR' THEN 'Romanian' 
		WHEN LEFT(sys.Name0,2) = 'TR' THEN 'Turkey' 
		WHEN LEFT(sys.Name0,3) = 'EVT' THEN 'Turkey' 
		WHEN LEFT(sys.Name0,2) = 'HU' THEN 'Hungary'
		WHEN LEFT(sys.Name0,3) = 'EVH' THEN 'Hungary'
		WHEN LEFT(sys.Name0,3) = 'BUD' THEN 'Hungary'
		ELSE 'Unknown' END AS 'Location'
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
	/*,CASE 
		 WHEN se.ChassisTypes0 in ('3','4','6','7','15') THEN 'Desktop'
		 WHEN se.ChassisTypes0 in ('8','9','10','21') THEN 'Laptop' END AS 'Type'*/
	,CASE WHEN b.Availability0>0 THEN 'Laptop' ELSE 'Desktop' END as Type
	,prc.Name0 AS 'Processor'
	,prc.NumberofCores0 AS 'Cores'
	,sys.Operating_System_Name_and0 AS 'OS in AD'
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
	,DATEDIFF(day, ch.LastDDR, GETDATE()) AS 'Days Last Active'
	
FROM v_R_System AS sys
	 left JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
	 left JOIN v_GS_SYSTEM_ENCLOSURE as se ON se.resourceID	= sys.resourceID
	 left JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
	 LEFT JOIN v_GS_LastSoftwareScan AS SWSCAN on SYS.ResourceID = SWSCAN.ResourceID
	 LEFT JOIN v_GS_WORKSTATION_STATUS AS HWSCAN on SYS.ResourceID = HWSCAN.ResourceID
	 LEFT JOIN v_CH_ClientSummary AS ch ON ch.ResourceID = sys.ResourceID
	 LEFT JOIN v_RA_System_MACAddresses AS mac ON mac.ResourceID = sys.ResourceID
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
	LEFT JOIN v_GS_BATTERY AS b ON b.ResourceID = sys.resourceID

--WHERE sys.user_name0 like '%Stefan.Plail%' -- or sys.name0 = 'EVH06768NB'
--WHERE sys.ResourceID in (select ResourceID from v_RA_System_MACAddresses where MAC_Addresses0 = '00:50:56:C0:00:08')
--WHERE sys.name0 like '%' + @ComputerName + '%'
--WHERE mac.MAC_Addresses0 like '%' + @ComputerName + '%'
--WHERE sys.ResourceID in (select resourceid from v_Add_Remove_Programs where v_Add_Remove_Programs.displayName0 like '%SAP%')
--WHERE sys.Name0 in ('EVG01954NB','EVG01076PC','EVG01214NB','EVG01233NB','EVG01235NB','EVG01338NB','EVG01356PC','EVG01574NB','EVG01965NB','EVG01969NB','EVG02352NB','EVG02353NB','EVG02380NB','EVG02561NB','EVH02289NB','EVH03547WS','EVH03666VM','EVH03906WS','EVH04956NB','EVH04965NB','EVH04992NB','EVH05063NB','EVH05068NB','EVH05326NB','EVH05592NB','EVH05843NB','EVH05865NB','EVH05942NB','EVH05950NB','EVH06170VM','EVH06226NB','EVH06331NB','EVH06381WS','EVH06545NB','EVH06563NB','EVH06704NB','EVH06726NB','EVH06756NB','EVH06768NB','EVH06900NB','EVH07000NB','EVH07098NB','EVH07264WS','EVH07398NB','EVH07572NB','EVH07600NB','EVH07728NB','EVH07776NB','EVH07873NB','EVH07906NB','EVH07939NB','EVH08069WS','EVH08530WS','EVH08669NB','EVH08815NB','EVHPOOL03NB','EVO00880','EVO01855','EVT01011NB','EVT01035NB','EVT01054NB','EVT01111NB','EVT01145NB','EVT01175NB','EVT01232NB')

ORDER BY sys.Name0
--where sys.user_name0 = '%tif%'



SELECT Distinct sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.User_Name0 AS 'Last Logon User'
	,usr2.Mail0 AS 'Last Logon User mail'
	--,sys.managedBy0 AS 'Managed by'
	,CASE WHEN usr.User_Name0 is NULL THEN sys.managedBy0 ELSE usr.Name0 END AS 'Managedby'
	,usr.Mail0 AS 'Email (managedby)'
	,CONVERT(char(10), sys.Last_Logon_Timestamp0,126) AS 'Last Logon'
	,ou.OU
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
		ELSE 'Unknown' END AS 'Location'
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
	/*,CASE 
	 WHEN se.ChassisTypes0 in ('3','4','6','7','15') THEN 'Desktop'
	 WHEN se.ChassisTypes0 in ('8','9','10','21') THEN 'Laptop' END AS 'Type'*/
	,CASE WHEN b.Availability0>0 THEN 'Laptop' ELSE 'Desktop' END as Type
	,prc.NumberofCores0 AS 'Cores'
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
	
FROM v_R_System AS sys
	 left JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
	 left JOIN v_GS_SYSTEM_ENCLOSURE as se ON se.resourceID	= sys.resourceID
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
	LEFT JOIN v_ClientDeploymentState as cds on cds.SMSID = sys.SMS_Unique_Identifier0
	LEFT JOIN v_r_user AS usr on usr.Distinguished_Name0 = sys.managedBy0
	LEFT JOIN v_r_user AS usr2 on usr2.User_Name0 = sys.User_Name0
	LEFT JOIN v_GS_BATTERY AS b ON b.ResourceID = sys.resourceID

--WHERE sys.user_name0 like '%Stefan.Plail%' -- or sys.name0 = 'EVH06768NB'
WHERE sys.user_name0 like '%' + @UserName + '%'
--WHERE sys.Name0 in ('EVG01581WS','EVG02034NB','EVG00013TV','EVG0001AV1','EVG00997TV','EVG01228NB','EVG01233NB','EVG01390NB','EVG01406NB','EVG01472NB','EVG01601NB','EVG01721NB','EVG01887NB','EVG01963NB','EVG01985NB','EVG02023NB','EVG02251NB','EVG02274NB','EVG02291NB','EVG02306PC','EVO00988','EVO01137','EVO01684')
--where sys.Client0 = 1

ORDER BY sys.Name0
--where sys.user_name0 = '%tif%'