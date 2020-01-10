USE CM_E01

DECLARE @CollectionID nvarchar(30)
SET @CollectionID = 'E01006FF' ---CAS00234 DE servers, CAS000A8 test servers, CAS0023A HU

SELECT col.CollectionID AS 'Collection ID'
	,col.CollectionName AS 'Collection Name'
	,sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.User_Name0 AS 'Last Logon User'
	,sys.AD_Site_Name0
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
	,os.Caption0 AS 'OS'
	,CASE WHEN sys.active0 = 1 THEN 'Active'
	ELSE 'Not Active' END AS 'Status'
	,ch.ClientStateDescription AS 'Client State'
	--,ch.LastMPServerName AS 'Management Point'
	,SWSCAN.LastScanDate
	,HWSCAN.LastHWScan

FROM v_FullCollectionMembership AS fcm
	JOIN vCollections AS col ON fcm.CollectionID = col.SiteID
	JOIN v_R_System AS sys ON fcm.resourceID = sys.ResourceID
	left JOIN v_GS_COMPUTER_SYSTEM as cs ON cs.ResourceID = sys.resourceID
	left JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
	LEFT JOIN v_GS_LastSoftwareScan AS SWSCAN on SYS.ResourceID = SWSCAN.ResourceID
	LEFT JOIN v_GS_WORKSTATION_STATUS AS HWSCAN on SYS.ResourceID = HWSCAN.ResourceID
	LEFT JOIN v_CH_ClientSummary AS ch ON ch.ResourceID = sys.ResourceID

WHERE fcm.CollectionID = @CollectionID