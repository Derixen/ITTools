USE CM_E01

SELECT sys.name0 AS 'Server name'
	,p.name0 AS 'Processor name'
	,p.NumberOfLogicalProcessors0 AS 'Number of logical processors'
	,p.NumberOfCores0 AS 'Number of cores'
	,os.Caption0 AS 'Operating system'
	,ins.ARPDisplayName0 'Installed product'


FROM v_GS_PROCESSOR AS p
	JOIN v_GS_SYSTEM AS sys ON p.ResourceID = sys.ResourceID
	JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = p.ResourceID
	JOIN v_GS_INSTALLED_SOFTWARE AS ins ON ins.ResourceID = p.ResourceID

WHERE SystemRole0 = 'Workstation' and ins.ARPDisplayName0 like 'Microsoft SQL Server 20%'