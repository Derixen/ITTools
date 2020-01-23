# Uses ActiveSetup as a "runonce" mechanism for all users to display the Upgrade Successful notification. This works whether the user is local admin or not.
# To prevent the notification from displaying for a second user, we simply delete the notification scripts from the temp directory after the first run.

$ErrorActionPreference = "Stop"

$Guid = "{" + ([guid]::NewGuid()).Guid + "}"
$RegPath = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components"
$Script1 = "Call-UpgradeSuccessfulNotification.ps1"
$Script2 = "Show-UpgradeSuccessfulNotification.ps1"

# Check / create C:\temp
If (!(Test-Path $env:SystemDrive\temp))
{
    $null = New-Item -Path "$env:SystemDrive\" -Name "temp" -ItemType "directory" -Force
}

# Copy script
$Script1, $Script2 | foreach {
    Copy-Item -Path "$PSScriptRoot\$_" -Destination "$env:SystemDrive\temp" -Force
}

# Set the ActiveSetup keys
$null = New-Item -Path $RegPath -Name $Guid
$null = New-ItemProperty -Path $RegPath\$Guid -Name "IsInstalled" -PropertyType DWORD -Value 1
$null = New-ItemProperty -Path $RegPath\$Guid -Name "StubPath" -PropertyType String -Value """$env:SystemDrive\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe"" -executionPolicy Unrestricted -WindowStyle Hidden -File ""$env:SystemDrive\temp\$Script1"""