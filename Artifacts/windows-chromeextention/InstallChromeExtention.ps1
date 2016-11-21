#
#Argument
#

$EXTENTIONID = $args[0]

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
	write-host $("-ExtentionID : " + $EXTENTIONID)
	write-host "========== Configuration =========="
} 

function InstallChocolatey
{
    Write-host "Installing Chocolatey..."
    Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) | Out-Null
    Write-host "Success."
}

function InstallChrome
{
    write-host "Installing Google Chrome..."
	choco install googlechrome --force --yes --acceptlicense --verbose | Out-Null
	if ($? -eq $false)
    {
        $errMsg = $("Error! Installation failed. Please see the chocolatey logs in %ALLUSERSPROFILE%\chocolatey\logs folder for details.")
        write-host $errMsg
    }
    Write-host "Success."
}

function InstallExtention ($IDEXTENTION)
{
    write-host "Installing Google Chrome Extention..."
    if (test-path -Path "HKLM:\Software\Wow6432Node\Google\Chrome"){
        if (test-path -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\$EXTENTIONID"){
        }
        else {
            New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions" -Name $EXTENTIONID | Out-Null
	    }
    }
    else {
        New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome" | Out-Null
        New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions" | Out-Null
        New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions" -Name $EXTENTIONID | Out-Null
	}
    Set-ItemProperty -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\$EXTENTIONID" -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" | Out-Null
    Write-host "Success."
}
##################################################################################################

try
{
	#Display Argument
	DisplayArgValues
	
	# install the chocolatey package manager
    InstallChocolatey

	# install Google Chrome
	InstallChrome
	
	#Install Extention ID
	InstallExtention -ExtentionID $IDEXTENTION 

	return 0
}

catch
{
	write-host "An Error Occured"
    return -1

}