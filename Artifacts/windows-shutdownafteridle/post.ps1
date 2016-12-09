copy "./windows-shutdownIdle90min.ps1" "C:\windows-shutdownIdle90min.ps1"

$U = "SYSTEM"
$A = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -argument "-windowstyle hidden -executionpolicy Unrestricted  C:\windows-shutdownIdle90min.ps1"
$T = New-ScheduledTaskTrigger -AtStartup 
$S = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$P = New-ScheduledTaskPrincipal -RunLevel Highest -UserId SYSTEM
$D = New-ScheduledTask -Action $A -Trigger $T -Settings $S -Principal $P
Register-ScheduledTask T3 -InputObject $D -User $U