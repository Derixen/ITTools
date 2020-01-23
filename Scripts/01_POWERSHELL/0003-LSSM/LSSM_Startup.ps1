##########################################################################
# STARTUP SCRIPT MANAGER
##########################################################################
# Created by: ME
# Created on: 2018-06-29
# Revision: 1.0.0
# Description: Script is responsible to control and run multiple scripts
# at logon or startup, with the ability to taget only specific members of specific groups
##########################################################################
# VERSION CONTROL
##########################################################################
# 2018.06.29 - v1.0 - Script created by ME
##########################################################################

$ErrorActionPreference = 'silentlycontinue'

##########################################################################
# GLOBAL VARIABLES
##########################################################################

$ScriptName = "Startup Script Manager"
$ScriptVersion = "1.0.0"
$WorkDir = "C:\Windows\Temp\_LSSM\"
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
Get-ChildItem -Path $WorkDir -Force -Filter LSSM* | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

##########################################################################
# RUNNING GLOBAL STARTUP SCRIPTS
##########################################################################
     
$Log = "LSSM_STARTUP_$LogDate.log"
$LogDir = $WorkDir + $Log

Output-Log -LogData ("------------------------------------------------")
Output-Log -LogData ("Script name: " + $ScriptName)
Output-Log -LogData ("Script version: " + $ScriptVersion)
Output-Log -LogData ("Script Type: STARTUP")
Output-Log -LogData ("Script running on " + (hostname))
Output-Log -LogData ("Script running at " + (get-date))
Output-Log -LogData ("Script running by " + (whoami))
Output-Log -LogData ("Script path " + ($ScriptPath))
Output-Log -LogData ("------------------------------------------------")

$Include=@("*.ps1","*.cmd","*.bat","*.vbs")
$GlobalStartupScripts = Get-ChildItem "$ScriptPath\Global_Startup\*.*" -Include $Include
$MemberbasedStartupScripts = Get-ChildItem "$ScriptPath\Memberbased_Startup\*.*" -Include $Include

Try
{
    Output-Log -LogData ( "Retrieving MemberOf List using .NET..." )
    $ComputerGroupsNET = ([System.DirectoryServices.DirectorySearcher]"(&(objectCategory=Computer)(name=$env:COMPUTERNAME))").FindAll().Properties["MemberOf"]
    $ComputerGroups = @()
    foreach ($ComputerGroupNET in $ComputerGroupsNET) {
        $Int = $ComputerGroupNET.IndexOf(",")
        $ComputerGroups += New-Object psobject -Property @{ Name = $ComputerGroupNET.Substring(3,$Int - 3) }
    }
    $ComputerGroups = $ComputerGroups | where {$_.Name -like "*LSSM_*"}
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    Output-Log -LogData ( "There was an error retrieving the Membership list from AD. Error Message: $ErrorMessage" )
    $ErrorOccured = $true
}

if($ErrorOccured) {
    Output-Log -LogData ( "Retrieving MemberOf List using PowerShell..." )
    $ComputerGroups = GET-ADComputer -Identity $env:COMPUTERNAME –Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup -Properties name | Select-Object name | where {$_.Name -like "RA046_GLSS_*"} -ErrorAction Stop
}
     
$Exclusions = @()
foreach ( $ComputerGroup in $ComputerGroups )
{
    If ($ComputerGroup.Name.Split("_")[3] -eq "E")
    {
        $Exclusions += New-Object psobject -Property @{ FileName = $ComputerGroup.Name.Substring(15, $ComputerGroup.Length - 15) }
    }
}

Output-Log -LogData ("/////GLOBAL STARTUP SCRIPTS/////")
$x = 0

Output-Log -LogData ("GLSS Groups: " + ($ComputerGroups.Name -join ";"))
Output-Log -LogData ("Scripts excluded from: " + ($Exclusions.FileName -join ";"))

foreach ( $GlobalStartupScript in $GlobalStartupScripts ) {
         
    If ( $Exclusions.FileName -notcontains $GlobalStartupScript.BaseName )
    {
        Output-Log -LogData ("Starting script '" + $GlobalStartupScript.Name + "':")
        $ScriptStartDate = Get-Date

        "------------------------------------------------" >> $LogDir

        Switch ($GlobalStartupScript.Extension) {
        ".ps1" { powershell.exe -File $GlobalStartupScript.FullName >> $LogDir }
        ".cmd" { cmd /c $GlobalStartupScript.FullName >> $LogDir }
        ".bat" { cmd /c $GlobalStartupScript.FullName >> $LogDir }
        ".vbs" { & cscript.exe /nologo $GlobalStartupScript.FullName >> $LogDir }
        }
     
        "------------------------------------------------" >> $LogDir

        $ScriptEndDate = Get-Date
        $ScriptRunTime = New-TimeSpan -Start $ScriptStartDate -End $ScriptEndDate
        Output-Log -LogData ("Stopping script '" + $GlobalStartupScript.Name + "'. Total runtime: $ScriptRunTime")
        $x = $x + 1
        $i = $i + 1
    } else {
        Output-Log -LogData ("Script '" + $GlobalStartupScript.Name + "' blocked from running.")
    }

}
Output-Log -LogData ("Global Startup Scripts run: " + $x)

##########################################################################
# RUNNING MEMBERBASED STARTUP SCRIPTS
##########################################################################

Output-Log -LogData ("/////MEMBERBASED STARTUP SCRIPTS/////")
$x = 0

foreach ( $MemberbasedStartupScript in $MemberbasedStartupScripts ) {
 
    $Found = $false

    foreach ( $ComputerGroup in $ComputerGroups ) {

        [string]$String1 = $ComputerGroup.Name.Substring(15, $ComputerGroup.Name.Length - 15)
        [string]$String2 = $MemberbasedStartupScript.BaseName

        IF ( $String1.ToLower().Equals($String2.ToLower()) )
        {
            $Found = $true
        }
    }

    if ($Found) {
        Output-Log -LogData ("Starting script '" + $MemberbasedStartupScript.Name + "':")
        $ScriptStartDate = Get-Date

        "------------------------------------------------" >> $LogDir

        Switch ($MemberbasedStartupScript.Extension) {
        ".ps1" { powershell.exe -File $MemberbasedStartupScript.FullName >> $LogDir }
        ".cmd" { cmd /c $MemberbasedStartupScript.FullName >> $LogDir }
        ".bat" { cmd /c $MemberbasedStartupScript.FullName >> $LogDir }
        ".vbs" { & cscript.exe /nologo $MemberbasedStartupScript.FullName >> $LogDir }
        }
     
        "------------------------------------------------" >> $LogDir

        $ScriptEndDate = Get-Date
        $ScriptRunTime = New-TimeSpan -Start $ScriptStartDate -End $ScriptEndDate
        Output-Log -LogData ("Stopping script '" + $MemberbasedStartupScript.Name + "'. Total runtime: $ScriptRunTime")
        $x = $x + 1
        $i = $i + 1
    }
}
Output-Log -LogData ("Memberbased Startup Scripts run: " + $x)

##########################################################################
# POST SCRIPTS
##########################################################################

$GLEndDate = Get-Date
$GLRunTime = New-TimeSpan -Start $GLStartDate -End $GLEndDate
Output-Log -LogData ("------------------------------------------------")
Output-Log -LogData ("Total number of scripts run: $i")
Output-Log -LogData ("Stopping Startup Scripts. Total runtime: $GLRunTime")
Output-Log -LogData ("------------------------------------------------")