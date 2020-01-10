USE CM_E01

DECLARE @ComputerName nvarchar(30)
SET @ComputerName = 'COMPUTERNAME01'

SELECT COL.CollectionID
	,COL.Name
	,COL.Comment

FROM v_Collection AS COL
	JOIN v_FullCollectionMembership AS FCM ON COL.CollectionID = FCM.CollectionID

WHERE FCM.Name like '%' + @ComputerName + '%'

ORDER BY COL.Name