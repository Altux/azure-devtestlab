<##################################################################################################

    Description
    ===========

	Set up for WIndows Server, this will set the system to not bring the Server Manager At Logon

    Usage examples
    ==============

    PowerShell -ExecutionPolicy bypass ./DoNotOpenServerManagerAtLogon.ps1 

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

    - Add a test-path to ensure that the path exist

##################################################################################################>

#
# Powershell Configurations
#

# Note: Because the $ErrorActionPreference is "Stop", this script will stop on first failure. 
$ErrorActionPreference = "stop"

# Ensure that current process can run scripts. 
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force 

##################################################################################################

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

function DoNotOpenServerManagerAtLogon
{
    write-host "Set up for Windows Server, this will set the system to not bring the Server Manager At Logon..."
    New-Item -Path HKLM:\Software\Policies\Microsoft\Windows\ -Name Server | Out-Null
    New-Item -Path HKLM:\Software\Policies\Microsoft\Windows\Server -Name ServerManager | Out-Null
    Set-itemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Server\ServerManager" -Name "DoNotOpenAtLogon" -Value 1  | Out-Null
}

##################################################################################################

#
# Main execution block.
#

try
{
    DoNotOpenServerManagerAtLogon
   
	Write-host "Success"
}

catch
{
	Handle-LastError
}
