using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.DirectoryServices.AccountManagement;
using System.Net;
using System.Net.NetworkInformation;
using System.Threading;
using System.Reflection;

namespace RemoteTools
{
    public partial class Form1 : Form
    {        

        // Global variables
        public static bool bUserAccess = false;
        public static bool bLogServer = false;
        public static bool bThreadFinished = false;

        public static string sLogServer;
        public static string sLogPath;
        public static string sAdminGroup = "SCCM Remote Control - Admin users";
        public static string sStandardGroup = "SCCM Remote Control - CN users";
        public static string sPCGroup = "SCCM Remote Controlled CN Workstations";
        public static string sSettingsFile;
        public static string sRemoteUser;

        public static long intRefMemorySize;
        public static long intMemorySize;
        public static int intTickCount = 0;
        public static int iProcessorID;

        public static bool bComputerFound;
        public static bool bStartedRT1;
        public static bool bConnected = false;
        public static bool bComputerAllowed = false;
        public static bool bIPFound = false;
        
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

            txtLogServer.Text = "Checking...";
            txtLogServer.BackColor = Color.Gray;
            txtLogServer.ForeColor = Color.White;

            txtUserAccess.Text = "Checking...";
            txtUserAccess.BackColor = Color.Gray;
            txtUserAccess.ForeColor = Color.White;

            try
            {
                string line;
                string word;
                string path = Directory.GetCurrentDirectory();
                if (File.Exists(path + @"\Settings.ini"))
                {
                    StreamReader file = new StreamReader(path + @"\Settings.ini");
                    while ((line = file.ReadLine()) != null)
                    {
                        Console.WriteLine(line);
                        if (line.Contains("ReportingServer"))
                        {
                            word = line.Replace("ReportingServer=", "");
                            sLogServer = word.Trim();
                        }
                        if (line.Contains("LogFilePath"))
                        {
                            word = line.Replace("LogFilePath=", "");
                            sLogPath = word.Trim();
                        }
                    }
                    file.Close();
                }
                else
                {
                    File.CreateText(path + @"\Settings.ini").Close();
                    File.AppendAllText(path + @"\Settings.ini", "ReportingServer=" + Environment.MachineName + Environment.NewLine + "LogFilePath=" + path);
                    StreamReader file = new StreamReader(path + @"\Settings.ini");
                    while ((line = file.ReadLine()) != null)
                    {
                        Console.WriteLine(line);
                        if (line.Contains("ReportingServer"))
                        {
                            word = line.Replace("ReportingServer=", "");
                            sLogServer = word.Trim();
                        }
                        if (line.Contains("LogFilePath"))
                        {
                            word = line.Replace("LogFilePath=", "");
                            sLogPath = word.Trim();
                        }
                    }
                    file.Close();
                }
            }
            catch (Exception)
            {
                txtActionLog.AppendText("There was a problem reading the settings file. Please delete it and relaunch Remote Tools to have it recreated");
            }

            txtActionLog.BackColor = Color.White;
            
            // Updating the Username field with error handling
            try
            {
                txtUser.Text = Environment.UserName.ToUpper();
            }
            catch (Exception)
            {
                txtUser.Text = "Username not found";
                txtUser.BackColor = Color.Red;
                txtUser.ForeColor = Color.White;
            }
            sRemoteUser = txtUser.Text.ToString();
            log("Remote Tools has been started");
            log("User: " + txtUser.Text.ToString());

            // Updating the Domain field with error handling
            try
            {
                txtDomain.Text = Environment.UserDomainName.ToUpper();
            }
            catch (Exception)
            {
                txtDomain.Text = "Domain not found";
                txtDomain.BackColor = Color.Red;
                txtDomain.ForeColor = Color.White;
            }
            log("Domain: " + txtDomain.Text.ToString());

            // Updating the PC name field with error handling
            try
            {
                txtPC.Text = Environment.MachineName.ToUpper();
            }
            catch (Exception)
            {
                txtPC.Text = "PC name not found";
                txtPC.BackColor = Color.Red;
                txtPC.ForeColor = Color.White;
            }
            log("Computer: " + txtPC.Text.ToString());

            ThreadStart childref = new ThreadStart(WorkingProcess);
            Thread procWork = new Thread(childref);
            procWork.Start();

        }

