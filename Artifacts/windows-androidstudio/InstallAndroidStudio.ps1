#
#Argument
#

$urlsdk = "https://dl.google.com/android/installer_r24.4.1-windows.exe"

###################################################################################################

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

function InstallAndroidStudio
{
    powershell.exe -ExecutionPolicy bypass ./startChocolatey.ps1 -PackageList androidstudio
}

function InstallSDK($urlsdk)
{
	#Install SDKManager
    write-host "Installing SDK Manager..."
	New-Item -ItemType Directory -Force -Path (Split-Path -parent "C:\Packages\Scripts\AndroidSDK.exe")    
	$client = new-object System.Net.WebClient | Out-Null
	$client.DownloadFile($urlsdk, "C:\Packages\Scripts\AndroidSDK.exe") 

	#Install SDKManager
	C:\Packages\Scripts\AndroidSDK.exe /S
	start-sleep 300

	#Download SDK
    write-host "Downloading SDKs..."
	echo y | C:\Users\ArtifactInstaller\AppData\Local\Android\Android-sdk\tools\android.bat update sdk --no-ui 
}

function SetupSDK
{
	#Create a script to move SDK to the User Folder 
    write-host "Setup Android Studio..."
    	mkdir "C:\Packages\Script\Sdk" | Out-Null
    	move 'C:\Users\artifactInstaller\AppData\Local\Android\android-sdk\*' 'C:\Packages\Scripts\Sdk' | Out-Null
	New-Item C:\Packages\Scripts\RunOnce.SDKmove.ps1 -type file -value "mkdir 'C:\Users\Administrateur\AppData\Local\Android\Sdk';move 'C:\Packages\Scripts\Sdk\*' 'C:\Users\Administrateur\AppData\Local\Android\Sdk'" | Out-Null
    	Set-itemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "RunOnce.SDKmove.ps1" -Value "powershell.exe -executionpolicy bypass -File 'C:\Packages\Scripts\RunOnce.SDKmove.ps1'" | Out-Null
    write-host "Success"
}
##################################################################################################

try
{	
	# install AndroidStudio
	InstallAndroidStudio
	
	#Setup the SDK (Download Install)
	InstallSDK($urlsdk)
	SetupSDK

	return 0
}

catch
{
	write-host "An Error Occured"
    return -1
}

