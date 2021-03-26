Function Set-NetworkTypes {
    $conns = Get-NetConnectionProfile

    foreach ($conn in $conns) {
        if ($conn.NetworkCategory -eq "Public") {
            $name = $conn.Name
            $confirm = Read-Host "Would you like to switch connection - $name - to Private? (y | n)"
            if ($confirm -eq "y") {
                Set-NetConnectionProfile -Name $name -NetworkCategory Private
            }
        }
    }
}

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
    Write-Output "Disable Hibernate..." `n
    powercfg.exe /h off
}