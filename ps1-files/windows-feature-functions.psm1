Function Enable-HyperV {
    Write-Host "Enabling Hyper V..." `n
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
}

Function Enable-AppGuard {
    Write-Host "Enabling MS Defender App Guard..." `n
    Enable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -All -NoRestart
}

Function Enable-WSL2 {
    Write-Host "Enabling WSL2..." `n
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
}

Function Disable-Hibernate {
    powercfg.exe /h off
}