copy "./windows-shutdownIdle90min.ps1" "windows-shutdownIdle90min.ps1"

$U = "SYSTEM"
$A = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -argument "-noninteractive -noprofile -command '&{C:\windows-shutdownIdle90min.ps1}'"
$T = New-ScheduledTaskTrigger -AtStartup
$D = New-ScheduledTask -Action $A -Trigger $T
Register-ScheduledTask T3 -InputObject $D -User $U


