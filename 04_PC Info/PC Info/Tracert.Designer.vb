<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Tracert
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
        Me.TracertResult = New System.Windows.Forms.TextBox()
        Me.TracertAddress = New System.Windows.Forms.TextBox()
        Me.RunTracert = New System.Windows.Forms.Button()
        Me.CloseTracert = New System.Windows.Forms.Button()
        Me.CopyClipboardTracert = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'TracertResult
        '
        Me.TracertResult.BackColor = System.Drawing.SystemColors.Menu
        Me.TracertResult.CharacterCasing = System.Windows.Forms.CharacterCasing.Lower
        Me.TracertResult.Location = New System.Drawing.Point(12, 44)
        Me.TracertResult.Multiline = True
        Me.TracertResult.Name = "TracertResult"
        Me.TracertResult.ReadOnly = True
        Me.TracertResult.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.TracertResult.Size = New System.Drawing.Size(364, 205)
        Me.TracertResult.TabIndex = 13
        Me.TracertResult.WordWrap = False
        '
        'TracertAddress
        '
        Me.TracertAddress.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.TracertAddress.ForeColor = System.Drawing.SystemColors.ScrollBar
        Me.TracertAddress.Location = New System.Drawing.Point(12, 12)
        Me.TracertAddress.Name = "TracertAddress"
        Me.TracertAddress.Size = New System.Drawing.Size(268, 26)
        Me.TracertAddress.TabIndex = 12
        Me.TracertAddress.Text = "<Tracert Address>"
        '
        'RunTracert
        '
        Me.RunTracert.Image = Global.PC_Info.My.Resources.Resources.run5
        Me.RunTracert.Location = New System.Drawing.Point(286, 12)
        Me.RunTracert.Name = "RunTracert"
        Me.RunTracert.Size = New System.Drawing.Size(90, 26)
        Me.RunTracert.TabIndex = 11
        Me.RunTracert.Text = "TRACERT"
        Me.RunTracert.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.RunTracert.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageBeforeText
        Me.RunTracert.UseVisualStyleBackColor = True
        '
        'CloseTracert
        '
        Me.CloseTracert.Image = Global.PC_Info.My.Resources.Resources._305_Close_24x24_72
        Me.CloseTracert.Location = New System.Drawing.Point(286, 255)
        Me.CloseTracert.Name = "CloseTracert"
        Me.CloseTracert.Size = New System.Drawing.Size(90, 45)
        Me.CloseTracert.TabIndex = 10
        Me.CloseTracert.Text = "CLOSE"
        Me.CloseTracert.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.CloseTracert.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageBeforeText
        Me.CloseTracert.UseVisualStyleBackColor = True
        '
        'CopyClipboardTracert
        '
        Me.CopyClipboardTracert.Image = Global.PC_Info.My.Resources.Resources.ClipBoard
        Me.CopyClipboardTracert.Location = New System.Drawing.Point(12, 255)
        Me.CopyClipboardTracert.Name = "CopyClipboardTracert"
        Me.CopyClipboardTracert.Size = New System.Drawing.Size(268, 45)
        Me.CopyClipboardTracert.TabIndex = 9
        Me.CopyClipboardTracert.Text = "COPY TO CLIPBOARD"
        Me.CopyClipboardTracert.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.CopyClipboardTracert.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageBeforeText
        Me.CopyClipboardTracert.UseVisualStyleBackColor = True
        '
        'Tracert
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(389, 312)
        Me.Controls.Add(Me.TracertResult)
        Me.Controls.Add(Me.TracertAddress)
        Me.Controls.Add(Me.RunTracert)
        Me.Controls.Add(Me.CloseTracert)
        Me.Controls.Add(Me.CopyClipboardTracert)
        Me.MaximizeBox = False
        Me.Name = "Tracert"
        Me.Text = "Tracert"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents TracertResult As System.Windows.Forms.TextBox
    Friend WithEvents TracertAddress As System.Windows.Forms.TextBox
    Friend WithEvents RunTracert As System.Windows.Forms.Button
    Friend WithEvents CloseTracert As System.Windows.Forms.Button
    Friend WithEvents CopyClipboardTracert As System.Windows.Forms.Button
End Class
