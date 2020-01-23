On Error Resume Next
Set oOutlook = CreateObject( "Outlook.Application" )
If Err.Number = 0 Then
	WScript.Echo oOutlook.Version
End If