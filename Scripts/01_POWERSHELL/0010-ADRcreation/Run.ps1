<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.144
	 Created on:   	10.10.2017 14:03
	 Created by:   	z003k2pn-a01
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

#Create Collections from Textfile
#Author: Lucian L�sch
#Set path to collection source file
Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386", "\bin\configurationmanager.psd1")
$SiteCode = Get-PSDrive -PSProvider CMSITE -Name E01
Set-Location "$($SiteCode.Name):\"

#Primary Variables
$InputFile = ".\Products.txt"
$UpdateClassificationsNormal = @("Sicherheitsupdates", "Definitionsupdates", "Updates", "Update-Rollups")
$UpdateClassificationsFeature_Tools = @("Feature Packs", "Tools")
$UpdateClassificationsSP_Upgrades = @("Service Packs", "Upgrades")

$DeployPackageLocation = "\\Server\ShareFolder"
$UpdateGroups = @("(Definition Updates / Updates / Security / Critical / Update Rollups) All", "(Definition Updates / Updates / Security / Critical / Update Rollups) Last month", "Feature / Tools", "Service Packs / Upgrades")
$PreFix = "[ORG][ADR]"
$LimitingCollectionName = "LimitingCollection"

$CollectionPath = "E01:\DeviceCollection\Collections"

#region Function
function create-DeploymentPackage{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]$DeploymentPackageLocation,
    [Parameter(Mandatory=$true)]
    [string]$Product,
    [Parameter(Mandatory=$true)]
    [string]$Suffix
	)
	Write-Host "Create Deployment Package $Product"
    $PathToDeploy = [string]::Format("{0}\{1}_{2}", $DeployPackageLocation, $Product, $Suffix)
    $PathToDeploy -replace " ", "_"
    $DeploymentPackageName = [string]::Format("[eIS]{0} - {1}", $Product, $Suffix)
    
    #existiert swupk schon?
    $rt=Get-CMSoftwareUpdateDeploymentPackage -Name $DeploymentPackageName
    if ($rt -eq $null) {
    
        #existiert zielpfad schon?
        #if (-not (Test-Path $PathToDeploy)) {
            #anlegen
	    #	write-host $PathToDeploy
    	#	new-item -ItemType directory -path "$PathToDeploy" | Out-Null
        #}
        #sudp anlegen
        Try
        {
	        New-CMSoftwareUpdateDeploymentPackage -Name $DeploymentPackageName -Path $PathToDeploy
        }
        Catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Write-Host $_.Exception.ItemName "-> " $_.Exception.Message
        }
        $rt=Get-CMSoftwareUpdateDeploymentPackage -Name $DeploymentPackageName 
        Try
        {
            Start-CMContentDistribution -InputObject $rt -DistributionPointGroupName "All"
        }
        Catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Write-Host $_.Exception.ItemName "-> " $_.Exception.Message
        }
        Write-Host "$rt.Name was created and distributed"
    }
    else
    {
        Write-Host $rt.Name "already exists"
    }
  return $rt[0]
}

