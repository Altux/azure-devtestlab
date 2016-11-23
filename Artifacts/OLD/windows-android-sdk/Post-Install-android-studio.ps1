#Download that file and install it in the right place

$url = "https://dl.google.com/android/installer_r24.4.1-windows.exe"
$path = "C:\Packages\Scripts\installer_r24.4.1-windows.exe"

New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)    
$client = new-object System.Net.WebClient 
$client.DownloadFile($url, $path)

C:\Packages\Scripts\installer_r24.4.1-windows.exe /S
start-sleep 300

echo y | C:\Users\ArtifactInstaller\AppData\Local\Android\Android-sdk\tools\android.bat update sdk --no-ui
