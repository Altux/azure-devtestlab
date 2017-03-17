$url = "https://go.microsoft.com/fwlink/?linkid=844652"
$path = "C:\Windows\Temp\onedrive.exe"

$client = New-Object System.Net.WebClient
$client.DownloadFile($url, $path)

start-process -FilePath $path -ArgumentList "/Silent"