function create-AutomaticDeploymentRule{
    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$true)]
    $sudp,
    [Parameter(Mandatory=$true)]
    [string]$collectionName,
    [Parameter(Mandatory=$true)]
    [string]$Product,
    [Parameter(Mandatory=$true)]
    $Schedule,
    [Parameter(Mandatory=$true)]
    [string[]]$UpdateClassification,
    [Parameter(Mandatory=$true)]
    [boolean]$Type
    )
    Write-Host $collectionName

    if($Type)
    {
            $ADPHash = @{
				AddToExistingSoftwareUpdateGroup = $true
				AllowRestart = $false
                AvailableImmediately =$true
                DeadlineTimeUnit = "Days" 
                DeadlineTime = 7
                AllowSoftwareInstallationOutsideMaintenanceWindow = $true
                CustomSeverity = "None"
                CollectionName = $collectionName
                Description = "Autocreated ADR"
                DeploymentPackageName = $sudp.Name
                DeployWithoutLicense = $true
                DisableOperationManager = $true
                DownloadFromInternet =$true
                DownloadFromMicrosoftUpdate =$true
                GenerateFailureAlert = $true
                GenerateSuccessAlert = $false
                GenerateOperationManagerAlert = $false
                LanguageSelection = "English"
				Vendor = "Microsoft"
                Name = $collectionName
                SuppressRestartServer = $true
                SuppressRestartWorkstation = $false
                NoInstallOnRemote = $true
		        NoInstallOnUnprotected = $true
                Product = $Product
                RunType = "RunTheRuleOnSchedule"
                Schedule = $Schedule
                SuccessPercentage = "95"
                Superseded = $false
                UpdateClassification = $UpdateClassification
                UseBranchCache = $true
                UserNotification = "DisplayAll"    
                VerboseLevel = "OnlySuccessAndErrorMessages"
                Title = "-Preview"   
                AllowUseMeteredNetwork = $true
                DateReleasedOrRevised = "LastMonth"
                EnabledAfterCreate = $true  
        }
    }else{
            $ADPHash = @{
                AddToExistingSoftwareUpdateGroup = $true
                AllowRestart = $true
                AllowSoftwareInstallationOutsideMaintenanceWindow = $true
                AllowUseMeteredNetwork = $true
                AvailableImmediately =$true
                CollectionName = $collectionName
                CustomSeverity = "None"
                DeadlineImmediately = $true
                Description = "Autocreated ADR"
                DeploymentPackageName = $sudp.Name
                DeployWithoutLicense = $true
                DisableOperationManager = $true
                DownloadFromInternet =$true
                DownloadFromMicrosoftUpdate =$true
                EnabledAfterCreate = $true
                GenerateFailureAlert = $false
                GenerateSuccessAlert = $false
                GenerateOperationManagerAlert = $false
                Name = $collectionName
                NoInstallOnRemote = $true
		        NoInstallOnUnprotected = $true
                Product = $product
                RunType = "RunTheRuleOnSchedule"
                Schedule = $Schedule
                SuccessPercentage = "95"
                Superseded = $false
                SuppressRestartServer = $true
                SuppressRestartWorkstation = $false
                UpdateClassification = $UpdateClassification
                UseBranchCache = $true
                UserNotification = "DisplayAll"
                VerboseLevel = "OnlySuccessAndErrorMessages"
                Title = "-Preview"                
            }
        }
    Write-Host @ADPHash
    $rt= get-CMSoftwareUpdateAutoDeploymentRule -Name $collectionName
	if ($rt -eq $null)
	{
		<#
			For more information on the try, catch and finally keywords, see:
				Get-Help about_try_catch_finally
		#>
		
		# Try one or more commands
		try {
			New-CMSoftwareUpdateAutoDeploymentRule @ADPHash
			
		}
		# Catch all other exceptions thrown by one of those commands
		catch
		{
			Write-Host "Error: " $collectionName | Out-File -FilePath "D:\Scripts\ADR.log" -Append
			$_.Exception.Message + $collectionName | Out-File -FilePath "D:\Scripts\ADR.log" -Append
		}
		$rt = get-CMSoftwareUpdateAutoDeploymentRule -Name $collectionName
    }
    return $rt
}

