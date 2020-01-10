SELECT distinct
vSYS.Name0,
ch.ClientStateDescription,
ch.LastActiveTime,
SUBSTRING(left(vSYS.managedBy0, charindex(',', vSYS.managedBy0)-1),4,len(vSYS.managedBy0)) as 'ManagedBy'
,os.Caption0 as OS
,ui.BulletinID AS [Bulletin_ID]
,ui.ArticleID AS [Article_ID]
,ui.Title AS [Title]
,ui.InfoURL AS [URL]
,ui.Description as [Description]
,ui.DateRevised AS [Date_Revised]

FROM fn_ListUpdateComplianceStatus(1033) ucsa
INNER JOIN v_CIRelation cir ON ucsa.CI_ID = cir.FromCIID
INNER JOIN v_UpdateInfo ui ON ucsa.CI_ID = ui.CI_ID 
JOIN v_CICategoryInfo ON ucsa.CI_ID = v_CICategoryInfo.CI_ID 
INNER JOIN fn_ListUpdateCategoryInstances(1033) SMS_UpdateCategoryInstance
ON v_CICategoryInfo.CategoryInstanceID = SMS_UpdateCategoryInstance.CategoryInstanceID
left Join v_R_System vSYS on vSYS.ResourceID=ucsa.MachineID
left join v_fullcollectionmembership FCM on FCM.resourceid=vSYS.resourceid
LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = vsys.ResourceID
LEFT JOIN v_CH_ClientSummary AS ch ON ch.ResourceID = vsys.ResourceID

WHERE
cir.RelationType=1
and ucsa.MachineID is not null
AND Status = '2' --2 Required, installed 3
AND (SMS_UpdateCategoryInstance.CategoryTypeName = N'Product'
AND SMS_UpdateCategoryInstance.AllowSubscription = 1)
and FCM.collectionid like 'CAS00234'---CAS00234 DE servers, CAS000A8 test servers, CAS0023A HU
--and (FCM.collectionid like 'CAS00238' or FCM.collectionid like 'CAS00239') --turkey and romanian
and ui.Title not like '%preview%'
and ui.Title not like '%microsoft .net framework%'
and v_CICategoryInfo.CategoryInstanceName like '%windows server%' -- and ui.Title like '%security%'
--and vSYS.Name0 = 'HUBUDDBS'
ORDER BY Name0 
