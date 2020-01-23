$Computername = 'COMPUTER.DOMAIN.COM'

$Command = {

    $TrendMicroFolder = 'C:\Program Files (x86)\Trend Micro\OfficeScan Client\'
    $TerndMicroFile = 'C:\Program Files (x86)\Trend Micro\OfficeScan Client\PccNTMon.exe'

    if (Get-Service ccmexec -ErrorAction SilentlyContinue) {
        Stop-Service ccmexec -Force -ErrorAction SilentlyContinue
        (Get-Service ccmexec).WaitForStatus('Stopped','00:05:00')
        If ((Get-Service ccmexec).Status -eq 'Stopped') { Write-Host 'Software Center service was stopped successfully' -ForegroundColor Green } else { Write-Error '5min Timeout reached. Software Center service could not be stopped. Please try again later...' -ForegroundColor Red -ErrorAction Stop } 
    } else { Write-Host 'ccmexec service does not exist' -ForegroundColor Yellow }


    if (Get-Service tmlisten) {
        cd $TrendMicroFolder
        $Password = Read-Host -Prompt 'Please enter the password to unload Trend Micro'
        .\PccNTMon.exe -n $Password
        cls

        Write-Host 'Software Center service was stopped successfully' -ForegroundColor Green
        Write-Host 'Stopping Trend Micro service...'

        (Get-Service tmlisten).WaitForStatus('Stopped','00:05:00')
        If ((Get-Service tmlisten).Status -eq 'Stopped') { Write-Host 'Trend Micro service was stopped successully' -ForegroundColor Green } else { Write-Error '5min Timeout reached. Trend Micro Service has not stopped. Please try the unload password again' -ForegroundColor Red -ErrorAction Stop } 
    }

    Write-Host 'Stopping WMI Service...' 
    Stop-service winmgmt -Force -ErrorAction Stop
    (Get-Service winmgmt).WaitForStatus('Stopped','00:05:00')
    If ((Get-Service winmgmt).Status -eq 'Stopped') { Write-Host 'WMI service was stopped successully' -ForegroundColor Green } else { Write-Error '5min Timeout reached. WMI service could not be stopped. Please try again later...' -ForegroundColor Red -ErrorAction Stop } 

    Write-Host 'Removing old WMI Repository backups'
    if (Test-Path 'c:\windows\system32\wbem\repository.old') { Remove-Item 'c:\windows\system32\wbem\repository.old' -Recurse -Force -ErrorAction SilentlyContinue }
    if (Test-Path 'c:\windows\system32\wbem\AutoRecover.old') { Remove-Item 'c:\windows\system32\wbem\AutoRecover.old' -Recurse -Force -ErrorAction SilentlyContinue }

    Write-Host 'Renaming WMI Repository...'
    Rename-Item 'c:\windows\system32\wbem\repository' 'c:\windows\system32\wbem\repository.old' -ErrorAction Stop
    Rename-Item 'c:\windows\system32\wbem\AutoRecover' 'c:\windows\system32\wbem\AutoRecover.old' -ErrorAction SilentlyContinue

    Write-Host 'Starting WMI Service cleanup jobs...'
    if (Test-Path 'C:\Windows\System32\wbem\winmgmt.exe') { 
        Start-Process -FilePath 'C:\Windows\System32\wbem\winmgmt.exe' -ArgumentList '/clearadap' -ErrorAction SilentlyContinue
        Start-Process -FilePath 'C:\Windows\System32\wbem\winmgmt.exe' -ArgumentList '/kill' -ErrorAction SilentlyContinue 
        Start-Process -FilePath 'C:\Windows\System32\wbem\winmgmt.exe' -ArgumentList '/unregserver' -ErrorAction SilentlyContinue 
        Start-Process -FilePath 'C:\Windows\System32\wbem\winmgmt.exe' -ArgumentList '/regserver' -ErrorAction SilentlyContinue 
        Start-Process -FilePath 'C:\Windows\System32\wbem\winmgmt.exe' -ArgumentList '/resyncperf' -ErrorAction SilentlyContinue 
        }

    Write-Host 'Re-registering important DLL files...'
    $sysroot = $env:SystemRoot
    regsvr32 /s $sysroot\system32\scecli.dll
    regsvr32 /s $sysroot\system32\userenv.dll
    gci -filter  *.dll | % {regsvr32 /s $_.Name}

    Write-Host 'Re-adding classes to the WMI Repository from MOF files'
    gci | where {'.mof', 'mfl' -contains $_.Extension}| % {mofcomp $_.Name} 

    Write-Host 'Registering new WMI executables...'
    if (Test-Path 'C:\Windows\System32\wbem\WmiApSrv.exe') { Start-Process -FilePath 'C:\Windows\System32\wbem\WmiApSrv.exe' -ArgumentList '/Regsvr32' -ErrorAction SilentlyContinue }
    if (Test-Path 'C:\Windows\System32\wbem\WmiPrvSE.exe') { Start-Process -FilePath 'C:\Windows\System32\wbem\WmiPrvSE.exe' -ArgumentList '/Regsvr32' -ErrorAction SilentlyContinue }
    if (Test-Path 'C:\Windows\System32\wbem\WMIADAP.exe') { Start-Process -FilePath 'C:\Windows\System32\wbem\WMIADAP.exe' -ArgumentList '/Regsvr32' -ErrorAction SilentlyContinue }

    Write-Host 'Starting WMI service...'
    Start-Service winmgmt -ErrorAction SilentlyContinue

    Write-Host 'Starting Trend Micro service...'
    Start-Process -FilePath $TerndMicroFile

    Write-Host 'Starting Software Center service...'
    Start-Service ccmexec -ErrorAction SilentlyContinue
}

$s = New-PSSession -ComputerName $Computername -Authentication Kerberos -UseSSL
Invoke-Command -Session $s -ScriptBlock $command