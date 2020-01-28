Imports System.DirectoryServices
Imports System
Imports System.Management
Imports System.Net.NetworkInformation
Imports System.Windows.Forms
Imports System.Windows.Forms.DataGrid
Imports System.Net
Imports System.Threading

Public Class Form1

    'GLOBAL VARIABLES
    Public columnCount As Integer
    Public columnNumber As Integer = 9
    Public tempArray(columnNumber) As String
    Public strDomain As String = "rootDSE"
    Public arrSearchList() As String
    Public returnResult As String
    Public strSecondarySearch As String
    Public strSecondaryAttribute As String

    Dim thread As System.Threading.Thread

    Delegate Sub dgvDelegate()

    ' Call the delegate

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Control.CheckForIllegalCrossThreadCalls = False
        Dim rootdse As New DirectoryServices.DirectoryEntry("LDAP://RootDSE")

        strDomain = rootdse.Properties("defaultNamingContext").Value.ToString()
        txtDomain.Text = strDomain
        Label4.Text = "0/0"
    End Sub

    Private Sub ColumnCreator(ByVal ColumnName As String, ByVal ColumnIndex As Integer)
        tempArray(ColumnIndex) = ColumnName
    End Sub

    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        strDomain = txtDomain.Text

        arrSearchList = txtBoxMulti.Lines()

        CheckBox0.Enabled = False
        CheckBox1.Enabled = False
        CheckBox2.Enabled = False
        CheckBox3.Enabled = False
        CheckBox4.Enabled = False
        CheckBox5.Enabled = False
        CheckBox6.Enabled = False
        CheckBox7.Enabled = False
        CheckBox8.Enabled = False
        CheckBox9.Enabled = False

        strSecondarySearch = tbSecondary.Text
        strSecondaryAttribute = cbbSecondary.Text

        Dim dgvThread As New Threading.Thread(AddressOf StartQuery)
        dgvThread.Priority = ThreadPriority.Highest
        dgvThread.IsBackground = True
        dgvThread.Start()

    End Sub
    'Private Sub dgvThreadMain()
    '    If Me.InvokeRequired Then
    '        Me.Invoke(New dgvDelegate(AddressOf StartQuery))
    '    End If
    'End Sub

    Private Function GetADattributes(DomainAttributeResults As SearchResult, DomainAttribute As String) As String
        Select Case DomainAttribute
            Case "lastLogonTimestamp", "pwdLastSet", "lockoutTime", "lastLogon", "lastLogoff"
                Try
                    returnResult = CStr(ConvertADObjectToDate(DomainAttributeResults.GetDirectoryEntry().Properties(DomainAttribute).Value))
                Catch ex As Exception
                    returnResult = "n/a"
                End Try
            Case Else
                Try
                    returnResult = CStr(DomainAttributeResults.GetDirectoryEntry().Properties(DomainAttribute).Value)
                Catch ex As Exception
                    returnResult = "n/a"
                End Try
        End Select
        Return returnResult
    End Function

    Private Shared Function ConvertADObjectToDate(ByVal Input As Object) As Date
        Try
            Dim Output As Date
            Dim low As Object = Input.GetType.InvokeMember("LowPart", Reflection.BindingFlags.GetProperty, Nothing, Input, Nothing)
            Dim high As Object = Input.GetType.InvokeMember("HighPart", Reflection.BindingFlags.GetProperty, Nothing, Input, Nothing)
            Dim J As Long = (Convert.ToInt64(high) << 32) + Convert.ToInt64(low)
            Output = If(Convert.ToInt64(high) << 32 = -1 And Convert.ToInt64(low) = -1, Output, DateTime.FromFileTime(J))
            Return Output
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Sub StartQuery()

        'Clearing table
        DataGridView1.Rows.Clear()
        Array.Clear(tempArray, 0, tempArray.Length)

        columnCount = 0

        If CheckBox0.Checked Then
            ColumnCreator(ComboBox0.Text, columnCount)
            columnCount = columnCount + 1
        End If

        If CheckBox1.Checked Then
            ColumnCreator(ComboBox1.Text, columnCount)
            columnCount = columnCount + 1
        End If

        If CheckBox2.Checked Then
            ColumnCreator(ComboBox2.Text, columnCount)
            columnCount = columnCount + 1
        End If

        If CheckBox3.Checked Then
            ColumnCreator(ComboBox3.Text, columnCount)
            columnCount = columnCount + 1
        End If

        If CheckBox4.Checked Then
            ColumnCreator(ComboBox4.Text, columnCount)
            columnCount = columnCount + 1
        End If

        If CheckBox5.Checked Then
            ColumnCreator(ComboBox5.Text, columnCount)
            columnCount = columnCount + 1
        End If

        If CheckBox6.Checked Then
            ColumnCreator(ComboBox6.Text, columnCount)
            columnCount = columnCount + 1
        End If

        If CheckBox7.Checked Then
            ColumnCreator(ComboBox7.Text, columnCount)
            columnCount = columnCount + 1
        End If

        If CheckBox8.Checked Then
            ColumnCreator(CheckBox8.Text, columnCount)
            columnCount = columnCount + 1
        End If

        If CheckBox9.Checked Then
            ColumnCreator(CheckBox9.Text, columnCount)
            columnCount = columnCount + 1
        End If

        'Establish connection to the domain and set search location
        Dim ldap As String = "LDAP://" + strDomain
        DataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.DisplayedCells

        'If no columns have been selected
        If columnCount = 0 Then
            MessageBox.Show("You have not selected any columns", _
             "Important Note", _
             MessageBoxButtons.OK, _
             MessageBoxIcon.Exclamation, _
             MessageBoxDefaultButton.Button1)
            GoTo LastLine
        End If

        'Create header of the DataGridView
        DataGridView1.ColumnCount = columnCount
        For i As Integer = 0 To columnCount - 1
            DataGridView1.Columns(i).Name = tempArray(i)
        Next

        'Get search path
        'Dim iUserCounter As Integer
        Dim iArrayMax As Integer
        iArrayMax = arrSearchList.GetUpperBound(0)

        'Write data in DataGridView1
        For iUserCounter As Integer = 0 To iArrayMax

            Dim SearchMembers As String = ""

            SearchMembers = Trim(arrSearchList(iUserCounter))
            If SearchMembers = "" Then Continue For

            Dim tempArrayUser2(columnNumber) As String
            Dim strSearchFilter As String = ""

            'Set search filter to User, Computer or Group depending on radiobutton
            If rbtnUsers.Checked = True Then
                strSearchFilter = "(&(objectCategory=User)(sAMAccountName=" + SearchMembers + "))"
                If cbSecondary.Checked Then
                    strSearchFilter = "(&(objectCategory=User)(" + strSecondaryAttribute + "=" + strSecondarySearch + ")(sAMAccountName=" + SearchMembers + "))"
                End If
            End If

            If rbtnComputers.Checked = True Then
                strSearchFilter = "(&(objectClass=Computer)(objectCategory=Computer)(Name=" + SearchMembers + "))"
                If cbSecondary.Checked Then
                    strSearchFilter = "(&(objectClass=Computer)(" + strSecondaryAttribute + "=" + strSecondarySearch + ")(Name=" + SearchMembers + "))"
                End If
            End If

            If rbtnGroups.Checked = True Then
                strSearchFilter = "(&(objectCategory=Group)(Name=" + SearchMembers + "))"
                If cbSecondary.Checked Then
                    strSearchFilter = "(&(objectCategory=Group)(" + strSecondaryAttribute + "=" + strSecondarySearch + ")(Name=" + SearchMembers + "))"
                End If
            End If

            Using rootEntry As New DirectoryEntry(ldap)

                Using searcher As New DirectorySearcher(rootEntry)

                    'DirectorySearcher properties
                    searcher.PageSize = Integer.MaxValue
                    searcher.SizeLimit = Integer.MaxValue
                    searcher.Filter = strSearchFilter
                    searcher.PropertiesToLoad.Add("canonicalName")

                    Dim results As SearchResultCollection
                    Dim bResultsFound As Boolean = True
                    Dim intResult As Integer
                    Dim intCurrent As Integer = 0

                    Try
                        If rbtnUsers.Checked Then
                            Try
                                results = searcher.FindAll
                                intResult = results.Count

                            Catch ex As Exception
                                bResultsFound = False
                            End Try
                        Else
                            results = searcher.FindAll
                            intResult = results.Count
                        End If
                    Catch ex As Exception
                        bResultsFound = False
                    End Try

                    If intResult = 0 Then
                        bResultsFound = False
                    End If

                    Dim pbCounter As Integer = 0
                    ProgressBar1.Maximum = intResult

                    If bResultsFound Then
                        results = searcher.FindAll
                        Using results
                            For Each DirectorySearchResult As SearchResult In results

                                columnCount = 0
                                'Displayname
                                If CheckBox0.Checked Then
                                    'tempArrayUser2(columnCount) = CStr(DirectorySearchResult.GetDirectoryEntry().Properties(ComboBox0.Text).Value)
                                    tempArrayUser2(columnCount) = GetADattributes(DirectorySearchResult, ComboBox0.Text)
                                    columnCount = columnCount + 1
                                End If

                                'Account ID
                                If CheckBox1.Checked Then
                                    tempArrayUser2(columnCount) = GetADattributes(DirectorySearchResult, ComboBox1.Text)
                                    columnCount = columnCount + 1
                                End If

                                'Description
                                If CheckBox2.Checked Then
                                    tempArrayUser2(columnCount) = GetADattributes(DirectorySearchResult, ComboBox2.Text)
                                    columnCount = columnCount + 1
                                End If

                                'Managed by
                                If CheckBox3.Checked Then
                                    tempArrayUser2(columnCount) = GetADattributes(DirectorySearchResult, ComboBox3.Text)
                                    columnCount = columnCount + 1
                                End If

                                'Object Path
                                If CheckBox4.Checked Then
                                    tempArrayUser2(columnCount) = GetADattributes(DirectorySearchResult, ComboBox4.Text)
                                    columnCount = columnCount + 1
                                End If

                                'Distinguished Name
                                If CheckBox5.Checked Then
                                    tempArrayUser2(columnCount) = GetADattributes(DirectorySearchResult, ComboBox5.Text)
                                    columnCount = columnCount + 1
                                End If

                                'E-mail
                                If CheckBox6.Checked Then
                                    tempArrayUser2(columnCount) = GetADattributes(DirectorySearchResult, ComboBox6.Text)
                                    columnCount = columnCount + 1
                                End If

                                'City
                                If CheckBox7.Checked Then
                                    tempArrayUser2(columnCount) = GetADattributes(DirectorySearchResult, ComboBox7.Text)
                                    columnCount = columnCount + 1
                                End If

                                If CheckBox10.Checked Then
                                    tempArrayUser2(columnCount) = GetADattributes(DirectorySearchResult, ComboBox8.Text)
                                    columnCount = columnCount + 1
                                End If

                                'Country
                                If CheckBox8.Checked Then
                                    'columnCount = columnCount + 1

                                    For i As Integer = 0 To columnCount - 1
                                        DataGridView1.Columns(i).Name = tempArray(i)
                                    Next

                                    Dim DirectoryRoot As New DirectoryEntry("LDAP://" & strDomain)
                                    Dim DirectorySearch As New DirectorySearcher(DirectoryRoot, "(CN=" & SearchMembers & ")")
                                    Dim DirectorySearchCollection As SearchResultCollection = DirectorySearch.FindAll()
                                    For Each DirectorySearchResult2 As SearchResult In DirectorySearchCollection
                                        Dim ResultPropertyCollection As ResultPropertyCollection = DirectorySearchResult2.Properties
                                        Dim GroupMemberDN As String
                                        For Each GroupMemberDN In ResultPropertyCollection("member")
                                            Dim DirectoryMember As New DirectoryEntry("LDAP://" & GroupMemberDN)
                                            Dim DirectoryMemberProperties As System.DirectoryServices.PropertyCollection = DirectoryMember.Properties
                                            Dim DirectoryItem As Object = DirectoryMemberProperties("sAMAccountName").Value
                                            If Nothing IsNot DirectoryItem Then
                                                tempArrayUser2(columnCount) = DirectoryItem.ToString()

                                                DataGridView1.Invoke(Sub()
                                                                         DataGridView1.Rows.Add(tempArrayUser2)
                                                                         DataGridView1.Refresh()
                                                                     End Sub)

                                                Me.Invoke(Sub()
                                                              Me.Refresh()
                                                          End Sub)
                                            End If
                                        Next GroupMemberDN
                                    Next DirectorySearchResult2

                                Else

                                    If CheckBox9.Checked Then
                                        'columnCount = columnCount + 1

                                        For i As Integer = 0 To columnCount - 1
                                            DataGridView1.Columns(i).Name = tempArray(i)
                                        Next

                                        Dim DirectoryRoot As New DirectoryEntry("LDAP://" & strDomain)
                                        Dim DirectorySearch As New DirectorySearcher(DirectoryRoot)
                                        DirectorySearch.SearchScope = DirectoryServices.SearchScope.Subtree
                                        DirectorySearch.Filter = "(&(objectcategory=user)(SAMAccountName=" & SearchMembers & "))"
                                        Dim DirectorySearchResult3 As SearchResult = DirectorySearch.FindOne

                                        For i = 0 To DirectorySearchResult3.Properties("memberOf").Count() - 1
                                            Dim DirectoryMember As New DirectoryEntry("LDAP://" & DirectorySearchResult3.Properties("memberOf")(i).ToString())
                                            Dim DirectoryMemberProperties As System.DirectoryServices.PropertyCollection = DirectoryMember.Properties
                                            Dim DirectoryItem As Object = DirectoryMemberProperties("sAMAccountName").Value
                                            If Nothing IsNot DirectoryItem Then
                                                tempArrayUser2(columnCount) = DirectoryItem.ToString()
                                                DataGridView1.Invoke(Sub()
                                                                         DataGridView1.Rows.Add(tempArrayUser2)
                                                                         DataGridView1.Refresh()
                                                                     End Sub)

                                                ProgressBar1.Invoke(Sub()
                                                                        ProgressBar1.Value = pbCounter
                                                                        ProgressBar1.Refresh()
                                                                    End Sub)

                                                Me.Invoke(Sub()
                                                              Me.Refresh()
                                                          End Sub)
                                            End If

                                        Next

                                    Else

                                        For i As Integer = 0 To columnCount - 1
                                            DataGridView1.Columns(i).Name = tempArray(i)
                                        Next

                                        DataGridView1.Invoke(Sub()
                                                                 DataGridView1.Rows.Add(tempArrayUser2)
                                                                 DataGridView1.Refresh()
                                                             End Sub)

                                        Me.Invoke(Sub()
                                                      Me.Refresh()
                                                  End Sub)



                                    End If

                                End If

                                pbCounter = pbCounter + 1

                                ProgressBar1.Value = pbCounter
                                ProgressBar1.Refresh()

                                'ProgressBar1.Invoke(Sub()
                                '                        ProgressBar1.Value = pbCounter
                                '                        ProgressBar1.Refresh()
                                '                    End Sub)
                            Next
                        End Using
                    Else
                        columnCount = 0

                        If CheckBox0.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If
                        If CheckBox1.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If
                        If CheckBox2.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If
                        If CheckBox3.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If
                        If CheckBox4.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If
                        If CheckBox5.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If
                        If CheckBox6.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If
                        If CheckBox7.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If
                        If CheckBox8.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If
                        If CheckBox10.Checked Then
                            columnCount = columnCount + 1
                            tempArrayUser2(columnCount - 1) = SearchMembers & " - Not Found"
                        End If

                        DataGridView1.Invoke(Sub()
                                                 DataGridView1.Rows.Add(tempArrayUser2)
                                                 DataGridView1.Refresh()
                                             End Sub)

                        ProgressBar1.Invoke(Sub()
                                                ProgressBar1.Value = pbCounter
                                                ProgressBar1.Refresh()
                                            End Sub)

                        Me.Invoke(Sub()
                                      Me.Refresh()
                                  End Sub)

                        pbCounter = pbCounter + 1

                    End If
                End Using
            End Using

        Next

