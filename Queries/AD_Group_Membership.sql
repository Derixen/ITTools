USE CM_E01

SELECT system_group_name0 
	,sys.Name0
	,sys.Resource_Domain_OR_Workgr0
	,sys.Client0

FROM v_R_System sys
	join [dbo].[v_RA_System_SystemGroupName] as sgn on sgn.ResourceID = sys.ResourceID

WHERE system_group_name0 like '%REMOVE_SYNCPLICITY%' --and sys.name0 = 'EVT01529NB'

ORDER BY Name0

