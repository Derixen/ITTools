Use CM_E01

DECLARE @ComputerName nvarchar(30)
SET @ComputerName = 'EVH07397NB'

SELECT DISTINCT sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,os.Caption0 AS 'OS'
	,CASE 
		WHEN se.ChassisTypes0 in ('3','4','6','7','15') THEN 'Desktop'
		WHEN se.ChassisTypes0 in ('8','9','10','21') THEN 'Laptop' 
		ELSE 'Unknown' END AS 'Type'
	,mem.capacity0 AS 'Memory Size'
	,mem.manufacturer0 AS 'Memory Maufacturer'
	
FROM v_R_System AS sys
	LEFT JOIN v_GS_SYSTEM_ENCLOSURE AS se ON se.resourceID	= sys.resourceID
	LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID
	LEFT JOIN v_GS_PHYSICAL_MEMORY AS mem ON mem.resourceID = sys.resourceID

WHERE sys.name0 like '%' + @ComputerName + '%'

ORDER BY sys.Name0