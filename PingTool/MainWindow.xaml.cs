using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Net.NetworkInformation;
using Microsoft.Management.Infrastructure;
using Microsoft.Management.Infrastructure.Options;
using System.Security;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Threading;
using System.DirectoryServices;
using System.Diagnostics;

namespace PingTool
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public Boolean bClicked = false;
        public Boolean bClicked2 = false;
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
        private void btnStartRevPing_Click(object sender, RoutedEventArgs e)
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

            bClicked2 = true;
        }
        private void btnPSExec_Click(object sender, RoutedEventArgs e)
        {
            string strCmdText;
            string strComputerName = "";

            try
            {
                strComputerName = System.Net.Dns.GetHostEntry(tbGetStats.Text).HostName;
            }
            catch (Exception)
            {
                MessageBox.Show(tbGetStats.Text + " - is not a valid entry, please check spelling!" );
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

    }
}
