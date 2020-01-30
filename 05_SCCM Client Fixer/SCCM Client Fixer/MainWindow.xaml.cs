using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Input;
using System.Net.NetworkInformation;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Threading;
using System.DirectoryServices;
using System.Diagnostics;

namespace SCCM_Client_Fixer
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public Boolean bClicked = false;
        public string strComputer;
        string[] lines;
        public MainWindow()
        {
            InitializeComponent();
        }

        // Classes
        public class PingTable
        {
            public string hostName { get; set; }
            public string ipAddress { get; set; }
            public string pcStatus { get; set; }
            public string FQDN { get; set; }

        }
        public class InfoTable
        {
            public string Property { get; set; }
            public string Value { get; set; }
        }

        // Eventhandlers
        private void dgTabla_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            string cellValue = GetSelectedCellValue();
            //System.Windows.MessageBox.Show(cellValue);
            tbGetStats.Text = cellValue;
        }

        private void GetPCInfo()
        {
            Dispatcher.Invoke(new Action(() => { dgStats.Items.Clear(); }));

            string pcName = "";
            string pcCaption = "";
            string OSVersion = "";
            string pcLastBootUpTime = "";
            string pcInstallDate = "";
            string pcSize = "";
            string pcFreeSpace = "";
            string pcLastLogon = "";
            string pcDomain = "";
            string pcModel = "";
            Int64 x = 0;
            Int64 y = 0;
            Int64 z = 0;

            using (PowerShell PowerShellInstance = PowerShell.Create())
            {

                PowerShellInstance.AddScript("param($pcName) Get-WmiObject win32_operatingsystem -ComputerName $pcName | select Version,CSName,BuildNumber,OSProductSuite,OSType,Caption, @{LABEL='LastBootUpTime'; EXPRESSION ={$_.ConverttoDateTime($_.lastbootuptime)}}, @{LABEL='InstallDate'; EXPRESSION ={$_.ConverttoDateTime($_.InstallDate)}}");
                PowerShellInstance.AddParameter("pcName", strComputer);

                try
                {
                    Collection<PSObject> PSOutput = PowerShellInstance.Invoke();

                    foreach (PSObject outputItem in PSOutput)
                    {
                        if (outputItem != null)
                        {
                            //TODO: do something with the output item
                            pcName = outputItem.Properties["CSName"].Value.ToString();
                            pcCaption = outputItem.Properties["Caption"].Value.ToString();
                            OSVersion = outputItem.Properties["Version"].Value.ToString();
                            pcLastBootUpTime = outputItem.Properties["LastBootUpTime"].Value.ToString();
                            pcInstallDate = outputItem.Properties["InstallDate"].Value.ToString();
                        }
                    }
                }
                catch (Exception)
                {
                    pcSize = "No Access";
                    pcFreeSpace = "No Access";
                }

                string psFilter = "Caption like 'C:'";
                PowerShellInstance.AddScript("param($pcName) Get-WmiObject Win32_LogicalDisk -ComputerName $pcName -filter " + '"' + psFilter + '"' + " | Select-Object Size,FreeSpace");
                PowerShellInstance.AddParameter("pcName", strComputer);

                try
                {
                    Collection<PSObject> PSOutput = PowerShellInstance.Invoke();

                    foreach (PSObject outputItem in PSOutput)
                    {
                        if (outputItem != null)
                        {
                            //TODO: do something with the output item
                            pcSize = outputItem.Properties["Size"].Value.ToString();
                            pcFreeSpace = outputItem.Properties["FreeSpace"].Value.ToString();

                            x = Convert.ToInt64(pcSize);
                            y = Convert.ToInt64(pcFreeSpace);

                            z = y / (x / 100);

                            x = x / 1024 / 1024 / 1024;
                            y = y / 1024 / 1024 / 1024;

                            pcSize = x.ToString() + " GB";
                            pcFreeSpace = y.ToString() + " GB (" + z.ToString() + "%)";

                        }
                    }
                }
                catch (Exception)
                {
                    pcSize = "No Access";
                    pcFreeSpace = "No Access";
                }

                PowerShellInstance.AddScript("param($pcName) Get-WmiObject Win32_ComputerSystem -ComputerName $pcName | Select-Object Domain,Model,UserName");
                PowerShellInstance.AddParameter("pcName", strComputer);

                try
                {
                    Collection<PSObject> PSOutput = PowerShellInstance.Invoke();

                    foreach (PSObject outputItem in PSOutput)
                    {
                        if (outputItem != null)
                        {
                            //TODO: do something with the output item
                            pcLastLogon = outputItem.Properties["UserName"].Value.ToString();
                            pcDomain = outputItem.Properties["Domain"].Value.ToString();
                            pcModel = outputItem.Properties["Model"].Value.ToString();
                        }
                    }
                }
                catch (Exception)
                {
                    pcLastLogon = "No Access";
                }

            }

            DirectoryEntry entry = new DirectoryEntry("LDAP://AD001.SIEMENS.NET");
            DirectorySearcher mySearcher = new DirectorySearcher(entry);
            mySearcher.Filter = ("(&(objectCategory=computer)(name=" + strComputer + "))");
            mySearcher.SizeLimit = int.MaxValue;
            mySearcher.PageSize = int.MaxValue;
            string ComputerName = "";
            foreach (SearchResult resEnt in mySearcher.FindAll())
            {
                //"CN=SGSVG007DC"
                ComputerName = resEnt.GetDirectoryEntry().Name;
            }

            switch (OSVersion)
            {
                case "10.0.10240":
                    OSVersion = "1507";
                    break;
                case "10.0.10586":
                    OSVersion = "1511";
                    break;
                case "10.0.14393":
                    OSVersion = "1607";
                    break;
                case "10.0.15063":
                    OSVersion = "1703";
                    break;
                case "10.0.16299":
                    OSVersion = "1709";
                    break;
                case "10.0.17134":
                    OSVersion = "1803";
                    break;
                case "10.0.17763":
                    OSVersion = "1809";
                    break;
                case "10.0.18353":
                    OSVersion = "1903";
                    break;
                case "10.0.18362":
                    OSVersion = "1909";
                    break;
                default:
                    break;
            }

            Dispatcher.Invoke(new Action(() => {
                dgStats.Items.Clear();
                dgStats.Items.Add(new InfoTable { Property = "Name", Value = pcName });
                dgStats.Items.Add(new InfoTable { Property = "Last Logon User", Value = pcLastLogon });
                dgStats.Items.Add(new InfoTable { Property = "OS", Value = pcCaption });
                dgStats.Items.Add(new InfoTable { Property = "OS Version", Value = OSVersion });
                dgStats.Items.Add(new InfoTable { Property = "Model", Value = pcModel });
                dgStats.Items.Add(new InfoTable { Property = "Install Date", Value = pcInstallDate });
                dgStats.Items.Add(new InfoTable { Property = "Last Boot", Value = pcLastBootUpTime });
                dgStats.Items.Add(new InfoTable { Property = "Size (C:)", Value = pcSize });
                dgStats.Items.Add(new InfoTable { Property = "FreeSpace (C:)", Value = pcFreeSpace });
            }));
        }
        private void GetInfo_Click(object sender, RoutedEventArgs e)
        {
            strComputer = tbGetStats.Text;
            Thread t = new Thread(GetPCInfo);
            t.Start();

        }
        private void StartPing_Click(object sender, RoutedEventArgs e)
        {
            lines = tbInput.Text.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
            Thread t = new Thread(PingList);
            t.Start();
        }
        // Functions
        public void PingList()
        {

            Dispatcher.Invoke(new Action(() => { dgTabla.Items.Clear(); }));

            if (tbInput.LineCount > 0)
            {


                //for (int i = 0; i < lines.Length; i++)
                foreach (string line in lines)
                {
                    if (PingHost(line))
                    {
                        System.Net.IPAddress[] ips;
                        ips = System.Net.Dns.GetHostAddresses(line);

                        Dispatcher.Invoke(new Action(() => {

                            dgTabla.Items.Add(new PingTable
                            {
                                hostName = line,
                                ipAddress = ips[0].ToString(),
                                pcStatus = "Online",
                                FQDN = System.Net.Dns.GetHostEntry(line).HostName
                            });

                        }));
                    }
                    else
                    {
                        Dispatcher.Invoke(new Action(() => {

                            dgTabla.Items.Add(new PingTable
                            {
                                hostName = line,
                                ipAddress = "n/a",
                                pcStatus = "Offline",
                                FQDN = "n/a"
                            });

                        }));
                    }

                }
            }
        }
        public string GetSelectedCellValue()
        {

            DataGridCellInfo cellInfo = new DataGridCellInfo();
            try
            {
                cellInfo = dgTabla.SelectedCells[0];
            }
            catch (Exception)
            {


            }

            if (cellInfo == null) return null;

            DataGridBoundColumn column = cellInfo.Column as DataGridBoundColumn;
            if (column == null) return null;

            FrameworkElement element = new FrameworkElement() { DataContext = cellInfo.Item };
            BindingOperations.SetBinding(element, TagProperty, column.Binding);

            return element.Tag.ToString();
        }
        public static bool PingHost(string nameOrAddress)
        {
            bool pingable = false;
            Ping pinger = new Ping();
            try
            {
                PingReply reply = pinger.Send(nameOrAddress);
                pingable = reply.Status == IPStatus.Success;
            }
            catch (PingException)
            {
                // Discard PingExceptions and return false;
            }
            return pingable;
        }
        private void OpenDrive_Click(object sender, RoutedEventArgs e)
        {
            string strPath = @"\\" + tbGetStats.Text + @"\C$";
            try
            {
                Process.Start(strPath);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }
        private void tbInput_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            if (!bClicked)
            {
                tbInput.Text = string.Empty;
            }

            bClicked = true;
        }
        private void tbGetStats_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            if (!bClicked)
            {
                tbGetStats.Text = string.Empty;
            }

            bClicked = true;
        }
        private void PSSession_Click(object sender, RoutedEventArgs e)
        {
            string strCmdText;
            string strComputerName = "";

            try
            {
                strComputerName = System.Net.Dns.GetHostEntry(tbGetStats.Text).HostName;
            }
            catch (Exception)
            {
                MessageBox.Show(tbGetStats.Text + " - is not a valid entry, please check spelling!");
            }

            // strCmdText = @"-NoExit $s = New-PSSessionOption -OpenTimeOut 60000; Enter-PSSession -ComputerName " + strComputerName + " -UseSSL -Authentication Kerberos";
            strCmdText = @"-NoExit $s = New-PSSessionOption -OpenTimeOut 60000; Enter-PSSession -ComputerName " + strComputerName + " -UseSSL -Authentication Kerberos -SessionOption $s";
            try
            {
                System.Diagnostics.Process.Start("powershell.exe", strCmdText);
            }
            catch (Exception)
            {
                MessageBox.Show("Something went wrong!");
            }

        }

        public static void RepairSCCM(object strComputerName)
        {
            string strCmdText;

            strCmdText = @"-NoExit $Destination = '\\" + strComputerName.ToString() + @"\c$\Temp'
                $SourceFiles = '\\DENBGMAEPA99SRV.evosoft.com\SMS_CAS\Client'

                Try {
                    Write-Host 'Copying CCM Installation source files...'
                    Copy-Item -Path $SourceFiles -Destination $Destination -Recurse -Container -Force -ErrorAction Stop 
                    Write-Host 'Client source files copied successfully' -ForegroundColor Green
                } Catch { 
                    Write-Host 'Could not copy Client installation files:' -ForegroundColor Red
                    Write-Host $_ -ForegroundColor Red
                }

                $Command = {

                    $TrendMicroFolder = 'C:\Program Files (x86)\Trend Micro\OfficeScan Client\'
                    $TerndMicroFile = 'C:\Program Files (x86)\Trend Micro\OfficeScan Client\PccNTMon.exe'
                    $CCMSetupLocal = 'C:\windows\ccmsetup\ccmsetup.exe'
                    $CCMSetupSource = 'C:\Temp\Client\ccmsetup.exe'
                    $CCMSetupArg = '/mp:DENBGMAEPA45SRV.evosoft.com SMSSITECODE=E01 FSP=DENBGMAEPA72SRV.ad001.siemens.net'
                    $LogFilePath = 'C:\Windows\ccmsetup\Logs\ccmsetup.log'
                    $Count = 1

                    if (Get-Service ccmexec -ErrorAction SilentlyContinue) {
                        Stop-Service ccmexec -Force -ErrorAction SilentlyContinue
                        (Get-Service ccmexec).WaitForStatus('Stopped','00:05:00')
                        If ((Get-Service ccmexec).Status -eq 'Stopped') { Write-Host 'Software Center service was stopped successfully' -ForegroundColor Green } else { Write-Error '5min Timeout reached. Software Center service could not be stopped. Please try again later...' -ForegroundColor Red -ErrorAction Stop } 
                    } else { Write-Host 'ccmexec service does not exist' -ForegroundColor Yellow }

                    if (Test-Path $CCMSetupLocal) {
                        Write-Host 'Starting uninstallation of Software Center...' 
                        Start-Process -FilePath $CCMSetupLocal -ArgumentList '/uninstall' -Wait -ErrorAction Stop
                        Write-Host 'Software Center was uninstalled successfully' -ForegroundColor Green
                    }

                    if (Get-Service tmlisten) {
                        cd $TrendMicroFolder
                        $Password = Read-Host -Prompt 'Please enter the password to unload Trend Micro'
                        .\PccNTMon.exe -n $Password
                        cls

                        Write-Host 'Copying CCM Installation source files...'
                        Write-Host 'Client source files copied successfully' -ForegroundColor Green
                        Write-Host 'Software Center service was stopped successfully' -ForegroundColor Green
                        Write-Host 'Starting uninstallation of Software Center...'
                        Write-Host 'Software Center was uninstalled successfully' -ForegroundColor Green 
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
                    gci -filter *.dll | % {regsvr32 /s $_.Name}

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
    
                    Write-Host 'Starting Software Center installation'
                    Start-Process -FilePath $CCMSetupSource -ArgumentList $CCMSetupArg -Wait
                    if (Test-Path $LogFilePath) {
                        while ((Get-Content -Path $LogFilePath -Tail 1 | Select-String -Pattern 'CcmSetup is exiting with return code' -SimpleMatch) -eq $null -or $Count -eq 120) 
                        {
                            Start-Sleep 10
                            $Count++
                        }
                        } else { Write-Host 'ccmsetup.log does not exist' -ForegroundColor Red }

                    if ($count -ge 120) { Write-Host 'Installation did not finish within 20 minutes' -ForegroundColor Red } 
                    else { 
                        $Lastline = Get-Content -Path $LogFilePath -Tail 1
                        $ReturnCode = $Lastline.Substring(7,$Lastline.IndexOf(']LOG]!>')-7) -replace 'CcmSetup is exiting with return code ',''
                        if ($ReturnCode -eq '0') { Write-Host 'Software Center was successfully installed' -ForegroundColor Green }
                        elseif($ReturnCode -eq '7') { Write - Host 'Software Center was successfully installed. Reboot Required' - ForegroundColor Yellow }
                        else { Write-Host 'There was an error: ' + $Lastline.Substring(7,$Lastline.IndexOf(']LOG]!>')-7) -ForegroundColor Red }
                        }

                }
                $s = New-PSSession -ComputerName '" + strComputerName + @"' -Authentication Kerberos -UseSSL
                Invoke-Command -ScriptBlock $command -Session $s";
            /*
            try
            {
                System.Diagnostics.Process.Start("powershell.exe", strCmdText);
            }
            catch (Exception)
            {
                MessageBox.Show("Something went wrong!");
            }
            */
        }

        private void StartFix_Click(object sender, RoutedEventArgs e)
        {

        }

        private void RepairSCCM_Click(object sender, RoutedEventArgs e)
        {
            string strComputerName = "";

            try
            { strComputerName = System.Net.Dns.GetHostEntry(tbGetStats.Text).HostName; }
            catch (Exception)
            { MessageBox.Show(tbGetStats.Text + " - is not a valid entry, please check spelling!"); }

            Thread t1 = new Thread(RepairSCCM);
            t1.Start(strComputerName);
        }
    }
}
