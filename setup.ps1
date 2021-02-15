# Start Transcript
Start-Transcript -Path ".\setup.log"
Pause

# Set execution policy to allow online PS scripts for this session
Write-Output "Setting Execution Policy for Session..." `n
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force
Pause

# Import Module Files
Write-Output "Importing Modules..."
Import-Module ".\modules\core-functions.psm1"
Import-Module ".\modules\computer-functions.psm1"
Import-Module ".\modules\user-functions.psm1"
Import-Module ".\modules\app-functions.psm1"
Pause

# Set File Explorer options
Set-ExplorerOptions
Pause

TIME LINE SETTINGS
ALT TAB Settings
Powertoys settings save
dot files
dot files repo
scheduled task to commit dot
gpg key

# Hide all Desktop Icons
Set-DesktopIconsHidden
Pause

# Clean Start Menu
Remove-StartMenuItems
Pause

# Clean Task Bar
Remove-TaskBarItems
Pause

# Move Home Folders to OneDrive
Move-HomeFolders
Pause

# Restart Explorer
Restart-Explorer
Pause

# Remove Bloatware Apps
Remove-BloatApps
Pause

# Dowload and install winget and dependencies
Install-WinGet
Pause

# Install My Apps with Winget
#Install-MyAppsWinget
Pause

# Install Choco
Install-Choco
Pause

# Install My Apps with Choclatey
#Install-MyAppsChoco
Pause

# Install Logitech Gaming Hub
Install-LGHub
Pause

# Install Elgato Wave Link
Install-WaveLink
Pause

# Enable Windows Features
Enable-HyperV
Enable-AppGuard
Enable-WSL2
Pause

# Set ps1 files to open in PS7
Set-PS7Default
Pause

# Reload PATH from Environment Variables
Reset-Path
Pause

# Disable Hibernate
Disable-Hibernate
Pause

# Delete Desktop Shortcuts
Remove-DesktopShortcuts
Pause

# Restart explorer
Restart-Explorer
Pause

# Delete script files 
Remove-ScriptFiles
Pause

# End Transcript
Stop-Transcript
Pause

# End Script
Show-ScriptEnding
Pause

# Restart PC
Restart-Computer