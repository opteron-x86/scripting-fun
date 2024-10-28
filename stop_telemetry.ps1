# Requires admin privileges
If (-Not [Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run this script as Administrator" -ForegroundColor Red
    Exit
}

# Disable Telemetry
Write-Host "Disabling Telemetry..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force

# Disable Feedback
Write-Host "Disabling Feedback requests..." -ForegroundColor Cyan
if (Test-Path "HKCU:\Software\Microsoft\Siuf\Rules") {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Force
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Value 0 -Force
}

# Disable Cortana
Write-Host "Disabling Cortana..." -ForegroundColor Cyan
if (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search") {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force
}

# Disable Location tracking
Write-Host "Disabling Location Tracking..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" -Force

# Disable Advertising ID
Write-Host "Disabling Advertising ID..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Force

# Disable Windows Error Reporting
Write-Host "Disabling Windows Error Reporting..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 1 -Force

# Disable Microsoft Compatibility Telemetry
Write-Host "Disabling Microsoft Compatibility Telemetry..." -ForegroundColor Cyan
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable

# Disable WiFi Sense
Write-Host "Disabling WiFi Sense..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "AutoConnectAllowedOEM" -Value 0 -Force

# Disable Biometrics
Write-Host "Disabling Biometrics..." -ForegroundColor Cyan
if (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Biometrics") {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Biometrics" -Name "Enabled" -Value 0 -Force
}

# Disable Windows Tips
Write-Host "Disabling Windows Tips..." -ForegroundColor Cyan
if (Test-Path "HKCU:\Software\Microsoft\Siuf\Rules") {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Value 0 -Force
}

# Disable Connected User Experiences and Telemetry service
Write-Host "Disabling Connected User Experiences and Telemetry Service..." -ForegroundColor Cyan
Stop-Service diagtrack
Set-Service diagtrack -StartupType Disabled

# Disable Data Collection and Preview Builds
Write-Host "Disabling Data Collection and Preview Builds..." -ForegroundColor Cyan
if (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds") {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "EnableConfigFlighting" -Value 0 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "EnableBuildPreview" -Value 0 -Force
}

# Disable diagnostic and feedback
Write-Host "Disabling Diagnostic and Feedback..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Value 1 -Force

# Disable Activity History (Timeline)
Write-Host "Disabling Activity History (Timeline)..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Value 0 -Force

# Disable Telemetry Scheduled Tasks
Write-Host "Disabling Telemetry Scheduled Tasks..." -ForegroundColor Cyan
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable

# Block Telemetry IPs via Firewall (Optional, uncomment and add IPs as needed)
# $telemetryIps = @(
#    "20.190.128.0/18",  
#    "40.126.0.0/18"
# )

Write-Host "Blocking telemetry IPs via Firewall..." -ForegroundColor Cyan
ForEach ($ip in $telemetryIps) {
    New-NetFirewallRule -DisplayName "Block Telemetry $ip" -Direction Outbound -RemoteAddress $ip -Action Block
}

Write-Host "Telemetry and tracking features have now been disabled!" -ForegroundColor Green