function Create-BaseCollection{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
    [string]$Product,
    [Parameter(Mandatory=$true)]
    [string]$UpdateGroup,
    [Parameter(Mandatory=$true)]
    [string]$CollectionPath,
    [Parameter(Mandatory=$true)]
    $CollectionMembers
    )
    $CollectionName = [string]::Format("{0} {1} {2}", $PreFix, $Product, $UpdateGroup)
    
    
    Write-Host "Creating BaseCollection $CollectionName"

    $Collection = Get-CMCollection -Name $CollectionName -CollectionType Device
    if (-not $Collection)
    {
        $CollSch = New-CMSchedule -RecurInterval Minutes -RecurCount 30
		$Collection = New-CMDeviceCollection -Name $CollectionName -LimitingCollectionName $LimitingCollectionName -RefreshSchedule $CollSch -RefreshType Periodic
	    Move-CMObject -FolderPath $CollectionPath -InputObject $Collection
        
        Write-Host "BaseCollection was created"
    }
    else
    {
        Write-Host "BaseCollection already exists"
    }
    Write-Host "Adding Collection Memberships"

    #Add to main update collection
    #foreach ($CollectionMember in $CollectionMembers)
    #{	
    #    Add-CMDeviceCollectionIncludeMembershipRule -CollectionId $Collection.CollectionID -IncludeCollectionId $CollectionMember
    #}

    return $Collection
}

#endregion

if (Test-Path($InputFile))
{
	$ProductList = Get-Content -Path $InputFile
}
else
{
	Write-Host "Input File not existing. Please check file " + $InputFile
	exit 1
}


