Function Restart-Explorer {
    Write-Output "Restarting Explorer process..."
    Stop-Process -processname explorer
}

Function Restart-Computer {
    Write-Output "Restarting PC..."
    shutdown -r -t 0 
}

Function Reset-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") 
}

# Removes Script Related Files
Function Remove-ScriptFiles {
    Write-Output "Removing files related to this script..."
    Remove-Item .\app-files -Recurse -Force
    Remove-Item .\README.md -Force
    Remove-Item .\setup.ps1 -Force
}

Function Show-ScriptEnding {
    # Notify User
    Write-Output "`n### Script Complete ###`n`nLog can be found here: .\setup.log`n`n### PC will now reboot ###"
    Pause
} 
