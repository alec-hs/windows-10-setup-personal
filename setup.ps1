# Currently tested and working on WIN10 x64 v20H2
# Need to open PS as admin and Set-Location to script folder
# Reg import steps will through error if run in PS ISE

# Check if PS Profile exists and create one if not
Write-Host 'Checking for or creating PS Profile...' `n
if (!(Test-Path -Path $Profile)) {
    New-Item -ItemType File -Path $Profile -Force
}

# Reload profile
.$Profile

# Set execution policy to allow online PS scripts for this session
Write-Host 'Setting Execution Policy for Session...' `n
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force

# Install NuGet Package Manager
Write-Host 'Installing NuGet Package Manager...' `n
Install-PackageProvider -Name 'NuGet' -Force | Out-Null

# Set MS Powershell Gallery to trusted source
Write-Host 'Trusting MS Powershell Gallery...' `n
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

# Install and import Windows Update moduel
Write-Host 'Installing Windows Update Module...' `n
Install-Module 'PSWindowsUpdate'
Import-Module 'PSWindowsUpdate'

# Get updates and install
do {
    Write-Host 'If updates are not run most app instals will be skipped.'
    $updateChoice = Read-Host -Prompt 'Would you like to run updates now? (y|n)'
} until ($updateChoice -eq 'y' -Or $updateChoice -eq 'n')

if ($updateChoice -eq 'y') {
    Write-Host 'Installing Windows Updates...' `n
    $updates = Get-WindowsUpdate
    do {
        Install-WindowsUpdate -AcceptAll -IgnoreReboot | Out-Null
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

# Setup Chocolatey package manager 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Apps using Chocolatey
# GUI Package Manager
choco install chocolateygui -y
# Utility Apps
choco install aida64-extreme -y
# MS Office Apps
choco install office365business -y -params '"/productid:O365HomePremRetail /exclude:""Access OneNote Publisher""'
choco pin office365business -y
# Media Apps
choco install adobe-creative-cloud -y
choco pin adobe-creative-cloud -y

if ($updateChoice -eq 'y') {
    # Dowload and install MS Store App Sideloader
    $url = 'https://github.com/microsoft/winget-cli/releases/download/v0.2.2941/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
    $path = './Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
    Invoke-WebRequest -Uri $url -OutFile $path
    Add-AppxPackage -Path $path

    # Install PowerShell 7
    winget install 'PowerShell'
    reg import .\reg-files\Add_64-bit_PowerShell_7_Open_here_context_menu_on_64-bit_Windows_10.reg

    # Install Other Desktop Apps
    winget install 'Logitech Gaming Hub'
    winget install 'PowerToys'
    winget install 'Visual Studio Code'
    winget install 'Visual Studio Community'
    winget install 'NordVPN'
    winget install 'Notepad++'
    winget install 'Nvidia GeForce Experience'
    winget install 'Plex for Windows'
    winget install 'Python'
    winget install 'Spotify'
    winget install 'Steam'
    winget install 'Google Chrome'
    winget install 'Firefox'
    winget install 'VLC media player'
    winget install 'Teamviewer'
    winget install 'Discord'
    winget install 'Dropbox'
    winget install 'TreeSize Free'
    winget install 'Link Shell Extension'
    winget install 'Audacity'
    winget install 'PuTTY'
    winget install 'CPU-Z'
    winget install '7Zip'
    winget install 'WinSCP'
    winget install 'GitHub Desktop'
    winget install 'Ubisoft Connect'
    winget install 'Teamspeak Client'

    # Install MS Store Apps
    winget install 'Windows Terminal'
    winget install 'Ubuntu'
    winget install 'Debian'
}

# Delete Desktop Shortcuts
Remove-Item C:\Users\$env:UserName\Desktop\*.lnk -Force
Remove-Item C:\Users\Public\Desktop\*.lnk -Force

# Enable WSL2
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart