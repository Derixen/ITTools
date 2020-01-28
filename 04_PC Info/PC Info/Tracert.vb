Public Class Tracert

    Private Sub RunTracert_Click(sender As Object, e As EventArgs) Handles RunTracert.Click
        Dim oProcess As New Process()
        Dim oStartInfo As New ProcessStartInfo("cmd.exe", "/C tracert " + TracertAddress.Text)
        oStartInfo.UseShellExecute = False
        oStartInfo.RedirectStandardOutput = True
        oStartInfo.WindowStyle = ProcessWindowStyle.Hidden
        oProcess.StartInfo = oStartInfo
        oProcess.Start()

        Dim sOutput As String
        Using oStreamReader As System.IO.StreamReader = oProcess.StandardOutput
            sOutput = oStreamReader.ReadToEnd()

        End Using

        TracertResult.AppendText(sOutput)
        TracertResult.AppendText("-------------------------------------------------------------")
        TracertResult.AppendText("")
    End Sub

    Private Sub TracertAddress_Click(sender As Object, e As EventArgs) Handles TracertAddress.Click
        TracertAddress.Text = ""
        TracertAddress.ForeColor = Color.Black
        TracertAddress.Font = New Font("", 12.0, FontStyle.Regular)
    End Sub

    Private Sub CloseTracert_Click(sender As Object, e As EventArgs) Handles CloseTracert.Click
        Me.Close()
    End Sub

    Private Sub CopyClipboardTracert_Click(sender As Object, e As EventArgs) Handles CopyClipboardTracert.Click
        Clipboard.Clear()
        Clipboard.SetText(TracertResult.Text)
    End Sub
End Class