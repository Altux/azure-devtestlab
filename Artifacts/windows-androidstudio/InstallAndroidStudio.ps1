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

function InstallChocolatey
{
    Write-host "Installing Chocolatey..."
    Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) | Out-Null
    Write-host "Success."
}

function Install($Application)
{
    write-host "Installing $Application..."
	choco install $Application --force --yes --acceptlicense --verbose | Out-Null
	if ($? -eq $false)
    {
        $errMsg = $("Error! Installation failed. Please see the chocolatey logs in %ALLUSERSPROFILE%\chocolatey\logs folder for details.")
        write-host $errMsg
    }
    Write-host "Success."
}

function InstallSDK($urlsdk)
{
	#Install SDKManager
    write-host "Installing SDK Manager..."
	New-Item -ItemType Directory -Force -Path (Split-Path -parent "C:\Packages\Scripts\AndroidSDK.exe")    
	$client = new-object System.Net.WebClient 
	$client.DownloadFile($urlsdk, "C:\Packages\Scripts\AndroidSDK.exe") | Out-Null

	#Install SDKManager
	C:\Packages\Scripts\AndroidSDK.exe /S
	start-sleep 300

	#Download SDK
    write-host "Downloading SDKs..."
	echo y | C:\Users\ArtifactInstaller\AppData\Local\Android\Android-sdk\tools\android.bat update sdk --no-ui | Out-Null
}

function SetupSDK
{
	#Create a script to move SDK to the User Folder 
    write-host "Setup Android Studio..."
	New-Item C:\Packages\Scripts\RunOnce.SDKmove.ps1 -type file -value "mkdir 'C:\Users\Administrateur\AppData\Local\Android\Sdk';move 'C:\Users\artifactInstaller\AppData\Local\Android\android-sdk\*' 'C:\Users\Administrateur\AppData\Local\Android\Sdk'" | Out-Null
    Set-itemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "RunOnce.SDKmove.ps1" -Value "powershell.exe -executionpolicy bypass -File 'C:\Packages\Scripts\RunOnce.SDKmove.ps1'" | Out-Null
}
##################################################################################################

try
{	
	# install the chocolatey package manager
    InstallChocolatey

	# install AndroidStudio
	Install("AndroidStudio")
	
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

