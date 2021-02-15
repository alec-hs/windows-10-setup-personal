Function Enable-HyperV {
    Write-Output "Enabling Hyper V..." `n
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
}

Function Enable-AppGuard {
    Write-Output "Enabling MS Defender App Guard..." `n
    Enable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -All -NoRestart
}

Function Enable-WSL2 {
    Write-Output "Enabling WSL2..." `n
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
}

Function Disable-Hibernate {
    powercfg.exe /h off
}