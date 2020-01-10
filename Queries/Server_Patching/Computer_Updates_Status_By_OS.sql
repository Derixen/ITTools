USE CM_E01

IF OBJECT_ID('tempdb..#TempTable01') IS NOT NULL DROP TABLE #TempTable01

SELECT sys.name0 AS 'Name'
	,sys.Resource_Domain_OR_Workgr0 AS Domain
	,sys.siemensResponsible0 AS SiemensResponsible
	,os.Caption0 AS 'OS'
	,cs.Manufacturer0 AS 'Manufacturer'
	,cs.Model0 AS 'Model'
--	,CAST(SUM(CASE WHEN sn.StateName = 'Detection state unknown' THEN 1 ELSE 0 END) AS float) AS 'DetectionStateUnknown'
--	,CAST(SUM(CASE WHEN sn.StateName = 'Update is not required' THEN 1 ELSE 0 END) AS float) AS 'UpdatesNotRequired'
	,SUM(CASE WHEN sn.StateName = 'Update is required' THEN 1 ELSE 0 END) AS 'UpdatesRequired'
	,CAST(SUM(CASE WHEN sn.StateName = 'Update is installed' THEN 1 ELSE 0 END) AS float) AS 'UpdatesInstalled'
	--,CAST(SUM(CASE WHEN sn.StateName = 'Update is required' and ui.IsDeployed = 1 THEN 1 ELSE 0 END) AS float) AS 'UpdatesRequiredDeployed'
	,MAX (sys.Active0) AS 'Client is Active'
	,MAX (sys.Client_Version0) AS 'Client Version'
	,MAX (lss.LastScanDate) AS 'Last Inventory date'
	,SUBSTRING(left(sys.managedBy0, charindex(',', sys.managedBy0)-1),4,len(sys.managedBy0)) as 'ManagedBy'
	,WinUpd.TimeStamp AS 'Last Succesful Update'
	,ui.

INTO #TempTable01
FROM v_R_System AS sys
	JOIN v_Update_ComplianceStatusAll AS UCS ON sys.ResourceID = UCS.ResourceID
	JOIN v_UpdateInfo AS ui on UCS.CI_ID = ui.CI_ID and ui.IsUserDefined = 0
	JOIN v_StateNames AS SN ON SN.TopicType = 500 and sn.StateID = UCS.Status
	LEFT JOIN v_GS_COMPUTER_SYSTEM AS cs ON cs.ResourceID = sys.resourceID
	LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID
	JOIN v_FullCollectionMembership AS fcm on fcm.ResourceID = sys.ResourceID AND (fcm.CollectionID = 'CAS00264' or fcm.CollectionID = 'CAS0026A' or fcm.CollectionID = 'E0100566' or fcm.CollectionID = 'CAS0026C' or fcm.CollectionID = 'CAS00269' or fcm.CollectionID = 'CAS0026B')
	JOIN v_FullCollectionMembership AS fcm2 on fcm2.ResourceID = sys.ResourceID AND (fcm2.CollectionID = 'CAS0023A' or fcm2.CollectionID = 'CAS00234' or fcm2.CollectionID = 'E01006DD')
	Join v_GS_LastSoftwareScan LSS on sys.resourceid = LSS.ResourceID
	left join v_GS_WINDOWSUPDATE as WinUpd on winupd.ResourceID = sys.resourceID 

	--JOIN v_CICategories_All catall2 on catall2.CI_ID=ui.CI_ID
	--JOIN v_CategoryInfo catinfo2 on catall2.CategoryInstance_UniqueID = catinfo2.CategoryInstance_UniqueID and catinfo2.CategoryTypeName='UpdateClassification'

WHERE sys.Active0 = 1 
	and fcm.CollectionID = 'CAS0026C' --@OSCollection
	and fcm2.CollectionID = 'CAS0023A'  --@ServerCollection
	-----CAS0023A HU, CAS00234   DE------
	--and ui.IsDeployed = 1 and (ui.Title like '% sql %' or ui.Title like '% office %' or ui.Title like '% visual studio %' or ui.Title like '% excel %' or ui.Title like '% word %' or ui.Title like '% outlook %' or ui.Title like '% PowerPoint %' )
	and ui.IsDeployed = 1 and (ui.Title like '% windows server %' or ui.Title like '% Removal Tool %'  or ui.Title like  '%for .NET Framework%')
	and ui.Title not like 'Microsoft .NET %'
	and 'UpdatesRequired' > '0'
	
GROUP BY sys.name0
	,sys.siemensResponsible0
	,cs.Manufacturer0
	,cs.Model0
	,os.Caption0
	,sys.Resource_Domain_OR_Workgr0
	,SUBSTRING(left(sys.managedBy0, charindex(',', sys.managedBy0)-1),4,len(sys.managedBy0))
	,WinUpd.TimeStamp

SELECT *
	,ROUND(CASE WHEN UpdatesRequired = 0 THEN 100 ELSE 100-(UpdatesRequired/((UpdatesInstalled + UpdatesRequired)/100)) END,1) AS 'Compliance' 

FROM #TempTable01 