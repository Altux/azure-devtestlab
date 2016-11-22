#
#Arguments
#

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string] $FeatureName,
    [Parameter(Mandatory=$true)][string] $Action
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
	if ($Action -eq "Disable"){
        write-host "Disabling $featureName..."
		disable-WindowsOptionalFeature -Online -FeatureName $FeatureName -NoRestart | Out-Null
        write-host "Success"
	}
	else{
        write-host "Enabling $featureName..."
		enable-WindowsOptionalFeature -Online -FeatureName $FeatureName -NoRestart | Out-Null
        write-host "Success"
	}
		
	return 0
}

catch
{
	write-host "An Error Occured"
    return -1

}

