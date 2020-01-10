Use CM_E01

SELECT sys.Name0 AS 'Host Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.AD_Site_Name0 AS 'Site'
	,sys.managedBy0 AS 'Managed By'
	,us.Distinguished_Name0 AS 'DN'
	,us.User_Name0 AS 'User Name'
	,us.Mail0 AS 'Email'
	,sys.User_Name0 AS 'Last Logon User'
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
	,os.Caption0 AS 'OS'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
	ELSE 'Not Active' END AS 'Status'

FROM v_R_System AS sys
JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
LEFT JOIN v_R_User AS us ON us.Distinguished_Name0 = sys.managedBy0

WHERE os.Caption0 like '%server%'
	and sys.AD_Site_Name0 in ('Szeged','Budapest','S-HUBUD-04','Miskolc')
	and sys.ResourceID not in (select ResourceID from v_FullCollectionMembership where CollectionID = 'E01002AE')
	--and sys.ResourceID not in (select ResourceID from v_FullCollectionMembership where CollectionID = 'E010054F')
	