foreach ($Product in $ProductList)
{	
	foreach ($UpdateGroup in $UpdateGroups)
	{			
        Write-Host "Start Creating ADR for $UpdateGroup"
	    switch ($UpdateGroup)
	    {
		    "(Definition Updates / Updates / Security / Critical / Update Rollups) All" {
                Write-Host "Getting Update Classifications"
                [string[]]$UpdateClassification = Get-CMSoftwareUpdateCategory -TypeName UpdateClassification | Where {$_.CategoryInstance_UniqueID -in @("UpdateClassification:e6cf1350-c01b-414d-a61f-263d14d133b4","UpdateClassification:e0789628-ce08-4437-be74-2495b842f43b","UpdateClassification:0fa1201d-4330-4fa8-8ae9-b877473b6441","UpdateClassification:28bc880e-0592-4cbf-8f95-c79b17911d5f","UpdateClassification:cd5ffd1e-e932-4e3a-bf74-18bf0b1bbd83")} | Select LocalizedCategoryInstanceName | Foreach {"$($_.LocalizedCategoryInstanceName)"}
                Write-Host $UpdateClassification
                Write-Host "Creating ADR Schedule"
			    $Schedule = New-CMSchedule -DayOfWeek Tuesday -WeekOrder Third -Start ([Datetime]"01:00")
                Write-Host "ADR Schedule was created. $Schedule"
                $SoftwareUpdatePackage = Create-DeploymentPackage -Product $Product -DeploymentPackageLocation $DeployPackageLocation -Suffix "All"
                $Collection = Create-Basecollection -Product $Product -UpdateGroup "(Definition Updates / Updates / Security / Critical / Update Rollups) All" -CollectionPath $CollectionPath -CollectionMembers ([string[]] $CollID = @("E01002AE"))
                Create-AutomaticDeploymentRule -sudp $SoftwareUpdatePackage -collectionName $Collection.Name -Product $Product -Schedule $Schedule -UpdateClassification $UpdateClassification -Type $true
                		    }
		    "(Definition Updates / Updates / Security / Critical / Update Rollups) Last month" {
                Write-Host "Getting Update Classifications"
                [string[]]$UpdateClassification = Get-CMSoftwareUpdateCategory -TypeName UpdateClassification | Where {$_.CategoryInstance_UniqueID -in @("UpdateClassification:e6cf1350-c01b-414d-a61f-263d14d133b4","UpdateClassification:e0789628-ce08-4437-be74-2495b842f43b","UpdateClassification:0fa1201d-4330-4fa8-8ae9-b877473b6441","UpdateClassification:28bc880e-0592-4cbf-8f95-c79b17911d5f","UpdateClassification:cd5ffd1e-e932-4e3a-bf74-18bf0b1bbd83")} | Select LocalizedCategoryInstanceName | Foreach {"$($_.LocalizedCategoryInstanceName)"}
                Write-Host $UpdateClassification
			    Write-Host "Creating ADR Schedule"
                $Schedule = New-CMSchedule -DayOfWeek Wednesday -WeekOrder Second -Start ([Datetime]"01:00")
                Write-Host "ADR Schedule was created. $Schedule"
                $SoftwareUpdatePackage = Create-DeploymentPackage -Product $Product -DeploymentPackageLocation $DeployPackageLocation -Suffix "Last month"
                $Collection = Create-Basecollection -Product $Product -UpdateGroup "(Definition Updates / Updates / Security / Critical / Update Rollups) Last month" -CollectionPath $CollectionPath -CollectionMembers ([string[]] $CollID = @("E01002AE","CAS0017B"))
                Create-AutomaticDeploymentRule -sudp $SoftwareUpdatePackage -collectionName $Collection.Name -Product $Product -Schedule $Schedule -UpdateClassification $UpdateClassification -Type $false
		    }
		    "Feature / Tools" {
                Write-Host "Getting Update Classifications"
                [string[]]$UpdateClassification = Get-CMSoftwareUpdateCategory -TypeName UpdateClassification | Where {$_.CategoryInstance_UniqueID -in @("UpdateClassification:b54e7d24-7add-428f-8b75-90a396fa584f", "UpdateClassification:b4832bd8-e735-4761-8daf-37f882276dab")} | Select LocalizedCategoryInstanceName | Foreach {"$($_.LocalizedCategoryInstanceName)"}
                Write-Host $UpdateClassification
                Write-Host "Creating ADR Schedule"			    
                $Schedule = New-CMSchedule -DayOfWeek Wednesday -WeekOrder Second -Start ([Datetime]"01:00")
                Write-Host "ADR Schedule was created. $Schedule"
                $SoftwareUpdatePackage = Create-DeploymentPackage -Product $Product -DeploymentPackageLocation $DeployPackageLocation -Suffix "Feature_Tools"
                $Collection = Create-Basecollection -Product $Product -UpdateGroup "Feature / Tools" -CollectionPath $CollectionPath -CollectionMembers ([string[]] $CollID = @("CAS0017D"))
                Create-AutomaticDeploymentRule -sudp $SoftwareUpdatePackage -collectionName $Collection.Name -Product $Product -Schedule $Schedule -UpdateClassification $UpdateClassification -Type $true
		    }
		    "Service Packs / Upgrades" {
                Write-Host "Getting Update Classifications"
                [string[]]$UpdateClassification = Get-CMSoftwareUpdateCategory -TypeName UpdateClassification | Where {$_.CategoryInstance_UniqueID -in @("UpdateClassification:68c5b0a3-d1a6-4553-ae49-01d3a7827828","UpdateClassification:3689bdc8-b205-4af4-8d4a-a63924c5e9d5")} | Select LocalizedCategoryInstanceName | Foreach {"$($_.LocalizedCategoryInstanceName)"}
                Write-Host $UpdateClassification
                Write-Host "Creating ADR Schedule"			    
                $Schedule = New-CMSchedule -DayOfWeek Wednesday -WeekOrder Second -Start ([Datetime]"01:00")
                Write-Host "ADR Schedule was created. $Schedule"
                $SoftwareUpdatePackage = Create-DeploymentPackage -Product $Product -DeploymentPackageLocation $DeployPackageLocation -Suffix "SP_Upgrades"
                $Collection = Create-Basecollection -Product $Product -UpdateGroup "Service Packs / Upgrades"  -CollectionPath $CollectionPath -CollectionMembers ([string[]] $CollID = @("CAS0017C"))
                Create-AutomaticDeploymentRule -sudp $SoftwareUpdatePackage -collectionName $Collection.Name -Product $Product -Schedule $Schedule -UpdateClassification $UpdateClassification -Type $true
		    }
	    }
        
#		SoftwareUpdateAutoDeploymentRule -vCollection $NewCollection -vProduct $Product -vUpdateClassifications $UpdateClassifications -vSchedule $Schedule -vOS $OS -DeploymentPackage $DeploymentPackage -Testing $false
	}
}



