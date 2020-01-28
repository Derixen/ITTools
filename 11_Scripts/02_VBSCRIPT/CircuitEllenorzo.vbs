Set oFSO = CreateObject("Scripting.FileSystemObject")
Set WshShellObj = WScript.CreateObject("WScript.Shell")
Set WshProcessEnv = WshShellObj.Environment("Process")
Set wshNetwork = CreateObject( "WScript.Network" )

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colComputer = objWMIService.ExecQuery("Select * from Win32_ComputerSystem")

For Each objComputer in colComputer
	If IsNull(objComputer.UserName) Then
		strUserName = wshNetwork.UserName
	Else
		strLoggedOnUserArr = Split(objComputer.UserName,"\")
		strUserName = strLoggedOnUserArr(1)
	End If
Next

strUserName7 = "C:\Documents and Settings\" & strUserName
strUserName10 = "C:\Users\" & strUserName

UserProfile = WshProcessEnv("USERPROFILE")

ProfileFileChecker(UserProfile)
ProfileFileChecker(strUserName10)
ProfileFileChecker(strUserName7)

Sub ProfileFileChecker(UserProfilePath)
	If oFSO.FileExists( UserProfilePath & "\AppData\Local\Programs\Circuit\Uninstall Circuit.exe" ) Then
		WScript.Echo "The application is installed"
		WScript.Quit(0)
	End If

	If oFSO.FileExists( UserProfilePath & ".AD001\AppData\Local\Programs\Circuit\Uninstall Circuit.exe" ) Then
		WScript.Echo "The application is installed"
		WScript.Quit(0)
	End If

	If oFSO.FileExists( UserProfilePath & ".ext\AppData\Local\Programs\Circuit\Uninstall Circuit.exe" ) Then
		WScript.Echo "The application is installed"
		WScript.Quit(0)
	End If

	If oFSO.FileExists( UserProfilePath & ".000\AppData\Local\Programs\Circuit\Uninstall Circuit.exe" ) Then
		WScript.Echo "The application is installed"
		WScript.Quit(0)
	End If
End Sub