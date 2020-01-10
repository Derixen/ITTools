USE CM_E01

select c.name as ColumnName
	,o.name as TableName

from sys.columns c
	inner join sys.objects o on c.object_id = o.object_id

where o.name like '%taskseq%' 

ORDER BY o.name
