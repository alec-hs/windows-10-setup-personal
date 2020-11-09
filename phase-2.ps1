
#Check and run as admin
param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

# Dowload and install MS Store App Sideloader and dependencies
Write-Host 'Installing WinGet Package Manager...' `n
#Microsoft.VCLibs.140.00.UWPDesktop_8wekyb3d8bbwe
Add-AppxPackage -Path './appx-files/Microsoft.VCLibs.140.00.UWPDesktop_14.0.29231.0_x64__8wekyb3d8bbwe.Appx'

#Microsoft.VCLibs.140.00_8wekyb3d8bbwe
Add-AppxPackage -Path './appx-files/Microsoft.VCLibs.140.00_14.0.29231.0_x64__8wekyb3d8bbwe.Appx'

#WinGet Installer
$url = 'https://github.com/microsoft/winget-cli/releases/download/v0.2.2941/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
$path = './appx-files/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle'
Invoke-WebRequest -Uri $url -OutFile $path
Add-AppxPackage -Path $path

# Install other Desktop Apps
Write-Host 'Installing desktop apps...' `n
winget install 'Logitech Gaming Hub'
winget install 'PowerToys'
winget install 'Visual Studio Code'
winget install 'Visual Studio Community'
winget install 'NordVPN'
winget install 'Notepad++'
winget install 'Nvidia GeForce Experience'
winget install 'Python'
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
Write-Host 'Installing Microsoft Store apps...' `n
winget install 'Windows Terminal'
winget install 'Ubuntu'
winget install 'Debian'

# Enable WSL2
Write-Host 'Enabling WSL2...' `n
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

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
Set-ItemProperty $key 'SearchboxTaskbarMode' 0     # Hide search box on taskbar

# Setup Chocolatey package manager 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Apps using Chocolatey
# GUI Package Manager
Write-Host 'Installing Chocolatey GUI...' `n
choco install chocolateygui -y
# Utility Apps
Write-Host 'Installing AIDA64-Extreme...' `n
choco install aida64-extreme -y
# MS Office Apps
Write-Host 'Installing MS Office...' `n
choco install office365business -y -params '"/productid:O365HomePremRetail /exclude:""Access OneNote Publisher""'
choco pin office365business -y
# Media Apps
Write-Host 'Installing Adobe Creative Cloud...' `n
choco install adobe-creative-cloud -y
choco pin adobe-creative-cloud -y

# Delete Desktop Shortcuts
Write-Host 'Removing Desktop shortcuts...' `n
Remove-Item C:\Users\$env:UserName\Desktop\*.lnk -Force
Remove-Item C:\Users\Public\Desktop\*.lnk -Force

#Restart explorer
Stop-Process -processname explorer