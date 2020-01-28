##########################################################################
# SAPLOGONINI COPY SCRIPT
##########################################################################
# Created by: Janos Friedrich
# Created on: 2018-06-07
# 
# Description: Script is responsible to copy the up-to-date SAPLogon.ini 
# to the Users PC during logon
##########################################################################

$ErrorActionPreference = 'silentlycontinue'

##########################################################################
# GLOBAL VARIABLES
##########################################################################

$ScriptID = "000xx"
$WorkDir = "C:\Windows\Temp\"
$LogDate = Get-Date -Format yyyyMMdd
$LogDateBackup = Get-Date -Format yyyyMMddHHmmss
$Log = "SapLogonCopy-$LogDate.log"
$LogDir = $WorkDir + $Log
$ScriptStartDate = Get-Date

##########################################################################
# FUNCTIONS
##########################################################################

function Output-Log 
{
    param( [string]$LogData  )
    $LogDateFormat = Get-Date -Format g
    $LogDateFormat + " - " + $LogData >> $LogDir
}

If( !($LogDir | Test-Path) ) 
{
    Output-Log -LogData ("------------------------")
    Output-Log -LogData ("------------------------")
    Output-Log -LogData ("ScriptID: " + $ScriptID)
    Output-Log -LogData ("Script running on " + (hostname))
    Output-Log -LogData ("Script running at " + (get-date))
    Output-Log -LogData ("Script running by " + (whoami))
    Output-Log -LogData ("------------------------")
}

Output-Log -LogData ("Starting script")

$Source = ".\saplogon_Siemens_GLOBAL.ini"
$Destination = "$env:USERPROFILE\AppData\Roaming\SAP\Common\SapLogon.ini"
$Destination2 = "$env:USERPROFILE\AppData\Roaming\SAP\SapLogon.ini"
$Exclusion = "$env:USERPROFILE\AppData\Roaming\SAP\Common\do_not_update_my_saplogon_ini.txt"
$Exclusion2 = "$env:USERPROFILE\AppData\Roaming\SAP\do_not_update_my_saplogon_ini.txt"
$Backup = "$env:USERPROFILE\AppData\Roaming\SAP\Common\_OldSapLogon\SapLogon-$LogDateBackup.ini"
$Backup2 = "$env:USERPROFILE\AppData\Roaming\SAP\_OldSapLogon\SapLogon-$LogDateBackup.ini"

$SourceFileExists = Test-Path $Source
$ExclusionFileExists = Test-Path $Exclusion
$ExclusionFileExists2 = Test-Path $Exclusion2
$DestinationFileExists = Test-Path $Destination
$DestinationFileExists2 = Test-Path $Destination2

If ($ExclusionFileExists -eq $True -or $ExclusionFileExists2 -eq $True)
{
    Output-Log -LogData ("Warning: Exclusion file do_not_update_my_saplogon_ini.txt found! Source file will not be copied")
}
else
{
    Output-Log -LogData ("Exclusion file do_not_update_my_saplogon_ini.txt not found")

    If ($SourceFileExists -eq $True )
    {
        Output-Log -LogData ("Source file exists")

        If ($DestinationFileExists -eq $True -and $DestinationFileExists2 -eq $True)
        {
            Output-Log -LogData ("Destination file already exist. Checking last modified date...")

            $DestinationFile = Get-Item $Destination
            $DestinationFile2 = Get-Item $Destination2
            $SourceFile = Get-Item $Source
            Output-Log -LogData ("Destination file was last modified at: " + $DestinationFile.LastWriteTime)
            Output-Log -LogData ("Destination2 file was last modified at: " + $DestinationFile2.LastWriteTime)
            Output-Log -LogData ("Source file was last modified at: " + $SourceFile.LastWriteTime)

            If ($SourceFile.LastWriteTime -eq $DestinationFile.LastWriteTime -and $SourceFile.LastWriteTime -eq $DestinationFile2.LastWriteTime)
            {
                Output-Log -LogData ("No modificaions found. File copy action will not be initiated")
                $ScriptEndDate = Get-Date
                $ScriptRunTime = New-TimeSpan -Start $ScriptStartDate -End $ScriptEndDate
                Output-Log -LogData ("Stopping script. Total runtime: $ScriptRunTime")
                Output-Log -LogData ("Script finished")
                Output-Log -LogData ("------------------------")
                Break
            }
            else
            {
                Output-Log -LogData ("Warning: Files have been modified")
                Output-Log -LogData ("Creating a backup of the local SapLogon.ini file")
                Try
                {
                    New-Item -ItemType File -Path $Backup -Force
                    New-Item -ItemType File -Path $Backup2 -Force
                    Copy-Item $Destination -Destination $Backup -ErrorAction Stop
                    Copy-Item $Destination2 -Destination $Backup2 -ErrorAction Stop
                    Output-Log -LogData ("Backup has been successfully created under $Backup")
                } 
                Catch
                {
                    $ErrorMessage = $_.Exception.Message
                    Output-Log -LogData ("Error: Backup failed")
                    Output-Log -LogData ("Error message: $ErrorMessage")
                }
            }
        }
        else
        {
            Output-Log -LogData ("Destination file does not exist")
        }

        Output-Log -LogData ("Copying SapLogon.ini from $Source to $Destination and $Destination2")
        Try
        {
            New-Item -ItemType File -Path $Destination -Force
            New-Item -ItemType File -Path $Destination2 -Force
            Copy-Item $Source -Destination $Destination -Recurse -Force -ErrorAction Stop
            Copy-Item $Source -Destination $Destination2 -Recurse -Force -ErrorAction Stop
        } 
        Catch
        {
            $ErrorMessage = $_.Exception.Message
            Output-Log -LogData ("Error: Copy failed")
            Output-Log -LogData ("Error message: $ErrorMessage")

            $ScriptEndDate = Get-Date
            $ScriptRunTime = New-TimeSpan -Start $ScriptStartDate -End $ScriptEndDate
            Output-Log -LogData ("Stopping script. Total runtime: $ScriptRunTime")
            Output-Log -LogData ("Script finished")
            Output-Log -LogData ("------------------------")
            Break
        }
        Output-Log -LogData ("Copy was successful")
        
    } 
    Else 
    {
        Output-Log -LogData ("Warning: Source file could not be found on $Source")
    }
}

$ScriptEndDate = Get-Date
$ScriptRunTime = New-TimeSpan -Start $ScriptStartDate -End $ScriptEndDate

Output-Log -LogData ("Stopping script. Total runtime: $ScriptRunTime")

Output-Log -LogData ("Script finished")
Output-Log -LogData ("------------------------")