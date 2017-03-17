$max = 1800
$timer = 0
do{
Start-Sleep -seconds 10
$sessions = query session | ?{ $_ -notmatch '^ SESSIONNAME' } | %{
    $item = "" | Select "Active", "SessionName", "Username", "Id", "State", "Type", "Device"
    $item.Active = $_.Substring(0,1) -match '>'
    $item.SessionName = $_.Substring(1,18).Trim()
    $item.Username = $_.Substring(19,20).Trim()
    $item.Id = $_.Substring(39,9).Trim()
    $item.State = $_.Substring(48,8).Trim()
    $item.Type = $_.Substring(56,12).Trim()
    $item.Device = $_.Substring(68).Trim()
    $item
} 
$check = ($sessions | ?{ $_.State -eq 'Active' }).username 
    if ($check -eq $empty){
        $timer+=10
        if ($timer -gt $max){
            shutdown -s -f -t 0
        }
    }
    else{$timer = 0}
}while (1 -eq 1)


