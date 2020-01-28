Imports System.Threading

Public Class Ping

    Private trd As Thread

    Private Sub Ping_Load(sender As Object, e As EventArgs) Handles MyBase.Load

    End Sub


    Private Sub ClosePing_Click(sender As Object, e As EventArgs) Handles ClosePing.Click
        Me.Close()
    End Sub

    Private Sub ReRunPing_Click(sender As Object, e As EventArgs) Handles ReRunPing.Click

        Dim oProcess As New Process()
        Dim oStartInfo As New ProcessStartInfo("cmd.exe", "/C ping " + PingAddress.Text)
        oStartInfo.UseShellExecute = False
        oStartInfo.RedirectStandardOutput = True
        oStartInfo.WindowStyle = ProcessWindowStyle.Hidden
        oProcess.StartInfo = oStartInfo
        oProcess.Start()

        Dim sOutput As String
        Using oStreamReader As System.IO.StreamReader = oProcess.StandardOutput
            sOutput = oStreamReader.ReadToEnd()

        End Using

        PingResult.AppendText(sOutput)
        PingResult.AppendText("-------------------------------------------------------------")
        PingResult.AppendText("")

    End Sub


    Private Sub CopyClipboardPing_Click(sender As Object, e As EventArgs) Handles CopyClipboardPing.Click
        Clipboard.Clear()
        Clipboard.SetText(PingResult.Text)
    End Sub

    Private Sub PingAddress_Click(sender As Object, e As EventArgs) Handles PingAddress.Click
        PingAddress.Text = ""
        PingAddress.ForeColor = Color.Black
    End Sub

End Class