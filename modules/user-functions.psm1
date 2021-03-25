# Remove all Task Bar items
Function Remove-TaskBarItems {
    Write-Output "Unpinning all Taskbar icons..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -Type Binary -Value ([byte[]](255))
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve" -ErrorAction SilentlyContinue
}

# Remove all pinned Start Menu items & hide recent apps
Function Remove-StartMenuItems {
    Write-Output "Unpinning all Start Menu tiles..."
	If ([System.Environment]::OSVersion.Version.Build -ge 15063 -And [System.Environment]::OSVersion.Version.Build -le 16299) {
		Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" -Include "*.group" -Recurse | ForEach-Object {
			$data = (Get-ItemProperty -Path "$($_.PsPath)\Current" -Name "Data").Data -Join ","
			$data = $data.Substring(0, $data.IndexOf(",0,202,30") + 9) + ",0,202,80,0,0"
			Set-ItemProperty -Path "$($_.PsPath)\Current" -Name "Data" -Type Binary -Value $data.Split(",")
		}
	} ElseIf ([System.Environment]::OSVersion.Version.Build -ge 17134) {
		$key = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current"
		$data = $key.Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
		Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $data
		Stop-Process -Name "ShellExperienceHost" -Force -ErrorAction SilentlyContinue
	}

    # Hide recent apps in Start Menu
    $key = "HKLM:\Software\Policies\Microsoft\Windows\Explorer"
    if (!(Test-Path $key)) {
        New-Item $key
    }
    Set-ItemProperty $key "HideRecentlyAddedApps" 1         
}

# Remove Desktop Shortcuts
Function Remove-DesktopShortcuts {
    # check paths first
    Write-Output "Removing Desktop shortcuts..." `n `n
    $paths = @("C:\Users\$env:UserName\Desktop\*.lnk","C:\Users\Public\Desktop\*.lnk","C:\Users\$env:UserName\OneDrive\$env:ComputerName\Desktop\*.lnk")
    $paths.ForEach({
        if (!(Test-Path $_)) {
            Remove-Item $_ -Force
        }
    })
}

# Set Explorer Options in Registry
Function Set-ExplorerOptions {
    Write-Output "Setting File Explorer Options..."
    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty $key "Hidden" 1                        # Show hidden file
    Set-ItemProperty $key "HideFileExt" 0                   # Show file extensions
    Set-ItemProperty $key "ShowCortanaButton" 0             # Hide Cortana button on taskbar
    Set-ItemProperty $key "LaunchTo" 1                      # Launch Explorer to "This PC"
    Set-ItemProperty $key "AutoCheckSelect" 1               # Show check boxes in explorer
    Set-ItemProperty $key "MMTaskbarMode" 2                 # Task bar icon on on screen where open
    Set-ItemProperty $key "DontPrettyPath" 1                # Keep user path case
    Set-ItemProperty $key "MultiTaskingAltTabFilter" 3      # Alt Tab to Windows only, no Edge Tabs

    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    Set-ItemProperty $key "SearchboxTaskbarMode" 0          # Hide search box on taskbar
    Set-ItemProperty $key "BingSearchEnabled" 0             # Disable Bing Search in Start Menu

    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    Set-ItemProperty $key "SystemPaneSuggestionsEnabled" 0  # Disable suggestions in Start Menu

    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty $key "HwSchMode" 1                     # Turn on GPU Scheduling

    $key = "HKLM:\Software\Policies\Microsoft\Windows\System"
    Set-ItemProperty $key "PublishUserActivities" 0         # Disables Activity History

    $key = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    Set-ItemProperty $key "HideSCAMeetNow" 1                # Hide "Meet Now" option on taskbar
}

# Hide all icons from desktop
Function Set-DesktopIconsHidden {
	Write-Output "Hiding all icons from desktop..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideIcons" -Value 1
}

# Move home folders to OneDrive
Function Move-HomeFolders {
   
}
