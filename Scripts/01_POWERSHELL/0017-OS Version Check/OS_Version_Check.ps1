$OS = [Environment]::OSVersion

If ($OS.Version -like '10.*') {Write-Host "Win10"}
ElseIf ($OS.Version -like '6.1*') {Write-Host "Win7"}
ElseIf ($OS.Version -like '6.3*') {Write-Host "Win8.1"}
Else {Write-Host "OS Not Supported"}