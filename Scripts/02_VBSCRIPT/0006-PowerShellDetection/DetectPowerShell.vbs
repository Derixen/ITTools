const HKEY_LOCAL_MACHINE = &H80000002
strComputer = "."
 
Set objFSO = createObject( "Scripting.FileSystemObject" )

On Error resume next

Set wshell = CreateObject( "WScript.Shell" )  
Set wshShell = WScript.CreateObject( "WScript.Shell" )  
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")  
strKeyPath = "Software\Microsoft\PowerShell\1\PowerShellEngine"      
oReg.EnumValues HKEY_LOCAL_MACHINE, strKeyPath, arrValueNames, arrValueTypes 


For i=0 To UBound( arrValueNames )               
	
	oReg.GetStringValue HKEY_LOCAL_MACHINE,strKeyPath, arrValueNames(i), strValue 

	if arrValueNames(i) = "PowerShellVersion" then
		wscript.echo strValue
		' Select Case strValue 
			' Case "1.0" 
				' outfile.writeline strComputer&":  Version 1.0" 
			' Case "2.0" 
				' outfile.writeline strComputer&":  Version 2.0" 
			' Case Else  
				' outfile.writeline strComputer&":  Powershell NOT instaled"                         
		' End Select 
	End if
	
Next   
