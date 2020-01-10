select sys.name0 [Computer Name]
		,sys.resourceid
	--	,sys.isactive
		,sys.Full_Domain_Name0 AS 'Domain'
		,os.Caption0 AS 'OS'
		,os.Version0
		,ch.ClientStateDescription AS 'Client State'
 from v_updateinfo ui
inner join v_UpdateComplianceStatus ucs on ucs.ci_id=ui.ci_id
join v_CICategories_All catall2 on catall2.CI_ID=UCS.CI_ID
join v_CategoryInfo catinfo2 on catall2.CategoryInstance_UniqueID = catinfo2.CategoryInstance_UniqueID and catinfo2.CategoryTypeName='UpdateClassification'
join v_R_System sys on sys.resourceid=ucs.resourceid
left JOIN v_GS_OPERATING_SYSTEM as os ON os.ResourceID = sys.ResourceID
LEFT JOIN v_CH_ClientSummary AS ch ON ch.ResourceID = sys.ResourceID
JOIN v_FullCollectionMembership AS fcm on fcm.ResourceID = sys.ResourceID

where  ucs.status='2' -- required
		AND (ui.articleid='4516064')
		and fcm.CollectionID = 'CAS00234' 
GROUP BY sys.name0, sys.resourceid,sys.Full_Domain_Name0,os.Caption0 ,os.Version0, ch.ClientStateDescription