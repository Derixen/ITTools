##########################################################################
# LOGON SCRIPT MANAGER
##########################################################################
# Created by: ME
# Created on: 2018-06-29
# Revision: 1.0.0
# Description: Script is responsible to control and run multiple scripts
# at logon or startup, with the ability to taget only specific members of specific groups
##########################################################################
# VERSION CONTROL
##########################################################################
# 2020.01.06 - v1.0 - Script created by ME
##########################################################################

$ErrorActionPreference = 'silentlycontinue'

##########################################################################
# GLOBAL VARIABLES
##########################################################################

$ScriptName = "Logon Script Manager"
$ScriptVersion = "1.0.0"
$WorkDir = "C:\Windows\Temp\_LSSM"
$LogDate = Get-Date -Format yyyyMMdd
$LogDateBackup = Get-Date -Format yyyyMMddHHmmss
$Log = "GLSS_$LogDate.log"
$LogDir = $WorkDir + $Log
$GLStartDate = Get-Date
$ScriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition
$i = 0
$ErrorOccured = $false

##########################################################################
# FUNCTIONS
##########################################################################

function Output-Log
{
    param( [string]$LogData  )
    $LogDateFormat = Get-Date -Format "yyyy.MM.dd HH:mm:ss"
    $LogDateFormat + " - " + $LogData >> $LogDir
}

##########################################################################
# SCRIPT BODY
##########################################################################

# Create log folder if it does not exists
If(!(test-path $WorkDir )) { New-Item -ItemType Directory -Force -Path $WorkDir }

# Remove old logs
$limit = (Get-Date).AddDays(-7)
Get-ChildItem -Path $WorkDir -Force -Filter GLSS* | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

##########################################################################
# RUNNING GLOBAL LOGON SCRIPTS
##########################################################################
$Log = "GLSS_LOGON_$LogDate.log"
$LogDir = $WorkDir + $Log

Output-Log -LogData ("------------------------------------------------")
Output-Log -LogData ("Script name: " + $ScriptName)
Output-Log -LogData ("Script version: " + $ScriptVersion)
Output-Log -LogData ("Script Type: LOGON")
Output-Log -LogData ("Script running on " + (hostname))
Output-Log -LogData ("Script running at " + (get-date))
Output-Log -LogData ("Script running by " + (whoami))
Output-Log -LogData ("Script path " + ($ScriptPath))
Output-Log -LogData ("------------------------------------------------")

$Include=@("*.ps1","*.cmd","*.bat","*.vbs")
$GlobalLogonScripts = Get-ChildItem "$ScriptPath\Global_Logon\*.*" -Include $Include
$MemberbasedLogonScripts = Get-ChildItem "$ScriptPath\Memberbased_Logon\*.*" -Include $Include

Try
{
    Output-Log -LogData ( "Retrieving MemberOf List using .NET..." )
    $UserGroupsNET = ([System.DirectoryServices.DirectorySearcher]"(&(objectCategory=User)(sAMAccountName=$env:UserName))").FindAll().Properties["MemberOf"]
    $UserGroups = @()
    foreach ($UserGroupNET in $UserGroupsNET) {
        $Int = $UserGroupNET.IndexOf(",")
        $UserGroups += New-Object psobject -Property @{ Name = $UserGroupNET.Substring(3,$Int - 3) }
    }
    $UserGroups = $UserGroups | where {$_.Name -like "*LSSM_*"}
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    Output-Log -LogData ( "There was an error retrieving the Membership list from AD. Error Message: $ErrorMessage" )
    $ErrorOccured=$true
}

if($ErrorOccured) {
    Output-Log -LogData ( "Retrieving MemberOf List using PowerShell..." )
    $UserGroups = GET-ADUser -Identity $env:UserName –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | Select-Object name | where {$_.Name -like "RA046_GLSS_*"}
}

$Exclusions = @()
foreach ( $UserGroup in $UserGroups )
{
 
    If ($UserGroup.Name.Split("_")[3] -eq "E")
    {
        $Exclusions += New-Object psobject -Property @{ FileName = $UserGroup.Name.Substring(15,$UserGroup.Length - 15) }
    }
}

