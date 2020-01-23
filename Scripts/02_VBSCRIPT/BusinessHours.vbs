Set objUX = GetObject("winmgmts:\\.\root\ccm\ClientSDK:CCM_ClientUXSettings")

Set GBH = objUX.ExecMethod_("GetBusinessHours")

WScript.echo "Working days currently set to: " & GBH.WorkingDays


