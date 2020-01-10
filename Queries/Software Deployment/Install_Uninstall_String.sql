USE CM_E01

SELECT sys.name0 AS 'Host'
	,sys.AD_Site_Name0 AS 'Domain' 
	,arp.ARPDisplayName0 AS 'DisplayName'
	,arp.InstalledLocation0 AS 'Installation Location'
	,arp.InstallSource0 AS 'Installation Source'
	,arp.UninstallString0 AS 'Uninstall String'

FROM v_R_System AS sys
	JOIN v_GS_INSTALLED_SOFTWARE AS arp ON sys.ResourceID = arp.ResourceID

where sys.name0 = 'COMPUTER01'
	and arp.arpdisplayname0 like '%pulse%'