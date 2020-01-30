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
using Microsoft.Win32;

namespace PingTool
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        // GLOBAL VARIABLES
        public Boolean bClicked = false;
        public string strComputerName;
        public string strCCMClientSource;
        public string strCCMSetupArguments;
        public string strCCMClientDestination;
        public string strCCMSetupFile;
        public string strCCMSetupLogFile;
        string[] lines;

        public MainWindow()
        {
            InitializeComponent();
            GetSettings();
        }

        // CLASSES
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

        // EVENTHANDLERS
        private void GetInfo_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                strComputerName = System.Net.Dns.GetHostEntry(tbGetStats.Text).HostName;
                Thread t = new Thread(GetPCInfo);
                t.Start();
            }
            catch (Exception)
            {
                MessageBox.Show("Invalid entry, please check the spelling and make sure the machine is available!");
            }
        }
        private void StartPing_Click(object sender, RoutedEventArgs e)
        {
            lines = tbInput.Text.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
            Thread t = new Thread(PingList);
            t.Start();
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
        private void RepairWMI_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                strComputerName = System.Net.Dns.GetHostEntry(tbGetStats.Text).HostName;
                GetSettings();
                Thread t = new Thread(RepairWMI);
                t.Start();
            }
            catch (Exception)
            {
                MessageBox.Show("Invalid entry, please check the spelling and make sure the machine is available!");
            }
        }
        private void RepairSCCM_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                strComputerName = System.Net.Dns.GetHostEntry(tbGetStats.Text).HostName;
                GetSettings();
                Thread t = new Thread(RepairSCCM);
                t.Start();
            }
            catch (Exception)
            {
                MessageBox.Show("Invalid entry, please check the spelling and make sure the machine is available!");
            }
        }
        private void RepairWUA_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                strComputerName = System.Net.Dns.GetHostEntry(tbGetStats.Text).HostName;
                GetSettings();
                Thread t = new Thread(RepairWUA);
                t.Start();
            }
            catch (Exception)
            {
                MessageBox.Show("Invalid entry, please check the spelling and make sure the machine is available!");
            }
        }
        private void Options_Click(object sender, RoutedEventArgs e)
        {
            GetSettings();

            Options win2 = new Options();
            win2.ShowDialog();
        }
        private void dgTabla_SelectedCellsChanged(object sender, SelectedCellsChangedEventArgs e)
        {
            string cellValue = GetSelectedCellValue();
            //System.Windows.MessageBox.Show(cellValue);
            tbGetStats.Text = cellValue;
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

        // FUNCTIONS
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
                PowerShellInstance.AddParameter("pcName", strComputerName);

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
                PowerShellInstance.AddParameter("pcName", strComputerName);

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
                PowerShellInstance.AddParameter("pcName", strComputerName);

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

            Dispatcher.Invoke(new Action(() => { dgStats.Items.Clear(); 
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
        public void GetSettings()
        {
            RegistryKey key = Registry.CurrentUser.OpenSubKey("Software", true);
            key = key.OpenSubKey("PingTool", true);

            if (key == null)
            {
                key = Registry.CurrentUser.OpenSubKey("Software", true);
                key.CreateSubKey("PingTool");
                key = key.OpenSubKey("PingTool", true);

                key.SetValue("CCMClientSourceFolder", @"\\DENBGMAEPA99SRV.evosoft.com\SMS_CAS\Client");
                key.SetValue("CCMSetupArguments", @"/mp:DENBGMAEPA45SRV.evosoft.com SMSSITECODE=E01 FSP=DENBGMAEPA72SRV.ad001.siemens.net");
                key.SetValue("CCMClientDestinationFolder", @"C:\Temp");
                key.SetValue("CCMSetupFile", @"C:\windows\ccmsetup\ccmsetup.exe");
                key.SetValue("CCMSetupLogFile", @"C:\Windows\ccmsetup\Logs\ccmsetup.log");
            }
            else
            {
                Object oCCMClientSourceFolder = key.GetValue("CCMClientSourceFolder");
                if (oCCMClientSourceFolder != null) { strCCMClientSource = oCCMClientSourceFolder.ToString(); } else { key.SetValue("CCMClientSourceFolder", @"CLIENT_SOURCE_SHARE_LOCATION_NOT_SET"); }

                Object oCCMSetupArguments = key.GetValue("CCMSetupArguments");
                if (oCCMSetupArguments != null) { strCCMSetupArguments = oCCMSetupArguments.ToString(); } else { key.SetValue("CCMSetupArguments", @"SETUP_ARGUMENTS_NOT_SET"); }

                Object oCCMClientDestinationFolder = key.GetValue("CCMClientDestinationFolder");
                if (oCCMClientDestinationFolder != null) { strCCMClientDestination = oCCMClientDestinationFolder.ToString(); } else { key.SetValue("CCMClientDestinationFolder", @"C:\Temp"); }

                Object oCCMSetupFile = key.GetValue("CCMSetupFile");
                if (oCCMSetupFile != null) { strCCMSetupFile = oCCMSetupFile.ToString(); } else { key.SetValue("CCMSetupFile", @"C:\windows\ccmsetup\ccmsetup.exe"); }

                Object oCCMSetupLogFile = key.GetValue("CCMSetupLogFile");
                if (oCCMSetupLogFile != null) { strCCMSetupLogFile = oCCMSetupLogFile.ToString(); } else { key.SetValue("CCMSetupLogFile", @"C:\Windows\ccmsetup\Logs\ccmsetup.log"); }
            }

        }
        public void RepairWMI()
        {
            string strCmdText;

            strCmdText = @"$Command = {
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

                Write-Host 'Starting Software Center service...'
                Start-Service ccmexec -ErrorAction SilentlyContinue

                Write-Host 'Starting Trend Micro service...'
                Start-Process -FilePath $TerndMicroFile
    
                Write-Host 'WMI Repair finished' -ForegroundColor Green
            }
            $s = New-PSSession -ComputerName '" + strComputerName + @"' -Authentication Kerberos -UseSSL
            Invoke-Command -ScriptBlock $command -Session $s";

            try
            {
                System.Diagnostics.Process.Start("powershell.exe", strCmdText);
            }
            catch (Exception)
            {
                MessageBox.Show("Something went wrong!");
            }
            
        }
        public void RepairSCCM()
        {
            string strCmdText;
            strCCMClientDestination = strCCMClientDestination.Replace(":", "$");

            strCmdText = @"-NoExit $SessionWorks = $true
            $CopyWorked = $false
            $Destination = '\\" + strComputerName + @"\" + strCCMClientDestination + @"\CCMClient'
            $SourceFiles = '" + strCCMClientSource + @"'
            $Command = { Write-Host 'PSSession established. Commencing with repair on " + strComputerName + @"'  -ForegroundColor Green }

            Try {
                $s = New-PSSession -ComputerName '" + strComputerName + @"' -Authentication Kerberos -UseSSL
                Invoke-Command -Session $s -ScriptBlock $command -ErrorAction SilentlyContinue
            } catch {
                $SessionWorks = $false
            }

            Write-Host 'Trying to copy source files from '$SourceFiles

            if (Test-Path $SourceFiles'\ccmsetup.exe') {
                if (-Not (Test-Path $Destination)) { New-Item -ItemType Directory -Force -Path $Destination }
                Write-Host 'Found '$SourceFiles'\ccmsetup.exe' -ForegroundColor Green
                Copy-Item -Path $SourceFiles'\*' -Destination $Destination -Recurse -Container -Force
                $CopyWorked = $true
                Write-Host 'Client source files copied successfully' -ForegroundColor Green
            } else {
                Write-Host 'Copy failed. Please check if source file '$SourceFiles'\ccmsetup.exe exsits' -ForegroundColor Red
                $CopyWorked = $false
            }

            if ($SessionWorks) { 

                $Command = {

                    $TrendMicroFolder = 'C:\Program Files (x86)\Trend Micro\OfficeScan Client\'
                    $TerndMicroFile = 'C:\Program Files (x86)\Trend Micro\OfficeScan Client\PccNTMon.exe'
                    $CCMSetupFile = '" + strCCMSetupFile + @"'
                    $CCMSetupSource = ('" + strCCMClientDestination + @"\CCMClient\ccmsetup.exe').Replace('$',':')
                    $CCMSetupArg = '" + strCCMSetupArguments + @"'
                    $LogFilePath = '" + strCCMSetupLogFile + @"'
                    $Count = 1

                    if (Get-Service ccmexec -ErrorAction SilentlyContinue) {
                        Stop-Service ccmexec -Force -ErrorAction SilentlyContinue
                        (Get-Service ccmexec).WaitForStatus('Stopped','00:05:00')
                        If ((Get-Service ccmexec).Status -eq 'Stopped') { Write-Host 'Software Center service was stopped successfully' -ForegroundColor Green } else { Write-Error '5min Timeout reached. Software Center service could not be stopped. Please try again later...' -ForegroundColor Red -ErrorAction Stop } 
                    } else { Write-Host 'ccmexec service does not exist' -ForegroundColor Yellow }

                    if (Test-Path $CCMSetupFile) {
                        Write-Host 'Starting uninstallation of Software Center...' 
                        Start-Process -FilePath $CCMSetupFile -ArgumentList '/uninstall' -Wait -ErrorAction Stop
                        Write-Host 'Software Center was uninstalled successfully' -ForegroundColor Green
                    }

                    if (Get-Service tmlisten) {
                        cd $TrendMicroFolder
                        $Password = Read-Host -Prompt 'Please enter the password to unload Trend Micro'
                        cls                            
                        .\PccNTMon.exe -n $Password

                        Write-Host 'PSSession established. Commencing with repair on " + strComputerName + @"'  -ForegroundColor Green 
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
    
                    if (Test-Path $LogFilePath) {
                        Write-Host 'Removing existing CCMSetup.log'
                        Remove-Item -Path $LogFilePath -ErrorAction SilentlyContinue
                    } else { 
                        Write-Host 'ccmsetup.log does not exist'
                    }

                    $InstallTry = 0
                    $bLogFound = $false

                    While ($InstallTry -lt 2 -and !$bLogFound) {

                        $LogCount = 0
                        $InstallTry++

                        if ($InstallTry -eq 1) { Write-Host 'Attempting to install Software Center' } else { Write-Host 'Installation did not start. Attempting to install Software Center for the 2nd time' -ForegroundColor Yellow }
                        Start-Process -FilePath $CCMSetupSource -ArgumentList $CCMSetupArg -Wait

                        Write-Host 'Checking for ccmsetup.log'
                        do {
                            If (Test-Path $LogFilePath) {
                                Write-Host 'Found ccmsetup.log' -ForegroundColor Green
                                $bLogFound = $true
                            } Else {
                                Write-Host 'ccmsetup.log not found' -ForegroundColor Red 
                                Start-Sleep -Seconds 5
                                $LogCount++
                                $bLogFound = $false
                            }

                        } While (!($bLogFound) -and $LogCount -lt 12)

                    }

                    if($bLogFound){

                        while ((Get-Content -Path $LogFilePath -Tail 1 | Select-String -Pattern 'CcmSetup is exiting with return code' -SimpleMatch) -eq $null -or $Count -eq 120) 
                        { 
                            Start-Sleep 10 
                            $Count++
                        }

                        if ($count -ge 120 -and (Test-Path $LogFilePath)) { 
                            Write-Host 'Installation did not finish within 20 minutes' -ForegroundColor Red 
                        } elseif ($count -ge 120 -and -not (Test-Path $LogFilePath)) {
                            Write-Host 'Installation did not start within 20 minutes' -ForegroundColor Red
                        } else {
                            $Lastline = Get-Content -Path $LogFilePath -Tail 1
                            $ReturnCode = $Lastline.Substring(7,$Lastline.IndexOf(']LOG]!>')-7) -replace 'CcmSetup is exiting with return code ',''

                            if ($ReturnCode -eq '0') { 
                                Write-Host 'Software Center was successfully installed' -ForegroundColor Green 
                            }
                            elseif ($ReturnCode -eq '7') { 
                                Write-Host 'Software Center was successfully installed. Reboot Required' -ForegroundColor Yellow 
                            } else { 
                                Write-Host 'There was an error: ' + $Lastline.Substring(7,$Lastline.IndexOf(']LOG]!>')-7) -ForegroundColor Red 
                            }
                        }

                    } else {
                        Write-Host 'Installation did not start after 2 minutes. Please try again...' -ForegroundColor Red 
                    }

                }

                if ($CopyWorked) {
                    $s = New-PSSession -ComputerName '" + strComputerName + @"' -Authentication Kerberos -UseSSL
                    Invoke-Command -ScriptBlock $command -Session $s
                }

            } else { Write-Host 'PSSession could not be established' -ForegroundColor Red }";

            try
            {
                System.Diagnostics.Process.Start("powershell.exe", strCmdText);
            }
            catch (Exception)
            {
                MessageBox.Show("Something went wrong!");
            }
            


        }
        public void RepairWUA()
        {
            string strCmdText;

            strCmdText = @"-NoExit $Command = {

                $arch = Get-WMIObject -Class Win32_Processor -ComputerName LocalHost | Select-Object AddressWidth

                Write-Host '1. Stopping Windows Update Services...'
                Stop-Service -Name BITS
                Stop-Service -Name wuauserv
                Stop-Service -Name appidsvc
                Stop-Service -Name cryptsvc -force

                Write-Host '2. Remove QMGR Data file...'
                Remove-Item '$env:allusersprofile\Application Data\Microsoft\Network\Downloader\qmgr*.dat' -ErrorAction SilentlyContinue

                Write-Host '3. Renaming the Software Distribution and CatRoot Folder...'
                Remove-Item $env:systemroot\SoftwareDistribution.bak -Recurse -ErrorAction Ignore
                Rename-Item $env:systemroot\SoftwareDistribution SoftwareDistribution.bak -ErrorAction SilentlyContinue
                Rename-Item $env:systemroot\System32\Catroot2 catroot2.bak -ErrorAction SilentlyContinue

                Write-Host '4. Removing old Windows Update log...'
                Remove-Item $env:systemroot\WindowsUpdate.log -ErrorAction SilentlyContinue

                Write-Host '5. Resetting the Windows Update Services to defualt settings...'
                'sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)'
                'sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)'

                Set-Location $env:systemroot\system32

                Write-Host '6. Registering some DLLs...'
                regsvr32.exe /s atl.dll
                regsvr32.exe /s urlmon.dll
                regsvr32.exe /s mshtml.dll
                regsvr32.exe /s shdocvw.dll
                regsvr32.exe /s browseui.dll
                regsvr32.exe /s jscript.dll
                regsvr32.exe /s vbscript.dll
                regsvr32.exe /s scrrun.dll
                regsvr32.exe /s msxml.dll
                regsvr32.exe /s msxml3.dll
                regsvr32.exe /s msxml6.dll
                regsvr32.exe /s actxprxy.dll
                regsvr32.exe /s softpub.dll
                regsvr32.exe /s wintrust.dll
                regsvr32.exe /s dssenh.dll
                regsvr32.exe /s rsaenh.dll
                regsvr32.exe /s gpkcsp.dll
                regsvr32.exe /s sccbase.dll
                regsvr32.exe /s slbcsp.dll
                regsvr32.exe /s cryptdlg.dll
                regsvr32.exe /s oleaut32.dll
                regsvr32.exe /s ole32.dll
                regsvr32.exe /s shell32.dll
                regsvr32.exe /s initpki.dll
                regsvr32.exe /s wuapi.dll
                regsvr32.exe /s wuaueng.dll
                regsvr32.exe /s wuaueng1.dll
                regsvr32.exe /s wucltui.dll
                regsvr32.exe /s wups.dll
                regsvr32.exe /s wups2.dll
                regsvr32.exe /s wuweb.dll
                regsvr32.exe /s qmgr.dll
                regsvr32.exe /s qmgrprxy.dll
                regsvr32.exe /s wucltux.dll
                regsvr32.exe /s muweb.dll
                regsvr32.exe /s wuwebv.dll

                Write-Host '7) Removing WSUS client settings...'
                REG DELETE 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate' /v AccountDomainSid /f
                REG DELETE 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate' /v PingID /f
                REG DELETE 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate' /v SusClientId /f

                Write-Host '8) Resetting the WinSock...'
                netsh winsock reset
                netsh winhttp reset proxy

                Write-Host '9) Delete all BITS jobs...'
                Import-Module BITSTransfer
                Get-BitsTransfer | Remove-BitsTransfer

                Write-Host '10) Attempting to install the Windows Update Agent...'
                if($arch -eq 64){
                    wusa Windows8-RT-KB2937636-x64 /quiet
                }
                else{
                    wusa Windows8-RT-KB2937636-x86 /quiet
                }
                    
                Write-Host '11) Reseting policy to fix invalid update detections...'
                Remove-Item 'C:\Windows\System32\GroupPolicy\Machine\Registry.pol' -Force
                gpupdate /force

                Write-Host '12) Starting Windows Update Services...'
                Start-Service -Name BITS
                Start-Service -Name wuauserv
                Start-Service -Name appidsvc
                Start-Service -Name cryptsvc

                Write-Host '13) Forcing discovery...'
                wuauclt /resetauthorization /detectnow

                Write-Host 'WUA Repair Finished' -ForegroundColor Green

            }
            $s = New-PSSession -ComputerName '" + strComputerName + @"' -Authentication Kerberos -UseSSL
            Invoke-Command -ScriptBlock $command -Session $s";

            try
            {
                System.Diagnostics.Process.Start("powershell.exe", strCmdText);
            }
            catch (Exception)
            {
                MessageBox.Show("Something went wrong!");
            }
            
        }
    }
}
