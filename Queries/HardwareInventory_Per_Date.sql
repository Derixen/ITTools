Use CM_E01

IF OBJECT_ID('tempdb..#HWScan') IS NOT NULL
	DROP TABLE #HWScan

SELECT CONVERT(char(10), LastHWScan,126) AS 'HWScanDate'
	,ResourceID
INTO #HWScan
FROM v_GS_WORKSTATION_STATUS

SELECT HWScanDate
	,Count(ResourceID) as 'Clients'
FROM #HWScan
GROUP BY HWScanDate
ORDER BY HWScanDate DESC




