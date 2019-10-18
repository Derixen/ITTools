<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Form1))
        Me.DataGridView1 = New System.Windows.Forms.DataGridView()
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.CopyToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.btnSaveReport = New System.Windows.Forms.Button()
        Me.btnOption = New System.Windows.Forms.Button()
        Me.txtBoxMulti = New System.Windows.Forms.TextBox()
        Me.btnMtoGridUser = New System.Windows.Forms.Button()
        Me.btnSearch = New System.Windows.Forms.Button()
        Me.lblProgressBar = New System.Windows.Forms.Label()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.CheckBox10 = New System.Windows.Forms.CheckBox()
        Me.ComboBox8 = New System.Windows.Forms.ComboBox()
        Me.ComboBox0 = New System.Windows.Forms.ComboBox()
        Me.CheckBox7 = New System.Windows.Forms.CheckBox()
        Me.ComboBox7 = New System.Windows.Forms.ComboBox()
        Me.CheckBox6 = New System.Windows.Forms.CheckBox()
        Me.ComboBox6 = New System.Windows.Forms.ComboBox()
        Me.CheckBox5 = New System.Windows.Forms.CheckBox()
        Me.ComboBox5 = New System.Windows.Forms.ComboBox()
        Me.CheckBox4 = New System.Windows.Forms.CheckBox()
        Me.ComboBox4 = New System.Windows.Forms.ComboBox()
        Me.CheckBox3 = New System.Windows.Forms.CheckBox()
        Me.ComboBox3 = New System.Windows.Forms.ComboBox()
        Me.CheckBox2 = New System.Windows.Forms.CheckBox()
        Me.ComboBox2 = New System.Windows.Forms.ComboBox()
        Me.CheckBox1 = New System.Windows.Forms.CheckBox()
        Me.ComboBox1 = New System.Windows.Forms.ComboBox()
        Me.CheckBox0 = New System.Windows.Forms.CheckBox()
        Me.CheckBox9 = New System.Windows.Forms.CheckBox()
        Me.CheckBox8 = New System.Windows.Forms.CheckBox()
        Me.rbtnUsers = New System.Windows.Forms.RadioButton()
        Me.rbtnComputers = New System.Windows.Forms.RadioButton()
        Me.rbtnGroups = New System.Windows.Forms.RadioButton()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.btnClear = New System.Windows.Forms.Button()
        Me.btnExit = New System.Windows.Forms.Button()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.btnCopy = New System.Windows.Forms.Button()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar()
        Me.tbSecondary = New System.Windows.Forms.TextBox()
        Me.cbbSecondary = New System.Windows.Forms.ComboBox()
        Me.GroupBox3 = New System.Windows.Forms.GroupBox()
        Me.cbSecondary = New System.Windows.Forms.CheckBox()
        Me.GroupBox4 = New System.Windows.Forms.GroupBox()
        Me.lblDomainText = New System.Windows.Forms.Label()
        Me.txtDomain = New System.Windows.Forms.TextBox()
        Me.GroupBox5 = New System.Windows.Forms.GroupBox()
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ContextMenuStrip1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        Me.GroupBox4.SuspendLayout()
        Me.GroupBox5.SuspendLayout()
        Me.SuspendLayout()
        '
        'DataGridView1
        '
        Me.DataGridView1.AllowUserToAddRows = False
        Me.DataGridView1.AllowUserToDeleteRows = False
        Me.DataGridView1.AllowUserToResizeRows = False
        Me.DataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.DataGridView1.ContextMenuStrip = Me.ContextMenuStrip1
        Me.DataGridView1.Location = New System.Drawing.Point(12, 356)
        Me.DataGridView1.Name = "DataGridView1"
        Me.DataGridView1.RowHeadersVisible = False
        Me.DataGridView1.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing
        Me.DataGridView1.Size = New System.Drawing.Size(556, 186)
        Me.DataGridView1.TabIndex = 1
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.CopyToolStripMenuItem})
        Me.ContextMenuStrip1.Name = "ContextMenuStrip1"
        Me.ContextMenuStrip1.Size = New System.Drawing.Size(103, 26)
        '
        'CopyToolStripMenuItem
        '
        Me.CopyToolStripMenuItem.Image = Global.AD_Query.My.Resources.Resources.copy
        Me.CopyToolStripMenuItem.Name = "CopyToolStripMenuItem"
        Me.CopyToolStripMenuItem.Size = New System.Drawing.Size(102, 22)
        Me.CopyToolStripMenuItem.Text = "Copy"
        '
        'btnSaveReport
        '
        Me.btnSaveReport.Enabled = False
        Me.btnSaveReport.Location = New System.Drawing.Point(247, 116)
        Me.btnSaveReport.Name = "btnSaveReport"
        Me.btnSaveReport.Size = New System.Drawing.Size(114, 23)
        Me.btnSaveReport.TabIndex = 2
        Me.btnSaveReport.Text = "Save Report"
        Me.btnSaveReport.UseVisualStyleBackColor = True
        '
        'btnOption
        '
        Me.btnOption.Enabled = False
        Me.btnOption.Location = New System.Drawing.Point(247, 145)
        Me.btnOption.Name = "btnOption"
        Me.btnOption.Size = New System.Drawing.Size(114, 23)
        Me.btnOption.TabIndex = 24
        Me.btnOption.Text = "Options / Help"
        Me.btnOption.UseVisualStyleBackColor = True
        '
        'txtBoxMulti
        '
        Me.txtBoxMulti.Location = New System.Drawing.Point(6, 19)
        Me.txtBoxMulti.MaxLength = 327670
        Me.txtBoxMulti.Multiline = True
        Me.txtBoxMulti.Name = "txtBoxMulti"
        Me.txtBoxMulti.Size = New System.Drawing.Size(219, 218)
        Me.txtBoxMulti.TabIndex = 23
        '
        'btnMtoGridUser
        '
        Me.btnMtoGridUser.Location = New System.Drawing.Point(-164, 258)
        Me.btnMtoGridUser.Name = "btnMtoGridUser"
        Me.btnMtoGridUser.Size = New System.Drawing.Size(113, 23)
        Me.btnMtoGridUser.TabIndex = 23
        Me.btnMtoGridUser.Text = "Search to Grid"
        Me.btnMtoGridUser.UseVisualStyleBackColor = True
        '
        'btnSearch
        '
        Me.btnSearch.Location = New System.Drawing.Point(247, 9)
        Me.btnSearch.Name = "btnSearch"
        Me.btnSearch.Size = New System.Drawing.Size(114, 72)
        Me.btnSearch.TabIndex = 12
        Me.btnSearch.Text = "Search"
        Me.btnSearch.UseVisualStyleBackColor = True
        '
        'lblProgressBar
        '
        Me.lblProgressBar.AutoSize = True
        Me.lblProgressBar.BackColor = System.Drawing.Color.Transparent
        Me.lblProgressBar.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(238, Byte))
        Me.lblProgressBar.Location = New System.Drawing.Point(373, 454)
        Me.lblProgressBar.Name = "lblProgressBar"
        Me.lblProgressBar.Size = New System.Drawing.Size(0, 13)
        Me.lblProgressBar.TabIndex = 11
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.CheckBox10)
        Me.GroupBox2.Controls.Add(Me.ComboBox8)
        Me.GroupBox2.Controls.Add(Me.ComboBox0)
        Me.GroupBox2.Controls.Add(Me.CheckBox7)
        Me.GroupBox2.Controls.Add(Me.ComboBox7)
        Me.GroupBox2.Controls.Add(Me.CheckBox6)
        Me.GroupBox2.Controls.Add(Me.ComboBox6)
        Me.GroupBox2.Controls.Add(Me.CheckBox5)
        Me.GroupBox2.Controls.Add(Me.ComboBox5)
        Me.GroupBox2.Controls.Add(Me.CheckBox4)
        Me.GroupBox2.Controls.Add(Me.ComboBox4)
        Me.GroupBox2.Controls.Add(Me.CheckBox3)
        Me.GroupBox2.Controls.Add(Me.ComboBox3)
        Me.GroupBox2.Controls.Add(Me.CheckBox2)
        Me.GroupBox2.Controls.Add(Me.ComboBox2)
        Me.GroupBox2.Controls.Add(Me.CheckBox1)
        Me.GroupBox2.Controls.Add(Me.ComboBox1)
        Me.GroupBox2.Controls.Add(Me.CheckBox0)
        Me.GroupBox2.Controls.Add(Me.btnMtoGridUser)
        Me.GroupBox2.Location = New System.Drawing.Point(370, 9)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(198, 271)
        Me.GroupBox2.TabIndex = 22
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Column Select"
        '
        'CheckBox10
        '
        Me.CheckBox10.AutoSize = True
        Me.CheckBox10.Location = New System.Drawing.Point(4, 240)
        Me.CheckBox10.Name = "CheckBox10"
        Me.CheckBox10.Size = New System.Drawing.Size(15, 14)
        Me.CheckBox10.TabIndex = 49
        Me.CheckBox10.UseVisualStyleBackColor = True
        '
        'ComboBox8
        '
        Me.ComboBox8.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox8.Enabled = False
        Me.ComboBox8.FormattingEnabled = True
        Me.ComboBox8.Location = New System.Drawing.Point(25, 237)
        Me.ComboBox8.Name = "ComboBox8"
        Me.ComboBox8.Size = New System.Drawing.Size(164, 21)
        Me.ComboBox8.TabIndex = 48
        '
        'ComboBox0
        '
        Me.ComboBox0.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox0.Enabled = False
        Me.ComboBox0.FormattingEnabled = True
        Me.ComboBox0.Location = New System.Drawing.Point(25, 21)
        Me.ComboBox0.Name = "ComboBox0"
        Me.ComboBox0.Size = New System.Drawing.Size(164, 21)
        Me.ComboBox0.TabIndex = 45
        '
        'CheckBox7
        '
        Me.CheckBox7.AutoSize = True
        Me.CheckBox7.Location = New System.Drawing.Point(4, 213)
        Me.CheckBox7.Name = "CheckBox7"
        Me.CheckBox7.Size = New System.Drawing.Size(15, 14)
        Me.CheckBox7.TabIndex = 42
        Me.CheckBox7.UseVisualStyleBackColor = True
        '
        'ComboBox7
        '
        Me.ComboBox7.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox7.Enabled = False
        Me.ComboBox7.FormattingEnabled = True
        Me.ComboBox7.Location = New System.Drawing.Point(25, 210)
        Me.ComboBox7.Name = "ComboBox7"
        Me.ComboBox7.Size = New System.Drawing.Size(164, 21)
        Me.ComboBox7.TabIndex = 41
        '
        'CheckBox6
        '
        Me.CheckBox6.AutoSize = True
        Me.CheckBox6.Location = New System.Drawing.Point(4, 186)
        Me.CheckBox6.Name = "CheckBox6"
        Me.CheckBox6.Size = New System.Drawing.Size(15, 14)
        Me.CheckBox6.TabIndex = 40
        Me.CheckBox6.UseVisualStyleBackColor = True
        '
        'ComboBox6
        '
        Me.ComboBox6.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox6.Enabled = False
        Me.ComboBox6.FormattingEnabled = True
        Me.ComboBox6.Location = New System.Drawing.Point(25, 183)
        Me.ComboBox6.Name = "ComboBox6"
        Me.ComboBox6.Size = New System.Drawing.Size(164, 21)
        Me.ComboBox6.TabIndex = 39
        '
        'CheckBox5
        '
        Me.CheckBox5.AutoSize = True
        Me.CheckBox5.Location = New System.Drawing.Point(4, 159)
        Me.CheckBox5.Name = "CheckBox5"
        Me.CheckBox5.Size = New System.Drawing.Size(15, 14)
        Me.CheckBox5.TabIndex = 38
        Me.CheckBox5.UseVisualStyleBackColor = True
        '
        'ComboBox5
        '
        Me.ComboBox5.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox5.Enabled = False
        Me.ComboBox5.FormattingEnabled = True
        Me.ComboBox5.Location = New System.Drawing.Point(25, 156)
        Me.ComboBox5.Name = "ComboBox5"
        Me.ComboBox5.Size = New System.Drawing.Size(164, 21)
        Me.ComboBox5.TabIndex = 37
        '
        'CheckBox4
        '
        Me.CheckBox4.AutoSize = True
        Me.CheckBox4.Location = New System.Drawing.Point(4, 132)
        Me.CheckBox4.Name = "CheckBox4"
        Me.CheckBox4.Size = New System.Drawing.Size(15, 14)
        Me.CheckBox4.TabIndex = 36
        Me.CheckBox4.UseVisualStyleBackColor = True
        '
        'ComboBox4
        '
        Me.ComboBox4.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox4.Enabled = False
        Me.ComboBox4.FormattingEnabled = True
        Me.ComboBox4.Location = New System.Drawing.Point(25, 129)
        Me.ComboBox4.Name = "ComboBox4"
        Me.ComboBox4.Size = New System.Drawing.Size(164, 21)
        Me.ComboBox4.TabIndex = 35
        '
        'CheckBox3
        '
        Me.CheckBox3.AutoSize = True
        Me.CheckBox3.Location = New System.Drawing.Point(4, 105)
        Me.CheckBox3.Name = "CheckBox3"
        Me.CheckBox3.Size = New System.Drawing.Size(15, 14)
        Me.CheckBox3.TabIndex = 34
        Me.CheckBox3.UseVisualStyleBackColor = True
        '
        'ComboBox3
        '
        Me.ComboBox3.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox3.Enabled = False
        Me.ComboBox3.FormattingEnabled = True
        Me.ComboBox3.Location = New System.Drawing.Point(25, 102)
        Me.ComboBox3.Name = "ComboBox3"
        Me.ComboBox3.Size = New System.Drawing.Size(164, 21)
        Me.ComboBox3.TabIndex = 33
        '
        'CheckBox2
        '
        Me.CheckBox2.AutoSize = True
        Me.CheckBox2.Location = New System.Drawing.Point(4, 78)
        Me.CheckBox2.Name = "CheckBox2"
        Me.CheckBox2.Size = New System.Drawing.Size(15, 14)
        Me.CheckBox2.TabIndex = 32
        Me.CheckBox2.UseVisualStyleBackColor = True
        '
        'ComboBox2
        '
        Me.ComboBox2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox2.Enabled = False
        Me.ComboBox2.FormattingEnabled = True
        Me.ComboBox2.Location = New System.Drawing.Point(25, 75)
        Me.ComboBox2.Name = "ComboBox2"
        Me.ComboBox2.Size = New System.Drawing.Size(164, 21)
        Me.ComboBox2.TabIndex = 31
        '
        'CheckBox1
        '
        Me.CheckBox1.AutoSize = True
        Me.CheckBox1.Location = New System.Drawing.Point(4, 51)
        Me.CheckBox1.Name = "CheckBox1"
        Me.CheckBox1.Size = New System.Drawing.Size(15, 14)
        Me.CheckBox1.TabIndex = 30
        Me.CheckBox1.UseVisualStyleBackColor = True
        '
        'ComboBox1
        '
        Me.ComboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ComboBox1.Enabled = False
        Me.ComboBox1.FormattingEnabled = True
        Me.ComboBox1.Location = New System.Drawing.Point(25, 48)
        Me.ComboBox1.Name = "ComboBox1"
        Me.ComboBox1.Size = New System.Drawing.Size(164, 21)
        Me.ComboBox1.TabIndex = 29
        '
        'CheckBox0
        '
        Me.CheckBox0.AutoSize = True
        Me.CheckBox0.Location = New System.Drawing.Point(4, 24)
        Me.CheckBox0.Name = "CheckBox0"
        Me.CheckBox0.Size = New System.Drawing.Size(15, 14)
        Me.CheckBox0.TabIndex = 28
        Me.CheckBox0.UseVisualStyleBackColor = True
        '
        'CheckBox9
        '
        Me.CheckBox9.AutoSize = True
        Me.CheckBox9.Location = New System.Drawing.Point(4, 19)
        Me.CheckBox9.Name = "CheckBox9"
        Me.CheckBox9.Size = New System.Drawing.Size(75, 17)
        Me.CheckBox9.TabIndex = 47
        Me.CheckBox9.Text = "MemberOf"
        Me.CheckBox9.UseVisualStyleBackColor = True
        '
        'CheckBox8
        '
        Me.CheckBox8.AutoSize = True
        Me.CheckBox8.Enabled = False
        Me.CheckBox8.Location = New System.Drawing.Point(110, 19)
        Me.CheckBox8.Name = "CheckBox8"
        Me.CheckBox8.Size = New System.Drawing.Size(69, 17)
        Me.CheckBox8.TabIndex = 44
        Me.CheckBox8.Text = "Members"
        Me.CheckBox8.UseVisualStyleBackColor = True
        '
        'rbtnUsers
        '
        Me.rbtnUsers.AutoSize = True
        Me.rbtnUsers.Checked = True
        Me.rbtnUsers.Location = New System.Drawing.Point(6, 19)
        Me.rbtnUsers.Name = "rbtnUsers"
        Me.rbtnUsers.Size = New System.Drawing.Size(52, 17)
        Me.rbtnUsers.TabIndex = 25
        Me.rbtnUsers.TabStop = True
        Me.rbtnUsers.Text = "Users"
        Me.rbtnUsers.UseVisualStyleBackColor = True
        '
        'rbtnComputers
        '
        Me.rbtnComputers.AutoSize = True
        Me.rbtnComputers.Location = New System.Drawing.Point(6, 35)
        Me.rbtnComputers.Name = "rbtnComputers"
        Me.rbtnComputers.Size = New System.Drawing.Size(75, 17)
        Me.rbtnComputers.TabIndex = 26
        Me.rbtnComputers.Text = "Computers"
        Me.rbtnComputers.UseVisualStyleBackColor = True
        '
        'rbtnGroups
        '
        Me.rbtnGroups.AutoSize = True
        Me.rbtnGroups.Location = New System.Drawing.Point(6, 51)
        Me.rbtnGroups.Name = "rbtnGroups"
        Me.rbtnGroups.Size = New System.Drawing.Size(59, 17)
        Me.rbtnGroups.TabIndex = 27
        Me.rbtnGroups.Text = "Groups"
        Me.rbtnGroups.UseVisualStyleBackColor = True
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.rbtnUsers)
        Me.GroupBox1.Controls.Add(Me.rbtnGroups)
        Me.GroupBox1.Controls.Add(Me.rbtnComputers)
        Me.GroupBox1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(238, Byte))
        Me.GroupBox1.Location = New System.Drawing.Point(247, 203)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(113, 77)
        Me.GroupBox1.TabIndex = 28
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Search Scope"
        '
        'btnClear
        '
        Me.btnClear.Location = New System.Drawing.Point(247, 87)
        Me.btnClear.Name = "btnClear"
        Me.btnClear.Size = New System.Drawing.Size(114, 23)
        Me.btnClear.TabIndex = 31
        Me.btnClear.Text = "Clear"
        Me.btnClear.UseVisualStyleBackColor = True
        '
        'btnExit
        '
        Me.btnExit.Location = New System.Drawing.Point(247, 174)
        Me.btnExit.Name = "btnExit"
        Me.btnExit.Size = New System.Drawing.Size(114, 23)
        Me.btnExit.TabIndex = 33
        Me.btnExit.Text = "Exit"
        Me.btnExit.UseVisualStyleBackColor = True
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.BackColor = System.Drawing.Color.Transparent
        Me.Label4.ForeColor = System.Drawing.SystemColors.ActiveCaptionText
        Me.Label4.Location = New System.Drawing.Point(96, 554)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(39, 13)
        Me.Label4.TabIndex = 34
        Me.Label4.Text = "Label4"
        '
        'btnCopy
        '
        Me.btnCopy.Location = New System.Drawing.Point(232, 548)
        Me.btnCopy.Name = "btnCopy"
        Me.btnCopy.Size = New System.Drawing.Size(336, 24)
        Me.btnCopy.TabIndex = 35
        Me.btnCopy.Text = "Copy result to Clipboard (with header)"
        Me.btnCopy.UseVisualStyleBackColor = True
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.Location = New System.Drawing.Point(12, 554)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(60, 13)
        Me.Label5.TabIndex = 36
        Me.Label5.Text = "STATUS:"
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Location = New System.Drawing.Point(12, 340)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(556, 10)
        Me.ProgressBar1.TabIndex = 37
        '
        'tbSecondary
        '
        Me.tbSecondary.Enabled = False
        Me.tbSecondary.Location = New System.Drawing.Point(161, 17)
        Me.tbSecondary.Name = "tbSecondary"
        Me.tbSecondary.Size = New System.Drawing.Size(184, 20)
        Me.tbSecondary.TabIndex = 41
        '
        'cbbSecondary
        '
        Me.cbbSecondary.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cbbSecondary.Enabled = False
        Me.cbbSecondary.FormattingEnabled = True
        Me.cbbSecondary.Location = New System.Drawing.Point(27, 17)
        Me.cbbSecondary.Name = "cbbSecondary"
        Me.cbbSecondary.Size = New System.Drawing.Size(128, 21)
        Me.cbbSecondary.TabIndex = 42
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.cbSecondary)
        Me.GroupBox3.Controls.Add(Me.cbbSecondary)
        Me.GroupBox3.Controls.Add(Me.tbSecondary)
        Me.GroupBox3.Location = New System.Drawing.Point(10, 286)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(351, 48)
        Me.GroupBox3.TabIndex = 43
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Secondary Filter"
        '
        'cbSecondary
        '
        Me.cbSecondary.AutoSize = True
        Me.cbSecondary.Location = New System.Drawing.Point(6, 20)
        Me.cbSecondary.Name = "cbSecondary"
        Me.cbSecondary.Size = New System.Drawing.Size(15, 14)
        Me.cbSecondary.TabIndex = 43
        Me.cbSecondary.UseVisualStyleBackColor = True
        '
        'GroupBox4
        '
        Me.GroupBox4.Controls.Add(Me.CheckBox9)
        Me.GroupBox4.Controls.Add(Me.CheckBox8)
        Me.GroupBox4.Location = New System.Drawing.Point(370, 286)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.Size = New System.Drawing.Size(198, 48)
        Me.GroupBox4.TabIndex = 44
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "Membership Search"
        '
        'lblDomainText
        '
        Me.lblDomainText.AutoSize = True
        Me.lblDomainText.Location = New System.Drawing.Point(13, 11)
        Me.lblDomainText.Name = "lblDomainText"
        Me.lblDomainText.Size = New System.Drawing.Size(49, 13)
        Me.lblDomainText.TabIndex = 45
        Me.lblDomainText.Text = "Domain: "
        '
        'txtDomain
        '
        Me.txtDomain.Location = New System.Drawing.Point(58, 8)
        Me.txtDomain.Name = "txtDomain"
        Me.txtDomain.Size = New System.Drawing.Size(183, 20)
        Me.txtDomain.TabIndex = 46
        '
        'GroupBox5
        '
        Me.GroupBox5.Controls.Add(Me.txtBoxMulti)
        Me.GroupBox5.Location = New System.Drawing.Point(10, 34)
        Me.GroupBox5.Name = "GroupBox5"
        Me.GroupBox5.Size = New System.Drawing.Size(231, 246)
        Me.GroupBox5.TabIndex = 47
        Me.GroupBox5.TabStop = False
        Me.GroupBox5.Text = "Search"
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(583, 576)
        Me.Controls.Add(Me.GroupBox5)
        Me.Controls.Add(Me.txtDomain)
        Me.Controls.Add(Me.lblDomainText)
        Me.Controls.Add(Me.GroupBox4)
        Me.Controls.Add(Me.GroupBox3)
        Me.Controls.Add(Me.ProgressBar1)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.btnCopy)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.btnExit)
        Me.Controls.Add(Me.btnClear)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.btnOption)
        Me.Controls.Add(Me.btnSearch)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.lblProgressBar)
        Me.Controls.Add(Me.btnSaveReport)
        Me.Controls.Add(Me.DataGridView1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.Name = "Form1"
        Me.Text = "UADST - Ultimate Active Directory Search Tool"
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        Me.GroupBox4.ResumeLayout(False)
        Me.GroupBox4.PerformLayout()
        Me.GroupBox5.ResumeLayout(False)
        Me.GroupBox5.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents DataGridView1 As System.Windows.Forms.DataGridView
    Friend WithEvents btnSaveReport As System.Windows.Forms.Button
    Friend WithEvents lblProgressBar As System.Windows.Forms.Label
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents txtBoxMulti As System.Windows.Forms.TextBox
    Friend WithEvents btnOption As System.Windows.Forms.Button
    Friend WithEvents btnMtoGridUser As System.Windows.Forms.Button
    Friend WithEvents btnSearch As System.Windows.Forms.Button
    Friend WithEvents rbtnUsers As System.Windows.Forms.RadioButton
    Friend WithEvents rbtnComputers As System.Windows.Forms.RadioButton
    Friend WithEvents rbtnGroups As System.Windows.Forms.RadioButton
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents btnClear As System.Windows.Forms.Button
    Friend WithEvents btnExit As System.Windows.Forms.Button
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents btnCopy As System.Windows.Forms.Button
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents ContextMenuStrip1 As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents CopyToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CheckBox0 As System.Windows.Forms.CheckBox
    Friend WithEvents ComboBox0 As System.Windows.Forms.ComboBox
    Friend WithEvents CheckBox8 As System.Windows.Forms.CheckBox
    Friend WithEvents CheckBox7 As System.Windows.Forms.CheckBox
    Friend WithEvents ComboBox7 As System.Windows.Forms.ComboBox
    Friend WithEvents CheckBox6 As System.Windows.Forms.CheckBox
    Friend WithEvents ComboBox6 As System.Windows.Forms.ComboBox
    Friend WithEvents CheckBox5 As System.Windows.Forms.CheckBox
    Friend WithEvents ComboBox5 As System.Windows.Forms.ComboBox
    Friend WithEvents CheckBox4 As System.Windows.Forms.CheckBox
    Friend WithEvents ComboBox4 As System.Windows.Forms.ComboBox
    Friend WithEvents CheckBox3 As System.Windows.Forms.CheckBox
    Friend WithEvents ComboBox3 As System.Windows.Forms.ComboBox
    Friend WithEvents CheckBox2 As System.Windows.Forms.CheckBox
    Friend WithEvents ComboBox2 As System.Windows.Forms.ComboBox
    Friend WithEvents CheckBox1 As System.Windows.Forms.CheckBox
    Friend WithEvents ComboBox1 As System.Windows.Forms.ComboBox
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents CheckBox9 As CheckBox
    Friend WithEvents tbSecondary As TextBox
    Friend WithEvents cbbSecondary As ComboBox
    Friend WithEvents GroupBox3 As GroupBox
    Friend WithEvents cbSecondary As CheckBox
    Friend WithEvents CheckBox10 As CheckBox
    Friend WithEvents ComboBox8 As ComboBox
    Friend WithEvents GroupBox4 As GroupBox
    Friend WithEvents lblDomainText As Label
    Friend WithEvents txtDomain As TextBox
    Friend WithEvents GroupBox5 As GroupBox
End Class
