force_cscript

'ServerSelection values 
ssDefault = 0 
ssManagedServer   = 1 
ssWindowsUpdate   = 2 
ssOthers          = 3 
 
'InStr values 
intSearchStartChar = 1 
 
dim strTitle 
 
Set updateSession = CreateObject("Microsoft.Update.Session") 
Set updateSearcher = updateSession.CreateupdateSearcher() 
 
updateSearcher.ServerSelection = ssWindowsUpdate 
Set searchResult = updateSearcher.Search("IsInstalled=0 and Type='Software'") 
 
WScript.Echo "List of applicable items on the machine:" 
 
For I = 0 To searchResult.Updates.Count-1 
    Set update = searchResult.Updates.Item(I) 
    WScript.Echo I + 1 & "> " & update.Title 
Next 
 
If searchResult.Updates.Count = 0 Then 
    WScript.Echo "There are no applicable updates." 
    WScript.Quit 
End If 
 


'==========================================================================
sub force_cscript 'This ensures that by double-clicking on the VBS file, it will output wscript.echo in CMD and not as a popup
    Dim Arg, Str
    If Not LCase( Right( WScript.FullName, 12 ) ) = "\cscript.exe" Then
        For Each Arg In WScript.Arguments
            If InStr( Arg, " " ) Then Arg = """" & Arg & """"
            Str = Str & " " & Arg
        Next
        CreateObject( "WScript.Shell" ).Run "cmd.exe /k " & "cscript //nologo """ & WScript.ScriptFullName & """" & Str
        WScript.Quit
    End If
end sub
'==========================================================================