USE CM_E01

SELECT
sys.Name0 AS 'Name',
sys.Resource_Domain_OR_Workgr0 AS 'Domain',
os.Caption0 AS 'OS',
NC.CIName,
cs.ClientStateDescription AS 'Client State',
MAX(lss.LastScanDate) AS 'Last Inventory Date',
SUBSTRING(left(sys.managedBy0, charindex(',', sys.managedBy0)-1),4,len(sys.managedBy0)) AS 'ManagedBy',
sys.siemensResponsible0 AS SiemensResponsible,
fcm.CollectionID 

FROM
v_R_System AS sys
JOIN v_GS_OPERATING_SYSTEM AS os ON sys.ResourceID = os.ResourceID
JOIN v_CH_ClientSummary AS cs ON sys.ResourceID = cs.ResourceID
JOIN v_GS_LastSoftwareScan AS lss ON sys.ResourceID = lss.ResourceID
JOIN v_FullCollectionMembership AS fcm ON sys.ResourceID = fcm.ResourceID
JOIN  fn_DCMDeploymentNonCompliantDetailsPerAsset(1) as NC ON NC.DeviceName = sys.Name0

WHERE
os.Caption0 LIKE '%Server%'
AND NC.BL_ID = '82664'
AND fcm.CollectionID = 'CAS00234'

GROUP BY
sys.name0,
sys.siemensResponsible0,
os.Caption0,
sys.Resource_Domain_OR_Workgr0,
cs.ClientStateDescription,
SUBSTRING(left(sys.managedBy0, charindex(',', sys.managedBy0)-1),4,len(sys.managedBy0)),
NC.CIName,
fcm.CollectionID 

