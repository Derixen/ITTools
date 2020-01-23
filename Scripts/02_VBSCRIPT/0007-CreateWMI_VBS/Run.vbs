On Error Resume Next

Set oLocator = CreateObject("WbemScripting.sWbemLocator")
Set oSvc = oLocator.ConnectServer(".", "root\cimv2")
Set oNamespace = oSvc.Get("__namespace")
Set oCustomNameSpace = oNamespace.SpawnInstance_

oCustomNamespace.name = "Custom"
oCustomNamespace.Put_()

'Create class to hold custom data
wbemCimtypeString = 8
wbemCimtypeUint32 = 19

Set oWMI = GetObject("winmgmts:root\cimv2\Custom")
Set oClass = oWMI.Get()

oClass.Path_.Class = "OSInfo"
oClass.Properties_.add "ID", wbemCimTypeUint32
oClass.Properties_("ID").Qualifiers_.add "key", true
oClass.Properties_.add "ProductName", wbemCimtypeString
oClass.Properties_.add "CurrentVersion", wbemCimtypeString
oClass.Properties_.add "CurrentBuild", wbemCimtypeString
oClass.Properties_.add "EditionID", wbemCimTypeString
oClass.Properties_.add "InstallationType", wbemCimTypeString
oClass.Properties_.add "SystemRoot", wbemCimTypeString

oClass.Put_()

strProductName = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName"
strCurrentVersion = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentVersion"
strCurrentBuild = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentBuild"
strEditionID = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EditionID"
strInstallationType = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\InstallationType"
strSystemRoot = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRoot"

Set objShell = WScript.CreateObject( "WScript.Shell" )

Set oWMI = GetObject("winmgmts:root\cimv2\Custom")
Set oData = oWMI.Get("OSInfo")
Set oInstance = oData.SpawnInstance_

oInstance.ID = "1"
oInstance.ProductName = objShell.RegRead(strProductName)
oInstance.CurrentVersion = objShell.RegRead(strCurrentVersion)
oInstance.CurrentBuild = objShell.RegRead(strCurrentBuild)
oInstance.EditionID = objShell.RegRead(strEditionID)
oInstance.InstallationType = objShell.RegRead(strInstallationType)
oInstance.SystemRoot = objShell.RegRead(strSystemRoot)

oInstance.Put_()