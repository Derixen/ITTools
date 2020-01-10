use CM_E01

SELECT sys.Name0
	,sw.ARPDisplayName0 as 'ARPDisplayName'
	,sw.ProductVersion0 as 'ProductVersion'
	,sys.managedBy0 as 'managedBy'
	,sys.User_Name0 as 'last Logon'
	,sw.[TimeStamp]
	,sw.Publisher0 as 'Publisher'
	,sw.ResourceID as 'ResourceID'
	,sw.RevisionID as 'RevisionID'
	,sw.AgentID as 'AgentID'
	,sw.InstallType0 as 'InstallType'
	,sw.Language0 as 'Language'
	,sw.OsComponent0 as 'OsComponent'
	,sw.VersionMajor0 as 'VersionMajor'
	,sw.VersionMinor0 as 'VersionMinor'
	,sw.InstallDate0 as 'InstallDate'
	,sw.InstalledLocation0 as 'InstalledLocation'
	,sw.UninstallString0 as 'UninstallString'
	,sw.RegisteredUser0 as 'RegisteredUser'
	,sw.ServicePack0 as 'ServicePack'
	,sw.SoftwareCode0 as 'SoftwareCode'
	,sw.InstallSource0 as 'InstallSource'
	,sw.LocalPackage0 as 'LocalPackage'
	,sw.ProductID0 as 'ProductID'
	,sw.ProductName0 as 'ProductName'
	,sys.User_Name0 as 'last Logon'

FROM v_GS_INSTALLED_SOFTWARE AS sw
	inner join v_R_System AS sys on sw.ResourceID = sys.ResourceID

WHERE (sw.ARPDisplayName0 not like 'Microsoft OneNote MUI%' 
	and sw.ARPDisplayName0 not like 'Microsoft Visual C++%')
