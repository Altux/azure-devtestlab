#Préparation du menu démarrer

function Unpin-App { param(
[string]$App)
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $App}).verbs() | ?{$_.Name.replace('&','') -match "Unpin from Start"} | %{$_.DoIt()}
}


#Pin
function Pin-App { param(
[string]$App)
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $App}).verbs() | ?{$_.Name.replace('&','') -match "Pin to Start"} | %{$_.DoIt()}
}

Start-Sleep -s 60

Unpin-App "Server Manager"
Unpin-App "Windows Powershell"
Unpin-App "Windows Powershell ISE"
Unpin-App "Windows Administrative tools"
Unpin-App "Task Manager"
Unpin-App "Control Panel"
Unpin-App "File Explorer"
Unpin-App "Event Viewer"
Unpin-App "Remote Desktop Connection"

Pin-App "Android Studio"
Pin-App "Google Drive"
Pin-App "File Explorer"
