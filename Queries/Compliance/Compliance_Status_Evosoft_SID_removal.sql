USE CM_E01

DECLARE @CBName nvarchar(30)
SET @CBName = '[eIS] Evosoft SID Removal'

SELECT Distinct 
	CIProp.DisplayName AS 'CI Name',
    SYS.Name0 AS 'Computer Name',
	sys.ResourceID,
    SNames.StateName AS 'Compliance State',
    CCS.LastComplianceMessageTime as 'Last Compliance Evaluation',
    SYS.User_Name0 as 'User Name',
    OS.Caption0 as 'Operating System',
    OS.InstallDate0 as 'Install Date',
    STATUS.LastHWScan as 'Last HW Scan',
    COMP.Model0 as 'Model',
    CI.CIVersion AS 'Baseline Content Version'
    --,CSCSD.CurrentValue

FROM
    v_BaselineTargetedComputers BTC
    INNER JOIN v_R_System as SYS ON SYS.ResourceID = BTC.ResourceID
    LEFT OUTER JOIN v_ClientCollectionMembers c ON C.ResourceID = SYS.ResourceID
    INNER JOIN v_GS_COMPUTER_SYSTEM COMP on COMP.ResourceID = BTC.ResourceID
    INNER JOIN v_GS_OPERATING_SYSTEM OS on OS.ResourceID = SYS.ResourceID
    INNER JOIN v_ConfigurationItems CI ON CI.CI_ID = BTC.CI_ID
    INNER JOIN v_CICurrentComplianceStatus CCS ON CCS.CI_ID = CI.CI_ID AND CCS.ResourceID = BTC.ResourceID
    INNER JOIN v_CIComplianceStatusComplianceDetail CSCD ON CSCD.CI_ID = CI.CI_ID
    INNER JOIN v_CICurrentSettingsComplianceStatusDetail CSCSD ON CSCSD.CI_ID = CSCD.Setting_CI_ID
    INNER JOIN v_LocalizedCIProperties_SiteLoc CIProp ON CIProp.CI_ID = CI.CI_ID
    INNER JOIN v_StateNames SNames ON CCS.ComplianceState = SNames.StateID
    LEFT OUTER JOIN v_GS_WORKSTATION_STATUS STATUS on STATUS.ResourceID=SYS.ResourceID
    LEFT OUTER JOIN v_R_User USR on USR.User_Name0 = SYS.User_Name0

WHERE
    CIProp.DisplayName = @CBName
    and SNames.TopicType = 401
        --AND C.CollectionID= @CollID

ORDER BY SNames.StateName