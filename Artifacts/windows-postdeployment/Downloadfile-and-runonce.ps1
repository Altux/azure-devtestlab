#
#Arguments
#


[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string] $url
)

$path = "C:\Packages\Scripts\PostDeployment.ps1"

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
# Functions
#

function DisplayArgValues
{
	write-host "========== Configuration =========="
	write-host $("-url : " + $url)
	write-host "========== Configuration =========="
} 


function DonwloadFile ($url, $path)
{
	New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)    
	$client = new-object System.Net.WebClient 
	$client.DownloadFile($url, $path)
} 

function RunOnce ($path, $name)
{
	Set-itemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "StartLayout" -Value "powershell.exe -executionpolicy bypass -File $path"
}

##################################################################################################

try
{
	#Display Argument
	DisplayArgValues
	
	#DonwloadFile to be launch
    DonwloadFile($url, $path)

	#RunOnce the file downloaded
	RunOnce($path, "PostDeployment")
	
	return 0
}

catch
{
	write-host "An Error Occured"
    return -1

}

