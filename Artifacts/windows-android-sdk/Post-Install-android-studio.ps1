#Download that file and install it in the right place

$url = "https://dl.google.com/android/installer_r24.4.1-windows.exe"
$path = C:\Packages\Scripts\installer_r24.4.1-windows.exe

New-Item -ItemType Directory -Force -Path (Split-Path -parent $path)    
$client = new-object System.Net.WebClient 
$client.DownloadFile($url, $path)

C:\Packages\Scripts\installer_r24.4.1-windows.exe /S
start-sleep 300

move "C:\Users\ArtifactInstaller\AppData\Local\Android\android-sdk" "C:\Users\Administrateur\AppData\Local\Android\sdk\"

　
echo y | C:\Users\Administrateur\AppData\Local\Android\sdk\tools\android.bat update sdk --no-ui --all --filter platform-tools,build-tools-24.0.1,android-22,android-23,doc-23,sys-img-armeabi-v7a-android-tv-23,sys-img-x86-android-tv-23,sys-img-armeabi-v7a-android-wear-23,sys-img-x86-android-wear-23,sys-img-armeabi-v7a-android-23,sys-img-x86_64-android-23,sys-img-x86-android-23,sys-img-armeabi-v7a-google_apis-23,sys-img-x86_64-google_apis-23,sys-img-x86-google_apis-23,sys-img-armeabi-v7a-android-tv-22,sys-img-x86-android-tv-22,sys-img-armeabi-v7a-android-wear-22,sys-img-x86-android-wear-22,sys-img-armeabi-v7a-android-22,sys-img-x86_64-android-22,sys-img-x86-android-22,sys-img-armeabi-v7a-google_apis-22,sys-img-x86_64-google_apis-22,sys-img-x86-google_apis-22,addon-google_apis-google-23,addon-google_apis-google-22,source-23,source-22,extra-google-m2repository,extra-google-usb_driver
