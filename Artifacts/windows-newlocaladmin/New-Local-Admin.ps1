<##################################################################################################

    Description
    ===========

	Create a new Admin user

    Usage examples
    ==============

    PowerShell -ExecutionPolicy bypass New-Local-Admin.ps1 -Account <Username> -password <Password>

    Where
        <Username> is the name of the new user that will be create
        <Password> is the password for the new administrator

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
    [string] $Account,
    [string] $Password
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

    if ([string]::IsNullOrEmpty($Password))
    {
        throw 'Enter the Password of the Administrator New'
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

function Add-LocalAdminUser
{
    [CmdletBinding()]
    param(
        [string] $UserName,
        [string] $Password,
        [switch] $Overwrite = $true
    )
    if ($Overwrite)
    {
           Remove-LocalAdminUser -UserName $UserName
    }
    $computer = [ADSI]"WinNT://$env:ComputerName"
    $user = $computer.Create("User", $UserName)
    $user.SetPassword($Password)

    $user.SetInfo()
    $group = [ADSI]"WinNT://$env:ComputerName/Administrators,group"
    $group.add("WinNT://$env:ComputerName/$UserName")

    return $user
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

###################################################################################################

#
# Main execution block.
#

try
{
    Validate-Params

	Add-LocalAdminUser -UserName $Account -Password $Password

    Write-Host "Success"
}

catch
{
	Handle-LastError
}

