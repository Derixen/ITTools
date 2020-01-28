 ScriptVersion = "1.0.0"
'==========================================================================
' NAME: Name of your Script
' DESCRIPTION: short description
' AUTHOR: PeskyJim
' CREATION DATE  : YYYY-MM-DD
'==========================================================================
force_cscript

On Error Resume Next

Dim objArgs, I 
IF Wscript.Arguments.Count > 0 Then 
    Set objArgs = WScript.Arguments 
    WScript.Echo "" & objArgs.Count & " arguments found:" 
    FOR I = 0 to (objArgs.count-1) 
        WScript.Echo objArgs(I) 
    Next 
ELSE 
    WScript.Echo "No arguments found." 
End IF

WScript.Echo "Buzi" 
WScript.Quit 1000

'==========================================================================
sub force_cscript
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