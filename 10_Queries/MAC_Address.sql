USE CM_E01

SELECT sys.Name0 

FROM v_R_System AS sys
	JOIN v_RA_System_MACAddresses AS MAC ON MAC.ResourceID = sys.ResourceID

WHERE MAC.MAC_Addresses0 = '00:00:00:00:00:00'