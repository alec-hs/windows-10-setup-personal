# Set execution policy to allow online PS scripts for this session
Write-Host 'Setting Execution Policy for Session...' `n
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force

# Disable Bing Search in Start Menu
Write-Host "Disabling Bing Search in Start Menu..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0

# Set Start Menu layout to empty
Copy-Item './LayoutModification.xml' C:\Users\$env:UserName\AppData\Local\Microsoft\Windows\Shell -Force
Remove-Item -Force -Recurse -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store'

# Set File Explorer options
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key 'Hidden' 1                    # Show hidden file
Set-ItemProperty $key 'HideFileExt' 0               # Show file extensions
Set-ItemProperty $key 'ShowCortanaButton' 0         # Hide Cortana button on taskbar
Set-ItemProperty $key 'LaunchTo' 1                  # Launch Explorer to "This PC"
Set-ItemProperty $key 'AutoCheckSelect' 1           # Show check boxes in explorer

$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
Set-ItemProperty $key 'SearchboxTaskbarMode' 0      # Hide search box on taskbar

$key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
Set-ItemProperty $key "HideSCAMeetNow" 1            # Hide "Meet Now" option on taskbar

# Restart explorer
Stop-Process -processname explorer

# Dowload and install winget and dependencies
Write-Host 'Installing WinGet Package Manager...' `n
# Microsoft.VCLibs.140.00.UWPDesktop_8wekyb3d8bbwe
Add-AppxPackage -Path './appx-files/Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx'

# Microsoft.VCLibs.140.00_8wekyb3d8bbwe
Add-AppxPackage -Path './appx-files/Microsoft.VCLibs.140.00_14.0.29231.0_x64__8wekyb3d8bbwe.Appx'

# winget cli
$url = 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
$path = './appx-files/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
Invoke-WebRequest -Uri $url -OutFile $path
Add-AppxPackage -Path $path

# Install Autoupdating Apps with WinGet
Write-Host 'Installing desktop apps...' `n

# Install Utility Apps
winget install 'PowerToys' -i
winget install 'Powershell' -i
winget install 'Windows Terminal' -i
winget install 'Google Chrome' -i
winget install 'NordVPN' -i
winget install 'Teamviewer' -i
winget install 'Dropbox' -i

# Install Gaming Apps
winget install 'Logitech Gaming Hub' -i
winget install 'Nvidia GeForce Experience' -i
winget install 'Steam' -i
winget install 'Ubisoft Connect' -i
winget install 'Stream Deck' -i
winget install 'Origin' -i

# Install Comms Apps
winget install 'Teamspeak Client' -i
winget install 'Discord' -i

# Install Dev Apps
winget install 'Visual Studio Code' -i
winget install 'Visual Studio Community' -i
winget install 'GitHub Desktop' -i
winget install 'Git' -i
winget install 'Python' -i

# Install Media Apps
winget install 'Plex For Windows' -i
winget install 'Spotify' -i

# Install WSL2 Distros
winget install 'Ubuntu'
winget install 'Debian'

# Enable WSL2
Write-Host 'Enabling WSL2...' `n
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Setup Chocolatey package manager 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Apps using Chocolatey
# GUI Package Manager
Write-Host 'Installing Chocolatey GUI...' `n
choco install chocolateygui -y

# Utility Apps
Write-Host 'Installing AIDA64-Extreme...' `n
choco install 7zip -y
choco install treesizefree -y
choco install aida64-extreme -y
choco install putty -y
choco install LinkShellExtension -y
choco install winscp -y
choco install cpu-z -y

# MS Office Apps
Write-Host 'Installing MS Office...' `n
choco install microsoft-office-deployment -y -params '"/64bit /product:HomeBusiness2019Retail /exclude:""Access OneNote Publisher""'
choco pin microsoft-office-deployment -y

# Media Apps
Write-Host 'Installing Adobe Creative Cloud...' `n
choco install vlc -y
choco install audacity -y
choco install adobe-creative-cloud -y
choco pin adobe-creative-cloud -y

# Enable Hyper V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# Set ps1 files to open in PS7
$key = 'HKLM:\Software\Classes\Microsoft.PowerShellScript.1\Shell\Open\Command'
Set-ItemProperty $key '(Default)' '"C:\Program Files\PowerShell\7\pwsh.exe" "%1"'

# Reload PATH from Environment Variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") 

# Disable Hibernate
powercfg.exe /h off

# Delete Desktop Shortcuts
Write-Host 'Removing Desktop shortcuts...' `n
Remove-Item C:\Users\$env:UserName\Desktop\*.lnk -Force
Remove-Item C:\Users\Public\Desktop\*.lnk -Force

#Restart explorer
Stop-Process -processname explorer