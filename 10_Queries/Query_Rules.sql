USE CM_E01

SELECT col.Name, crq.RuleName
	, crq.QueryExpression
	,cols.ObjectPath AS 'Console Path'
	,cols.MemberCount
	,cols.LocalMemberCount
FROM
    v_Collection AS col
	LEFT JOIN  v_CollectionRuleQuery AS crq ON col.CollectionID = crq.CollectionID
	LEFT JOIN  vCollections AS cols ON col.CollectionID=cols.SiteID

WHERE crq.QueryExpression like '%evosoft%'
ORDER BY  1

/*
select  distinct SMS_R_SYSTEM.ItemKey,SMS_R_SYSTEM.DiscArchKey,SMS_R_SYSTEM.Name0,SMS_R_SYSTEM.SMS_Unique_Identifier0,SMS_R_SYSTEM.Resource_Domain_OR_Workgr0,SMS_R_SYSTEM.Client0 from vSMS_R_System AS SMS_R_System LEFT OUTER JOIN System_System_Group_Name_F_ARR AS __em_System_Group_Name_F_ARR0 ON SMS_R_System.ItemKey = __em_System_Group_Name_F_ARR0.ItemKey   where __em_System_Group_Name_F_ARR0.System_Group_Name0 = N'EVOSOFT\SCCM_Updates_Security_Critical'
*/
--SELECT TOP 10 * FROM v_Collection
SELECT TOP 10 * FROM vCollections where CollectionName like '%Carbon%'

SELECT TOP 10 * FROM vCollections where CollectionName like '%Network%'


