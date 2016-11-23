#Do Not Open Server Manager At Logon

$ServerManager ="HKLM:\Software\Policies\Microsoft\Windows\Server\ServerManager"
New-Item -Path HKLM:\Software\Policies\Microsoft\Windows\ -Name Server
New-Item -Path HKLM:\Software\Policies\Microsoft\Windows\Server -Name ServerManager
Set-itemProperty -Path $ServerManager -Name "DoNotOpenAtLogon" -Value 1
