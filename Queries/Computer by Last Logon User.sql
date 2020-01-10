USE CM_E01

DECLARE @UserName nvarchar(30)
SET @UserName = 'Z003CCZK'

SELECT DISTINCT sys.Name0 AS 'Name'
	,sys.Full_Domain_Name0 AS 'Domain'
	,sys.User_Name0 AS 'Last Logon User'
	,CONVERT(char(10), sys.Last_Logon_Timestamp0,126) AS 'Last Logon'
	,cs.Model0 AS 'Model'
	,CASE 
	 WHEN se.ChassisTypes0 in ('3','4','6','7','15') THEN 'Desktop'
	 WHEN se.ChassisTypes0 in ('8','9','10','21') THEN 'Laptop' END AS 'Type'
	,os.Caption0 AS 'OS'
	
FROM v_R_System AS sys
	 LEFT JOIN v_GS_COMPUTER_SYSTEM AS cs ON cs.ResourceID = sys.resourceID
	 LEFT JOIN v_GS_SYSTEM_ENCLOSURE AS se ON se.resourceID	= sys.resourceID
	 LEFT JOIN v_GS_OPERATING_SYSTEM AS os ON os.ResourceID = sys.ResourceID

WHERE sys.user_name0 like '%' + @UserName + '%'

ORDER BY sys.Name0