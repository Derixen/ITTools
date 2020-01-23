##########################################################################
# REMOVE EXPIRED CERTIFICATIONS
##########################################################################
# Created by: Janos Friedrich
# Created on: 2018-11-29
# 
# Description: Parse all local Windows cert stores and remove any certificate that is expired
##########################################################################

$ErrorActionPreference = 'silentlycontinue'
$ScriptName = 'REMOVE EXPIRED CERTIFICATIONS'
$ScriptType = 'Startup' ##Type can be STARTUP or LOGON

##########################################################################
# GLOBAL VARIABLES
##########################################################################

$ScriptNameMod = $ScriptName -replace " ", "_"
$LogDir = "C:\Windows\Temp\"
$LogDate = Get-Date -Format yyyyMMdd
$LogFile = "Evosoft-$ScriptNameMod-$LogDate.log"
$LogPath = $LogDir + $LogFile
$ScriptStartDate = Get-Date

##########################################################################
# FUNCTIONS
##########################################################################

function Output-Log 
{
    param( [string]$LogData  )
    $LogDateFormat = Get-Date -Format "yyyy.MM.dd HH:mm:ss"
    $LogDateFormat + " - " + $LogData >> $LogPath
}

##########################################################################
# STARTING LOGGING
##########################################################################

If( !($LogPath | Test-Path) ) 
{
    Output-Log -LogData ("------------------------")
    Output-Log -LogData ("------------------------")
    Output-Log -LogData ("Script Name: $ScriptName")
    Output-Log -LogData ("Script Type: $ScriptType")
    Output-Log -LogData ("Script running on " + (hostname))
    Output-Log -LogData ("Script running at " + (get-date))
    Output-Log -LogData ("Script running by " + (whoami))
    Output-Log -LogData ("------------------------")
}

Output-Log -LogData ("Starting script")

##########################################################################
# SCRIPT BODY
##########################################################################

$today = Get-Date
$ConfirmPreference = "None"

$myCerts = Get-Item Cert:\LocalMachine\My
$myCerts.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)

$ExpiredList = Get-ChildItem $myCerts.PSPath

$CertNumb = $ExpiredList.Count
Output-Log -LogData ("Found $CertNumb certifications for Local Machine")

$ExpiredList = Get-ChildItem $myCerts.PSPath | Where-Object { $_.NotAfter -lt $today }
$CertNumb = $ExpiredList.Count
Output-Log -LogData ("Number of expired certifications: $CertNumb")

if ($CertNumb -ne 0) 
{
    Output-Log -LogData ("Starting removal of expired certifications")
    ForEach ($Cert in $ExpiredList) {
        $CertSubj = $Cert.Subject
        Output-Log -LogData ("Removing certification: $CertSubj")
        Try
        {
            $myCerts.Remove($Cert)
            Output-Log -LogData ("Successfully removed: $CertSubj")
        }
        Catch
        {
            $ErrorMessage = $_.Exception.Message
            Output-Log -LogData ("Failed to removed: $CertSubj")
            Output-Log -LogData ("Error: $ErrorMessage")
        }
}
} else { 
    Output-Log -LogData ("No certification(s) required removal")
}
 
$myCerts.Close() # We opened it, so we need to close it.

##########################################################################
# ENDING LOGGING
##########################################################################

$ScriptEndDate = Get-Date
$ScriptRunTime = New-TimeSpan -Start $ScriptStartDate -End $ScriptEndDate

Output-Log -LogData ("Stopping script. Total runtime: $ScriptRunTime")

Output-Log -LogData ("Script finished")
Output-Log -LogData ("------------------------")