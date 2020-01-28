Set oWS = WScript.CreateObject("WScript.Shell")
' Get the %userprofile% in a variable, or else it won't be recognized
userProfile = oWS.ExpandEnvironmentStrings( "%userprofile%" )
wscript.echo userProfile