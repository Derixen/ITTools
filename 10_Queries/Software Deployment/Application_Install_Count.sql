 USE CM_E01
 
 SELECT AP.DisplayName0 AS 'Add-/Remove Programs Display Name'
    --,AP.ProdID0 AS 'Product ID'
	,AP.Publisher0 AS 'Add-/Remove Programs Publisher'
    ,AP.Version0 AS 'Add-/Remove Programs Version'
	--,AP.ProdID0
	,Count(distinct SD.Name0) AS 'Hostname'

FROM v_R_System AS SD
    LEFT JOIN v_Add_Remove_Programs AS AP ON SD.ResourceID = AP.ResourceID

WHERE AP.DisplayName0 like 'Adobe%Acrobat%' and sd.name0 like 'EVG%'

GROUP BY AP.DisplayName0
	,AP.ProdID0
	,AP.Publisher0
	,AP.Version0
	,AP.ProdID0

ORDER BY 'Hostname' DESC