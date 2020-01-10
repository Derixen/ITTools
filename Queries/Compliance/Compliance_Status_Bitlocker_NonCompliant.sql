USE CM_E01

select Netbios_Name0 AS 'Machine Name'
	,LastComplianceMessageTime AS 'Last Scan Time'
	,CurrentValue AS 'Driver Encryption Status' 
	
from v_CIComplianceStatusDetail 

where ConfigurationItemName = '[eIS][CI] Bitlocker Status'