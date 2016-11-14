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

<#Download the config.ini
$url = "https://raw.githubusercontent.com/Altux/azure-devtestlab/master/Applications%20Config%20File/Android%20Studio/config.ini"
$path = "C:\Users\Administrateur\.android\avd\ESCP-V3_API_10.avd\config.ini"
New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)    
$client = new-object System.Net.WebClient 
$client.DownloadFile($url, $path)#>
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
