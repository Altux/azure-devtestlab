<##################################################################################################

    Description
    ===========

    - This Script disable Internet Security using registry values

    Usage examples
    ==============

    Powershell -executionpolicy bypass -file DisableIeSecurity.ps1

	
    Pre-Requisites
    ==============

    - Please ensure that this script is run elevated.
    - Please ensure that the powershell execution policy is set to unrestricted or bypass.

    Known issues / Caveats
    ======================

    - No known issues.

    Coming soon / planned work
    ==========================

	- Add Test-Path to make sure everything exist



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

#
# Main execution block.
#

try
{
    Write-Host "Disabling IE Enforcement Security..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 | Out-Null
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0 | Out-Null

    Write-Host "Disabling Setup Wizard at first Start..."
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name "Internet Explorer" | Out-Null
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer" -Name "Main" | Out-Null
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 1 | Out-Null
			
    Write-Host "Success"
}

catch
{
	Handle-LastError
}