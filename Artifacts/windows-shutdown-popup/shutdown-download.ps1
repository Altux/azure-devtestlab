copy "./windows-shutdown-popup.ps1" "C:\windows-shutdown-popup.ps1"

$U = "Administrateur"
$A = New-ScheduledTaskAction -Execute "powershell.exe" -argument "C:\windows-shutdown-popup.ps1"
$T = New-ScheduledTaskTrigger -AtLogon
$D = New-ScheduledTask -Action $A -Trigger $T
Register-ScheduledTask T1 -InputObject $D -User $U


