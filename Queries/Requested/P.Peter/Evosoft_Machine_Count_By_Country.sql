USE CM_E01

SELECT Name0
	,CASE WHEN Name0 like 'EVH%' OR Name0 like 'HU%' OR AD_Site_Name0 in ('Budapest','Szeged','S-HUBUD-04','Miskolc') THEN 'Hungary'
	WHEN Name0 like 'EVG%' OR Name0 like 'DE%' OR Name0 like 'EVO%' OR AD_Site_Name0 in ('S-DEERL-01','Nuernberg') THEN 'Germany'
	WHEN Name0 like 'EVT%' OR Name0 like 'TR%' THEN 'Turkey'
	WHEN Name0 like 'EVR%' OR Name0 like 'RO%' THEN 'Romanian'
	ELSE 'Unknown' END AS 'Country'
INTO #TempClient
FROM v_R_System
WHERE Operating_System_Name_and0 not like '%server%'


SELECT Name0
	,CASE WHEN Name0 like 'EVH%' OR Name0 like 'HU%' OR AD_Site_Name0 in ('Budapest','Szeged','S-HUBUD-04','Miskolc') THEN 'Hungary'
	WHEN Name0 like 'EVG%' OR Name0 like 'DE%' OR Name0 like 'EVO%' OR AD_Site_Name0 in ('S-DEERL-01','Nuernberg') THEN 'Germany'
	WHEN Name0 like 'EVT%' OR Name0 like 'TR%' THEN 'Turkey'
	WHEN Name0 like 'EVR%' OR Name0 like 'RO%' THEN 'Romanian'
	ELSE 'Unknown' END AS 'Country'
INTO #TempServer
FROM v_R_System
WHERE Operating_System_Name_and0 like '%server%'

SELECT Country, Count(Name0) AS 'Clients' FROM #TempClient GROUP BY Country ORDER BY Country
SELECT Country, Count(Name0) AS 'Servers' FROM #TempServer GROUP BY Country ORDER BY Country

DROP TABLE #TempClient
DROP TABLE #TempServer

--GROUP BY Name0