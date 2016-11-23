<##################################################################################################

    Description
    ===========

	Download and RunOnce a powershell script that will be launch at first Logon

    Usage examples
    ==============

    PowerShell -ExecutionPolicy bypass Downloadfile-and-runone.ps1 -url <url>
   
    Where,
      <url> is the url of your script to be run at first logon


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
    [string]$url
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

function Validate-Params
{
    [CmdletBinding()]
    param(
    )

    if ([string]::IsNullOrEmpty($url))
    {
        throw 'The Script need a URL of your script to be run at first logon'
    }
}


function DonwloadFile
{
    [CmdletBinding()]
    param(
    [string] $url,
    [string] $path
    ) 
	$client = new-object System.Net.WebClient
	$client.DownloadFile($url, $path)
} 

function RunOnce
{
    [CmdletBinding()]
    param(
    [string] $name,
    [string] $path
    )
	Set-itemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name $name -Value "powershell.exe -executionpolicy bypass -File $path" 
}

##################################################################################################

#
# Main execution block.
#

try
{
    Validate-Params
    DonwloadFile -url $url -path "C:\PostDeployment.ps1"
	RunOnce -path "C:\PostDeployment.ps1" -name "PostDeployment"
	
	Write-host "Success"
}

catch
{
	Handle-LastError
}

