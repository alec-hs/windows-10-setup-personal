# Set execution policy to allow online PS scripts for this session
Write-Host 'Setting Execution Policy for Session...' `n
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force

# Install Powershell 7
Invoke-Expression "& { $(Invoke-Restmethod https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet -AddExplorerContextMenu"

# Set ps1 files to open in PS7
$key = 'HKLM:\Software\Classes\Microsoft.PowerShellScript.1\Shell\Open\Command'
Set-ItemProperty $key '(Default)' '"C:\Program Files\PowerShell\7\pwsh.exe" "%1"'

# Reload PATH from Environment Variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") 

# Switch to PS7
$path = Get-Location
$launch = 'cmd /c start pwsh -Command ./phase-1.ps1 ' + $path
Invoke-Expression $launch