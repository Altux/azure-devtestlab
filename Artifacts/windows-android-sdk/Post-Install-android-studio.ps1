#Download that file and install it in the right place

$url1 = "https://dl.google.com/android/installer_r24.4.1-windows.exe"
$path1 = "C:\Packages\Scripts\installer_r24.4.1-windows.exe"

$url2 = "https://raw.githubusercontent.com/Altux/azure-devtestlab/master/Applications%20Config%20File/Android%20Studio/config.ini"
$path2 = "C:\Users\Administrateur\.android\avd\ESCP-V3_API_10.avd"


function DownloadFIle($url, $path)
{
    New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)    
    $client = new-object System.Net.WebClient 
    $client.DownloadFile($url, $path)
}

DownloadFile($url1, $path1)

C:\Packages\Scripts\installer_r24.4.1-windows.exe /S
start-sleep 300

echo y | C:\Users\ArtifactInstaller\AppData\Local\Android\Android-sdk\tools\android.bat update sdk --no-ui
C:\Users\ArtifactInstaller\AppData\Local\Android\Android-sdk\tools\android.bat create avd -t "android-10" -b "armeabi" -n "ESCP-V3_API_10"

DownloadFile($url2, $path2)
