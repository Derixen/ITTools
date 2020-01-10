USE CM_E01

SELECT Client_Version0 AS 'Client Version'
	,count(ResourceID) AS 'Count'

FROM v_R_System

WHERE Client0 = 1

GROUP BY Client_Version0

ORDER BY 'count' DESC