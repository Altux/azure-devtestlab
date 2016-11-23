<##################################################################################################

    Description
    ===========

	Install Chrome and a Chrome extention

    Usage examples
    ==============

    PowerShell -ExecutionPolicy bypass InstallChromeExtention -EXTENTIONID <ID>
   
    Where,
      <ID> is the ID of the Chrome Application or Extention, this filed can be empty


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
# Optional parameters to this script file.
#


[CmdletBinding()]
param(
    [string] $EXTENTIONID
)

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

function InstallChrome
{
    powershell.exe -ExecutionPolicy bypass ./startChocolatey.ps1 -PackageList googlechrome
}

function InstallExtention ($IDEXTENTION)
{
    write-host "Installing Google Chrome Extention..."
    if (test-path -Path "HKLM:\Software\Wow6432Node\Google\Chrome"){
        if (test-path -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\$EXTENTIONID"){
        }
        else {
            New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions" -Name $EXTENTIONID | Out-Null
	    }
    }
    else {
        New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome" | Out-Null
        New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions" | Out-Null
        New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions" -Name $EXTENTIONID | Out-Null
	}
    Set-ItemProperty -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\$EXTENTIONID" -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" | Out-Null
    Write-host "Success."
}
##################################################################################################

#
# Main execution block.
#

try
{
	# install Google Chrome
	InstallChrome
	
	#Install Extention ID
    if (-NOT [string]::IsNullOrEmpty($IDEXTENTION))
    {
	    InstallExtention -ExtentionID $IDEXTENTION 
    }
	Write-Host "Success"
}

catch
{
    Handle-LastError
}