        // WRITING TO THE LOG FILE
        public void log(string text2)
        {
            if (File.Exists(sLogPath + @"\log\RemoteTools.log"))
            {
                try
                {
                    File.AppendAllText(sLogPath + @"\log\RemoteTools.log", DateTime.Now.ToString() + " - " + sRemoteUser + "\t" + text2 + Environment.NewLine);
                }
                catch (Exception)
                {
                    //Could not write to 
                }
            }
            else
            {
                try
                {
                    Directory.CreateDirectory(sLogPath + @"\log");
                    File.CreateText(sLogPath + @"\log\RemoteTools.log").Close();
                    File.AppendAllText(sLogPath + @"\log\RemoteTools.log", DateTime.Now.ToString() + " - " + sRemoteUser + "\t" + text2 + Environment.NewLine);
                }
                catch (Exception)
                {
                    //This stupid file is still in use arghhhhhh....
                }
            }
        }

        public void WorkingProcess()
        {
            bThreadFinished = false;

            //Check GROUP MEMBERSHIP
            string DomainName = Environment.UserDomainName;
            string UserName = Environment.UserName;

            log("Checking group membership...");

            try
            {
                PrincipalContext ctx = new PrincipalContext(ContextType.Domain, DomainName);
                UserPrincipal user = UserPrincipal.FindByIdentity(ctx, UserName);
                GroupPrincipal group = GroupPrincipal.FindByIdentity(ctx, sAdminGroup);
                GroupPrincipal group2 = GroupPrincipal.FindByIdentity(ctx, sStandardGroup);
                if (user != null)
                {
                    // check if user is member of that group
                    if (user.IsMemberOf(group) || user.IsMemberOf(group2))
                    {
                        bUserAccess = true;

                        txtUserAccess.Invoke(new UpdateTextCallback(this.UpdateUserAccessText),
                        new object[] { "OK" });

                        txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                        new object[] { "Remote Tools access for " + UserName + ": OK" });

                        log("User has access to use the Remote Tool");
                    }
                    else
                    {
                        bUserAccess = false;

                        txtUserAccess.Invoke(new UpdateTextCallback(this.UpdateUserAccessText),
                        new object[] { "Access Denied" });

                        txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                        new object[] { "Remote Tools access for " + UserName + ": ACCESS DENIED" });

                        log("User has no access to use the Remote Tool");
                    }

                    if (user.IsMemberOf(group2))
                    {
                        log("User is set as an Admnistrator for the Remote Tool. Settings option will be unlocked");
                        btnSettings.Enabled = true;
                        txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                        new object[] { "Settings option has been Unlocked"});
                    }
                }
            }
            catch (Exception)
            {
                bUserAccess = false;

                txtUserAccess.Invoke(new UpdateTextCallback(this.UpdateUserAccessText),
                new object[] { "ERROR"});

                txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                new object[] { "ERROR: Please check access to the domain or if security group for Remote Tools exists" });

                log("ERROR: Please check access to the domain or if the security group for Remote Tools exists");
            }

            //PING THE SERVER
            log("Pinging log server: " + sLogServer);

            try
            {
                var ping = new Ping();
                var reply = ping.Send(sLogServer, 10000);
                if (reply.Status == IPStatus.Success)
                {
                    bLogServer = true;

                    txtLogServer.Invoke(new UpdateTextCallback(this.UpdateLogServerText),
                    new object[] { "OK" });

                    txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                    new object[] { "Reporting Server: AVAILABLE" });

                    log("Reporting Server " + sLogServer + " is available");
                }
                else
                {
                    bLogServer = false;

                    txtLogServer.Invoke(new UpdateTextCallback(this.UpdateLogServerText),
                    new object[] { "UNAVAILABLE" });

                    txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                    new object[] { "Reporting Server: UNAVAILABLE" });

                    log("Reporting Server " + sLogServer + " is unavailable");
                }
            }
            catch (Exception)
            {
                bLogServer = false;

                txtLogServer.Invoke(new UpdateTextCallback(this.UpdateLogServerText),
                new object[] { "UNREACHABLE" });

                txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                new object[] { "Reporting Server: UNREACHABLE" });

                log("Reporting Server " + sLogServer + " is UNREACHABLE");
            }

            if (bUserAccess)
            {
                if (bLogServer)
                {
                    txtSearch.Enabled = true;
                    txtSearch.ReadOnly = false;
                    button1.Enabled = true;

                    txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                    new object[] { "Remote Tools is ready!" });

                    log("Remote Tools is ready");
                }
                else
                {
                    txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                    new object[] { "ERROR: Remote Tools cannot be used while the reporting server is unavailable" });

                    log( "ERROR: Remote Tools cannot be used while the reporting server is unavailable" );
                }
            }
            else
            {
                txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                new object[] { "ERROR: Remote Tools cannot be used by this account" });

                log( "ERROR: Remote Tools cannot be used by this account" );
            }

            bThreadFinished = true;

        }

        public delegate void UpdateTextCallback(string text);

        private void UpdateLogServerText(string text)
        {

            txtLogServer.Text = text;

            if (bLogServer)
            {
                txtLogServer.BackColor = Color.Green;
                txtLogServer.ForeColor = Color.White;
            }
            else
            {
                txtLogServer.BackColor = Color.Red;
                txtLogServer.ForeColor = Color.White;
            }

        }

        private void UpdateUserAccessText(string text)
        {
            txtUserAccess.Text = text;

            if (bUserAccess)
            {
                txtUserAccess.BackColor = Color.Green;
                txtUserAccess.ForeColor = Color.White;
            }
            else
            {
                txtUserAccess.BackColor = Color.Red;
                txtUserAccess.ForeColor = Color.White;
            }

        }

        private void UpdateActionLog(string text)
        {
            txtActionLog.AppendText(text + Environment.NewLine);
        }

          private static string GetMachineNameFromIPAddress(string ipAdress)
        {
            string machineName = string.Empty;
            try
            {
                IPHostEntry hostEntry = Dns.GetHostEntry(ipAdress);
                machineName = hostEntry.HostName;
                bIPFound = true;
            }
            catch (Exception)
            {
                bIPFound = false;
                // Machine not found...
            }
            return machineName;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            txtActionLog.AppendText("Checing connection to " + txtSearch.Text.ToString() + "..." + Environment.NewLine);
            log("Connection attempt has been made to " + txtSearch.Text.ToString() );

            string ComputerName = txtSearch.Text.ToString();

            if (rbtnIP.Checked)
            {
                ComputerName = GetMachineNameFromIPAddress(txtSearch.Text.ToString());
                ComputerName = ComputerName.Replace(".corp.skf.net", "");
            }

            string DomainName = Environment.UserDomainName;
            
            bComputerFound = false;

            try
            {
                using (PrincipalContext domainContext = new PrincipalContext(ContextType.Domain, DomainName))
                {
                    ComputerPrincipal computer = ComputerPrincipal.FindByIdentity(domainContext, ComputerName);
                    if (computer != null)
                    {
                        bComputerFound = true;
                        GroupPrincipal group = GroupPrincipal.FindByIdentity(domainContext, sPCGroup);
                        if (computer.IsMemberOf(group))
                        {
                            bComputerAllowed = true;
                        }
                        else
                        {
                            bComputerAllowed = false;
                        }
                            
                    }
                    else
                    {
                        bComputerFound = false;
                    }
                }
            }
            catch (Exception)
            {
                bComputerFound = false;
            }

            if (bComputerFound)
            {
                if (bComputerAllowed)
                {
                    timer1.Tick += new EventHandler(timer_Tick);
                    timer1.Enabled = true;
                    timer1.Start();

                    ThreadStart childref3 = new ThreadStart(LaunchCommandLineApp);
                    Thread LaunchRemoteTool = new Thread(childref3);
                    LaunchRemoteTool.Start();
                }
                else
                {
                    MessageBox.Show(ComputerName + ": You are not allowed to connect to this Computer", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtActionLog.AppendText(ComputerName + ": not allowed to connect!" + Environment.NewLine);
                    log(ComputerName + ": not allowed to connect!");
                }

            }
            else
            {
                if (bIPFound)
                {
                    MessageBox.Show(ComputerName + " does not exist! Please check your spelling.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtActionLog.AppendText(ComputerName + " does not exist!" + Environment.NewLine);
                    log(ComputerName + " does not exist!");
                }
                else
                {
                    MessageBox.Show(txtSearch.Text.ToString() + " is incorrect! Please check again.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtActionLog.AppendText(txtSearch.Text.ToString() + " is incorrect!" + Environment.NewLine);
                    log(txtSearch.Text.ToString() + " is incorrect!");
                }

            }
            
            

        }

        public void LaunchCommandLineApp()
        {

            // Use ProcessStartInfo class
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.CreateNoWindow = false;
            startInfo.UseShellExecute = false;
            startInfo.FileName = sLogPath + @"\RemoteTools\CmRcViewer.exe";
            startInfo.WindowStyle = ProcessWindowStyle.Hidden;
            startInfo.Arguments = txtSearch.Text.ToString();

            try
            {
                // Start the process with the info we specified.
                // Call WaitForExit and then the using statement will close.
                using (Process exeProcess = Process.Start(startInfo))
                {
                    iProcessorID = exeProcess.Id;
                    exeProcess.WaitForExit();
                }
            }
            catch
            {
                // Log error.

                txtActionLog.Invoke(new UpdateTextCallback(this.UpdateActionLog),
                new object[] { "Connection to " + txtSearch.Text.ToString() + " FAILED. Remote Tools encountered an error." + Environment.NewLine + "Please try again..." });
                log("Connection to " + txtSearch.Text.ToString() + " FAILED. Remote Tools encountered an error.");
            }
        }

        public void timer_Tick(object sender, EventArgs e)
        {
            intTickCount = intTickCount + 1;

            Process[] pname = Process.GetProcessesByName("CmRcViewer");
            
            if (pname.Length == 0)
            {
                //process is not running
                if (intTickCount > 5)
                {
                    timer1.Stop();
                }
            }
            else
            {

                //Getting reference physical memory size
                if (!bStartedRT1)
                {
                    bStartedRT1 = true;
                    intRefMemorySize = Process.GetProcessById(iProcessorID).WorkingSet64;
                    intRefMemorySize = intRefMemorySize + 2000000;
                    txtActionLog.AppendText("Remote Tools started..." + Environment.NewLine);
                    log("Remote Tools started...");
                }

                //Getting Physical Memory size
                intMemorySize = Process.GetProcessById(iProcessorID).WorkingSet64;

                if (intMemorySize > intRefMemorySize)
                {
                    if (!bConnected)
                    {
                        txtActionLog.AppendText("Connected to " + txtSearch.Text.ToString() + Environment.NewLine);
                        log("Connected to " + txtSearch.Text.ToString());
                    }
                    bConnected = true;
                }

                //process is running
                if (intTickCount > 5 && !bConnected)
                {
                    Process.GetProcessById(iProcessorID).Kill();
                    txtActionLog.AppendText("Disconnecting from " + txtSearch.Text.ToString() + Environment.NewLine );
                    log( "Disconnecting from " + txtSearch.Text.ToString() );

                    timer1.Stop();
                    intTickCount = 0;
                    bConnected = false;
                    bStartedRT1 = false;
                }

                if (bConnected && intMemorySize < intRefMemorySize)
                {
                    Process.GetProcessById(iProcessorID).Kill();
                    txtActionLog.AppendText("Disconnecting from " + txtSearch.Text.ToString() + Environment.NewLine);
                    log("Disconnecting from " + txtSearch.Text.ToString());

                    timer1.Stop();
                    intTickCount = 0;
                    bConnected = false;
                    bStartedRT1 = false;
                }

            }
                

        }

        private void btnReCheck_Click(object sender, EventArgs e)
        {
            // Updating the Username field
            log("Checking the credentials again...");

            txtLogServer.Text = "Checking...";
            txtLogServer.BackColor = Color.Gray;
            txtLogServer.ForeColor = Color.White;

            txtUserAccess.Text = "Checking...";
            txtUserAccess.BackColor = Color.Gray;
            txtUserAccess.ForeColor = Color.White;

            try
            {
                txtUser.Text = Environment.UserName.ToUpper();
            }
            catch (Exception)
            {
                txtUser.Text = "Username not found";
                txtUser.BackColor = Color.Red;
                txtUser.ForeColor = Color.White;
            }

            // Updating the Domain field
            try
            {
                txtDomain.Text = Environment.UserDomainName.ToUpper();
            }
            catch (Exception)
            {
                txtDomain.Text = "Domain not found";
                txtDomain.BackColor = Color.Red;
                txtDomain.ForeColor = Color.White;
            }

            // Updating the PC name field
            try
            {
                txtPC.Text = Environment.MachineName.ToUpper();
            }
            catch (Exception)
            {
                txtPC.Text = "PC name not found";
                txtPC.BackColor = Color.Red;
                txtPC.ForeColor = Color.White;
            }

            //string UserName = Environment.UserName;

            ThreadStart childref = new ThreadStart(WorkingProcess);
            Thread procWork = new Thread(childref);
            procWork.Start();
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            if (bThreadFinished)
            {
                Application.Exit();
                log("Exiting Remote Tools");
            } else
            {
                MessageBox.Show("Please wait, background checks not yet finished...", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnSettings_Click(object sender, EventArgs e)
        {
                string path = Directory.GetCurrentDirectory();
                var fileToOpen = path + @"\Settings.ini";
                var process = new Process();
                process.StartInfo = new ProcessStartInfo()
                {
                    UseShellExecute = true,
                    FileName = fileToOpen
                };

                process.Start();

        }

    }
}
