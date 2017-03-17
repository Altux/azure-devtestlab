while ($true){
$usersession = qwinsta administrateur | foreach-object {
    $_.Trim() -replace "\s+",","
} | ConvertFrom-Csv

if ($usersession.Username -eq "administrateur"){
    Write-Output "Administrateur is connected"

    $maxvalue = 2160 #36h
    $Path = "C:\ProgramData\exaduo\QUota\" 
    $file = "value.txt"

    if (Test-path ($Path + $file)){
        write-output "The file already exist"
        while (1){
            $value = get-content ($Path + $file)
            write-output "Time spent: $value minute(s)"
            if ($value -gt $maxvalue){
                Write-Output "MAXVALUE REACH !!!"
                shutdown -s -f -t 0
            } 
            Write-Output "Waiting 60 seconds"
            sleep -Seconds 60
            $value = ([int]$value + 1)
            $value | Set-Content ($Path + $file)
        }
    }
    else {
        New-item -Path $Path -Name $file -ItemType "file"
        "0" | Set-Content ($Path + $file)
    }    
}
else {
    Write-Output "Administrateur is not connected"
    sleep -Seconds 60
}
}
