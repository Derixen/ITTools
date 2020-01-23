#Mount-windowsimage -ImagePath D:\93_Image\WIM\install.wim -Path D:\93_Image\WIM\Offline -Index 3
#Get-WindowsImage -ImagePath "D:\93_Image\WIM\install.wim"
#Dismount-WindowsImage -Path D:\93_Image\WIM\Offline -Save
## VARIABLES
$MainFolder = "D:\93_Image\UNATTEND"
$DiskImageToBeUsed = 'Windows 10 Enterprise'

## CALCULATED VARIABLES
$ImagePath = "$MainFolder\install.wim"
$ImageOfflinePath = "$MainFolder\Offline"
$Features = "$MainFolder\Features"
$LPs = "$MainFolder\LPs"
$LXPs = "$MainFolder\LXPs"
$SourcePath = "$MainFolder\Source"

## COPY IMAGE FILE
Write-Host "Copying install.wim file to $MainFolder"
Copy-Item "$SourcePath\Sources\install.wim" -Destination $MainFolder

## REMOVE ALL DISK IMAGES, EXCLUDING WINDOWS 10 ENTERPRISE
Write-Host "Getting Disk Images from install.wim. Disk Image to be used is $DiskImageToBeUsed"
$Images = Get-WindowsImage -ImagePath $ImagePath

foreach ($image in $Images)
{
    $ImageName = $Image.ImageName
    If ( $ImageName -ne $DiskImageToBeUsed ) 
    { 
        Write-Host "Removing Disk Image: $ImageName"
        Remove-WindowsImage -ImagePath $ImagePath -Name $ImageName | Out-Null 
    }
}

## MOUNT IMAGE AND START MODIFICATION
Write-Host "Mounting $ImagePath"
Mount-windowsimage -ImagePath $ImagePath -Path $ImageOfflinePath -Index 1

## REMOVE APPS NOT REQUIRED
Write-Host "Removing not approved Built-in Apps from Image"
$AppsToBeRemoved = @(
    "Microsoft.3DBuilder"
    "Microsoft.AppConnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.DuoLingo-LearnLanguagesforFree"
    "Microsoft.EclipseManager"
    "Microsoft.Flipboard.Flipboard"
    "Microsoft.Freshpaint"
    "Microsoft.GetStarted"
    "Microsoft.Messaging"
    "Microsoft.Microsoft.Xbox.TCUI"
    "Microsoft.Microsoft.XboxGameCallableUI"
    "Microsoft.Microsoft.XboxGamingOverlay"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.PicsArt"
    "Microsoft.SkypeApp"
    "Microsoft.Windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WunderList"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
)

$apps = Get-AppxProvisionedPackage -Path "$ImageOfflinePath"
foreach ($app in $apps)
{
    if ($app.DisplayName -in $AppsToBeRemoved)
    {
        Write-Host "Removing " + $app.DisplayName
        Remove-AppxProvisionedPackage -Path $ImageOfflinePath -PackageName $app.PackageName
    }
}

## ENABLE OPTIONAL-FEATURES
Write-Host "Enabling required Optional-Features"
$OptionalFeaturesToEnable = @(
    "NetFx3"
)

$OptionalFeatures = Get-WindowsOptionalFeature -Path $ImageOfflinePath

foreach ($OptionalFeature in $OptionalFeatures)
{
    if ($OptionalFeature.FeatureName -in $OptionalFeaturesToEnable)
    {
        Write-Host "Enabling " + $OptionalFeature.FeatureName
        Enable-WindowsOptionalFeature -Path $ImageOfflinePath -FeatureName $OptionalFeature.FeatureName -Source "$SourcePath\sources\sxs"
    }
}

## ADD ALL FEATURES CAB FILES
Write-Host "Adding Features on Demand CAB files..."
Add-WindowsPackage -Path $ImageOfflinePath -PackagePath $Features -IgnoreCheck

## ADD ALL LANGUAGE CAB FILES
Write-Host "Adding Language Pack CAB files..."
Add-WindowsPackage -Path $ImageOfflinePath -PackagePath $LPs -IgnoreCheck

## ADD LANGUAGE EXPERIENCE PACKS
Write-Host "Adding Language Experience Pack files..."
$LXPFolders = Get-ChildItem -Path $LXPs #-Include *.txt

Foreach ($LXPFolder in $LXPFolders) {

    $LXPFolderName = $LXPFolder.FullName
    $APPX = (Get-ChildItem -Path "$LXPFolderName\*" -Include *.appx -Recurse).FullName
    $XML = (Get-ChildItem -Path "$LXPFolderName\*" -Include *.xml -Recurse).FullName

    Write-Host "Adding LXP file $APPX"
    Add-AppxProvisionedPackage -Path $ImageOfflinePath -PackagePath $APPX -LicensePath $XML

}

## MOUNT IMAGE AND START MODIFICATION
Write-Host "Saving Windows Image"
Dismount-WindowsImage -Path $ImageOfflinePath -Save

Write-Host "$ImagePath has been saved"