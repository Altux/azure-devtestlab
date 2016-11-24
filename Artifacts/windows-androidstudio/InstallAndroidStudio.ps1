<##################################################################################################

    Description
    ===========

	Install Android Studio

    Usage examples
    ==============

    PowerShell -ExecutionPolicy bypass InstallAndroidStudio 

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

function Remove-LocalAdminUser
{
    [CmdletBinding()]
    param(
        [string] $UserName
    )

    if ([ADSI]::Exists('WinNT://./' + $UserName))
    {
        $computer = [ADSI]"WinNT://$env:ComputerName"
        $computer.Delete('User', $UserName)
        try
        {
            gwmi win32_userprofile | ? { $_.LocalPath -like "*$UserName*" -and -not $_.Loaded } | % { $_.Delete() | Out-Null }
        }
        catch
        {
            # Ignore any errors, specially with locked folders/files. It will get cleaned up at a later time, when another artifact is installed.
        }
    }
}

function InstallAndroidStudio
{
    powershell.exe -ExecutionPolicy bypass ./startChocolatey.ps1 -PackageList androidstudio
}

function InstallSDK
{
	#Download SDK
    write-host "Downloading SDKs..."
	echo y | C:\Users\ArtifactInstaller\AppData\Local\Android\Android-sdk\tools\android.bat update sdk --no-ui 
}

function SetupSDK
{
	#Create a script to move SDK to the User Folder 
    write-host "Setup Android Studio..."
    	mkdir "C:\Sdk" | Out-Null
    	move 'C:\Users\artifactInstaller\AppData\Local\Android\android-sdk\*' 'C:\Sdk' | Out-Null
	New-Item C:\RunOnce.SDKmove.ps1 -type file -value "New-Item -ItemType Directory -Force -Path 'C:\Users\Administrateur\AppData\Local\Android\Sdk';move-item -path 'C:\Sdk\*' -destination 'C:\Users\Administrateur\AppData\Local\Android\Sdk';Remove-Item C:\Sdk -force;Remove-Item c:\RunOnce.SDKmove.ps1 -force" | Out-Null
    	Set-itemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "RunOnce.SDKmove.ps1" -Value "powershell.exe -executionpolicy bypass -File 'C:\RunOnce.SDKmove.ps1'" | Out-Null




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
	# install AndroidStudio
	InstallAndroidStudio

    # Create a Shortcut for Android Studio in the Desktop
    Shortcut -Name "Android Studio" -TargetPath "C:\Program Files\Android\Android Studio\bin\studio64.exe"
	
	#Setup the SDK
	InstallSDK
	SetupSDK
    
    Write-Host "Success"
}

catch
{
	Handle-LastError
}

finally{
    Remove-LocalAdminUser "artifactInstaller"
}
