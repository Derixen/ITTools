SELECT distinct
    ResourceID        = CompliantDetails.AssetID
	,ResourceName	  = syst.Netbios_name0
 --   , ComplianceState = 'Compliant'
    , UserName        = CompliantDetails.ADUserName
    , CIVersion       = CompliantDetails.BLRevision
    , SettingVersion  = CompliantDetails.Revision
    , SettigName      = CompliantDetails.CIName
    , RuleName        = CompliantDetails.RuleName
    , Criteria        = CompliantDetails.ValidationRule
    , ActualValue     = CompliantDetails.DiscoveredValue
    , InstanceData    = CompliantDetails.InstanceData
	,CompliantDetails.Severity as Severity
FROM v_FullCollectionMembership AS CollectionMembers
INNER JOIN fn_DCMDeploymentCompliantDetailsPerAsset(2) AS CompliantDetails ON CompliantDetails.AssetID = CollectionMembers.ResourceID
    AND CompliantDetails.BL_ID = '82664' --@BaselineID,
	join v_R_System as syst on  CollectionMembers.ResourceID = syst.ResourceID
--WHERE CollectionMembers.CollectionID = 'CAS0023A'
where syst.Netbios_name0 = 'HUEVHSMMGT1'