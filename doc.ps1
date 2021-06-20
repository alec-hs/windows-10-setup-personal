$NewRootPath = "$env:UserProfile\OneDrive\Computers\$env:ComputerName\"
$regUSF = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
 
$Folders = "Personal,My Pictures,My Music,My Video,Desktop"
$Folders = $Folders.Split(",")
$FolderNames = "Documents,Pictures,Music,Videos,Desktop"
$FolderNames = $FolderNames.Split(",")
 
$ArrayPosition = -1
 
Function Move-KnownFolderPath {
    Param (
            [Parameter(Mandatory = $true)]
            [ValidateSet('Desktop', 'Documents', 'Music', 'Pictures', 'Videos')]
            [string]$KnownFolder,
            [Parameter(Mandatory = $true)]
            [string]$Path
    )
 
    # Known Folder GUIDs
    $KnownFolders = @{
        'Desktop' = @('B4BFCC3A-DB2C-424C-B029-7FE99A87C641');
        'Documents' = @('FDD39AD0-238F-46AF-ADB4-6C85480369C7','f42ee2d3-909f-4907-8871-4c22fc0bf756');
        'Music' = @('4BD8D571-6D19-48D3-BE97-422220080E43','a0c69a99-21c8-4671-8703-7934162fcf1d');
        'Pictures' = @('33E28130-4E1E-4676-835A-98395C3BC3BB','0ddd015d-b06c-45d5-8c4c-f59713854639');
        'Videos' = @('18989B1D-99B5-455B-841C-AB7C74E4DDFC','35286a68-3c57-41a1-bbb1-0eae73d76c95');
    }
 
    $FolderGUID = ([System.Management.Automation.PSTypeName]'KnownFolders').Type
	#create the Type entry if it does not yet exist / relates to the Registry eventually
    If (-not $FolderGUID) {
        $KnownFolderGUID = @'
[DllImport("shell32.dll")]
public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
'@
        $FolderGUID = Add-Type -MemberDefinition $KnownFolderGUID -Name 'KnownFolders' -Namespace 'SHSetKnownFolderPath' -PassThru
    }
 
    If(!(Test-Path $Path)){
		#in case folder does yet exist, we create it
		Try {
			New-Item -Path $Path -Type Directory -Force -ErrorAction SilentlyContinue
		} Catch {}
    }
	#set the new folder path
	ForEach ($TmpGUID in $KnownFolders[$KnownFolder]) {
		$tmp = $FolderGUID::SHSetKnownFolderPath([ref]$TmpGUID, 0, 0, $Path)	
	}	
	Attrib +r $Path	#needed to retain the icon 
}
 
ForEach ($Folder In $Folders)
{	
	$ArrayPosition += 1
    Write-Host "Working on folder"$FolderNames[$ArrayPosition] -BackgroundColor DarkGreen
    $SourcePath = (Get-ItemProperty -Path $regUSF -Name $Folder).$Folder
    If ($SourcePath.Length -gt 0)
    {
		Write-Host "Checking source path: $SourcePath"
		If ((Test-Path -Path $SourcePath)){
			Write-Host "Path is accessible..."
			$CompSource = Get-Item -Path $SourcePath
			$CompareResult = $false
			If ((Test-Path -Path ($NewRootPath + "\" + $CompSource.Name))){
				$CompTarget = Get-Item -Path ($NewRootPath + "\" + $CompSource.Name)
				Write-Host "Comparing Source Path: "$CompSource.FullName
				Write-Host "With Target Path:    "$CompTarget.FullName
				If ($CompSource.FullName.ToLower() -eq $CompTarget.FullName.ToLower()){
					$CompareResult = $true
				} Else {
					$CompareResult = $false
				}
			} Else {
				Write-Host "Target Path does not exist..."
			}
			If ($CompareResult -eq $true){
				Write-Host "Source and Target path are identical: $CompTarget" -ForegroundColor Yellow
				Write-Host "Not applying any changes!" -ForegroundColor Yellow
				#Pause
			} Else {
				$SourceFolder = Get-Item -Path $SourcePath
				Write-Host "Accessing source folder $SourceFolder" -ForegroundColor Green
				If (!(Test-Path -Path ($NewRootPath + '\' + $SourceFolder.Name))){
					Move-KnownFolderPath -KnownFolder ("" + $FolderNames[$ArrayPosition] + "") -Path ($NewRootPath + '\' + $FolderNames[$ArrayPosition])
					$TargetPath = Get-Item -Path ("$NewRootPath\" + $FolderNames[$ArrayPosition])
					Write-Host "Created new folder $TargetPath"
					
					Write-Host "Moving data from: $SourcePath"
					Write-Host "To folder:      $TargetPath"
					Write-Host "This can take several minutes..."
					Move-Item -Path ("" + $SourcePath + "\*") -Destination $TargetPath -Force -ErrorAction SilentlyContinue
					Write-Host "Done moving data."
				} Else {
					Write-Host "Warning - Target Path exists already: $CompTarget" -ForegroundColor Yellow
					Write-Host "Files will not be moved, registry still will be adjusted to the target path!" -ForegroundColor Yellow
					#Pause
					Move-KnownFolderPath -KnownFolder ("" + $FolderNames[$ArrayPosition] + "") -Path ($NewRootPath + '\' + $FolderNames[$ArrayPosition])
					Write-Host "Finished adjusting registry."
				}
			}
		} Else {
			Write-Host "SourceFolder Path invalid: $SourcePath" -ForegroundColor Red
		}
    } 
	Write-Host "Done processing"$FolderNames[$ArrayPosition] -BackgroundColor Blue
	#Pause
}

Write-Host "Script finished processing" -ForegroundColor Green
#Pause
