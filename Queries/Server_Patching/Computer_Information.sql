Use CM_E01

DECLARE @ComputerName nvarchar(30)
SET @ComputerName = 'EVR01350NB'

SELECT Distinct sys.Name0 AS 'Name'
	,sys.resourceid
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.User_Name0 AS 'Last Logon User'
	,sys.SMS_Unique_Identifier0
	,sys.Object_GUID0
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
	,os.Version0
	,CASE os.OSLanguage0
		WHEN 1033 THEN 'English'
		WHEN 1031 THEN 'German'
		ELSE 'Other'
	END AS 'OS Language'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
	ELSE 'Not Active' END AS 'Status'
	,ch.ClientStateDescription AS 'Client State'
	--,ch.LastMPServerName AS 'Management Point'
	,CONVERT(char(10), SWSCAN.LastScanDate,126) AS 'SW Scan'
	,CONVERT(char(10), HWSCAN.LastHWScan,126) AS 'HW Scan'
	

FROM v_R_System AS sys
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

--WHERE sys.user_name0 like '%z0033nfa%'
WHERE sys.name0 = @ComputerName
--WHERE sys.Name0 in ('EVG01287NB','EVG01367WS','EVG01419NB','EVG01462NB','EVG01628NB','EVG01641WS','EVG01936NB','EVG01650WS','EVG02242NB','EVO02037','EVG01272NB','EVG01282NB','EVG01289NB','EVG01422NB','EVG01473WS','EVG01639WS','EVG01656WS','EVG01658WS','EVG01771PC','EVG01934NB','EVG01941NB','EVG02201NB','EVG02206NB','EVG02235NB','EVO00988','EVO01562','EVO02136','EVO02200','EVO00987','EVG00026V1','EVG01625WS','EVG01836NB','EVG02220NB','EVG0028AV1','EVG01270NB','EVG01472NB','EVG01690NB','EVG01763NB','EVG01942NB','EVG01947NB','EVG02059NB','EVG02222NB','EVG01427WS','EVG01679NB','EVG01654NB','EVG02136NB','EVO01116','EVO01350','EVG01103NB','EVG02214NB','EVO01589','EVG02106NB','EVG02200NB','EVG02258NB','EVG01204NB','EVG01963NB','EVG01256NB','EVG02030NB','EVG02180NB','EVG02237NB','EVO01757','EVO01137','EVG01418NB','EVG02182NB','EVG02231NB','EVG02226NB','EVG02227NB','EVG01395NB','EVG02223NB','EVG02171NB','EVG02070NB','EVG01757WS','EVG01424NB','EVG01846PC','EVG02208NB','EVG02212NB','EVT01418','EVG01120NB','EVG01631NB','EVG01527NB','EVG01070NB','EVG01800WS','EVG02198NB','EVG01940NB','EVG01252NB','EVG01340NB','EVG02031NB','EVO02126','EVG01152NB','EVG02100NB','EVO01849','EVO00983')
--where sys.Client0 = 1

ORDER BY sys.Name0
--where sys.user_name0 = '%tif%'