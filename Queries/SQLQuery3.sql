USE CM_E01

SELECT Operating_System_Name_and0 AS 'OS'
	,CASE
		WHEN Operating_System_Name_and0 = 'Microsoft Windows NT Workstation 10.0' THEN 'Windows 10'
		WHEN Operating_System_Name_and0 = 'Microsoft Windows NT Workstation 10.0' THEN 'Windows 10'
		WHEN Operating_System_Name_and0 = 'Microsoft Windows NT Workstation 10.0 (Tablet Edition)' THEN 'Windows 10'
	END AS 'OS friendly name'
	,Build01 AS 'Build number'
	,CASE Build01
		WHEN '10.0.10240' THEN '1507'
		WHEN '10.0.10586' THEN '1511'
		WHEN '10.0.14393' THEN '1607'
		WHEN '10.0.15063' THEN '1703'
		WHEN '10.0.16299' THEN '1709'
		WHEN '10.0.17134' THEN '1803'
		WHEN '10.0.17763' THEN 'Windows 10 Insider Preview Build'
		ELSE 'Unknown' END AS 'Version'

		,COUNT(Operating_System_Name_and0) AS 'Quantity'

FROM v_R_System

WHERE Operating_System_Name_and0 LIKE '%Workstation%10%'

GROUP BY Operating_System_Name_and0
	,Build01

ORDER BY 'Version' ASC