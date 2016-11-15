#Set 443 Value to the RDP Port on Reg
$RDP ="HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
Set-itemProperty -Path $RDP -Name "PortNumber" -Value 443

#Set New FIrewall Rules to let 443 port on RDP
New-NetFirewallRule -DisplayName "Allow 443 on RDP" -Direction "Inbound" -Program "%SystemRoot%\system32\svchost.exe" -Protocol TCP -Localport "443" -action allow

echo y | net stop termservice
echo y | net start termservice
