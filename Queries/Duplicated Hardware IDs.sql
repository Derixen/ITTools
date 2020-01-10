USE CM_E01

SELECT Name0
	,Hardware_ID0
	,Count(Hardware_ID0) AS SystemCount

FROM dbo.v_R_System

GROUP BY Hardware_ID0, Name0

ORDER BY SystemCount DESC