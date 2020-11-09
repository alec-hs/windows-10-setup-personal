
















# Setup post reboot tasks
Copy-Item -Path '/post-reboot-user.ps1' -Destination 'C:\Users\' + $env:UserName + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'





# Change Win+X Menu
Expand-Archive -Path './exe-files/hashlnk_0.2.0.0.zip' -DestinationPath './exe-files/'
Remove-Item -Path './exe-files/hashlnk_0.2.0.0.zip'

$group1 = 'C:\Users\' + $env:UserName + '\AppData\Local\Microsoft\Windows\WinX\Group1'
$group2 = 'C:\Users\' + $env:UserName + '\AppData\Local\Microsoft\Windows\WinX\Group2'
$group3 = 'C:\Users\' + $env:UserName + '\AppData\Local\Microsoft\Windows\WinX\Group3'

$source = 'C:\Users\' + $env:UserName + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Control Panel.lnk'
Copy-Item  $source $group2

$files = Get-ChildItem C:\Users\$env:UserName\AppData\Local\Microsoft\Windows\WinX\ -Recurse
foreach ($file in $files) {
    .\exe-files\hashlnk.exe $file
}


