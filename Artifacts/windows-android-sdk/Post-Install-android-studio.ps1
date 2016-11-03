#Download that file and install it in the right place

$url = "https://dl.google.com/android/installer_r24.4.1-windows.exe"
$path = "C:\Packages\Scripts\installer_r24.4.1-windows.exe"

New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)    
$client = new-object System.Net.WebClient 
$client.DownloadFile($url, $path)

C:\Packages\Scripts\installer_r24.4.1-windows.exe /S
start-sleep 300
mkdir "C:\Users\Administrateur\AppData\Local\Android\sdk"
move "C:\Users\artifactInstaller\AppData\Local\Android\android-sdk\*" "C:\Users\Administrateur\AppData\Local\Android\sdk"
echo y | C:\Users\Administrateur\AppData\Local\Android\sdk\tools\android.bat update sdk --no-ui