LastLine:
        CheckBox0.Enabled = True
        CheckBox1.Enabled = True
        CheckBox2.Enabled = True
        CheckBox3.Enabled = True
        CheckBox4.Enabled = True
        CheckBox5.Enabled = True
        CheckBox6.Enabled = True
        CheckBox7.Enabled = True
        CheckBox10.Enabled = True
        If rbtnUsers.Checked Or rbtnComputers.Checked Then
            CheckBox9.Enabled = True
        Else
            CheckBox8.Enabled = True
        End If

    End Sub

    'RADIOBUTTON EVENTS
    Private Sub radioButtonUser_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs) Handles rbtnUsers.CheckedChanged
        If rbtnUsers.Checked Then
            SetUserAttributes()
            CheckBox8.Enabled = False
            CheckBox9.Enabled = True
        End If
    End Sub
    Private Sub radioButtonComputer_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs) Handles rbtnComputers.CheckedChanged
        If rbtnComputers.Checked Then
            SetComputerAttributes()
            CheckBox8.Enabled = False
            CheckBox9.Enabled = True
        End If
    End Sub
    Private Sub radioButtonGroup_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs) Handles rbtnGroups.CheckedChanged
        If rbtnGroups.Checked = True Then
            SetGroupAttributes()
            CheckBox9.Enabled = False
            CheckBox8.Enabled = True
        End If
    End Sub

    'BUTTON EVENTS
    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExit.Click
        Close()
    End Sub
    Private Sub btnClear_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClear.Click
        DataGridView1.Rows.Clear()
        txtBoxMulti.Clear()
    End Sub
    Private Sub btnOption_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOption.Click
        Form2.Show()
    End Sub
    Private Sub btnCopy_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCopy.Click
        Dim s As String = ""
        Dim oCurrentCol As DataGridViewColumn    'Get header
        oCurrentCol = DataGridView1.Columns.GetFirstColumn(DataGridViewElementStates.Visible)
        Try
            Do
                s &= oCurrentCol.HeaderText & Chr(Keys.Tab)
                oCurrentCol = DataGridView1.Columns.GetNextColumn(oCurrentCol,
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
                    oCurrentCol = DataGridView1.Columns.GetNextColumn(oCurrentCol,
                          DataGridViewElementStates.Visible, DataGridViewElementStates.None)
                Loop Until oCurrentCol Is Nothing
                s = s.Substring(0, s.Length - 1)
                s &= Environment.NewLine
            Next    'Put to clipboard
            Dim o As New DataObject
            o.SetText(s)
            Clipboard.Clear()
            Clipboard.SetDataObject(o, True)
            'MessageBox.Show("Result successfully copied to clipboard!", _
            ' "Information", _
            ' MessageBoxButtons.OK, _
            ' MessageBoxIcon.Information, _
            ' MessageBoxDefaultButton.Button1)
        Catch ex As Exception
            MessageBox.Show("Error occured while copying: No data found in the grid!",
             "Error - No Data Found",
             MessageBoxButtons.OK,
             MessageBoxIcon.Error,
             MessageBoxDefaultButton.Button1)
        End Try

    End Sub

    Private Sub CopyToolStripMenuItem_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CopyToolStripMenuItem.Click
        Dim dataobj As New DataObject(DataGridView1.GetClipboardContent())
        Clipboard.SetDataObject(dataobj)
    End Sub
    'Sub FillActiveDirectoryTreeView(ByRef tvw As TreeView, ByVal TopLevelDirEntriesArray() As DirectoryEntry)

    '    Dim DirEntry As DirectoryEntry
    '    Dim Nd As TreeNode

    '    For Each DirEntry In TopLevelDirEntriesArray
    '        Nd = New TreeNode(DirEntry.Name)
    '        Nd.Tag = DirEntry
    '        tvw.Nodes.Add(Nd)
    '        FillADTreeNode(Nd)
    '    Next

    'End Sub
    'Sub FillADTreeNode(ByRef ADNode As TreeNode)
    '    Dim DirEntry As DirectoryEntry
    '    Dim MainEntry As DirectoryEntry = CType(ADNode.Tag, DirectoryEntry)
    '    Dim Nd As TreeNode

    '    For Each DirEntry In MainEntry.Children
    '        Nd = New TreeNode(DirEntry.Name)
    '        Nd.Tag = DirEntry
    '        ADNode.Nodes.Add(Nd)
    '        FillADTreeNode(Nd)
    '    Next

    'End Sub

    Sub SetUserAttributes()
        Dim attribute As String
        Dim attributes As New ArrayList
        attributes.Add("aCSPolicyName")
        attributes.Add("adminDescription")
        attributes.Add("adminDisplayName")
        attributes.Add("c")
        attributes.Add("canonicalName")
        attributes.Add("cn")
        attributes.Add("co")
        attributes.Add("comment")
        attributes.Add("company")
        attributes.Add("countryCode")
        attributes.Add("createTimeStamp")
        attributes.Add("department")
        attributes.Add("description")
        attributes.Add("displayName")
        attributes.Add("displayNamePrintable")
        attributes.Add("distinguishedName")
        attributes.Add("division")
        attributes.Add("employeeID")
        attributes.Add("extensionAttribute1")
        attributes.Add("extensionAttribute2")
        attributes.Add("extensionAttribute3")
        attributes.Add("extensionAttribute4")
        attributes.Add("extensionAttribute5")
        attributes.Add("extensionAttribute6")
        attributes.Add("extensionAttribute7")
        attributes.Add("extensionAttribute8")
        attributes.Add("extensionAttribute9")
        attributes.Add("extensionAttribute10")
        attributes.Add("extensionAttribute11")
        attributes.Add("extensionAttribute12")
        attributes.Add("extensionName")
        attributes.Add("givenName")
        attributes.Add("homeDirectory")
        attributes.Add("homeDrive")
        attributes.Add("homePhone")
        attributes.Add("homePostalAddress")
        attributes.Add("info")
        attributes.Add("initials")
        attributes.Add("ipPhone")
        attributes.Add("isDeleted")
        attributes.Add("l")
        attributes.Add("lastLogoff")
        attributes.Add("lastLogon")
        attributes.Add("lockoutTime")
        attributes.Add("logonCount")
        attributes.Add("logonWorkstation")
        attributes.Add("mail")
        attributes.Add("manager")
        attributes.Add("memberOf")
        attributes.Add("middleName")
        attributes.Add("mobile")
        attributes.Add("modifyTimeStamp")
        attributes.Add("o")
        attributes.Add("ou")
        attributes.Add("personalTitle")
        attributes.Add("physicalDeliveryOfficeName")
        attributes.Add("postalAddress")
        attributes.Add("postalCode")
        attributes.Add("postOfficeBox")
        attributes.Add("profilePath")
        attributes.Add("pwdLastSet")
        attributes.Add("revision")
        attributes.Add("sAMAccountName")
        attributes.Add("sAMAccountType")
        attributes.Add("scriptPath")
        attributes.Add("sn")
        attributes.Add("st")
        attributes.Add("street")
        attributes.Add("streetAddress")
        attributes.Add("telephoneNumber")
        attributes.Add("title")
        attributes.Add("url")
        attributes.Add("userAccountControl")
        attributes.Add("wbemPath")
        attributes.Add("whenChanged")
        attributes.Add("whenCreated")

        ComboBox0.Items.Clear()
        ComboBox1.Items.Clear()
        ComboBox2.Items.Clear()
        ComboBox3.Items.Clear()
        ComboBox4.Items.Clear()
        ComboBox5.Items.Clear()
        ComboBox6.Items.Clear()
        ComboBox7.Items.Clear()
        ComboBox8.Items.Clear()
        cbbSecondary.Items.Clear()

        For Each attribute In attributes
            ComboBox0.Items.Add(attribute)
            ComboBox1.Items.Add(attribute)
            ComboBox2.Items.Add(attribute)
            ComboBox3.Items.Add(attribute)
            ComboBox4.Items.Add(attribute)
            ComboBox5.Items.Add(attribute)
            ComboBox6.Items.Add(attribute)
            ComboBox7.Items.Add(attribute)
            ComboBox8.Items.Add(attribute)
            cbbSecondary.Items.Add(attribute)
        Next

        ComboBox0.SelectedIndex = -1
        ComboBox1.SelectedIndex = -1
        ComboBox2.SelectedIndex = -1
        ComboBox3.SelectedIndex = -1
        ComboBox4.SelectedIndex = -1
        ComboBox5.SelectedIndex = -1
        ComboBox6.SelectedIndex = -1
        ComboBox7.SelectedIndex = -1
        ComboBox8.SelectedIndex = -1
        cbbSecondary.SelectedIndex = -1

    End Sub
    Sub SetComputerAttributes()

        Dim attribute As String
        Dim attributes As New ArrayList
        attributes.Add("accountExpires")
        attributes.Add("aCSPolicyName")
        attributes.Add("adminDescription")
        attributes.Add("adminDisplayName")
        attributes.Add("c")
        attributes.Add("cn")
        attributes.Add("co")
        attributes.Add("comment")
        attributes.Add("company")
        attributes.Add("countryCode")
        attributes.Add("department")
        attributes.Add("description")
        attributes.Add("displayName")
        attributes.Add("displayNamePrintable")
        attributes.Add("distinguishedName")
        attributes.Add("division")
        attributes.Add("extensionAttribute1")
        attributes.Add("extensionAttribute2")
        attributes.Add("extensionAttribute3")
        attributes.Add("extensionAttribute4")
        attributes.Add("extensionAttribute5")
        attributes.Add("extensionAttribute6")
        attributes.Add("extensionAttribute7")
        attributes.Add("extensionAttribute8")
        attributes.Add("extensionAttribute9")
        attributes.Add("extensionAttribute10")
        attributes.Add("extensionAttribute11")
        attributes.Add("extensionAttribute12")
        attributes.Add("info")
        attributes.Add("ipHostNumber")
        attributes.Add("isDeleted")
        attributes.Add("lastLogonTimestamp")
        attributes.Add("location")
        attributes.Add("logonCount")
        attributes.Add("managedBy")
        attributes.Add("manager")
        attributes.Add("name")
        attributes.Add("networkAddress")
        attributes.Add("objectCategory")
        attributes.Add("objectGUID")
        attributes.Add("objectSid")
        attributes.Add("operatingSystem")
        attributes.Add("operatingSystemHotfix")
        attributes.Add("operatingSystemServicePack")
        attributes.Add("operatingSystemVersion")
        attributes.Add("ou")
        attributes.Add("pwdLastSet")
        attributes.Add("sAMAccountName")
        attributes.Add("sAMAccountType")
        attributes.Add("serialNumber")
        attributes.Add("sn")
        attributes.Add("userAccountControl")
        attributes.Add("whenChanged")
        attributes.Add("whenCreated")

        ComboBox0.Items.Clear()
        ComboBox1.Items.Clear()
        ComboBox2.Items.Clear()
        ComboBox3.Items.Clear()
        ComboBox4.Items.Clear()
        ComboBox5.Items.Clear()
        ComboBox6.Items.Clear()
        ComboBox7.Items.Clear()
        ComboBox8.Items.Clear()
        cbbSecondary.Items.Clear()

        For Each attribute In attributes
            ComboBox0.Items.Add(attribute)
            ComboBox1.Items.Add(attribute)
            ComboBox2.Items.Add(attribute)
            ComboBox3.Items.Add(attribute)
            ComboBox4.Items.Add(attribute)
            ComboBox5.Items.Add(attribute)
            ComboBox6.Items.Add(attribute)
            ComboBox7.Items.Add(attribute)
            ComboBox8.Items.Add(attribute)
            cbbSecondary.Items.Add(attribute)
        Next

        ComboBox0.SelectedIndex = -1
        ComboBox1.SelectedIndex = -1
        ComboBox2.SelectedIndex = -1
        ComboBox3.SelectedIndex = -1
        ComboBox4.SelectedIndex = -1
        ComboBox5.SelectedIndex = -1
        ComboBox6.SelectedIndex = -1
        ComboBox7.SelectedIndex = -1
        ComboBox8.SelectedIndex = -1
        cbbSecondary.SelectedIndex = -1

    End Sub

    Sub SetGroupAttributes()

        Dim attribute As String
        Dim attributes As New ArrayList
        attributes.Add("cn")
        attributes.Add("comment")
        attributes.Add("description")
        attributes.Add("displayName")
        attributes.Add("distinguishedName")
        attributes.Add("groupType")
        attributes.Add("info")
        attributes.Add("member")
        attributes.Add("managedBy")
        attributes.Add("name")
        attributes.Add("lastLogonTimestamp")
        attributes.Add("objectCategory")
        attributes.Add("objectClass")
        attributes.Add("objectGUID")
        attributes.Add("objectSid")
        attributes.Add("sAMAccountName")
        attributes.Add("sAMAccountType")
        attributes.Add("whenChanged")
        attributes.Add("whenCreated")

        ComboBox0.Items.Clear()
        ComboBox1.Items.Clear()
        ComboBox2.Items.Clear()
        ComboBox3.Items.Clear()
        ComboBox4.Items.Clear()
        ComboBox5.Items.Clear()
        ComboBox6.Items.Clear()
        ComboBox7.Items.Clear()
        ComboBox8.Items.Clear()
        cbbSecondary.Items.Clear()

        For Each attribute In attributes
            ComboBox0.Items.Add(attribute)
            ComboBox1.Items.Add(attribute)
            ComboBox2.Items.Add(attribute)
            ComboBox3.Items.Add(attribute)
            ComboBox4.Items.Add(attribute)
            ComboBox5.Items.Add(attribute)
            ComboBox6.Items.Add(attribute)
            ComboBox7.Items.Add(attribute)
            ComboBox8.Items.Add(attribute)
            cbbSecondary.Items.Add(attribute)
        Next

        ComboBox0.SelectedIndex = -1
        ComboBox1.SelectedIndex = -1
        ComboBox2.SelectedIndex = -1
        ComboBox3.SelectedIndex = -1
        ComboBox4.SelectedIndex = -1
        ComboBox5.SelectedIndex = -1
        ComboBox6.SelectedIndex = -1
        ComboBox7.SelectedIndex = -1
        ComboBox8.SelectedIndex = -1
        cbbSecondary.SelectedIndex = -1

    End Sub

    'CHECKBOXES
    Private Sub CheckBox0_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox0.CheckedChanged

        If CheckBox0.Checked Then
            ComboBox0.Enabled = True
        Else
            ComboBox0.Enabled = False
        End If

    End Sub
    Private Sub CheckBox1_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked Then
            ComboBox1.Enabled = True
        Else
            ComboBox1.Enabled = False
        End If
    End Sub
    Private Sub CheckBox2_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox2.CheckedChanged
        If CheckBox2.Checked Then
            ComboBox2.Enabled = True
        Else
            ComboBox2.Enabled = False
        End If
    End Sub
    Private Sub CheckBox3_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox3.CheckedChanged
        If CheckBox3.Checked Then
            ComboBox3.Enabled = True
        Else
            ComboBox3.Enabled = False
        End If
    End Sub
    Private Sub CheckBox4_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox4.CheckedChanged
        If CheckBox4.Checked Then
            ComboBox4.Enabled = True
        Else
            ComboBox4.Enabled = False
        End If
    End Sub
    Private Sub CheckBox5_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox5.CheckedChanged
        If CheckBox5.Checked Then
            ComboBox5.Enabled = True
        Else
            ComboBox5.Enabled = False
        End If
    End Sub
    Private Sub CheckBox6_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox6.CheckedChanged
        If CheckBox6.Checked Then
            ComboBox6.Enabled = True
        Else
            ComboBox6.Enabled = False
        End If
    End Sub
    Private Sub CheckBox7_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox7.CheckedChanged
        If CheckBox7.Checked Then
            ComboBox7.Enabled = True
        Else
            ComboBox7.Enabled = False
        End If
    End Sub
    Private Sub CheckBox8_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox8.CheckedChanged
        If CheckBox8.Checked Then

        Else

        End If
    End Sub

    Private Sub cbSecondary_CheckedChanged(sender As Object, e As EventArgs) Handles cbSecondary.CheckedChanged
        If cbSecondary.Checked Then
            cbbSecondary.Enabled = True
            tbSecondary.Enabled = True
        Else
            cbbSecondary.Enabled = False
            tbSecondary.Enabled = False
        End If
    End Sub

    Private Sub CheckBox10_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox10.CheckedChanged
        If CheckBox10.Checked Then
            ComboBox8.Enabled = True
        Else
            ComboBox8.Enabled = False
        End If
    End Sub
End Class
