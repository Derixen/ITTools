## Allow access to Microsoft's download sites
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$Name = "DisableWindowsUpdateAccess"
$value = "0"

New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

## Disable Windows Update Server temporarly
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$Name = "UseWUServer"
$value = "0"

New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing1"
$Name = "RepairContentServerSource"
$value = "2"

If (!(Test-Path $registryPath)){ New-Item $registryPath -Force | Out-Null }

New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

Restart-Service wuauserv

Get-WindowsCapability -Online | Where-Object {$_.Name -like "Rsat*" -AND $_.State -eq "NotPresent"} | Add-WindowsCapability -Online