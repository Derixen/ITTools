USE CM_E01

IF OBJECT_ID('tempdb..#Duplicated') IS NOT NULL DROP TABLE #Duplicated

SELECT R.Name0 AS 'HostName'
	,R.ResourceID AS 'ID'
	,R.Full_Domain_Name0 AS 'Domain'
	,CASE WHEN r.active0 = 1 THEN 'Active'
		ELSE 'Not Active' END AS 'SCCM Client Status'
	,CASE WHEN r.Obsolete0 = 1 THEN 'Yes'
		ELSE 'No' END AS 'Obsolete'
	,CASE WHEN r.active0 = 0 AND r.Obsolete0 = 1 THEN 'Delete Me'
		ELSE '' END AS 'Comment'

INTO #Duplicated
FROM v_R_System AS r 
	FULL JOIN v_R_System AS s1 ON s1.ResourceId = r.ResourceId 
	FULL JOIN v_R_System AS s2 ON s2.Name0 = s1.Name0
	
WHERE s1.Name0 = s2.Name0 
	and s1.ResourceId != s2.ResourceId

SELECT tmp1.HostName
	,tmp1.ID
	,tmp1.Domain
	,tmp1.[SCCM Client Status]
	,tmp1.Obsolete
	,tmp2.Number
	,CASE WHEN tmp2.Number = 2 and [SCCM Client Status] = 'Not Active' THEN 'DELETE ME' ELSE 'OK' END AS 'Status' 

FROM #Duplicated AS tmp1
	JOIN (SELECT HostName, Count(HostName) AS 'Number' FROM #Duplicated GROUP BY HostName) AS tmp2 ON tmp1.HostName = tmp2.HostName

WHERE [SCCM Client Status] = 'Not Active'
