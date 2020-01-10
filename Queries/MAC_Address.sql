USE CM_E01

SELECT sys.Name0 

FROM v_R_System AS sys
	JOIN v_RA_System_MACAddresses AS MAC ON MAC.ResourceID = sys.ResourceID

WHERE MAC.MAC_Addresses0 = '10:E7:C6:24:FE:6F' --'40:B0:34:42:60:19'