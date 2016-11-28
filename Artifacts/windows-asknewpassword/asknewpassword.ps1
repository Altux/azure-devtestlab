<##################################################################################################

    Description
    ===========

	Ask to the user to change his password

    Usage examples
    ==============

    PowerShell -ExecutionPolicy bypass ./asknewpassword.ps1 -Account <Username>

    Where
        <Username> is the name of the user that will be ask to change his password

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
    [string] $Account
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

    if ([string]::IsNullOrEmpty($Account))
    {
        throw 'Enter the Account name of the Administrator"'
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

function Set-UserchangePassword
{
    [CmdletBinding()]
    param(
        [string] $UserName
    )

    Write-Host "Set the parameter change password at next logon to the user: $UserName ..."
    $obj = [ADSI]"WinNT://$env:ComputerName"
    $user = $obj.Children.find($UserName)
    $user.PasswordExpired = 1
    $user.SetInfo()
}

###################################################################################################

#
# Main execution block.
#

try
{
    Validate-Params

	Set-UserchangePassword -UserName $Account | Out-Null

    Write-Host "Success"
}

catch
{
	Handle-LastError
}

