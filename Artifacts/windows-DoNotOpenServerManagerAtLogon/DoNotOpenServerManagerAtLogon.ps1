#Do Not Open Server Manager At Logon

$ServerManager ="HKCU:\Software\Microsoft\ServerManager"

Set-itemProperty -Path $ServerManager -Name "DoNotOpenServerManagerAtLogon" -Value 1
