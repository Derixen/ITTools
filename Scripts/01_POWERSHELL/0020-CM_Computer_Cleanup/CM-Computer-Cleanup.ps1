#====================================================================================================================\
# PURPOSE:
#    Remove computer objects from SCCM that no longer exist in an Active Directory location defined within the SCCM 
#    Active Directory System Discovery configuration.
#
# NOTE:
#    The SCCM Console must be present and connected via PowerShell, one time, on the system where this is executed.
#    https://blogs.technet.microsoft.com/configmgrteam/2013/03/27/powershell-connecting-to-configuration-manager/
#
# REQUIREMENTS:
#    Powershell 4.0 or higher
#    Active Roles Management Shell for Active Directory -OR- Active Directory Cmdlets (RSAT)
#    System Center Configuration Manager Cmdlet Library
#====================================================================================================================/
    
    
    # SETTINGS
        # SCCM Site Code (3-digit code) [string]
            $CMSiteCode = "P01"

        # SCCM Primary Server (server.domain.com) [string]
            $CMPrimaryServer = "SERVER.domain.com"

        # Collection name to clean up (typically 'All Systems' or 'All Workstations') [string]
            $CleanCollection = "All Systems"

        # Active Directory global catalog server (server.domain.com) [string]
            $GCServer = "GLOBALDC.domain.com"

        # Use the Active Directory Module included with RSAT instead of Active Roles Managment Shell [boolean]
            $UseRSATModule = $False


#====================================================================================================================\
# No need to edit below this line
#====================================================================================================================/


    # PREPARE ENVIRONMENT
        $StartingEAP = $ErrorActionPreference
        $ErrorActionPreference = "Stop"
        If(!$UseRSATModule){ Add-PSSnapin Quest.ActiveRoles.ADManagement }
        Import-Module ((Split-Path $env:SMS_ADMIN_UI_PATH)+"\ConfigurationManager.psd1")


    # LOAD AD SYSTEM DISCOVERY CONFIGURATION FROM SCCM
        $SearchRoots = @()
        $Query = Get-WmiObject -Namespace root\sms\site_$CMSiteCode -ComputerName $CMPrimaryServer -Class SMS_SCI_Component -Filter "ComponentName='SMS_AD_SYSTEM_DISCOVERY_AGENT'"
        $Query.PropLists.Values | ?{ $_ -like "LDAP://*" } | %{ $SearchRoots += $_.Replace("LDAP://","") }


    # LOAD COMPUTERS FROM ACTIVE DIRECTORY
        $ADComputers = @()
        Write-Host "Loading computer objects from Active Directory..." -ForegroundColor Yellow
        ForEach($Root in $SearchRoots) {
            If($UseRSATModule){
                $ADComputers += Get-ADComputer -Server "$($GCServer):3268" -Filter * -SearchBase "$Root" -SearchScope Subtree | Select -ExpandProperty Name
            } Else {
                $ADComputers += Get-QADComputer -Service "$GCServer" -SearchRoot "$Root" -SearchScope Subtree -UseGlobalCatalog -SizeLimit 0 -Activity "Loading computer objects from $Root" | Select -ExpandProperty Name
            }
        }


    # LOAD COMPUTERS FROM CONFIGURATION MANAGER
        Write-Host "Loading computer objects from SCCM..." -ForegroundColor Yellow
        Set-Location "$($CMSiteCode):"
        $CMComputers = Get-CMDevice -CollectionName "$CleanCollection"
        $CMCount = $CMComputers | Measure-Object | Select -ExpandProperty Count


    # PERFORM CONFIGURATION MANAGER CLEANUP
        $Counter = 0
        $Removals = 0
        Write-Host "Cleaning up computer objects..." -ForegroundColor Green
        If($CMCount -gt 0){
            ForEach($Computer in $CMComputers){
                Write-Progress -Activity "Analyzing SCCM Computer Objects" -Status "Verifying" -CurrentOperation $($Computer.Name) -PercentComplete ($Counter / $CMCount * 100)
                If($Computer.Name -ne "x86 Unknown Computer (x86 Unknown Computer)" -and $Computer.Name -ne "x64 Unknown Computer (x64 Unknown Computer)"){ 
                    If((-Not($ADComputers -contains "$($Computer.Name)")) -and (-Not($Computer -eq $Null))){
                        Write-Host "REMOVING: $($Computer.Name)" -ForegroundColor Cyan
                        Remove-CMDevice -InputObject $Computer -Force
                        $Removals++
                    }
                }
                $Counter++
            }
            Write-Host "`n$Removals COMPUTERS WERE REMOVED" -ForegroundColor Magenta
        } Else {
            Write-Host "Collection `"$CleanCollection`" is empty" -ForegroundColor Magenta
        }


    # CLEANUP ENVIRONMENT
        Set-Location "C:"
        $ErrorActionPreference = $StartingEAP