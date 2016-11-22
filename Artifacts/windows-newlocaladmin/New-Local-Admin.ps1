#
#Arguments
#

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string] $Account,
    [Parameter(Mandatory=$true)][string] $Password
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

try
{
	#Crate new account
	write-host "Creating new Account: $Account"
	Net User $Account $Password /add | Out-Null
    write-host "Success"

	#Set the user to be Administrator
	write-host "Moving $Account to be administrator's group"
	Net Localgroup Administrators /add $Account | Out-Null
	Net Localgroup Users /delete $Account | Out-Null
    write-host "Success"
    	
	return 0
}

catch
{
	write-host "An Error Occured"
    return -1

}

