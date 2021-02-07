Function Restart-Explorer {
    Write-Host "Restarting Explorer process..."
    Stop-Process -processname explorer
}

Function Restart-Computer {
    Write-Host "Restarting PC..."
    shutdown -r -t 0 
}

Function Reload-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") 
}

# Removes Script Related Files
Function Remove-ScriptFiles {
    Write-Host "Removing files related to this script..."
    Remove-Item $PSScriptRoot\LayoutModification.xml -Force
    Remove-Item $PSScriptRoot\appx-files -Recurse -Force
    Remove-Item $PSScriptRoot\lghub-files -Recurse -Force
    Remove-Item $PSScriptRoot\README.md -Force
    Remove-Item $PSScriptRoot\setup.ps1 -Force
}
