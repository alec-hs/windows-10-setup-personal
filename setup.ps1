# Set execution policy to allow online PS scripts for this session
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force

# Install NuGet Package Manager
Install-PackageProvider -Name 'NuGet' -Force

# Set MS Powershell Gallery to trusted source
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

# Install and import Windows Update moduel
Install-Module 'PSWindowsUpdate'
Import-Module 'PSWindowsUpdate'

# Get updates and install
$updates = Get-WindowsUpdate
do {
    Install-WindowsUpdate -AcceptAll -IgnoreReboot
    $updates = Get-WindowsUpdate
} until ($updates.count -eq 0)

#Set Start Menu Layout
Copy-Item './LayoutModification.xml' C:\Users\$env:UserName\AppData\Local\Microsoft\Windows\Shell -Force
Remove-Item -Force -Recurse -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store'

# Set File Explorer Options
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key 'Hidden' 1
Set-ItemProperty $key 'HideFileExt' 0
Set-ItemProperty $key 'ShowCortanaButton' 0
Set-ItemProperty $key 'LaunchTo' 1

