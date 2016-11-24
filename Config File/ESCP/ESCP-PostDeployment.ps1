<##################################################################################################

    Description
    ===========

	Set up ESCP template at the first start up

    Usage examples
    ==============

    PowerShell -ExecutionPolicy bypass ./ESCP-PostDeployment.ps1 

    Pre-Requisites
    ==============

    - Ensure that the PowerShell execution policy is set to unrestricted.
    - If calling from another process, make sure to execute as script to get the exit code (e.g. "& ./foo.ps1 ...").

    Known issues / Caveats
    ======================
    
    - Using powershell.exe's -File parameter may incorrectly return 0 as exit code, causing the
      operation to report success, even when it fails.

    Coming soon / planned work
    ==========================

    - N/A.

##################################################################################################>

#
# Powershell Configurations
#

# Note: Because the $ErrorActionPreference is "Stop", this script will stop on first failure. 
$ErrorActionPreference = "stop"

# Ensure that current process can run scripts. 
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force 

###################################################################################################

#
# Functions used in this script.
#

function Handle-LastError
{
    [CmdletBinding()]
    param(
    )

    $message = $error[0].Exception.Message

    if ($message)
    {
        Write-Host -Object "ERROR: $message" -ForegroundColor Red
    }

    # IMPORTANT NOTE: Throwing a terminating error (using $ErrorActionPreference = "Stop") still
    # returns exit code zero from the PowerShell script when using -File. The workaround is to
    # NOT use -File when calling this script and leverage the try-catch-finally block and return
    # a non-zero exit code from the catch block.

    exit -1
}

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
    cd C:\Users\Administrateur\AppData\Local\Android\Sdk\tools
	.\android.bat create avd -t "android-10" -b "armeabi" -n "ESCP-V3_API_10" -d "4in WVGA (Nexus S)" --force

	#Download the config.ini
		$url = "https://raw.githubusercontent.com/Altux/azure-devtestlab/master/Config%20File/ESCP/AVD-config.ini"
		$path = "C:\Users\Administrateur\.android\avd\ESCP-V3_API_10.avd\config.ini"
		New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)  
		$client = new-object System.Net.WebClient 
		$client.DownloadFile($url, $path) 


	#Add Project Android Studio Shortcut to the desktop
		$WshShell = New-Object -comObject WScript.Shell
		$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\AndroidStudioProjects.lnk")
		$Shortcut.TargetPath = "C:\Windows\explorer.exe"
		$Shortcut.Arguments ="C:\Users\Administrateur\AndroidStudioProjects"
		$Shortcut.Save() 

}

function shortcut
{
    [CmdletBinding()]
    param(
        [string] $Name,
        [string] $TargetPath
    )

    write-host "Creating $Name Shortcut to the Public Desktop..."
    $WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\$Name.lnk")
	$Shortcut.TargetPath = $TargetPath
	$Shortcut.Save()
}

##################################################################################################

#
# Main execution block.
#

try
{
	#Add Shorcut to the desktop
    shortcut -Name "Google Drive" -TargetPath "C:\Program Files (x86)\Google\Drive\googledrivesync.exe"

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

    #Setup Android Studio
	SetupAndroidStudio | Out-Null

    Remove-Item "c:\PostDeployment.ps1" -force | Out-Null
    
    Write-Host "Success"
}

catch
{
	Handle-LastError
}

