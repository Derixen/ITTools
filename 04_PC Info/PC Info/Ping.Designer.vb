<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Ping
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(Ping))
        Me.PingResult = New System.Windows.Forms.TextBox()
        Me.ReRunPing = New System.Windows.Forms.Button()
        Me.ClosePing = New System.Windows.Forms.Button()
        Me.CopyClipboardPing = New System.Windows.Forms.Button()
        Me.PingAddress = New System.Windows.Forms.TextBox()
        Me.SuspendLayout()
        '
        'PingResult
        '
        Me.PingResult.BackColor = System.Drawing.SystemColors.Menu
        Me.PingResult.CharacterCasing = System.Windows.Forms.CharacterCasing.Lower
        Me.PingResult.Location = New System.Drawing.Point(12, 44)
        Me.PingResult.Multiline = True
        Me.PingResult.Name = "PingResult"
        Me.PingResult.ReadOnly = True
        Me.PingResult.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.PingResult.Size = New System.Drawing.Size(364, 205)
        Me.PingResult.TabIndex = 8
        Me.PingResult.WordWrap = False
        '
        'ReRunPing
        '
        Me.ReRunPing.Image = Global.PC_Info.My.Resources.Resources.run5
        Me.ReRunPing.Location = New System.Drawing.Point(286, 12)
        Me.ReRunPing.Name = "ReRunPing"
        Me.ReRunPing.Size = New System.Drawing.Size(90, 26)
        Me.ReRunPing.TabIndex = 6
        Me.ReRunPing.Text = "PING"
        Me.ReRunPing.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.ReRunPing.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageBeforeText
        Me.ReRunPing.UseVisualStyleBackColor = True
        '
        'ClosePing
        '
        Me.ClosePing.Image = Global.PC_Info.My.Resources.Resources._305_Close_24x24_72
        Me.ClosePing.Location = New System.Drawing.Point(286, 255)
        Me.ClosePing.Name = "ClosePing"
        Me.ClosePing.Size = New System.Drawing.Size(90, 45)
        Me.ClosePing.TabIndex = 4
        Me.ClosePing.Text = "CLOSE"
        Me.ClosePing.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.ClosePing.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageBeforeText
        Me.ClosePing.UseVisualStyleBackColor = True
        '
        'CopyClipboardPing
        '
        Me.CopyClipboardPing.Image = Global.PC_Info.My.Resources.Resources.ClipBoard
        Me.CopyClipboardPing.Location = New System.Drawing.Point(12, 255)
        Me.CopyClipboardPing.Name = "CopyClipboardPing"
        Me.CopyClipboardPing.Size = New System.Drawing.Size(268, 45)
        Me.CopyClipboardPing.TabIndex = 3
        Me.CopyClipboardPing.Text = "COPY TO CLIPBOARD"
        Me.CopyClipboardPing.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.CopyClipboardPing.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageBeforeText
        Me.CopyClipboardPing.UseVisualStyleBackColor = True
        '
        'PingAddress
        '
        Me.PingAddress.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(238, Byte))
        Me.PingAddress.ForeColor = System.Drawing.SystemColors.ScrollBar
        Me.PingAddress.Location = New System.Drawing.Point(12, 12)
        Me.PingAddress.Name = "PingAddress"
        Me.PingAddress.Size = New System.Drawing.Size(268, 26)
        Me.PingAddress.TabIndex = 9
        Me.PingAddress.Text = "<Ping Address>"
        '
        'Ping
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(388, 312)
        Me.Controls.Add(Me.PingAddress)
        Me.Controls.Add(Me.PingResult)
        Me.Controls.Add(Me.ReRunPing)
        Me.Controls.Add(Me.ClosePing)
        Me.Controls.Add(Me.CopyClipboardPing)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.Name = "Ping"
        Me.Text = "Ping Tool"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ClosePing As System.Windows.Forms.Button
    Friend WithEvents CopyClipboardPing As System.Windows.Forms.Button
    Friend WithEvents ReRunPing As System.Windows.Forms.Button
    Friend WithEvents PingResult As System.Windows.Forms.TextBox
    Friend WithEvents PingAddress As TextBox
End Class
