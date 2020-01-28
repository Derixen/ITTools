 USE CM_E01
 
 SELECT DisplayName0
	,Count(ResourceID) AS 'Installations'

FROM v_Add_Remove_Programs 

WHERE DisplayName0 like 'Adobe%Flash%Player%PPAPI%'

GROUP BY DisplayName0

