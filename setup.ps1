# Start Transcript
Start-Transcript -Path "$PSScriptRoot\setup.log"

# Set execution policy to allow online PS scripts for this session
Write-Host "Setting Execution Policy for Session..." `n
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force

# Import Module Files
Import-Module ".\ps1-files\app-functions.psm1"
Import-Module ".\ps1-files\user-profile-functions.psm1"
Import-Module ".\ps1-files\core-functions.psm1"

# Set File Explorer options
Write-Host "Setting File Explorer Options..."
$key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty $key "Hidden" 1                        # Show hidden file
Set-ItemProperty $key "HideFileExt" 0                   # Show file extensions
Set-ItemProperty $key "ShowCortanaButton" 0             # Hide Cortana button on taskbar
Set-ItemProperty $key "LaunchTo" 1                      # Launch Explorer to "This PC"
Set-ItemProperty $key "AutoCheckSelect" 1               # Show check boxes in explorer
Set-ItemProperty $key "MMTaskbarMode" 2                 # Task bar icon on on screen where open
Set-ItemProperty $key "DontPrettyPath" 1                # Keep user path case

$key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
Set-ItemProperty $key "SearchboxTaskbarMode" 0          # Hide search box on taskbar
Set-ItemProperty $key "BingSearchEnabled" 0             # Disable Bing Search in Start Menu

$key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
Set-ItemProperty $key "SystemPaneSuggestionsEnabled" 0  # Disable suggestions in Start Menu

$key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty $key "HwSchMode" 1                     # Turn on GPU Scheduling

$key = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
Set-ItemProperty $key "HideSCAMeetNow" 1                # Hide "Meet Now" option on taskbar



# Clean Start Menu
Remove-StartMenuItems

# Clean Task Bar
Remove-TaskBarItems

# Move Home Folders to OneDrive
Move-HomeFolders

# Restart explorer
Restart-Explorer

# Remove Bloatware Apps
Remove-BloatApps

# Dowload and install winget and dependencies
Install-WinGet

# Install Autoupdating Apps with WinGet
Write-Host "Installing desktop apps..." `n

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
winget install 'Nvidia GeForce Experience'
winget install 'Steam'
winget install 'Ubisoft Connect'
winget install 'Streamdeck'
winget install 'Logitech Gaming Hub'

# Install Comms Apps
winget install 'Teamspeak Client'
winget install 'Discord'

# Install Dev Apps
winget install 'Visual Studio Code (System Installer - x64)' -i
winget install 'Visual Studio Community'
winget install 'GitHub Desktop'
winget install 'Git' -i
winget install 'Python' -i

# Install Media Apps
winget install 'Plex For Windows'
winget install 'OBS Studio'

# Install WSL2 Distros
winget install 'Ubuntu'
winget install 'Debian'

# Setup Chocolatey package manager 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Update Choco Packages
Write-Host "Updating Chocolatey Package List..." `n
choco upgrade all -y

# Install Apps using Chocolatey
# GUI Package Manager
Write-Host "Installing Chocolatey GUI..." `n
choco install chocolateygui -y

# Utility Apps
Write-Host "Installing AIDA64-Extreme..." `n
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

# MS Office Apps
Write-Host "Installing MS Office..." `n
choco install microsoft-office-deployment -y -params '"/64bit /product:HomeBusiness2019Retail /exclude:""Access OneNote Publisher""'
choco pin add -n=microsoft-office-deployment

# Media Apps
Write-Host "Installing Adobe Creative Cloud..." `n
choco install vlc -y
choco install audacity -y
choco install spotify -y
choco pin add -n=spotify
choco install adobe-creative-cloud -y
choco pin add -n=adobe-creative-cloud

# Upgrade Choco Packages
Write-Host "Updating Chocolatey Package List..." `n
choco upgrade all -y

# Install Logitech Gaming Hub
Install-LGHub

# Enable Windows Features
Enable-HyperV
Enable-AppGuard
Enable-WSL2

# Set ps1 files to open in PS7
Set-PS7Default

# Reload PATH from Environment Variables
Reload-Path

# Disable Hibernate
Disable-Hibernate

# Delete Desktop Shortcuts
Remove-DesktopShortcuts

# Restart explorer
Restart-Explorer

# Delete script files 
Remove-ScriptFiles

# End Transcript
Stop-Transcript

# Notify User
Write-Host "`n### Script Complete ###`n`nLog can be found here: $PSScriptRoot\setup.log`n`n### PC will now reboot ###"
Pause

# Restart PC
Restart-Computer