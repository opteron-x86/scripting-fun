# Powershell script to automatically download and install Firefox, useful on a new Windows instance so you don't have to open Edge and click no on a dozen annoying questions just to download Firefox
$firefoxUrl = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"

$installerPath = "$env:USERPROFILE\Downloads\FirefoxInstaller.exe"

$webClient = New-Object System.Net.WebClient

try {
    Write-Host "Downloading the latest Firefox installer..."
    $webClient.DownloadFile($firefoxUrl, $installerPath)
    Write-Host "Download complete. Installer saved to $installerPath"
    
    Write-Host "Starting the Firefox installer..."
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
    Write-Host "Firefox installer has been started."
} catch {
    Write-Host "An error occurred: $_"
} finally {
    $webClient.Dispose()
