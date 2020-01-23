Set wshNetwork = CreateObject( "WScript.Network" ) 

strComputer = "."
strUserName = wshNetwork.UserName 

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
 
Set colAccounts = objWMIService.ExecQuery _
    ("Select * From Win32_Group Where LocalAccount = TRUE And SID = 'S-1-5-32-544'")
 
For Each objAccount in colAccounts

	Set objGroup = GetObject("WinNT://" & strComputer & "/" & objAccount.Name & ",group")
	
	For Each mem In objGroup.Members
	
		if mem.Name = strUserName Then
			WScript.echo 1
		End If
		
	Next
	
Next
