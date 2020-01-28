strScriptVersion = "1.8"

'==========================================================================
' NAME: Packaging Script
' DESCRIPTION:
' AUTHOR: Gergely Vörös
' DATE  : 2017-02-14
'========================================================================== 
' v1.0 - 2016-12-02: File Created
' v1.5 - 2017-02-14: Development of Standard Script Started by Gergely Voros
' v1.8 - 2017-06-06: Development of Standard Continued by Gergely Voros

'Error codes
'1112 - User pressed cancel
' -1 - File not found
'603 - Unknown error in vbs
'1115 - Pending Reboot Found
'3010 - Reboot Required

'=====SCRIPT HELP============= (Created by Gergely Voros)
'
'Under "Task Variables" section please always change --> strSoftwareName and strPackager variables
'
'=======Functions=============
'
'----------RUNNING INSTALL---------
'fnStartExe strPathToEXE, strEXE, strParam, booAutoLogging --> EXAMPLE: fnStartExe strScriptLocation & "\Prereq\", "vcredist_x86.exe", "/q /l", True ---> please be aware that the loging of the exe is added to
'Please NOTE that strExe must be present with FULL PATH and "\" is required!!!
'Return: intReturn (Global Return) 
'-1 file not found
'specific return of the EXE
'booAutoLogging --> adding log file to the default path (only use when you have a log switch)

'**********************************
'fnStartMSI fnStartMsi strPathToMsi, strMSI, strParam, strUIMode --> EXAMPLE: fnstartMSI strScriptLocation & "\", "softwarephone.msi", "ALLUSERS=1", "/qb-!"
'Please NOTE that strMSI must be present with FULL PATH!!!
'Return: intReturn (Global Return) 
'-1 file not found
'specific return of the MSI
'strUIMode --> default parameters of msiexec

'**********************************
'fnUninstallMSI strProdCode, strMSI, strParam --> EXAMPLE: fnUninstallMSI "{D70BC038-664F-468E-A3D0-8697A7F86FD6}", "Managed Client (Standard).msi", "/qb"
'Return: intReturn (Global Return) 
'specific return of the MSI

'----------FILE OPERATIONS--------
'fnDeleteFromAllUsers strDestination --> fnDeleteFromAllUsers "AppData\Roaming\Sample"
'Delete folders from all users
'Return: fnDeleteFromAllUsers (function returns an error code not global)

'**********************************
'fnDeleteFileFromAllUsers strUsrSpecFile --> fnDeleteFileFromAllUsers "AppData\Roaming\SAMPLE\Sample.txt"
'Delete file from all users
'Return: fnDeleteFileFromAllUsers (function returns an error code not global)

'**********************************
'fnDeleteFolder strPath --> fnDeleteFolder "C:\Temp\Delfold"
'Delete specific folder
'Return: fnDeleteFolder (function returns an error code not global)

'**********************************
'fnDeleteFile strFileFullPath --> 

'**********************************
'fnCopyFile strSource, strDestination, strCreatIfNotExists --> fnCopyFile "C:\Temp\Sample1\Sample2\Sample3\a.txt", "C:\Temp\Samp\Samp1\Samp2\", "True"

'**********************************
'fnCopyFolder strSource,strDestination -->


'----------CHECKERS---------------
'Is32BitOS() and Is64BitOS() --> Is32BitOS = True (x86 system); Is64BitOS = True (x64 system)
'**********************************
'fnFindInstalledApp strtext -->
'**********************************
'fnCheckforPendingReboot() --> boo True or False
'**********************************
'Lsh ByVal N, ByVal Bits --> required for other function (fnCompareVersions)
'**********************************
'GetVersionStringAsArray ByVal Version --> required for other function (fnCompareVersions)
'**********************************
'fnCompareVersions ByVal Version1, ByVal Version2 -->
'**********************************
'fnCheckParticularHotfix strPuter, strHotfixID -->
'**********************************
'fnCheckRegistryForProductCodes arrProdCode, strNewVersion -->


'--------SCRIPT OPERATIONS---------
'fnLog( EntryText ) --> EXAMPLE: fnLog "Your Text!!!"
'subforce_cscript --> running script in a visula mode fnMessage()/wscript.echo -> displayed in cmd
'sbforce_cscript() -->
'fnMessage strMessage -->
'fnDtrmnCRInstallerGUID strProductGUID, booFunctionLogging -->
'fnReturnCheckandContinue()
'fnExit()


'--------Registry OPERATIONS-------
'fnFindRegKey strKey, strName -->
'fnregValueExists strkey -->
'fnRegWrite  strValuePath, strData, strRegType -->
'fnRegDelete strKey -->


'--------OS Related OPERATIONS-------
'fnUserLogOff() -->
'fnKillProc myProcess -->
'fnYNPopup strMessage, intTimeout, strHeader -->
'fnCheckProc myProcess -->
'fnNEWRestart( ) -->

'__________________________________________________________________________________________________________________________________________________________________________________________________________
'__________________________________________________________________________________________________________________________________________________________________________________________________________
'__________________________________________________________________________________________________________________________________________________________________________________________________________
'__________________________________________________________________________________________________________________________________________________________________________________________________________

On Error Resume Next

'Setting references
Set objFSO = CreateObject( "Scripting.FileSystemObject" )
Set objShell = CreateObject( "WScript.Shell" )
Set objReg = GetObject( "winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv" )
Set objWMI = GetObject( "winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2" )
Set objNetwork = CreateObject( "WScript.Network" )
Set objSysInfo = CreateObject("Microsoft.Update.SystemInfo")
Set objWMIOss = objWMI.ExecQuery ("Select * from Win32_OperatingSystem")
Set objEnvSys = objShell.Environment("SYSTEM")

'Constants
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8

'Registry Constants
Const HKCR = &H80000000
Const HKCU = &H80000001
Const HKLM = &H80000002
Const HKU  = &H80000003

'Global Variables
StrUninstProdCode = "0"
StrUninstVer = "0"
strfnDtrmnCRInstallerGUID = "0"
strReturnType = "exit"
booHKULOADED = false

'OS related Variables
strOSVersion = objShell.RegRead( "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName" )
strProgramFiles = objShell.ExpandEnvironmentStrings( "%programfiles%" )
strProgramFilesx86 = objShell.ExpandEnvironmentStrings( "%programfiles(x86)%" )
strProgramData = objShell.ExpandEnvironmentStrings( "%programdata%" )
strWindir = objShell.ExpandEnvironmentStrings( "%windir%" )
strAllUsersProfile = objShell.ExpandEnvironmentStrings( "%allusersprofile%" )
strComputerName = objShell.ExpandEnvironmentStrings( "%COMPUTERNAME%" )
strUserName = objShell.ExpandEnvironmentStrings( "%USERNAME%" )
strDesktopPublic = LCase( "c:\users\public\desktop" )
strDesktopPerUser = objShell.SpecialFolders( "Desktop" ) ' For per-user installation only

' Task Variables

'************************************Mandatory Fields*************************************
strSoftwareName = "DXC_OfficeMediaTypeFix_1.0_MUI"
strTask = "Running " & chr(34) & WScript.ScriptName & chr(34) & "!"
strPackager = "Gergely Voros"
'*****************************************************************************************


