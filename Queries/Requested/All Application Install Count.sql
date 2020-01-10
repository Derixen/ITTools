 USE CM_E01
 
 SELECT AP.DisplayName0 AS 'Add-/Remove Programs Display Name'
	,AP.Publisher0 AS 'Add-/Remove Programs Publisher'
    ,AP.Version0 AS 'Add-/Remove Programs Version'
	,Count(distinct SD.Name0) AS 'Hostname'

FROM v_R_System AS SD
    LEFT JOIN v_Add_Remove_Programs AS AP ON SD.ResourceID = AP.ResourceID

WHERE AP.DisplayName0 not like 'Microsoft%Update%'
	and AP.DisplayName0 not like 'Security Update%'
	and AP.DisplayName0 not like 'Service Pack%'
	and AP.DisplayName0 not like '%Language Pack%'
	and AP.DisplayName0 not like 'hotfix%'
	and AP.DisplayName0 not like 'Update for%'
	and AP.Publisher0 not in ('Intel Corporation','Intel(R) Corporation','Intel')
	and AP.DisplayName0 not like 'Microsoft Visual C++%'

GROUP BY AP.DisplayName0
	,AP.Publisher0
	,AP.Version0

ORDER BY AP.DisplayName0