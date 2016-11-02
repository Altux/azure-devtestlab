$url = "https://raw.githubusercontent.com/Altux/azure-devtestlab/master/Artifacts/Windows-Upload-script-start-layout/Set-StartLayout-ESCP.ps1" 
$path = "C:\Packages\Scripts\Set-StartLayout-ESCP.ps1"

New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)    
$client = new-object System.Net.WebClient 
$client.DownloadFile($url, $path)

$RunOnce ="HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"

Set-itemProperty -Path $RunOnce -Name "StartLayout" -Value "powershell.exe -executionpolicy bypass -File C:\Packages\Scripts\Set-StartLayout-ESCP.ps1 -WindowStyle Hidden"
