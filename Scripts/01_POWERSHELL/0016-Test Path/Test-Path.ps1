$WorkDir = "C:\Windows\Temp\_Test"
If(!(test-path $WorkDir )) { New-Item -ItemType Directory -Force -Path $WorkDir }