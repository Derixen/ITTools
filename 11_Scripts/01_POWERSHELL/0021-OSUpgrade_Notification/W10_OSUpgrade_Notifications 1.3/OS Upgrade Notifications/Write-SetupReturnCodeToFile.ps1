# Saves the _SMSTSOSUpgradeActionReturnCode TS variable value to local file

# Set variables
$SaveToRoot = "$env:SystemDrive"
$SaveToDirectory = "temp"
$SaveToLocation = "$SaveToRoot\$SaveToDirectory\"
$FileName = "_SMSTSOSUpgradeActionReturnCode.txt"

# Create the temp directory if doesn't exist
If (!(Test-Path $SaveToLocation))
{
    $null = New-Item -Path $SaveToRoot\ -Name $SaveToDirectory -ItemType "directory" -Force
}

# Write the return code to file
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$Value = $tsenv.Value("_SMSTSOSUpgradeActionReturnCode")
$Value | Out-File -FilePath "$SaveToLocation\$FileName" -Force