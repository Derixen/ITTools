$ol = New-Object -ComObject Outlook.Application
$ns = $ol.GetNamespace('mapi')
$ns.Accounts.Session.DefaultStore.DisplayName
$ns.Accounts|select DisplayName,Username,SMTPAddress