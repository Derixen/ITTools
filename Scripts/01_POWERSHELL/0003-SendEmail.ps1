$mail_from = "abc@example.com"
$mail_to = "def@example.com"
#$mailsd = ""
$mailsmtp = "exchange.example.com"
$mail_body = "This is a test mail"

Send-MailMessage -To $mail_to -From $mail_from -Subject "Test mail" -Body $mail_body -SmtpServer $mailsmtp #-Attachments $output
