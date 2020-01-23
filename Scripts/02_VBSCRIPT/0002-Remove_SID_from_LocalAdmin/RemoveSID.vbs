On Error Resume Next

Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colAccounts = objWMIService.ExecQuery( "Select * From Win32_Group Where LocalAccount = TRUE And SID = 'S-1-5-32-544'" )

For Each objAccount in colAccounts
	strComputer = "."
	strLocalAdmin = objAccount.Name

	Set objGroup = GetObject("WinNT://" & strComputer & "/" & strLocalAdmin)

	For Each objUser in objGroup.Members
		
		If ( InStr(objUser.Name, "S-1-5-21-1173374613-544147077-346042403") > 0 ) Then
			objGroup.Remove(objUser.ADsPath)
		End If
		
	Next
Next
