select DisplayName0
	,Version0
	,'x86' AS 'Architecture'
	,Count(resourceID) AS 'Installations' 

from v_GS_ADD_REMOVE_PROGRAMS

where DisplayName0 not like '%update%' --or DisplayName0 not like '%service pack%' 

group by DisplayName0
	,Version0

UNION ALL

select DisplayName0
	,Version0
	,'x64' AS 'Architecture'
	,Count(resourceID) AS 'Installations' 

from v_GS_ADD_REMOVE_PROGRAMS_64

where DisplayName0 not like '%update%' --or DisplayName0 not like '%service pack%' 

group by DisplayName0
	,Version0

ORDER BY Installations DESC