' Logging Variables
strScriptLocation = objFSO.getParentFolderName( Wscript.ScriptFullName )
strLogFolder = "C:\Windows\Temp\"
strLogFile = strLogFolder & left( WScript.ScriptName, len( WScript.ScriptName ) - 4 ) & ".log"
strlogfileExt1 = strLogFolder & "SMP_" & strSoftwareName & "-ext1.log"
strlogfileExt2 = strLogFolder & "SMP_" & strSoftwareName & "-ext2.log"
strDate = Now()

For each os in objWMIOss   
strOsLanguage = os.OSLanguage
Next

If Is32BitOS() then
OSArchitecture = "x86"
else
OSArchitecture = "x64"
End If

fnLog "********************************************************"
fnLog "                        START                           "
fnLog "********************************************************"
fnLog "========================================================"
fnLog "                   Start Script                         "
fnLog "========================================================"
fnLog "========================================================"
fnLog "Script version: v" & strScriptVersion
fnLog "========================================================"
fnLog strTask
fnLog "Packaged by: " & strPackager & "!"
fnLog "========================================================"
fnLog "Script is running from: " & chr(34) & strScriptLocation & chr(34) & "!"
fnLog "========================================================"
fnLog "OS Version: " & chr(34) & strOSVersion & chr(34) & "!"
fnLog "========================================================"
fnLog "OS Language: " & chr(34) & strOsLanguage & chr(34) & "!"
fnLog " ========================================================"
If OSArchitecture = "x86" Then
	fnLog "Architecture is x86."
Else
	fnLog "Architecture is x64."
End If
fnLog "========================================================"

'Script Options
'***************

REM If Is32BitOS() Then
REM strSysFolder = "\System32"
REM Else
REM strSysFolder = "\Sysnative"
REM End If

intReturn = 0

'sbforce_cscript()

'*************************************************************
'                          MAIN
'*************************************************************

'________________________________________________1__________________________________________________________
booOffline = False

