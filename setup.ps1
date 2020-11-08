# Currently tested and working on WIN10 x64 v20H2
# Need to open PS as admin and Set-Location to script folder
# Reg import steps will through error if run in PS ISE

#Start Logging
try{stop-transcript|out-null} catch [System.InvalidOperationException]{}
Start-Transcript -Path C:\Users\$env:UserName\Desktop\ps-windows-setup-log.txt

#Check if user want full output
do {
    $outputChoice = Read-Host -Prompt 'Do you want to show all script outputs? (y|n)'
} until ($outputChoice -eq 'y' -Or $outputChoice -eq 'n')

if ($outputChoice -eq 'y') {$Output = 'Out-Default'} else {$Output = 'Out-Null'}

# Check if PS Profile exists and create one if not
Write-Host 'Checking for or creating PS Profile...' `n
if (!(Test-Path -Path $Profile)) {
    New-Item -ItemType File -Path $Profile -Force | & $output
}

# Reload profile
.$Profile

# Set execution policy to allow online PS scripts for this session
Write-Host 'Setting Execution Policy for Session...' `n
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force

# Install NuGet Package Manager
Write-Host 'Installing NuGet Package Manager...' `n
Install-PackageProvider -Name 'NuGet' -Force | & $output

# Set MS Powershell Gallery to trusted source
Write-Host 'Trusting MS Powershell Gallery...' `n
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

# Install and import Windows Update moduel
Write-Host 'Installing Windows Update Module...' `n
Install-Module 'PSWindowsUpdate'
Import-Module 'PSWindowsUpdate'

# Get updates and install
do {
    $updateChoice = Read-Host -Prompt 'Would you like to run updates now? (y|n)'
} until ($updateChoice -eq 'y' -Or $updateChoice -eq 'n')

if ($updateChoice -eq 'y') {
    Write-Host `n 'Installing Windows Updates...' `n
    $updates = Get-WindowsUpdate
    do {
        Install-WindowsUpdate -AcceptAll -IgnoreReboot | & $output
        $updates = Get-WindowsUpdate
    } until ($updates.count -eq 0)
}

# Set Start Menu Layout to Empty
Copy-Item './LayoutModification.xml' C:\Users\$env:UserName\AppData\Local\Microsoft\Windows\Shell -Force
Remove-Item -Force -Recurse -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store'

# Set File Explorer Options
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key 'Hidden' 1                    # Show hidden file
Set-ItemProperty $key 'HideFileExt' 0               # Show file extensions
Set-ItemProperty $key 'ShowCortanaButton' 0         # Hide Cortana button on taskbar
Set-ItemProperty $key 'LaunchTo' 1                  # Launch Explorer to "This PC"
Set-ItemProperty $key 'AutoCheckSelect' 1           # Show check boxes in explorer

$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
Set-ItemProperty $key 'SearchboxTaskbarMode' 0     # Hide search box on taskbar

Stop-Process -processname explorer

#Check if Windows 10 is 'N' version
$version = (Get-WmiObject -class Win32_OperatingSystem).Caption

#Install missing media pack
if ($version -match ' N') {
    Get-WindowsCapability -Online | Where-Object -Property Name -like "*media*" | Add-WindowsCapability -Online
}

# Setup Chocolatey package manager 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) | & $output

# Install Apps using Chocolatey
# GUI Package Manager
Write-Host 'Installing Chocolatey GUI...' `n
choco install chocolateygui -y | & $output
# Utility Apps
Write-Host 'Installing AIDA64-Extreme...' `n
choco install aida64-extreme -y | & $output
# MS Office Apps
Write-Host 'Installing MS Office...' `n
choco install office365business -y -params '"/productid:O365HomePremRetail /exclude:""Access OneNote Publisher""' | & $output
choco pin office365business -y
# Media Apps
Write-Host 'Installing Adobe Creative Cloud...' `n
choco install adobe-creative-cloud -y | & $output
choco pin adobe-creative-cloud -y

# Dowload and install MS Store App Sideloader and dependencies
Write-Host 'Installing WinGet Package Manager...' `n
#Microsoft.VCLibs.140.00.UWPDesktop_8wekyb3d8bbwe
Add-AppxPackage -Path './appx-files/Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx'

#Microsoft.VCLibs.140.00_8wekyb3d8bbwe
Add-AppxPackage -Path './appx-files/Microsoft.VCLibs.140.00_14.0.29231.0_x64__8wekyb3d8bbwe.Appx'

#WinGet Installer
$url = 'https://github.com/microsoft/winget-cli/releases/download/v0.2.2941/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
$path = './Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
Invoke-WebRequest -Uri $url -OutFile $path
Add-AppxPackage -Path $path

# Install PowerShell 7
Write-Host 'Installing Powershell 7...' `n
winget install 'PowerShell'| & $output
Write-Host 'Enabling PS7 Menu Actions...' `n
reg import .\reg-files\Add_64-bit_PowerShell_7_Open_here_context_menu_on_64-bit_Windows_10.reg

# Install Other Desktop Apps
winget install 'Logitech Gaming Hub' | & $output
winget install 'PowerToys' | & $output
winget install 'Visual Studio Code' | & $output
winget install 'Visual Studio Community' | & $output
winget install 'NordVPN' | & $output
winget install 'Notepad++' | & $output
winget install 'Nvidia GeForce Experience' | & $output
winget install 'Plex for Windows' | & $output
winget install 'Python' | & $output
winget install 'Spotify' | & $output
winget install 'Steam' | & $output
winget install 'Google Chrome' | & $output
winget install 'Firefox' | & $output
winget install 'VLC media player' | & $output
winget install 'Teamviewer' | & $output
winget install 'Discord' | & $output
winget install 'Dropbox' | & $output
winget install 'TreeSize Free' | & $output
winget install 'Link Shell Extension' | & $output
winget install 'Audacity' | & $output
winget install 'PuTTY' | & $output
winget install 'CPU-Z' | & $output
winget install '7Zip' | & $output
winget install 'WinSCP' | & $output
winget install 'GitHub Desktop' | & $output
winget install 'Ubisoft Connect' | & $output
winget install 'Teamspeak Client' | & $output

# Install MS Store Apps
winget install 'Windows Terminal' | & $output
winget install 'Ubuntu' | & $output
winget install 'Debian' | & $output

# Delete Desktop Shortcuts
Write-Host 'Removing Desktop shortcuts...' `n
Remove-Item C:\Users\$env:UserName\Desktop\*.lnk -Force
Remove-Item C:\Users\Public\Desktop\*.lnk -Force

# Enable WSL2
Write-Host 'Enabling WSL2...' `n
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart | & $output

#Stop Logging
Stop-Transcript