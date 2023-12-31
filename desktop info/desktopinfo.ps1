# Define source and destination folders
$sourceFolder = "\\dc\tools\desktopinfo"
$destFolder = "C:\windows\desktopinfo"

# Function to copy and update files
function Sync-Folder {
    param (
        [string]$sourceFolder,
        [string]$destFolder
    )

    # Copy files from source to destination
    Get-ChildItem -Path $sourceFolder -Recurse | ForEach-Object {
        $destPath = $_.FullName.Replace($sourceFolder, $destFolder)
        New-Item -ItemType Directory -Path (Split-Path $destPath) -Force | Out-Null
        Copy-Item -Path $_.FullName -Destination $destPath -Force
    }
}

# Create destination folder if it doesn't exist and sync files
New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
Sync-Folder -sourceFolder $sourceFolder -destFolder $destFolder

# Add or update the registry key
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "DesktopInfo" -Value "C:\Windows\DesktopInfo\DesktopInfo64.exe"

