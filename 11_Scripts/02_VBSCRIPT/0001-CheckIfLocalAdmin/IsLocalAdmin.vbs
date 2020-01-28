On Error Resume Next

Set objNetwork = CreateObject("Wscript.Network")
strComputer = "." 'objNetwork.ComputerName

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colAccounts = objWMIService.ExecQuery( "Select * From Win32_Group Where LocalAccount = TRUE And SID = 'S-1-5-32-544'" )
Set colComputer = objWMIService.ExecQuery("Select * from Win32_ComputerSystem")

For Each objComputer in colComputer
	If IsNull(objComputer.UserName) Then
		strLoggedOnUser = objNetwork.UserName
	Else
		strLoggedOnUserArr = Split(objComputer.UserName,"\")
		strLoggedOnUser = strLoggedOnUserArr(1)
	End If
Next

wscript.echo strLoggedOnUser

For Each objAccount in colAccounts

    strLocalAdmin = objAccount.Name
	Set objGroup = GetObject("WinNT://" & strComputer & "/" & strLocalAdmin)
	
	For Each objUser in objGroup.Members
		If InStr( LCase(strLoggedOnUser), LCase(objUser.Name) ) <> 0 Then
			Wscript.Echo 1 ' is local administrator
		End If
	Next

Next
