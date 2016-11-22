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
        mkdir "C:\Users\Default\AppData\Local\Android"
        mkdir "C:\Users\Default\AppData\Local\Android\sdk"
        move "C:\Users\artifactInstaller\AppData\Local\Android\android-sdk\*" "C:\Users\Default\AppData\Local\Android\sdk" 
    write-host "Success"
}

##################################################################################################

try

{	
	# install AndroidStudio
	InstallAndroidStudio
	
	#Setup the SDK
	InstallSDK
	SetupSDK

	return 0
}

catch
{
	write-host "An Error Occured"
	return -1
}

finally{
    Remove-LocalAdminUser "artifactInstaller"
}
