$url = "" 
$path = "C:\Packages\Scripts\windows-shutdown-popup.ps1"

New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)    
$client = new-object System.Net.WebClient 
$client.DownloadFile($url, $path)

$A = New-ScheduledTaskAction –Execute "powershell.exe" -argument "C:\Packages\Scripts\windows-shutdown-popup.ps1"
$T = New-ScheduledTaskTrigger -AtLogon
$D = New-ScheduledTask -Action $A -Trigger $T
Register-ScheduledTask T1 -InputObject $D