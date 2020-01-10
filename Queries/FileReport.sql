Use CM_E01

SELECT DISTINCT sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
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
	,os.Caption0 AS 'Operating System'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
		ELSE 'Not Active' END AS 'Status'
	,sf.FileName
	,sf.FileVersion
	,sf.FilePath
	
FROM v_R_System AS sys
	JOIN v_GS_SoftwareFile AS sf ON sf.ResourceID = sys.ResourceID
	LEFT JOIN v_GS_COMPUTER_SYSTEM AS cs ON cs.ResourceID = sys.ResourceID
	LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID

WHERE sf.FileName = 'PccNTMon.exe' and sf.FilePath = 'C:\Program Files (x86)\Trend Micro\OfficeScan Client\'

ORDER BY sys.Name0
