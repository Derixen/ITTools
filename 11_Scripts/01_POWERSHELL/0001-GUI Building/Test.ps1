#==============================================================================================
# XAML Code - Imported from Visual Studio Express WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
         Title="OS Details" Height="306" Width="525" WindowStartupLocation="CenterScreen" WindowStyle='None' ResizeMode='NoResize'>
    <Grid>

 
        

    </Grid>
</Window>
'@
#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

#===========================================================================
# Add events to Form Objects
#===========================================================================
#$btnExit.Add_Click({$form.Close()})

#===========================================================================
# Stores WMI values in WMI Object from Win32_Operating System Class
#===========================================================================
#$oWMIOS = Get-WmiObject win32_OperatingSystem

#===========================================================================
# Links WMI Object Values to XAML Form Fields
#===========================================================================
#$txtHostName.Text = $oWMIOS.PSComputerName

#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null