#Disable IE Enforcement security by registry

$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"

Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0

#Disable Setup Wizard at first start

$FirstRunDisable = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main"

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name "Internet Explorer"
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer" -Name "Main"
Set-ItemProperty -Path $FirstRunDisable -Name "DisableFirstRunCustomize" -Value 1
