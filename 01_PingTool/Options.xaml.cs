using Microsoft.Win32;
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
using System.Windows.Shapes;

namespace PingTool
{
    /// <summary>
    /// Interaction logic for Options.xaml
    /// </summary>
    public partial class Options : Window
    {
        public Options()
        {
            InitializeComponent();

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
                if (oCCMClientSourceFolder != null) { tbCCMClientSource.Text = oCCMClientSourceFolder.ToString(); } else { key.SetValue("CCMClientSourceFolder", @"CLIENT_SOURCE_SHARE_LOCATION_NOT_SET"); tbCCMClientSource.Text = @"CLIENT_SOURCE_LOCATION_NOT_SET"; }

                Object oCCMSetupArguments = key.GetValue("CCMSetupArguments");
                if (oCCMSetupArguments != null) { tbCCMSetupArguments.Text = oCCMSetupArguments.ToString(); } else { key.SetValue("CCMSetupArguments", @"SETUP_ARGUMENTS_NOT_SET"); tbCCMSetupArguments.Text = @"SETUP_ARGUMENTS_NOT_SET"; }

                Object oCCMClientDestinationFolder = key.GetValue("CCMClientDestinationFolder");
                if (oCCMClientDestinationFolder != null) { tbCCMClientDestination.Text = oCCMClientDestinationFolder.ToString(); } else { key.SetValue("CCMClientDestinationFolder", @"C:\Temp"); tbCCMClientDestination.Text = @"C:\Temp"; }

                Object oCCMSetupLocal = key.GetValue("CCMSetupFile");
                if (oCCMSetupLocal != null) { tbCCMSetupFile.Text = oCCMSetupLocal.ToString(); } else { key.SetValue("CCMSetupFile", @"C:\windows\ccmsetup\ccmsetup.exe"); tbCCMSetupFile.Text = @"C:\windows\ccmsetup\ccmsetup.exe"; }

                Object oCCMSetupLog = key.GetValue("CCMSetupLogFile");
                if (oCCMSetupLog != null) { tbCCMSetupLogFile.Text = oCCMSetupLog.ToString(); } else { key.SetValue("CCMSetupLogFile", @"C:\Windows\ccmsetup\Logs\ccmsetup.log"); tbCCMSetupLogFile.Text = @"C:\Windows\ccmsetup\Logs\ccmsetup.log"; }
            }

        }
        private void btnSave_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                RegistryKey key = Registry.CurrentUser.OpenSubKey("Software", true);
                key = key.OpenSubKey("PingTool", true);

                key.SetValue("CCMClientSourceFolder", tbCCMClientSource.Text);
                key.SetValue("CCMClientDestinationFolder", tbCCMClientDestination.Text);
                key.SetValue("CCMSetupArguments", tbCCMSetupArguments.Text);
                key.SetValue("CCMSetupFile", tbCCMSetupFile.Text);
                key.SetValue("CCMSetupLogFile", tbCCMSetupLogFile.Text);

                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                this.Close();
            }
        }
        private void btnCancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }

}

