<##################################################################################################

    Description
    ===========

	Change the RDP Port 

    Usage examples
    ==============

    PowerShell -ExecutionPolicy bypass ./SetwindowsRDPport.ps1 -port <Port Number>
   
    Where,
      <Port Number> is the new port use by the RDP service


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
    [String]$port
)

###################################################################################################

#
# Powershell Configurations
#

# Note: Because the $ErrorActionPreference is "Stop", this script will stop on first failure. 
#$ErrorActionPreference = "stop"

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

    if ([String]::IsNullOrEmpty($port))
    {
        throw 'The Script need the new port for the RDP Service'
    }
}


function ChangePort
{
    [CmdletBinding()]
    param(
    [String] $port
    ) 
    Set-itemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "PortNumber" -Value $port
    New-NetFirewallRule -DisplayName "Allow $port on RDP" -Direction "Inbound" -Program "%SystemRoot%\system32\svchost.exe" -Protocol TCP -Localport $port -action allow 
    net stop UmRdpService;net stop termservice;net start UmRdpService;net start termservice 
} 

##################################################################################################

#
# Main execution block.
#

try
{
    Validate-Params
    ChangePort -port $port
    	
	Write-host "Success"
}

catch
{
	Handle-LastError
}
