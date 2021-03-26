## TODO ##
#Powertoys settings save
#dot files
#dot files repo
#scheduled task to commit dot
#gpg key

# Start Transcript
Start-Transcript -Path ".\setup.log"

# Set execution policy to allow online PS scripts for this session
Write-Output "Setting Execution Policy for Session..."`n
Set-ExecutionPolicy -ExecutionPolicy 'Bypass' -Scope 'Process' -Force

# Import Module Files
Write-Output "Importing Modules..."
Import-Module ".\modules\core-functions.psm1"
Import-Module ".\modules\computer-functions.psm1"
Import-Module ".\modules\user-functions.psm1"
Import-Module ".\modules\app-functions.psm1"
Import-Module BitsTransfer

# Set Networks to Private
Set-NetworkTypes

# Set File Explorer options
Set-ExplorerOptions

# Hide all Desktop Icons
Set-DesktopIconsHidden

# Clean Start Menu
Remove-StartMenuItems

# Clean Task Bar
Remove-TaskBarItems

# Move Home Folders to OneDrive
Move-HomeFolders

# Restart Explorer
Restart-Explorer

# Remove Bloatware Apps
Remove-BloatApps

# Dowload and install winget and dependencies
Install-WinGet

# Install My Apps with Winget
Install-MyAppsWinget

# Install Choco
Install-Choco

# Install My Apps with Choclatey
Install-MyAppsChoco

# Install Logitech Gaming Hub
Install-LGHub

# Install Elgato Wave Link
Install-WaveLink

# Enable Windows Features
Enable-HyperV
Enable-AppGuard
Enable-WSL2

# Set ps1 files to open in PS7
Set-PS7Default

# Reload PATH from Environment Variables
Reset-Path

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

# End Script
Show-ScriptEnding

# Restart PC
Restart-Computer