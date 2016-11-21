#
# Powershell Configurations
#

# Note: Because the $ErrorActionPreference is "Stop", this script will stop on first failure. 
$ErrorActionPreference = "stop"

# Ensure that current process can run scripts. 
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force 

###################################################################################################

#
# Functions
#

function Unpin-App 
{ 
	param([string]$App)
	((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $App}).verbs() | ?{$_.Name.replace('&','') -match "Unpin from Start"} | %{$_.DoIt()}
	write-host "Remove $app to the start-menu ..."
}

function Pin-App 
{ 
	param([string]$App)
    	((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $App}).verbs() | ?{$_.Name.replace('&','') -match "Pin to Start"} | %{$_.DoIt()}
	write-host "Adding $app to the start-menu ..."
}

function SetupAndroidStudio{
	Write-host "Setup of the Android Studio"

	#Creation of a AVD
		C:\Users\Administrateur\AppData\Local\Android\Sdk\tools\android.bat create avd -t "android-10" -b "armeabi" -n "ESCP-V3_API_10" -d "4in WVGA (Nexus S)" | Out-Null

	#Download the config.ini
		$url = "https://raw.githubusercontent.com/Altux/azure-devtestlab/master/Applications%20Config%20File/Android%20Studio/config.ini"
		$path = "C:\Users\Administrateur\.android\avd\ESCP-V3_API_10.avd\config.ini"
		New-Item -ItemType Directory -Force -Path (Split-Path -parent $path) | Out-Null    
		$client = new-object System.Net.WebClient 
		$client.DownloadFile($url, $path) 


	#Add Project Android Studio Shortcut to the desktop
		$WshShell = New-Object -comObject WScript.Shell
		$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\AndroidStudioProjects.lnk")
		$Shortcut.TargetPath = "C:\Windows\explorer.exe"
		$Shortcut.Arguments ="C:\Users\Administrateur\AndroidStudioProjects"
		$Shortcut.Save() | Out-Null

}



##################################################################################################

try
{
	#Setup Android Studio
	SetupAndroidStudio

	#Add Shorcut to the desktop
    	write-host "Creating Google Drive Shortcut to the Desktop..."
    	$WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Google Drive.lnk")
	$Shortcut.TargetPath = "C:\Program Files (x86)\Google\Drive\googledrivesync.exe"
	$Shortcut.Save()

    	write-host "Creating Android Studio Shortcut to the Desktop..."
    	$WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Android Studio.lnk")
	$Shortcut.TargetPath = "C:\Program Files\Android\Android Studio\bin\studio64.exe"
	$Shortcut.Save()

	#Change Hours
    	write-host "Changing Hour..."
	C:\Windows\system32\tzutil /s "Romance Standard Time"
	
	Start-Sleep -s 45
	
	#Unpin all tiles
	Unpin-App "Server Manager"
	Unpin-App "Windows Powershell"
	Unpin-App "Windows Powershell ISE"
	Unpin-App "Windows Administrative tools"
	Unpin-App "Task Manager"
	Unpin-App "Control Panel"
	Unpin-App "File Explorer"
	Unpin-App "Event Viewer"
	Unpin-App "Remote Desktop Connection"

	#Pin tiles needed
	Pin-App "Android Studio"
	Pin-App "Google Drive"
	Pin-App "File Explorer"
	Pin-App "Google Chrome"
	return 0
}

catch
{
	write-host "An Error Occured"
    return -1
}

