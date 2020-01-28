Option Explicit
Const HKEY_LOCAL_MACHINE = &H80000002
Dim oReg : Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
Dim oShell : Set oShell = CreateObject("WScript.Shell")
Dim sPath, aSub, sKey, aSubToo, sKeyToo, dwValue

' Get all keys within sPath
sPath = "SYSTEM\CurrentControlSet\Enum\IDE"
oReg.EnumKey HKEY_LOCAL_MACHINE, sPath, aSub

' Loop through each key
For Each sKey In aSub
    ' Get all subkeys within the key 'sKey'
    oReg.EnumKey HKEY_LOCAL_MACHINE, sPath & "\" & sKey, aSubToo
    For Each sKeyToo In aSubToo
        ' Try and get the DWORD value in Device Parameters\DefaultDvdRegion
        oReg.GetDWORDValue HKEY_LOCAL_MACHINE, sPath & "\" & sKey & "\" & sKeyToo & "\Device Parameters", "DefaultDvdRegion", dwValue
        Wscript.Echo "DVDRegion of " & sPath & "\" & sKey & "\" & sKeyToo & " = " & dwValue
    Next
Next