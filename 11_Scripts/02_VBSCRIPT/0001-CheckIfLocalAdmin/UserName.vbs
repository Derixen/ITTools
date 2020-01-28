Const HKEY_LOCAL_MACHINE = &H80000002

strComputer = "."

Set objRegistry=GetObject("winmgmts:\\" & strComputer & "\root\default:StdRegProv")

strKeyPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
objRegistry.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubkeys

For Each objSubkey In arrSubkeys
	strValueName = "ProfileImagePath"
	strSubPath = strKeyPath & "\" & objSubkey
	objRegistry.GetExpandedStringValue HKEY_LOCAL_MACHINE, strSubPath, strValueName, strValue
	Wscript.Echo strValue
Next