rm c:\programdata\Exaduo\quota\*
copy "./Windows-quota.ps1" "c:\programdata\Exaduo\quota\Windows-quota.ps1"

$U = "SYSTEM"
$A = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -argument "-windowstyle hidden -executionpolicy Unrestricted  C:\ProgramData\Exaduo\ShutdownLogOff\windows-shutdownlogoff.ps1"
$T = New-ScheduledTaskTrigger -AtStartup 
$S = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$P = New-ScheduledTaskPrincipal -RunLevel Highest -UserId SYSTEM
$D = New-ScheduledTask -Action $A -Trigger $T -Settings $S -Principal $P
Register-ScheduledTask T2 -InputObject $D -User $U