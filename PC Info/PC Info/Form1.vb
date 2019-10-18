Imports System
Imports System.Threading
Imports System.Management
Imports System.Net.NetworkInformation
Imports System.Windows.Forms
Imports System.Windows.Forms.DataGrid
Imports System.Net
Imports Microsoft.Win32

Public Class Form1

    Private trd As Thread

    Private Sub DataGridView1_CellMouseClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellMouseEventArgs) Handles DataGridView1.CellMouseClick
        'if the datagridview was right clicked, set the currentcell to the right-clicked cell and then show a context menu with options for filling the right-clicked cell
        If (e.Button = Windows.Forms.MouseButtons.Right) Then
            Dim ht As DataGridView.HitTestInfo
            Dim rect As Rectangle = DataGridView1.GetCellDisplayRectangle(e.ColumnIndex, e.RowIndex, True)
            Dim ptLoc As System.Drawing.Point = New System.Drawing.Point(rect.Left + e.X, rect.Top + e.Y)
            Try
                ht = Me.DataGridView1.HitTest(e.X, e.Y)
                DataGridView1.CurrentCell = DataGridView1.Rows(e.RowIndex).Cells(e.ColumnIndex)
                ContextMenuStrip1.Show(DataGridView1.PointToScreen(ptLoc))
            Catch ex As Exception
                MsgBox(ex.Message)
            End Try

        End If
    End Sub

    Private Sub CopyToolStripMenuItem_Click(ByVal sender As Object, ByVal e As EventArgs) Handles CopyToolStripMenuItem.Click
        Dim dataobj As New DataObject(DataGridView1.GetClipboardContent())
        Clipboard.SetDataObject(dataobj)
    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim strHostName As String = ""
        Dim strIPAddress As String = ""
        Dim strDomain As String = ""
        Dim strLogonUser As String = ""
        Dim OSVersion As Version
        Dim strOSVersion As String = ""
        Dim strSP As String = ""
        Dim strServicePack As String = ""
        Dim strMAC As String = ""
        'Dim nics() As NetworkInterface

        Dim objOS As ManagementObjectSearcher
        Dim objCS As ManagementObjectSearcher
        Dim objLD As ManagementObjectSearcher
        Dim objBIOS As ManagementObjectSearcher
        Dim objNAC As ManagementObjectSearcher
        Dim objMgmt As ManagementObject
        Dim strComputerName As String = ""
        Dim strManufacturer As String = ""
        Dim StrModel As String = ""
        Dim strOSName As String = ""
        'Dim strOSVersion As String
        Dim strSystemType As String = ""
        Dim strTPM As String = ""
        Dim strWindowsDir As String = ""
        Dim strSerialNum As String = ""
        'Dim m_strDescription As String
        Dim strDeviceID As String
        Dim strSize As String
        Dim strFreeSpace As String
        Dim strFreeSpacePrecentage As String
        Dim i As Integer = 0

        Try
            objOS = New ManagementObjectSearcher("SELECT * FROM Win32_OperatingSystem")
            objCS = New ManagementObjectSearcher("SELECT * FROM Win32_ComputerSystem")
            objBIOS = New ManagementObjectSearcher("SELECT * FROM Win32_BIOS")
            objNAC = New ManagementObjectSearcher("SELECT * FROM Win32_NetworkAdapterConfiguration")

            For Each objMgmt In objOS.Get
                strOSName = objMgmt("name").ToString()
                strOSVersion = objMgmt("version").ToString()
                strComputerName = objMgmt("csname").ToString()
                strWindowsDir = objMgmt("windowsdirectory").ToString()
            Next

            For Each objMgmt In objCS.Get
                strManufacturer = objMgmt("manufacturer").ToString()
                StrModel = objMgmt("model").ToString()
                strSystemType = objMgmt("systemtype").ToString
                strTPM = objMgmt("totalphysicalmemory").ToString()
            Next

            For Each objMgmt In objBIOS.Get
                strSerialNum = objMgmt("serialnumber").ToString()
            Next

            For Each objMgmt In objNAC.Get
                If objMgmt("IPEnabled").ToString = "True" Then
                    strMAC = objMgmt("MACAddress").ToString()
                End If
            Next

            'For Each objMgmt In objLD.Get
            '    If objMgmt("DriveType").ToString = "3" Then
            '        strDeviceID(i) = objMgmt("DeviceID").ToString()
            '        strSize(i) = objMgmt("Size").ToString
            '        strFreeSpace(i) = objMgmt("FreeSpace").ToString()
            '        i = i + 1
            '    End If
            'Next

        Catch ex As Exception
            MessageBox.Show("Could not make a connection to the WMI")
        End Try

        'Get Computer Name
        Try
            Try
                strHostName = Environment.MachineName
            Catch ex As Exception

            End Try
            Try
                If strHostName = "" Then
                    strHostName = System.Net.Dns.GetHostName()
                End If
            Catch ex As Exception

            End Try
            If strHostName = "" Then
                strHostName = strComputerName
            End If
        Catch ex As Exception
            strHostName = "ERROR COLLECTING DATA"
        End Try

        'Get IP Address
        Try
            Dim hostInfo As IPHostEntry = System.Net.Dns.GetHostEntry(strHostName)
            Dim index As Integer
            For index = 0 To hostInfo.AddressList.Length - 1
                If InStr(hostInfo.AddressList(index).ToString, ".") <> 0 Then
                    strIPAddress = strIPAddress & hostInfo.AddressList(index).ToString & "; "
                End If
            Next index
            'strIPAddress = System.Net.Dns.GetHostEntry(strHostName).AddressList.Where(Function(a As IPAddress) Not a.IsIPv6LinkLocal AndAlso Not a.IsIPv6Multicast AndAlso Not a.IsIPv6SiteLocal).First().ToString()
        Catch ex As Exception
            strIPAddress = "ERROR COLLECTING DATA"
        End Try

        'Get User Name
        Try
            Try
                strLogonUser = Environment.UserName
            Catch ex As Exception

            End Try

            If strLogonUser = "" Then
                Dim strTempString As String = System.Security.Principal.WindowsIdentity.GetCurrent().Name.ToString()
                strLogonUser = Strings.Right(strTempString, Strings.Len(strTempString) - InStr(strTempString, "\"))
            End If

        Catch ex As Exception
            strLogonUser = "ERROR COLLECTING DATA"
        End Try

        'Get Domain Name
        Try
            Try
                strDomain = Environment.UserDomainName
            Catch ex As Exception

            End Try

            If strDomain = "" Then
                Dim strTempString As String = System.Security.Principal.WindowsIdentity.GetCurrent().Name.ToString()
                strDomain = Strings.Left(strTempString, InStr(strTempString, "\") - 1)
            End If

        Catch ex As Exception
            strDomain = "ERROR COLLECTING DATA"
        End Try

        'Get OS version
        Try
            Try
                strOSName = Strings.Left(strOSName, InStr(strOSName, "|") - 2)
            Catch ex As Exception

            End Try

            If strOSName = "" Then
                OSVersion = Environment.OSVersion.Version
                Select Case OSVersion.Major
                    Case 5
                        Select Case OSVersion.Minor
                            Case 0
                                strOSName = "Windows 2000"
                            Case 1
                                strOSName = "Windows XP"
                            Case 2
                                strOSName = "Windows XP 64-Bit Edition"
                        End Select
                    Case 6
                        Select Case OSVersion.Minor
                            Case 0
                                strOSName = "Windows Vista"
                            Case 1
                                strOSName = "Windows 7"
                            Case 2
                                strOSName = "Windows 8"
                            Case 3
                                strOSName = "Windows 8.1"
                        End Select
                    Case Else
                        strOSName = "Unknown"
                End Select
            End If

        Catch ex As Exception
            strOSName = "ERROR COLLECTING DATA"
        End Try

        'Get Service Pack version
        Try
            strSP = Environment.OSVersion.ToString
            If InStr(strSP, "Service") > 0 Then
                strServicePack = Strings.Right(strSP, Strings.Len(strSP) - InStr(strSP, "Service") + 1)
            Else
                strServicePack = "NOT INSTALLED"
            End If
        Catch ex As Exception
            strServicePack = "ERROR COLLECTING DATA"
        End Try

        'Get Memory
        Dim strMemory As Double = Math.Round(CDbl(strTPM) / (1024 * 1024))

        'Get HDD Size
        'Dim strSize01 As String = CStr(Math.Round(CDbl(objWMI.Size01) / 1024 / 1024 / 1024)) & " GB"
        'Dim strSize02 As String = CStr(Math.Round(CDbl(objWMI.Size02) / 1024 / 1024 / 1024)) & " GB"

        'Get HDD Free Disk space
        'Dim strFreeSpace01 As String = CStr(Math.Round(CDbl(objWMI.FreeSpace01) / 1024 / 1024 / 1024)) & " GB"
        'Dim strFreeSpace02 As String = CStr(Math.Round(CDbl(objWMI.FreeSpace02) / 1024 / 1024 / 1024)) & " GB"

        DataGridView1.ColumnCount = 2
        DataGridView1.Columns(0).Name = "Host"
        DataGridView1.Columns(1).Name = "Data"
        DataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        DataGridView1.Columns(0).DefaultCellStyle.BackColor = Color.LightGreen

        DataGridView1.Rows.Add("GENERAL INFORMATION", "")
        DataGridView1.Rows.Add("Computer Name:", strHostName)
        DataGridView1.Rows.Add("Domain:", strDomain)
        DataGridView1.Rows.Add("User Account:", strLogonUser)
        DataGridView1.Rows.Add("Operating System:", strOSName)
        DataGridView1.Rows.Add("Service Pack:", strServicePack)
        DataGridView1.Rows.Add("OS Version:", strOSVersion)
        DataGridView1.Rows.Add("OS Type:", strSystemType)
        DataGridView1.Rows.Add("COMPUTER INFORMATION", "")
        DataGridView1.Rows.Add("Manufacturer:", strManufacturer)
        DataGridView1.Rows.Add("Model:", StrModel)
        DataGridView1.Rows.Add("Serial Number:", strSerialNum)
        DataGridView1.Rows.Add("Total Phisical Memory:", strMemory & " MB")
        DataGridView1.Rows.Add("Windows Directory:", strWindowsDir)

        'Add Drive names and info
        Try
            objLD = New ManagementObjectSearcher("SELECT * FROM Win32_LogicalDisk")
            For Each objMgmt In objLD.Get
                If objMgmt("Description").ToString = "Local Fixed Disk" Then
                    strDeviceID = objMgmt("DeviceID").ToString()
                    strSize = CStr(Math.Round(CDbl(objMgmt("size").ToString()) / 1024 / 1024 / 1024)) & " GB"
                    strFreeSpace = CStr(Math.Round(CDbl(objMgmt("FreeSpace").ToString()) / 1024 / 1024 / 1024)) & " GB"
                    strFreeSpacePrecentage = CStr(Math.Round(Math.Round(CDbl(objMgmt("FreeSpace").ToString()) / 1024 / 1024 / 1024) / (Math.Round(CDbl(objMgmt("size").ToString()) / 1024 / 1024 / 1024) / 100), 2, MidpointRounding.AwayFromZero))
                    DataGridView1.Rows.Add("Harddisk/Free space (" & strDeviceID & "):", strSize & " / " & strFreeSpace & " (" & strFreeSpacePrecentage & "%)")
                End If
            Next
        Catch ex As Exception
            DataGridView1.Rows.Add("Harddisk/Free space:", "ERROR COLLECTING DATA")
        End Try

        DataGridView1.Rows.Add("NETWORK INFORMATION", "")
        DataGridView1.Rows.Add("IP-Address(es):", strIPAddress)

        'Get Network Addresses
        Try
            Dim adapters As NetworkInterface() = NetworkInterface.GetAllNetworkInterfaces()
            Dim adapter As NetworkInterface
            Dim myMac As String = String.Empty

            For Each adapter In adapters
                Dim adapterProperties As IPInterfaceProperties = adapter.GetIPProperties()
                Dim DHCPaddresses As IPAddressCollection = adapterProperties.DhcpServerAddresses
                Dim DNSaddresses As IPAddressCollection = adapterProperties.DnsAddresses
                Dim myGateways As GatewayIPAddressInformationCollection = Nothing

                If adapter.OperationalStatus.ToString = "Up" Then
                    Select Case adapter.NetworkInterfaceType
                        'Exclude Tunnels, Loopbacks and PPP
                        Case NetworkInterfaceType.Loopback, NetworkInterfaceType.Tunnel 'NetworkInterfaceType.Ppp,
                        Case Else
                            Dim strAdapter As String = adapter.Name.ToString
                            If DNSaddresses.Count > 0 Then
                                DataGridView1.Rows.Add("Adapter Name:", strAdapter)
                                If adapter.GetPhysicalAddress.ToString = "" Then
                                    'DataGridView1.Rows.Add("MAC Address:", "No MAC address found")
                                Else
                                    DataGridView1.Rows.Add("MAC Address:", adapter.GetPhysicalAddress.ToString)
                                End If
                                myGateways = adapterProperties.GatewayAddresses
                                For Each GateWay As GatewayIPAddressInformation In myGateways
                                    DataGridView1.Rows.Add("Default Gateway:", GateWay.Address.ToString)
                                Next

                                If DHCPaddresses.Count > 0 Then
                                    Dim DHCPaddress As IPAddress
                                    For Each DHCPaddress In DHCPaddresses
                                        DataGridView1.Rows.Add("DHCP Address:", DHCPaddress.ToString())
                                    Next DHCPaddress
                                End If
                                Dim DNSaddress As IPAddress
                                Dim intDNSCount As Integer = 1
                                For Each DNSaddress In DNSaddresses
                                    If InStr(DNSaddress.ToString(), ".") > 0 Then
                                        DataGridView1.Rows.Add("DNS Address(" & intDNSCount & "):", DNSaddress.ToString())
                                        intDNSCount = intDNSCount + 1
                                    End If
                                Next DNSaddress
                                'Exit For
                            End If
                    End Select
                End If
            Next adapter
        Catch ex As Exception
            strMAC = "ERROR COLLECTING DATA"
        End Try

        'Add NetworkDrive names and info
        Try
            objLD = New ManagementObjectSearcher("SELECT * FROM Win32_LogicalDisk")
            For Each objMgmt In objLD.Get
                If objMgmt("DriveType").ToString = "4" Then
                    strDeviceID = objMgmt("DeviceID").ToString()
                    strSize = ""
                    Try
                        strSize = objMgmt("ProviderName").ToString()
                    Catch ex As Exception

                    End Try
                    DataGridView1.Rows.Add("Network Drive (" & strDeviceID & "):", strSize)
                End If
            Next
        Catch ex As Exception
            'nothing
        End Try

        DataGridView1.ClearSelection()

    End Sub

    Private Function dataObj() As DataObject
        Throw New NotImplementedException
    End Function

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

    Private Sub btnConfig_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConfig.Click
        Dim s As String = ""
        Dim oCurrentCol As DataGridViewColumn    'Get header
        oCurrentCol = DataGridView1.Columns.GetFirstColumn(DataGridViewElementStates.Visible)
        Do
            s &= oCurrentCol.HeaderText & Chr(Keys.Tab)
            oCurrentCol = DataGridView1.Columns.GetNextColumn(oCurrentCol, _
               DataGridViewElementStates.Visible, DataGridViewElementStates.None)
        Loop Until oCurrentCol Is Nothing
        s = s.Substring(0, s.Length - 1)
        s &= Environment.NewLine    'Get rows
        For Each row As DataGridViewRow In DataGridView1.Rows
            oCurrentCol = DataGridView1.Columns.GetFirstColumn(DataGridViewElementStates.Visible)
            Do
                If row.Cells(oCurrentCol.Index).Value IsNot Nothing Then
                    s &= row.Cells(oCurrentCol.Index).Value.ToString
                End If
                s &= Chr(Keys.Tab)
                oCurrentCol = DataGridView1.Columns.GetNextColumn(oCurrentCol, _
                      DataGridViewElementStates.Visible, DataGridViewElementStates.None)
            Loop Until oCurrentCol Is Nothing
            s = s.Substring(0, s.Length - 1)
            s &= Environment.NewLine
        Next    'Put to clipboard
        Dim o As New DataObject
        o.SetText(s)
        Clipboard.SetDataObject(o, True)
    End Sub

    'QUICK-FIX BUTTONS

    Private Sub btnClearCacheForSiebel_Click(sender As Object, e As EventArgs)

        trd = New Thread(AddressOf ClearCacheForSiebel)
        trd.Start()

    End Sub

    Private Sub btnResetIE_Click(sender As Object, e As EventArgs)

        trd = New Thread(AddressOf ResetInternetExplorerSettings)
        trd.Start()

    End Sub

    Private Sub btnGPUpdate_Click(sender As Object, e As EventArgs) Handles btnGPUpdate.Click

        trd = New Thread(AddressOf GroupPolicyUpdate)
        trd.Start()

    End Sub

    Private Sub IPconfigAll_Click(sender As Object, e As EventArgs) Handles IPconfigAll.Click

        Dim oProcess As New Process()
        Dim oStartInfo As New ProcessStartInfo("cmd.exe", "/C ipconfig /all")
        oStartInfo.UseShellExecute = False
        oStartInfo.RedirectStandardOutput = True
        oProcess.StartInfo = oStartInfo
        oProcess.Start()

        Dim sOutput As String
        Using oStreamReader As System.IO.StreamReader = oProcess.StandardOutput
            sOutput = oStreamReader.ReadToEnd()
        End Using

        Output.OutputText.Text = sOutput
        Output.OutputText.SelectionStart = 0
        Output.ShowDialog()

    End Sub

    Private Sub IPConfigFlushDNS_Click(sender As Object, e As EventArgs) Handles IPConfigFlushDNS.Click
        Dim oProcess As New Process()
        Dim oStartInfo As New ProcessStartInfo("cmd.exe", "/C ipconfig /flushdns")
        oStartInfo.UseShellExecute = False
        oStartInfo.RedirectStandardOutput = True
        oProcess.StartInfo = oStartInfo
        oProcess.Start()

        MessageBox.Show("DNS Successfully flushed!",
        "Information",
        MessageBoxButtons.OK,
        MessageBoxIcon.Information,
        MessageBoxDefaultButton.Button1)

    End Sub

    'SOFTWARE BUTTONS

    Private Sub OpenApplicationCatalog_Click(sender As Object, e As EventArgs)
        Process.Start("IEXPLORE.exe", "http://w1186.corp.skf.net/CMApplicationCatalog/")
    End Sub

    'DIAGNOSTICS BUTTONS

    Private Sub btnOpenLogonLog_Click_1(sender As Object, e As EventArgs)
        Dim LogonScriptLog As String = "C:\Windows\Temp\GlobalLogon\LogonStatus.log"
        If System.IO.File.Exists(LogonScriptLog) = True Then
            Process.Start(LogonScriptLog)
        Else
            MessageBox.Show("File not found!",
            "Warrning",
            MessageBoxButtons.OK,
            MessageBoxIcon.Exclamation,
            MessageBoxDefaultButton.Button1)
        End If
    End Sub

    Private Sub btnAutoruns_Click(sender As Object, e As EventArgs)
        MessageBox.Show("Autoruns scan has been started! Results will be sent to the support team",
        "Information",
        MessageBoxButtons.OK,
        MessageBoxIcon.Information,
        MessageBoxDefaultButton.Button1)

        trd = New Thread(AddressOf RunAutorunsScan)
        trd.Start()

    End Sub

    'THREADING SUBS

    Private Sub ClearCacheForSiebel()

        Dim a As Array = Process.GetProcesses(".")
        Dim proc As Process
        Dim isRunning As Boolean = False

        For Each proc In a
            If proc.ProcessName.ToString = "iexplore" Then
                isRunning = True
            End If
        Next

        If isRunning Then
            MessageBox.Show("Internet Explorer is still running! Please close and try again.", _
            "Warrning", _
            MessageBoxButtons.OK, _
            MessageBoxIcon.Exclamation, _
            MessageBoxDefaultButton.Button1)
        Else
            Shell("RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2", , True)
            Shell("RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 4", , True)
            Shell("RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8", , True)
            Shell("RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8192", , True)
            MessageBox.Show("Cache Deleted Successfully!", _
            "Information", _
            MessageBoxButtons.OK, _
            MessageBoxIcon.Information, _
            MessageBoxDefaultButton.Button1)
        End If

    End Sub

    Private Sub ResetInternetExplorerSettings()

        Try
            Dim regKey As RegistryKey
            regKey = Registry.CurrentUser.OpenSubKey("SOFTWARE\Microsoft\Group Policy\Client\RunOnce", True)
            regKey.DeleteValue("{64A6CB32-9D3B-47D1-9955-5AE5993ECA82}")
            regKey.DeleteValue("{9791B892-B7CD-47C6-93DE-C7CA3C882992}")
            regKey.Close()
        Catch ex As Exception
            'MessageBox.Show("Error: " + ex.Message)
        End Try

        Try
            Shell("gpupdate.exe /force /wait:0", 0, True)
        Catch ex As Exception
            MessageBox.Show("Error: " + ex.Message, _
            "Warrning", _
            MessageBoxButtons.OK, _
            MessageBoxIcon.Exclamation, _
            MessageBoxDefaultButton.Button1)
        End Try

        MessageBox.Show("Browser Settings have been SUCCESSFULLY reset to SKF default." + Environment.NewLine + "Please RESTART Interten Explorer!", _
        "Information", _
        MessageBoxButtons.OK, _
        MessageBoxIcon.Information, _
        MessageBoxDefaultButton.Button1)

    End Sub

    Private Sub GroupPolicyUpdate()

        Try
            Shell("gpupdate.exe /force /wait:0", 0, True)
        Catch ex As Exception
            MessageBox.Show("Error: " + ex.Message, _
            "Warrning", _
            MessageBoxButtons.OK, _
            MessageBoxIcon.Exclamation, _
            MessageBoxDefaultButton.Button1)
        End Try

        MessageBox.Show("Group Policy has been updated SUCCESSFULLY", _
        "Information", _
        MessageBoxButtons.OK, _
        MessageBoxIcon.Information, _
        MessageBoxDefaultButton.Button1)

    End Sub

    Private Sub PingTool_Click(sender As Object, e As EventArgs) Handles PingTool.Click
        Ping.ShowDialog()
    End Sub

    Private Sub Tracert_Click(sender As Object, e As EventArgs) Handles btnTracert.Click
        Tracert.ShowDialog()
    End Sub

    Private Sub RunAutorunsScan()
        Shell("cmd.exe /c autorunsc.exe -a b -ct >> Autoruns.txt", , True)
    End Sub

End Class