strregx64 = objShell.RegRead( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration\O365ProPlusRetail.MediaType" )


strregx86 = objShell.RegRead( "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration\O365ProPlusRetail.MediaType" )



If strregx64 = "DVD" then

err.clear

objShell.RegDelete("HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration\O365ProPlusRetail.MediaType")

intreturn =  err.number

fnLog "Removal of the following registry value: HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration\O365ProPlusRetail.MediaType. Returned: " & err.number

ElseIf strregx86 = "DVD" then

err.clear

objShell.RegDelete ("HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration\O365ProPlusRetail.MediaType")
intreturn =  err.number

fnLog "Removal of the following registry value: HKLM\SOFTWARE\WOW6432Node\Microsoft\Office\ClickToRun\Configuration\O365ProPlusRetail.MediaType. Returned: " & err.number

Else

fnLog "Registry value not found."

intreturn = 0



End If


'____________________________________________Exit Script______________________________________________________
If booOffline = true then
fnExit_OFFLINE()
ELSE
fnExit()
End If
'_____________________________________________________________________________________________________________


' Exit Section - ONLINE
'***************************************
Function fnExit_OFFLINE()
fnSetReturnType_OFFLINE()
fnlog "THE END -- Exiting Installation with " & strReturnType & " code: " & intReturn
fnLog "********************************************************"
fnLog "                        END                             "
fnLog "********************************************************"
wscript.quit intReturn
End Function

Function fnSetReturnType_OFFLINE()
			If intReturn = 0 then
			strReturnType = "exit"
			Msgbox "Installation of " & strSoftwareName & " finished successfully!", vbOKOnly, ""
			ElseIf intreturn = 3010 then
			strReturnType = "Reboot is required."
			Msgbox "Installation finished! Please reboot your computer!", vbOKOnly, ""
			Else
			strReturnType = "ERROR"
			Msgbox "Installation of " & strSoftwareName & " finished with ERROR!" & vbCrLf & "ERROR " & intReturn, vbOKOnly, ""
			End If
End Function

Function fnReturnCheckandContinue_OFFLINE() ' Check Return and Continue If 0
If not intreturn=0 then
fnExit_OFFLINE()
Else
End IF
End Function

' Exit Section - ONLINE
'***************************************
Function fnExit()
fnSetReturnType()
fnlog "THE END -- Exiting Installation with " & strReturnType & " code: " & intReturn
fnLog "********************************************************"
fnLog "                        END                             "
fnLog "********************************************************"
wscript.quit intReturn
End Function

Function fnReturnCheckandContinue() ' Check Return and Continue If 0
If not intreturn=0 then
fnExit()
Else
End IF
End Function

Function fnSetReturnType()
			If intReturn = 0 then
			strReturnType = "exit"
			ElseIf intreturn = 3010 then
			strReturnType = "Reboot is required."
			Else
			strReturnType = "ERROR"
			End If
End Function


'*********************************************************************
'Functions
'*********************************************************************
Function fnReadRegistryValue(strValueName)
	fnLog "Reading in Registry for: " & strValueName
	fnReadRegistryValue = objShell.RegRead(strValueName)
	fnLog "Found value: " & fnReadRegistryValue
End Function
'-------------------------------------------------------------------------RUNNING INSTALL-------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'===========================================================================fnStartExe==================================================================================

Function fnStartExe( strPathToEXE, strEXE, strParam, booAutoLogging )
	On Error Resume Next
	err.clear
	If objfso.FileExists( strPathToEXE & strEXE ) Then 
		
		If booAutoLogging = True then
			strCmdLine = chr(34) & strPathToEXE & strEXE & chr(34) & " " & strParam & " " & chr(34) & strwindir & "\TEMP\SWMS_Logs\" & left( strEXE, len( strEXE ) - 4 ) & "_EXE.log" & chr(34)
		Else
			strCmdLine = chr(34) & strPathToEXE & strEXE & chr(34) & " " & strParam
		End If
	
	fnLog "Running fnStartEXE: " & strCmdLine
	fnStartExe = objShell.run( strCmdLine, 1, TRUE )
			fnSetReturnType()
			fnLog "fnStartEXE - " & strPathToMsi & strEXE & " " & strParam & " - returned " & strReturnType & " code:  " & fnStartExe
	Else
			fnStartExe = -1
			fnSetReturnType()
			fnLog "fnStartEXE - " & strPathToMsi & strEXE & " " & strParam & " - returned " & strReturnType & " code:  " & fnStartExe
	End If
End function

'===========================================================================fnStartMsi==================================================================================

Function fnStartMsi( strPathToMsi, strMSI, strParam, strUIMode )
	On Error Resume Next
	err.clear
	If objfso.FileExists( strPathToMsi & strMSI ) Then 
		strCmdLine = "MSIEXEC.EXE /i " & chr(34) & strPathToMsi & strMSI & chr(34) & " " & strParam & " " & strUIMode & " /L*V " & chr(34) & strLogFolder & left( strMSI, len( strMSI ) - 4 ) & "_MSI.log" & chr(34)
		fnLog "Running fnStartMSI: " & strCmdLine
	fnStartExe = objShell.run( strCmdLine, 1, TRUE )
			fnSetReturnType()
			
			fnLog "fnStartMsi - " & strPathToMsi & strMSI & " " & strParam & " - returned " & strReturnType & " code:  " & fnStartExe
	Else
			fnStartExe = -1
			fnLog "fnStartMsi - " & strPathToMsi & strMSI & " " & strParam & " - returned with ERROR:  " & fnStartExe
	End If
End function

'===========================================================================fnUninstallMSI==================================================================================

Function fnUninstallMSI( strProdCode, strMSI, strParam )
	On Error Resume Next
	err.clear
		strCmdLine = "MSIEXEC.EXE /X " & strProdCode & " " & strParam & " /L*V " & chr(34) & strLogFolder & "Uninstall-" & left( strMSI, len( strMSI ) - 4 ) & "_MSI.log" & chr(34)
		fnLog "Running fnUninstallMSI: " & strCmdLine
	intreturn = objShell.run( strCmdLine, 1, TRUE )
	fnSetReturnType()
			fnLog "fnUninstallMSI - " & strMSI & " " & strParam & " - returned " & strReturnType & " code:  " & intReturn
End function

'-------------------------------------------------------------------------FILE OPERATIONS-------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

'===========================================================================fnDeleteFromAllUsers==================================================================================

Function fnDeleteFromAllUsers( strDestination )
	On Error Resume Next
	err.clear
	'fnLoadAllUsers 1
		Dim fs, f, f1, fc, s
		folderspec= "C:\Users"
		Set fs = CreateObject("Scripting.FileSystemObject")
		Set f = fs.GetFolder(folderspec)
		Set fc = f.SubFolders
		For Each f1 In fc
			If Not f1.name = "Public" Then
				If Not f1.name = "Default User" Then 
					If Not f1.name = "All Users" Then
					If objfso.FolderExists( "C:\Users\" & f1.name &"\" & strdestination ) Then 
					fnDeleteFromAllUsersNotEX = False
						'msgbox strsource & "C:\Users\" & f1.name &"\" & strdestination
						'fnCopyFolder strSource, "C:\Users\" & f1.name & "\" & strdestination
						fnDeleteFromAllUsers = fnDeleteFolder ( "C:\Users\" & f1.name &"\" & strdestination )
					Else
					fnlog "Folder DOES NOT EXIST: " & "C:\Users\" & f1.name & "\" & strdestination
					fnDeleteFromAllUsersNotEX = True
					End If
					

					If fnDeleteFromAllUsersNotEX = True Then
					fnDeleteFromAllUsers = 0
					ElseIf fnDeleteFromAllUsersNotEX = False and fnDeleteFromAllUsers = 0 then
					strReturnType = "exit"
					fnlog "Removal of" &  " C:\Users\" & f1.name & "\" & strdestination & " returned with " & strReturnType & " code: " & fnDeleteFromAllUsers
					Else
					strReturnType = "ERROR"
					fnDeleteFromAllUsers = err.number
					fnlog "Removal of" &  " C:\Users\" & f1.name & "\" & strdestination & " returned with " & strReturnType & " code: " & fnDeleteFromAllUsers
					End If
					
					
					End If
				End If
			End If
		Next
End Function

'===========================================================================fnDeleteFileFromAllUsers==================================================================================
Function fnRenameFile(strOrigFile, strNewFile)
   If objFSO.FileExists(strOrigFile) Then
		err.clear
        objFSO.MoveFile strOrigFile, strNewFile
		fnRenameFile = err.number
   Else
    fnRenameFile = -1
	fnLog "ERROR fnRenameFile returned with: " & -1
   End If
End Function
'===========================================================================fnDeleteFileFromAllUsers==================================================================================

Function fnDeleteFileFromAllUsers( strUsrSpecFile )
	On Error Resume Next
	err.clear
	'fnLoadAllUsers 1
		Dim fs, f, f1, fc, s
		folderspec= "C:\Users"
		Set fs = CreateObject("Scripting.FileSystemObject")
		Set f = fs.GetFolder(folderspec)
		Set fc = f.SubFolders
		For Each f1 In fc
			If Not f1.name = "Public" Then
				If Not f1.name = "Default User" Then 
					If Not f1.name = "All Users" Then
					If objfso.FileExists( "C:\Users\" & f1.name &"\" & strUsrSpecFile ) Then 
					fnDeleteFileFromAllUsersNotEX = False
						'msgbox strsource & "C:\Users\" & f1.name &"\" & strdestination
						'fnCopyFolder strSource, "C:\Users\" & f1.name & "\" & strdestination
						fnDeleteFileFromAllUsers = fnDeleteFile ( "C:\Users\" & f1.name &"\" & strUsrSpecFile )
					Else
					fnlog "fnDeleteFileFromAllUsers -- File DOES NOT EXIST: " & "C:\Users\" & f1.name & "\" & strUsrSpecFile
					fnDeleteFileFromAllUsersNotEX = True
					End If
					
					If fnDeleteFileFromAllUsersNotEX = True Then
					fnDeleteFileFromAllUsers = 0
					ElseIf fnDeleteFileFromAllUsersNotEX = False and fnDeleteFileFromAllUsers = 0 then
					strReturnType = "exit"
					fnlog "Removal of" &  " C:\Users\" & f1.name & "\" & strdestination & " returned with " & strReturnType & " code: " & fnDeleteFileFromAllUsers
					Else
					strReturnType = "ERROR"
					fnDeleteFileFromAllUsers = err.number
					fnlog "Removal of" &  " C:\Users\" & f1.name & "\" & strdestination & " returned with " & strReturnType & " code: " & fnDeleteFileFromAllUsers
					End If
					
					End If
				End If
			End If
		Next

End Function

'===========================================================================fnDeleteFolder==================================================================================

Function fnDeleteFolder( strPath )
	On Error Resume Next
	err.clear
	If objFSO.FolderExists( strPath ) Then 
		Set deletefolder = objFSO.GetFolder( strPath )
		If deletefolder.Attributes=0 Then
			deletefolder.Delete(True)
			fnDeleteFolder = err.number
		Else
			deletefolder.Attributes=0
			deletefolder.Delete( True )
			fnDeleteFolder = err.number
		End If
	ELSE
	fnlog "Folder Does Not Exist: " & strPath
	fnDeleteFolder = -1
	End If
End Function

'===========================================================================fnDeleteFile==================================================================================

Function fnDeleteFile( strFileFullPath )
	On Error Resume Next
	err.clear
	If objFSO.FileExists( strFileFullPath ) Then 
		Set deletefile = objFSO.DeleteFile( strFileFullPath )
		If deletefile.Attributes=0 Then
			deletefile.Delete(True)
			fnDeleteFile = err.number
			fnlog "fnDeleteFile " & strFileFullPath & " Returned:" & fnDeleteFile 
		Else 
			deletefile.Attributes=0
			deletefile.Delete( True )
			fnDeleteFile = err.number
			fnlog "fnDeleteFile " & strFileFullPath & " Returned:" & fnDeleteFile
		End If
	ELSE
	fnlog "fnDeleteFile -- File Does Not Exist: " & strFileFullPath
	fnDeleteFile = -1
	End If
End Function

'===========================================================================fnCopyFolder===========================================================================================

Function fnCopyFolder( strSource,strDestination )
	On Error Resume Next
	err.clear
	If Not objFSO.FolderExists( strDestination ) Then 
		Set folder = objFSO.CreateFolder( strDestination ) 
		fnLog "Destination folder created: " & strDestination
	Else
		fnLog "Destination folder already exists: " & strDestination
	End If 
	If objFSO.folderexists( strSource ) Then 
		fnLog "Copying Folder to " & strDestination
		objFSO.copyfolder strSource, strDestination,True
	End If
	intReturn = err.number
	fnCopyFolder = err.number
	fnLog "fnCopyFolder returns error code: " & intReturn
End Function


'===========================================================================fnCopyFile==============================================================================================

Function fnCopyFile( strSource, strDestination, strCreatIfNotExists )
	On Error Resume Next
	err.clear
	fnLog "fnCopyFile started: " & strSource & "to" & strDestination
	
	If strCreatIfNotExists = "True" then
	fnCreateFolderRecursive strDestination
	End If
	
	If objFSO.FileExists( strSource ) Then 	
		objFSO.CopyFile strSource, strDestination, TRUE
		fnCopyFile = err.number
		If fnCopyFile = 0 then
		strReturnType = "exit"
		Else
		strReturnType = "ERROR"
		End If
		fnLog "fnCopyFile finished with " & strReturnType & " code: " & fnCopyFile
	Else
		intReturn = -1
		fnCopyFile = intReturn
		fnLog "File Not found !!! :" & strSource & " - ERROR: " & intReturn
	End IF
End Function

'=========================================================================fnCreateFolderRecursive=========================================================================================

Function fnCreateFolderRecursive(strDestination)
  Dim arr, dir, path

  arr = split(strDestination, "\")
  path = ""
  For Each dir In arr
    If path <> "" Then path = path & "\"
    path = path & dir
    If objFSO.FolderExists(path) = False Then objFSO.CreateFolder(path)
		If err.number = 0 then
		strReturnType = "exit"
		Else
		strReturnType = "ERROR"
		End If
	fnLog "Creating Folder : " & path & " - Returnerd" & " with" & strReturnType & "code: " & intReturn
  Next
End Function

'----------------------------------------------------------------------------CHECKERS-----------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

'===========================================================================fnCheckOfficeVer=============================================================================

Function fnCheckOfficeVer()

If not fnReadRegistryValue("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths\Winword.exe\") = EMPTY then
	strWordPath = fnReadRegistryValue("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths\Winword.exe\")
	strCheckOfficeVerFull = objFSO.GetFileVersion(strWordPath)
	strCheckOfficeVer = Split(strCheckOfficeVerFull,".")
	fnCheckOfficeVer = strCheckOfficeVer(0) & "." & strCheckOfficeVer(1)
ElseIf not fnReadRegistryValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Winword.exe\@") = EMPTY then
	strWordPath = fnReadRegistryValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Winword.exe\")
	strCheckOfficeVerFull = objFSO.GetFileVersion(strWordPath)
	strCheckOfficeVer = Split(strCheckOfficeVerFull,".")
	fnCheckOfficeVer = strCheckOfficeVer(0) & "." & strCheckOfficeVer(1)
Else
	fnCheckOfficeVer = "0"
	fnLog "fnCheckOfficeVer ERROR: no installed OFFICE found!"
End If

End Function

'===========================================================================Is32BitOS==================================================================================

Function Is32BitOS()
    If GetObject("winmgmts:root\cimv2:Win32_Processor='cpu0'").AddressWidth = 32 Then
        Is32BitOS = True
    Else
        Is32BitOS = False
    End If
End Function

Function Is64BitOS()
    If GetObject("winmgmts:root\cimv2:Win32_Processor='cpu0'").AddressWidth = 64 Then
        Is64BitOS = True
    Else
        Is64BitOS = False
    End If
End Function

'===========================================================================fnFindInstalledApp==================================================================================

'Find via WMI

Function fnFindInstalledApp( strtext )

'This script outputs to a .tsv file a list of applications installed on the computer
'Output file is software.tsv
'Usage: cscript applications.vbs

If Not objFSO.FolderExists( "c:\windows\temp\SWMS_Logs\Tools\" ) Then 
	Set objFile = objFSO.CreateFolder( "c:\windows\temp\SWMS_Logs\Tools\" )
End If

strDataFile="InstalledAppsQuery_" & left( WScript.ScriptName, len( WScript.ScriptName ) - 4 ) & ".tsv"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objTextFile = objFSO.CreateTextFile("c:\windows\temp\SWMS_Logs\Tools\" & strDataFile, True)

strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
  & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colSoftware = objWMIService.ExecQuery _
  ("Select * from Win32_Product")

objTextFile.WriteLine "Caption" & vbtab & _
  "Description" & vbtab & "Identifying Number" & vbtab & _
  "Install Date" & vbtab & "Install Location" & vbtab & _
  "Install State" & vbtab & "Name" & vbtab & _ 
  "Package Cache" & vbtab & "SKU Number" & vbtab & "Vendor" & vbtab _
    & "Version" 

For Each objSoftware in colSoftware
  objTextFile.WriteLine objSoftware.Caption & vbtab & _
  objSoftware.Description & vbtab & _
  objSoftware.IdentifyingNumber & vbtab & _
  objSoftware.InstallDate2 & vbtab & _
  objSoftware.InstallLocation & vbtab & _
  objSoftware.InstallState & vbtab & _
  objSoftware.Name & vbtab & _
  objSoftware.PackageCache & vbtab & _
  objSoftware.SKUNumber & vbtab & _
  objSoftware.Vendor & vbtab & _
  objSoftware.Version
Next
objTextFile.Close

'This searches for a string of txt in a file

  If (InStr(1,lCase( objFSO.OpenTextFile("c:\windows\temp\SWMS_Logs\Tools\" & strDataFile,1,true,-2).ReadAll ),lCase( strtext ),1) <> 0) Then
  fnFindInstalledApp = True
  Else
  fnFindInstalledApp = False
  End If

End Function

'===========================================================================fnCheckforPendingReboot===============================================================================

Function fnCheckforPendingReboot()

If fnregValueExists ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations") = true then
reboot1 = true
Else
reboot1 = false
End IF

IF OSArchitecture = "x64" then
	If fnregValueExists ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates\UpdateExeVolatile\Flags") then
		x64RegReturn = objShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates\UpdateExeVolatile\Flags")
		If not x64RegReturn = 0 then
			reboot2 = true
		Else
			reboot2=false
		end if
	Else
	reboot2=false
	END If

	If fnregValueExists ("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Updates\UpdateExeVolatile\Flags") then
	x86RegReturn = objShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Updates\UpdateExeVolatile\Flags")
	If not x86RegReturn = 0 then
		reboot3=True
	Else
		reboot3=False
	End If
	Else
		reboot3=False
	END If

Else
	If fnregValueExists ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates\UpdateExeVolatile\Flags") = True then
		x64RegReturn = objShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates\UpdateExeVolatile\Flags")
		If not x64RegReturn = 0 then
			reboot2 = true
		Else
			reboot2=false
		end if
	Else
	reboot2=false
	END If
	
END If

If OSArchitecture = "x64" then
	If ( ( Reboot1=False ) and ( Reboot2=false ) and ( Reboot3=False ) ) then
	'wscript.echo "reboot is not required"
	fnCheckforPendingReboot = 0
	else
	'wscript.echo "reboot is REQUIRED"
	fnCheckforPendingReboot = 3010
	END If
Else
	If ( ( Reboot1=False )and ( Reboot2=False ) ) then
	'wscript.echo "reboot is not required"
	fnCheckforPendingReboot = 0
	Else
	'wscript.echo "reboot is REQUIRED"
	fnCheckforPendingReboot = 3010
	END If
End If

End Function

'===========================================================================Lsh===========================================================================================

' Bitwise left shift
Function Lsh(ByVal N, ByVal Bits)
  Lsh = N * (2 ^ Bits)
End Function

'===========================================================================GetVersionStringAsArray=========================================================================

' Returns a version string "a.b.c.d" as a two-element numeric
' array. The first array element is the most significant 32 bits,
' and the second element is the least significant 32 bits.

Function GetVersionStringAsArray(ByVal Version)
  Dim VersionAll, VersionParts, N
  VersionAll = Array(0, 0, 0, 0)
  VersionParts = Split(Version, ".")
  For N = 0 To UBound(VersionParts)
    VersionAll(N) = CLng(VersionParts(N))
  Next

  Dim Hi, Lo
  Hi = Lsh(VersionAll(0), 16) + VersionAll(1)
  Lo = Lsh(VersionAll(2), 16) + VersionAll(3)

  GetVersionStringAsArray = Array(Hi, Lo)
End Function

'===========================================================================CompareVersions=================================================================================

' Compares two versions "a.b.c.d". If Version1 < Version2,
' returns -1. If Version1 = Version2, returns 0.
' If Version1 > Version2, returns 1.

Function fnCompareVersions(ByVal Version1, ByVal Version2)
  Dim Ver1, Ver2, Result
  Ver1 = GetVersionStringAsArray(Version1)
  Ver2 = GetVersionStringAsArray(Version2)
  If Ver1(0) < Ver2(0) Then
    Result = -1
  ElseIf Ver1(0) = Ver2(0) Then
    If Ver1(1) < Ver2(1) Then
      Result = -1
    ElseIf Ver1(1) = Ver2(1) Then
      Result = 0
    Else
      Result = 1
    End If
  Else
    Result = 1
  End If
  fnCompareVersions = Result
  'wscript.echo "Compareversion" & fnCompareVersions
End Function

'===========================================================================fnCheckParticularHotfix=====================================================================================

Function fnCheckParticularHotfix(strPuter, strHotfixID) 
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''  
    ' Version 1.0 
    ' Checks if a particular hotfix is installed or not.  
    ' This function has these 3 return options: 
    ' TRUE, FALSE, <error description>  
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''  
    On error resume next 
    Set objWMIService = GetObject("winmgmts:" _ 
        & "{impersonationLevel=impersonate}!\\" & strPuter & "\root\cimv2") 
    if err.number <> 0 then 
        CheckParticularHotfix = "WMI could not connect to computer '" & strPuter & "'" 
        exit function 'No reason to continue 
    end if 
     
    strWMIforesp = "Select * from Win32_QuickFixEngineering where HotFixID = 'Q" & strHotfixID &_  
    "' OR HotFixID = 'KB" & strHotfixID & "'" 
    Set colQuickFixes = objWMIService.ExecQuery (strWMIforesp) 
    if err.number <> 0 Then    'if an error occurs 
        CheckParticularHotfix = "Unable to get WMI hotfix info" 
    else 'Error number 0 meaning no error occured  
        tal = colQuickFixes.count 
        if tal > 0 then 
            fnCheckParticularHotfix = "Yes"    'HF installed 
        else  
            fnCheckParticularHotfix = "No"   'HF not installed 
        end If 
    end if 
    Set colQuickFixes = Nothing 
     
    Err.Clear 
    On Error GoTo 0 
end function 

'===========================================================================fnCheckRegistryForProductCodes=====================================================================================

Function fnCheckRegistryForProductCodes( arrProdCode, strNewVersion )
On error resume next
fnCheckRegistryForProductCodes = FALSE
err.clear

For i = 0 To ubound (arrProdCode)

ProdCode = arrProdCode( i )

	If is32BitOS() then
		If fnFindRegKey( "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", Prodcode ) = "Found" then
			fnLog "fnCheckRegistryForProductCodes: Product Found!"
			fnLog "Checking Installed Version."
			strCurrentVer = objShell.RegRead( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & Prodcode & "\DisplayVersion" )
			fnLog "Minimum Required Version is: " & strNewVersion & " The Currently available version is: " & strCurrentVer & "!"
				If  fnCompareVersions( strCurrentVer, strNewVersion ) =  -1 then
					fnLog "Compare Version: minimum required version is not installed!"
				StrUninstProdCode = Prodcode
				fnCheckRegistryForProductCodes = True
				StrUninstVer = strCurrentVer
				End If
		End If		

	Else

		If fnFindRegKey( "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall", Prodcode ) = "Found" then
			fnLog "fnCheckRegistryForProductCodes: Product Found!"
			fnLog "Checking Installed Version."
			strCurrentVer = objShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\" & Prodcode & "\DisplayVersion")
			fnLog "Minimum Required Version is: " & strNewVersion & " The Currently available version is: " & strCurrentVer & "!"
				If fnCompareVersions( strCurrentVer, "strNewVersion" ) = -1  then
					fnLog "Compare Version: minimum required version is not installed!"
				StrUninstProdCode = Prodcode
				fnCheckRegistryForProductCodes = True
				StrUninstVer = strCurrentVer
				End If
		End If

		If fnFindRegKey( "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", Prodcode ) = "Found" then
			fnLog "fnCheckRegistryForProductCodes: Product Found!"
			fnLog "Checking Installed Version."
			strCurrentVerx64 = objShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & Prodcode & "\DisplayVersion")
			fnLog "Minimum Required Version is: " & strNewVersion & " The Currently available version is: " & strCurrentVerx64 & "!"
				If fnCompareVersions( strCurrentVerx64, strNewVersion ) = -1 then
					fnLog "Compare Version: minimum required version is not installed!"
				StrUninstProdCode = Prodcode
				fnCheckRegistryForProductCodes = True
				StrUninstVer = strCurrentVerx64
				End If
		End If
		
	End If

Next

End Function



'----------------------------------------------------------------------------SCRIPT OPERATIONS--------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

'===========================================================================fnLog==================================================================================

Function fnLog( EntryText )

	ON ERROR RESUME NEXT
	
	If Not objFSO.FolderExists( strLogFolder ) Then 
		Set objFile = objFSO.CreateFolder( strLogFolder )
	End If

	If objfso.FileExists( strLogFile ) Then 
		Set objFile = objFSO.OpenTextFile( strLogFile, ForAppending )
	else
		Set objFile = objFSO.CreateTextFile( strLogFile )
	End If
	
	objFile.WriteLine strDate & " " & vbTab & EntryText '& vbCrLf 
	objFile.Close
	
End Function


Function fnGetScriptHost()
	If UCASE(right(wscript.fullname,11)) = "CSCRIPT.EXE" Then
		strGetScriptHost = "cscript"
	Else
		strGetScriptHost = "wscript"
		wscript.echo "Start with ""cscript.exe " & Wscript.ScriptName & """!"
		fnLog "wscript Not supported"
		fnEnding 1603
	End If
End Function

'===========================================================================subforce_cscript==================================================================================

'Function Created by György Tilly
sub sbforce_cscript() 'combination of 1 & 2
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

'===========================================================================fnMessage==========================================================================================

function fnMessage(strMessage)
	wscript.echo(Time & " " & strMessage)
end function

'===========================================================================fnDtrmnCRInstallerGUID=====================================================================================

Function fnDtrmnCRInstallerGUID( strProductGUID, booFunctionLogging )

on error resume next

err.clear

arrProdcode = Split (strProductGUID, "-")
strFormed = arrProdcode(0) & arrProdcode(1) & arrProdcode(2) & arrProdcode(3) & arrProdcode(4)

strFormed = left( strFormed, len( strFormed ) - 1 )

strFormed = right( strFormed, len( strFormed ) - 1 )

Dim arrNewGuid(32)

For q = 0 To len(strFormed)
	arrNewGuid(q) = Mid(strFormed,q,1)
Next 

strfnDtrmnCRInstallerGUID = 	arrNewGuid(8) &_
					arrNewGuid(7) &_
					arrNewGuid(6) &_
					arrNewGuid(5) &_
					arrNewGuid(4) &_
					arrNewGuid(3) &_
					arrNewGuid(2) &_
					arrNewGuid(1) &_
					arrNewGuid(12) &_
					arrNewGuid(11) &_
					arrNewGuid(10) &_
					arrNewGuid(9) &_
					arrNewGuid(16) &_
					arrNewGuid(15) &_
					arrNewGuid(14) &_
					arrNewGuid(13) &_
					arrNewGuid(18) &_
					arrNewGuid(17) &_
					arrNewGuid(20) &_
					arrNewGuid(19) &_
					arrNewGuid(22) &_
					arrNewGuid(21) &_
					arrNewGuid(24) &_
					arrNewGuid(23) &_
					arrNewGuid(26) &_
					arrNewGuid(25) &_
					arrNewGuid(28) &_
					arrNewGuid(27) &_
					arrNewGuid(30) &_
					arrNewGuid(29) &_
					arrNewGuid(32) &_
					arrNewGuid(31)

					
If booFunctionLogging = True then

fnlog "Guid under HKLM_or_HKCU\" & strfnDtrmnCRInstallerGUID

End If

End Function

'----------------------------------------------------------------------------Registry OPERATIONS--------------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'===========================================================================fnCreateARP===================================================================================

Function fnCreateARP ( strUninstallString, strVisible )

arrCreateARPNames = Split(strSoftwareName, "_")

strVendor = arrCreateARPNames(0)
strAppName = arrCreateARPNames(1)
strVersion = arrCreateARPNames(2)

err.clear

fnRegWrite  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & strVendor & strAppName & strVersion & "\DisplayName", strAppName, "REG_SZ"
fnReturnCheckandContinue()
fnRegWrite  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & strVendor & strAppName & strVersion & "\DisplayVersion", strVersion, "REG_SZ"
fnReturnCheckandContinue()
fnRegWrite  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & strVendor & strAppName & strVersion & "\UninstallString", strUninstallString, "REG_SZ"
fnReturnCheckandContinue() 
fnRegWrite  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & strVendor & strAppName & strVersion & "\InstallLocation", strScriptLocation, "REG_SZ" 
fnReturnCheckandContinue()
fnRegWrite  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & strVendor & strAppName & strVersion & "\Publisher", strVendor, "REG_SZ" 
fnReturnCheckandContinue()

If strVisible = "Yes" then
Else
fnRegWrite  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & strVendor & strAppName & strVersion & "\SystemComponent", "1", "REG_SZ" 
End If

fnReturnCheckandContinue()

fnLog "ARP entry creation returned with SUCCESS!"

End Function

'===========================================================================fnDeleteARP===================================================================================

Function fnDeleteARP ()
err.clear

arrCreateARPNames = Split(strSoftwareName, "_")

strVendor = arrCreateARPNames(0)
strAppName = arrCreateARPNames(1)
strVersion = arrCreateARPNames(2)

fnRegDelete  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & strVendor & strAppName & strVersion
fnReturnCheckandContinue()

fnLog "ARP entry removal returned with SUCCESS!"

End Function

'===========================================================================fnCreateActiveSetup===================================================================================

Function fnCreateActiveSetup ( strActiveSetupCommand )

	If Not objFSO.FolderExists( strLogFolder & "ActiveSetup" ) Then 
		objFSO.CreateFolder( strLogFolder & "ActiveSetup" ) 
		fnLog "Active Setup folder created: " & strLogFolder & "ActiveSetup"
	Else
		fnLog "Active Setup folder already exists: " & strLogFolder & "ActiveSetup"
	End If 

arrCreateARPNames = Split(strSoftwareName, "_")

strVendor = arrCreateARPNames(0)
strAppName = arrCreateARPNames(1)
strVersion = arrCreateARPNames(2)

strACTSVersion = Replace(strVersion,".",",")

err.clear

fnRegWrite  "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\" & strVendor & strAppName & strVersion & "\Version", strACTSVersion, "REG_SZ"
fnReturnCheckandContinue()
fnRegWrite  "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\" & strVendor & strAppName & strVersion & "\StubPath", strActiveSetupCommand, "REG_SZ"
fnReturnCheckandContinue()
fnLog "ActiveSetup entry creation returned with SUCCESS!"

End Function

'===========================================================================fnDeleteACTS===================================================================================

Function fnDeleteACTS ()
err.clear

arrCreateARPNames = Split(strSoftwareName, "_")

strVendor = arrCreateARPNames(0)
strAppName = arrCreateARPNames(1)
strVersion = arrCreateARPNames(2)

fnRegDelete  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" & strVendor & strAppName & strVersion
fnReturnCheckandContinue()

fnLog "Active Setup Entry Removal Finished SUCCESSFULLY!"

End Function

'===========================================================================fnFindRegKeyHKU================================================================================

Function fnFindRegKey( strKey, strName )
	'ysnReturn = False
	objReg.EnumKey HKU, strKey, arrSubkeys
	If IsArray( arrSubkeys ) Then 
		 For Each strSubkey In arrSubkeys
			If InStr( lcase( strSubkey ), lcase( strName ) ) > 0 Then
				fnFindRegKey = "Found"
			End If
		 Next 
	End If 
End Function

'===========================================================================fnFindRegKey==================================================================================

Function fnFindRegKey( strKey, strName )
	'ysnReturn = False
	objReg.EnumKey HKLM, strKey, arrSubkeys
	If IsArray( arrSubkeys ) Then 
		 For Each strSubkey In arrSubkeys
			If InStr( lcase( strSubkey ), lcase( strName ) ) > 0 Then
				fnFindRegKey = "Found"
			End If
		 Next 
	End If 
End Function

'=====================================================================fnUninstallExcellAddin===============================================================================

Function fnUninstallExcellAddin ( strAddinFile )

On Error Resume Next

fnLog "fnUninstallExcellAddin STARTED:"

If booOffline = true and fnCheckProc("EXCEL.EXE") = true  then
Popret = fnYNPopup("Due to a removal of an Excle AddIn your EXCEL should be close!" & vbsrlf & "Please respond or your worksheet will be closed in 40 seconds.", 40, "Removal of EXCLE AddIn!!!")
	If Popret = 0 then
	fnKillProc( "EXCEL.EXE" )
	ELSE
	fnLog "fnUninstallExcellAddin Returned with an ERROR: " & Popret
	End If
ELSE
fnKillProc( "EXCEL.EXE" )
End If

strRegOfficeVer = fnCheckOfficeVer()

fnLoadHKU()

objReg.EnumKey HKU,"", arrSubkeys

    If IsArray(arrSubkeys) Then 

			For Each strSubkey In arrSubkeys

				' Select Case strSubkey
				' Case "S-1-5-18"
				' Case "S-1-5-19"
				' Case "S-1-5-20"
				' Case Else
					strExcelRegistryKey = "HKEY_USERS\" & strSubkey & "\Software\Microsoft\Office\" & strRegOfficeVer & "\Excel\Options"
						strRegKey = ""
						strRegKeyValue = ""
						intCount = 0
						strDone = "No"
					
						strRegKeyValue = objShell.RegRead(strExcelRegistryKey & "\Open")

						If not strRegKeyValue = Empty then
								If InStrInStr(strAddinFile, strRegKeyValue) > 0 Then
									Err.Clear
									objShell.RegDelete (strExcelRegistryKey & "\Open")
									If (err.number = 0) then
									' strDone = "Yes"
									End If
								End If
						End If
						
						Err.Clear
						
						Do
						intCount = intCount + 1
						strRegKey = strExcelRegistryKey & "\Open" & intCount
							Err.Clear
							strRegKeyValue = objShell.RegRead(strRegKey)
							If err.number = 0 then
								If InStr(strAddinFile, strRegKeyValue) > 0 Then
									Err.Clear
									objShell.RegDelete (strExcelRegistryKey & "\Open" & intCount)
									If (err.number = 0) then
									fnLog "The following registry entry is removed: " & strExcelRegistryKey & "\Open" & intCount
									strDone = "Yes"
									End If
								End If
							ElseIf intCount > 100 then
							strDone = "Yes"
							End If
						Loop Until strDone = "Yes"
				' End Select
			Next 
    End If 

fnLog "fnUninstallExcellAddin ENDS HERE"

End Function

'===========================================================================fnDeleteRegKeyFromUsers===============================================================================

Function fnDeleteRegKeyFromUsers ( strHKCURegPath )

On Error Resume Next

fnLoadHKU()

fnLog "START fnDeleteRegKeyFromUsers: " & strHKCURegPath


			arrRegPath = Split(strHKCURegPath,"\")
			If arrregpath(0) = "HKEY_CURRENT_USER" then
			strNewPath = right( strHKCURegPath, len( strHKCURegPath ) - 17 )
			 ' wscript.echo strNewPath
			ElseIf arrregpath(0) = "HKCU" then
			strNewPath = right( strHKCURegPath, len( strHKCURegPath ) - 4 )
			 ' wscript.echo strNewPath
			ELSE
			fnDeleteRegKeyFromUsers = -1
			fnLog "ERROR provided strHKCURegPath is not valid: " & fnDeleteRegKeyFromUsers
			End If

			
objReg.EnumKey HKU,"", arrSubkeys
    If IsArray(arrSubkeys) Then 

			For Each strSubkey In arrSubkeys

				' Select Case strSubkey
				' Case "S-1-5-18"
				' Case "S-1-5-19"
				' Case "S-1-5-20"
				' Case Else
									' wscript.echo strSubkey & strNewPath
									err.clear
									fnDeleteRegAndSubkeys HKU, strSubkey & strNewPath
									If (err.number = 0) then
									fnLog "RegKey Deleted: " & "HKU" & strSubkey & strNewPath
									End If
				' End Select
			Next 
    End If 

fnLog "END fnDeleteRegKeyFromUsers"

End Function

'===========================================================================fnDeleteRegAndSubkeys============================================================================

Function fnDeleteRegAndSubkeys(constReg, strKeyPath) 
objReg.EnumKey constReg, strKeyPath, arrSubkeys
	If IsArray(arrSubkeys) Then 
		For Each strSubkey In arrSubkeys 
		' wscript.echo strSubkey 
		fnDeleteRegAndSubkeys constReg, strKeyPath & "\" & strSubkey 
		Next 
	End If 
objReg.DeleteKey constReg, strKeyPath 
End Function

'===========================================================================fnLoadHKU========================================================================================
Function fnLoadHKU()

If booHKULOADED = false then
	objReg.EnumKey HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList", arrProfs
	For Each strProf in arrProfs
			
			Select Case strProf
				Case "S-1-5-18"
				Case "S-1-5-19"
				Case "S-1-5-20"
				Case Else
				srtTheUser = objShell.RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\" & strProf & "\ProfileImagePath")
				' wscript.echo srtTheUser
				fnStartExe "C:\Windows\System32\", "reg.exe", " load HKU\" & strProf & " " & srtTheUser & "\ntuser.dat", False
				booHKULOADED = True
			End Select

	Next
Else
fnLog "HKU loaded already."
End If

End Function

'===========================================================================fnregValueExists===============================================================================

Function fnregValueExists (strkey)
      'This function checks if a registry value exists and returns True of False
      On Error Resume Next
      Err.Clear
      inregturn = objShell.RegRead(strkey)
      If inregturn <> 0 Then 
	  fnregValueExists = True
	  Else
	  fnregValueExists = False
	  End IF
End Function

'===========================================================================fnRegWrite=====================================================================================

Function fnRegWrite ( strValuePath, strData, strRegType )

On Error Resume Next
err.clear
objShell.RegWrite strValuePath, strData, strRegType
fnRegWrite  = err.number

End Function

'===========================================================================fnRegDelete=====================================================================================

Function fnRegDelete(strKey)
	'fnRegDelete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\CfgDownload"
	On Error Resume Next
	fnLog "Deleting Registry Key " & strKey
	objShell.RegDelete strKey
	fnLog "RegKey deleted"
	On Error Goto 0    
End Function

'===========================================================================fnFindValueNameAndDelReg=========================================================================
Function fnFindValueNameAndDelReg( constMainReg, strSearchPath, strValue )

On error resume next
objReg.EnumKey constMainReg, "", arrSubkeys

For Each strSubKey in arrSubKeys
	
	objReg.EnumKey constMainReg, strSubKey & strSearchPath, arrSubkeys2
	
	For each subkey2 in arrSubkeys2
	
		objReg.EnumValues constMainReg, strSubKey & strSearchPath & subkey2, arrValueNames, arrValueTypes
			
			For Each ValueName in arrValueNames

				If ValueName = strValue then
				
					fnFindValueNameAndDelReg_ret = objReg.DeleteKey ( constMainReg, strSubKey & strSearchPath & subkey2 )
					fnlog "fnFindValueNameAndDelReg delete registry called with: " & constMainReg & strSubKey & strSearchPath & subkey2
					fnlog "fnFindValueNameAndDelReg delete registry: " & fnFindValueNameAndDelReg_ret

				End If
				
			Next
	Next

Next	

End Function

'===========================================================================fnFindKeyAndDelReg=========================================================================
Function fnFindKeyAndDelReg( constMainReg, strSearchPath, strValue )

On error resume next
objReg.EnumKey constMainReg, "", arrSubkeys

For Each strSubKey in arrSubKeys
	
	objReg.EnumKey constMainReg, strSubKey & strSearchPath, arrSubkeys2
	
	For each subkey2 in arrSubkeys2

				If subkey2 = strValue then
				
					fnFindKeyAndDelReg_ret = objReg.DeleteKey ( constMainReg, strSubKey & strSearchPath & subkey2 )
					fnlog "fnFindKeyAndDelReg delete registry called with: " & constMainReg & strSubKey & strSearchPath & subkey2
					fnlog "fnFindKeyAndDelReg delete registry: " & fnFindKeyAndDelReg_ret

				End If
				
			Next
	Next

End Function

'----------------------------------------------------------------------------OS Related OPERATIONS------------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'===========================================================================fnUserLogOff==================================================================================

Function fnUserLogOff()

	StrHeader = "Log-off"
	
	StrMsg1= "Your SafeGuard Enterprise configuration has been changed. To have the new settings take effect you have to log on to the system anew." & chr(13) & chr(13) & "Do you want to be LOGGED OFF now?"
	
	StrMSg2 = "Log-off REFUSED!" & chr(13) & chr(13) & "Please log on to the system anew as soon as possible to ensure compliance IT security regulation."
	
	StrMSg3 = "Please SAVE your data and CLOSE all applications/windows before you proceed, then click OK to be logged off. You can log on again immediately."
	
	
	fnLog "Asking user to log off"

	UsrChoice = MsgBox(StrMsg1,65828,strHeader) 'Valid user choises: 1=OK / 2=CANCEL / 6=YES / 7=NO
	if UsrChoice = 6 then 'if YES
		fnLog "User has started log-off procedure"
		
		StrHeader = "Log-off confirmation"
		UsrChoiceConfirm = MsgBox(strMsg3,65841,StrHeader)
		if UsrChoiceConfirm = 1 then 'if OK
			fnLog "User has confirmed log-off"
			objShell.exec ("C:\windows\system32\shutdown.exe /l")
			'fnRefreshExplorer 'use this for quick testing instead of log-off. Only Explorer process will be restarted then
			'intReturn="1" '1 = use this when letting Altiris log off the user
		elseif UsrChoiceConfirm = 2 then 'if CANCEL
			fnLog "User has canceled log-off procedure"
			StrHeader = "Log-off canceled"
			msgbox strMsg2 ,65536,StrHeader
		end if
		
	elseif UsrChoice = 7 then 'if NO
		fnLog "User has canceled log-off procedure"
		StrHeader = "Log-off canceled"
		msgbox strMsg2 ,65536,StrHeader
	end if

End Function


'===========================================================================fnKillProcInstall=====================================================================================

Function fnKillProc( myProcess )
On Error Resume Next
'Purpose: Kills a process and waits until it is truly dead
Err.clear
    Dim blnRunning, colProcesses, objProcess
    blnRunning = False

    Set colProcesses = GetObject( _
                       "winmgmts:{impersonationLevel=impersonate}" _
                       ).ExecQuery( "Select * From Win32_Process", , 48 )
    For Each objProcess in colProcesses
        If LCase( myProcess ) = LCase( objProcess.Name ) Then
            ' Confirm that the process was actually running
            blnRunning = True
            ' Get exact case for the actual process name
            myProcess  = objProcess.Name
            ' Kill all instances of the process
            objProcess.Terminate()
			fnKillProc = err.number
			fnlog "fnKillProc Returned: " & fnKillProc & "!"
        End If
    Next

    If blnRunning Then	
        ' Wait and make sure the process is terminated.
        Do Until Not blnRunning
            Set colProcesses = GetObject( _
                               "winmgmts:{impersonationLevel=impersonate}" _
                               ).ExecQuery( "Select * From Win32_Process Where Name = '" _
                             & myProcess & "'" )
            WScript.Sleep 100 'Wait for 100 MilliSeconds
            If colProcesses.Count = 0 Then 'If no more processes are running, exit loop
                blnRunning = False
            End If
        Loop
        ' Display a message
		fnKillProc = 0
        fnlog myProcess & " was terminated. fnKillProc Returned: "  & fnKillProc
    Else
		fnKillProc = -1
        fnlog "Process """ & myProcess & """ not found. fnKillProc Returned: " & fnKillProc
    End If
End Function

'===========================================================================fnYNPopup=====================================================================================

Function fnYNPopup(strMessage, intTimeout, strHeader)

intPopReturn = objShell.Popup(strMessage, intTimeout, strHeader, vbYesNo + vbQuestion)

If intPopReturn = vbYes Then
	fnLog " User pressed Yes!"
	fnYNPopup = 0
End If
If intPopReturn = vbNo Then
	fnLog " User pressed Cancel!"
	fnYNPopup = 1112
End If
If intPopReturn = -1 Then
	fnLog " Popup timed out"
	fnYNPopup = 0
End If
End Function

'===========================================================================fnCheckProc=====================================================================================

Function fnCheckProc( myProcess )
On Error Resume Next
'Purpose: Kills a process and waits until it is truly dead

    Dim colProcesses, objProcess, return
    return = False
    Set colProcesses = GetObject( _
                       "winmgmts:{impersonationLevel=impersonate}" _
                       ).ExecQuery( "Select * From Win32_Process", , 48 )
    For Each objProcess in colProcesses
        If LCase( myProcess ) = LCase( objProcess.Name ) Then
            ' Confirm that the process was actually running
            fnCheckProc = True
		Else
        End If
    Next
End Function

'===========================================================================fnNEWRestart=====================================================================================

Function fnNEWRestart( )
	fnLog " Initiate shutdown..."
	objShell.Run "shutdown.exe /R /F /t 20 /c "" Your client will reboot automatically after 20 Second"" ", 0 ,FALSE
	interturn = 0
	fnExit()
End Function


'******************************************************************************************************THE***********END**************************************************************************************
'Under construction

Function fnDotNetVersion( strRequiredVersion )

If Is32BitOS() then
  objReg.EnumKey HKLM, "SOFTWARE\Microsoft\NET Framework Setup\NDP", arrSubkeys
	For each Subkey in arrSubkeys
	
		If instr(Subkey, "v" & strRequiredVersion) = 1 then
			objReg.EnumKey HKLM, "SOFTWARE\Microsoft\NET Framework Setup\NDP\" & subkey, arrVerSubkeys
				For Each VerSubkey in arrVerSubkeys
					'wscript.echo VerSubkey
						'If instr(VerSubkey, "Client") = 1 then
						'strClntVrsn = objShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\" & Subkey & "\" & VerSubkey & "\" & "Release")
						'wscript.echo strClntVrsn
						'End If
						
						'If instr(VerSubkey, "Full") = 1 then
						strFllVrsn = objShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\" & Subkey & "\" & VerSubkey & "\" & "Version")
						'wscript.echo strFllVrsn
							If ( fnCompareVersions( strFllVrsn, strRequiredVersion ) = 0 ) or ( fnCompareVersions( strFllVrsn, strRequiredVersion ) = 1 ) then
								fnDotNetVersion = True
							End IF
						'End If
				Next
		End If
	Next

Else

  objReg.EnumKey HKLM, "SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP", arrSubkeys
	For each Subkey in arrSubkeys
		If instr(Subkey, "v" & strRequiredVersion) = 1 then
			'wscript.echo subkey
			objReg.EnumKey HKLM, "SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\" & subkey, arrVerSubkeys
				For Each VerSubkey in arrVerSubkeys
					'wscript.echo VerSubkey
						'If instr(VerSubkey, "Client") = 1 then
							'strClntVrsn = objShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\" & Subkey & "\" & VerSubkey & "\" & "Release")
							'wscript.echo strClntVrsn
						'End If
						
						'If instr(VerSubkey, "Full") = 1 then
							strFllVrsn = objShell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\" & Subkey & "\" & VerSubkey & "\" & "Version")
								If ( fnCompareVersions( strFllVrsn, strRequiredVersion ) = 0 ) or ( fnCompareVersions( strFllVrsn, strRequiredVersion ) = 1 ) then
									fnDotNetVersion = True
								End IF
						'End If
				Next
		End If
	Next
End If


End Function

'******************************************************************************************************THE***********END**************************************************************************************