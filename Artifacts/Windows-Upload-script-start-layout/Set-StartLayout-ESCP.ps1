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

#Move SDK Folder to the Administrateur Profile
mkdir "C:\Users\Administrateur\AppData\Local\Android\Sdk"
move "C:\Users\artifactInstaller\AppData\Local\Android\android-sdk\*" "C:\Users\Administrateur\AppData\Local\Android\Sdk"

#Creation of a AVD
C:\Users\Administrateur\AppData\Local\Android\Sdk\tools\android.bat create avd -t "android-10" -b "armeabi" -n "ESCP-V3_API_10" -d "4in WVGA (Nexus S)"

#Download the config.ini
$url = "https://raw.githubusercontent.com/Altux/azure-devtestlab/master/Applications%20Config%20File/Android%20Studio/config.ini"
$path = "C:\Users\Administrateur\.android\avd\ESCP-V3_API_10.avd\config.ini"
New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)    
$client = new-object System.Net.WebClient 
$client.DownloadFile($url, $path)

#Add GoogleDrive Shortcut to the desktop
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Google Drive.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\Google\Drive\googledrivesync.exe"
$Shortcut.Save()

#Add Project Android Studio Shortcut to the desktop
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\AndroidStudioProjects.lnk")
$Shortcut.TargetPath = "C:\Windows\explorer.exe"
$Shortcut.Arguments ="C:\Users\Administrateur\AndroidStudioProjects"
$Shortcut.Save()

#Add Android Studio Shortcut to the desktop
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Android Studio.lnk")
$Shortcut.TargetPath = "C:\Program Files\Android\Android Studio\bin\studio64.exe"
$Shortcut.Save()

#Change Hours
C:\Windows\system32\tzutil /s "Romance Standard Time"

Start-Sleep -s 45

#Create the Start-Layout
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
Pin-App "Google Chrome"
