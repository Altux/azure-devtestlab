$EXTENTIONID = "gbchcmhmhahfdphkhkmpfmihenigjmpp"

New-Item -Path "HKLM:\Software\Wow6432Node\Google" -Name "Chrome"
New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome" -Name "Extensions"
New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions" -Name $EXTENTIONID
Set-ItemProperty -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\$EXTENTIONID" -Name "update_url" -Value "https://clients2.google.com/service/update2/crx"
