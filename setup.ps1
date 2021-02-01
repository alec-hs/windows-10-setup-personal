# Set execution policy to allow online PS scripts for this session
Write-Host 'Setting Execution Policy for Session...' `n
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force

# Disable Bing Search in Start Menu
Write-Host "Disabling Bing Search in Start Menu..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0

# Set Start Menu layout to empty
Write-Host "Emptying Start Menu..."
Copy-Item './LayoutModification.xml' C:\Users\$env:UserName\AppData\Local\Microsoft\Windows\Shell -Force
Remove-Item -Force -Recurse -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store'

# Set File Explorer options
Write-Host "Setting File Explorer Options..."
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
#Set-ItemProperty $key 'Hidden' 1                        # Show hidden file
Set-ItemProperty $key 'HideFileExt' 0                   # Show file extensions
Set-ItemProperty $key 'ShowCortanaButton' 0             # Hide Cortana button on taskbar
Set-ItemProperty $key 'LaunchTo' 1                      # Launch Explorer to "This PC"
Set-ItemProperty $key 'AutoCheckSelect' 1               # Show check boxes in explorer

$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
Set-ItemProperty $key 'SearchboxTaskbarMode' 0          # Hide search box on taskbar

$key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
Set-ItemProperty $key "HideSCAMeetNow" 1                # Hide "Meet Now" option on taskbar

# Restart explorer
Write-Host "Restarting Explorer process..."
Stop-Process -processname explorer

# Dowload and install winget and dependencies
Write-Host 'Installing WinGet Package Manager...' `n
# Microsoft.VCLibs.140.00.UWPDesktop_8wekyb3d8bbwe
Add-AppxPackage -Path './appx-files/Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx'

# winget cli
$url = 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
$path = './appx-files/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
Invoke-WebRequest -Uri $url -OutFile $path
Add-AppxPackage -Path $path

# Install Autoupdating Apps with WinGet
Write-Host 'Installing desktop apps...' `n

# Install Utility Apps
# -i : interative install for setting options
winget install 'PowerToys'
winget install 'Powershell' -i
winget install 'Windows Terminal'
winget install 'Google Chrome'
winget install 'NordVPN'
winget install 'Teamviewer'
winget install 'Dropbox'
winget install 'Rufus'

# Install Gaming Apps
winget install 'Nvidia GeForce Experience' -i
winget install 'Steam'
winget install 'Ubisoft Connect'
winget install 'Streamdeck' -i

# Install Comms Apps
winget install 'Teamspeak Client'
winget install 'Discord'

# Install Dev Apps
winget install 'Visual Studio Community'
winget install 'GitHub Desktop'
winget install 'Git' -i
winget install 'Python' -i

# Install Media Apps
winget install 'Plex For Windows'
winget install 'OBS Studio'

# Broken currently - moved to choco
#winget install 'ZeroTier' -i
#winget install 'Visual Studio Code' -i
#winget install 'Origin' -i

# Broken need manual install
#winget install 'Spotify' -i
#winget install 'Logitech Gaming Hub' -i

# Install WSL2 Distros
winget install 'Ubuntu'
winget install 'Debian'

# Enable WSL2
Write-Host 'Enabling WSL2...' `n
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart

# Setup Chocolatey package manager 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Update Choco Packages
Write-Host 'Updating Chocolatey Package List...' `n
choco upgrade all -y

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
choco install zerotier-one -y
choco install crystaldiskinfo -y
choco install crystaldiskmark -y
choco install scrcpy -y
choco install hcloud -y

# Dev Apps
choco install 'vscode' -y
choco pin add -n=vscode

# MS Office Apps
Write-Host 'Installing MS Office...' `n
choco install microsoft-office-deployment -y -params '"/64bit /product:HomeBusiness2019Retail /exclude:""Access OneNote Publisher""'
choco pin add -n=microsoft-office-deployment

# Media Apps
Write-Host 'Installing Adobe Creative Cloud...' `n
choco install vlc -y
choco install audacity -y
choco install adobe-creative-cloud -y
choco pin add -n=adobe-creative-cloud

# Upgrade Choco Packages
Write-Host 'Updating Chocolatey Package List...' `n
choco upgrade all -y

# Enable Hyper V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# Enable MS Defender App Guard
Enable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -All -NoRestart

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

# Restart explorer
Stop-Process -processname explorer

# Delete script files 
Remove-Item $PSScriptRoot\LayoutModification.xml -Force
Remove-Item $PSScriptRoot\appx-files -Recurse -Force
Remove-Item $PSScriptRoot\setup.ps1 -Force

# Restart PC
shutdown -r -t 0