Output-Log -LogData ("/////GLOBAL LOGON SCRIPTS/////")
$x = 0

Output-Log -LogData ("LSSM Groups: " + ($UserGroups.Name -join ";"))
Output-Log -LogData ("Scripts excluded from: " + ($Exclusions.FileName -join ";"))

foreach ( $GlobalLogonScript in $GlobalLogonScripts ) {

    If ( $Exclusions.FileName -notcontains $GlobalLogonScript.BaseName )
    {
        Output-Log -LogData ("Starting script '" + $GlobalLogonScript.Name + "':")
        $ScriptStartDate = Get-Date
     
        "------------------------------------------------" >> $LogDir

        Switch ($GlobalLogonScript.Extension) {
        ".ps1" { powershell.exe -File $GlobalLogonScript.FullName >> $LogDir }
        ".cmd" { cmd /c $GlobalLogonScript.FullName >> $LogDir }
        ".bat" { cmd /c $GlobalLogonScript.FullName >> $LogDir }
        ".vbs" { & cscript.exe /nologo $GlobalLogonScript.FullName >> $LogDir }
        }
     
        "------------------------------------------------" >> $LogDir
 
        $ScriptEndDate = Get-Date
        $ScriptRunTime = New-TimeSpan -Start $ScriptStartDate -End $ScriptEndDate
        Output-Log -LogData ("Stopping script. '" + $GlobalLogonScript.Name + "'. Total runtime: $ScriptRunTime")
        $x = $x + 1
        $i = $i + 1
    } else {
        Output-Log -LogData ("Script '" + $GlobalLogonScript.Name + "' blocked from running.")
    }

}
Output-Log -LogData ("Global Logon Scripts run: " + $x)

##########################################################################
# RUNNING MEMBERBASED LOGON SCRIPTS
##########################################################################

Output-Log -LogData ("/////MEMBERBASED LOGON SCRIPTS/////")
$x = 0

foreach ( $MemberbasedLogonScript in $MemberbasedLogonScripts ) {

    $Found = $false
 
    foreach ( $UserGroup in $UserGroups ) {

        [string]$Strint1 = $UserGroup.Name.Substring(15, $UserGroup.Name.Length - 15)
        [string]$String2 = $MemberbasedLogonScript.BaseName

        IF ( $Strint1.ToLower().Equals($String2.ToLower()) )
        {
            $Found = $true
        }
    }

    if ($Found) {
        Output-Log -LogData ("Starting script '" + $MemberbasedLogonScript.Name + "':")
        $ScriptStartDate = Get-Date

        "------------------------------------------------" >> $LogDir

        Switch ($MemberbasedLogonScript.Extension) {
        ".ps1" { powershell.exe -File $MemberbasedLogonScript.FullName >> $LogDir }
        ".cmd" { cmd /c $MemberbasedLogonScript.FullName >> $LogDir }
        ".bat" { cmd /c $MemberbasedLogonScript.FullName >> $LogDir }
        ".vbs" { & cscript.exe /nologo $MemberbasedLogonScript.FullName >> $LogDir }
        }
     
        "------------------------------------------------" >> $LogDir

        $ScriptEndDate = Get-Date
        $ScriptRunTime = New-TimeSpan -Start $ScriptStartDate -End $ScriptEndDate
        Output-Log -LogData ("Stoping script '" + $MemberbasedLogonScript.Name + "'. Total runtime: $ScriptRunTime")
        $x = $x + 1
        $i = $i + 1
    }

}
Output-Log -LogData ("Memberbased logon Scripts run: " + $x)

##########################################################################
# POST SCRIPTS
##########################################################################

$GLEndDate = Get-Date
$GLRunTime = New-TimeSpan -Start $GLStartDate -End $GLEndDate
Output-Log -LogData ("------------------------------------------------")
Output-Log -LogData ("Total number of scripts run: $i")
Output-Log -LogData ("Stopping Logon Scripts. Total runtime: $GLRunTime")
Output-Log -LogData ("------------------------------------------------")