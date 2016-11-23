<##################################################################################################

    Description
    ===========

	Install or Uninstall a Windows Optional Feature

    Usage examples
    ==============

    PowerShell -ExecutionPolicy bypass WindowsOptionalFeature -Feature <FeatureName> -Action <Action>
   
    Where,
      <FeatureName> is the name of the Feature
      <Action> is the action Enable or Disable

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
    [string] $FeatureName,
    [string] $Action
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

function Validate-Params
{
    [CmdletBinding()]
    param(
    )

    if ([string]::Compare($Action, "Disable") -and [string]::Compare($Action, "Enable"))
    {
        throw 'Action parameter is required, It as to be "Disable" or "Enable"'
    }

    if ([string]::IsNullOrEmpty($FeatureName))
    {
        throw 'Feature parameter is required. Use "Get-WindowsOptionalFeature -online" to list FeatureName and there State'
    }
}


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

function installFeature
{
    [CmdletBinding()]
    param(
        [string] $FeatureName
    )

    if (Get-WindowsOptionalFeature -Online -FeatureName $FeatureName){
        Write-host "Enabling $FeatureName ..."
        enable-WindowsOptionalFeature -Online -FeatureName $FeatureName -NoRestart | Out-Null
    }
    else{
        throw '$FeatureName Optional Feature do not exist' 
    }
}

function uninstallFeature
{
    [CmdletBinding()]
    param(
        [string] $FeatureName
    )
   
   if (Get-WindowsOptionalFeature -Online -FeatureName $FeatureName){
        Write-host "disabling $FeatureName ..."
        disable-WindowsOptionalFeature -Online -FeatureName $FeatureName -NoRestart | Out-Null
    }
    else{
        throw '$FeatureName Optional Feature do not exist' 
    }
   
}

###################################################################################################

#
# Main execution block.
#

try
{
    Validate-Params

	if ($Action -eq "Disable"){
		uninstallFeature -FeatureName $FeatureName  
	}
    else {
        InstallFeature -FeatureName $FeatureName
	}
    Write-host "Success"		
}

catch
{
	Handle-LastError
}