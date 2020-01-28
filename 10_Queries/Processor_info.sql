Use CM_E01

SELECT sys.Name0 AS 'Host Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,p.Name0 AS 'Processor Name'
	,cs.Model0 AS 'Model'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
	ELSE 'Not Active' END AS 'Status'

FROM v_R_System AS sys
JOIN v_GS_PROCESSOR as p ON p.resourceID = sys.resourceid
JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID