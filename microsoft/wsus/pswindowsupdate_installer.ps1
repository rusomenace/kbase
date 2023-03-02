# Verifica existencia de repositorio nuget si no lo instala

if (Get-PackageProvider NuGet -ErrorAction Ignore) {
    Write-Host -Foregroundcolor GREEN "Package provider exists"
    Get-PackageProvider NuGet -ErrorAction Ignore | Select-Object Version | Format-Table -HideTableHeaders
} 
else {
    Write-Host -Foregroundcolor RED "Package provider does not exist, installing..."
    Install-PackageProvider -Name NuGet -Force
}

# Si NuGet esta instalado en una version por debajo de la 3.0.0.1 (01/02/2023) lo actualiza
# Es posible que requiera un reboot para que tome efecto el cambio

$NuGetLatest = "3.0.0.1"
$NuGet = Get-PackageProvider NuGet | Select-Object Version | Format-Table -HideTableHeaders | Out-String
$Nuget = $Nuget -replace '\s',''

if ($NuGet -ne $NuGetLatest) {
	Write-Host -Foregroundcolor RED "Package provider not latest and updating"
	Install-Module PackageManagement -Force
#	Restart-Computer
}

else {
	Write-Host -Foregroundcolor GREEN "Package provider up to date"
}

# Verifica modulo de pswindowsupdate si no lo instala
if (Get-InstalledModule PSWindowsUpdate -ErrorAction Ignore) {
    Write-Host -Foregroundcolor GREEN "Module exists"
    Get-InstalledModule PSWindowsUpdate -ErrorAction Ignore | Select-Object Version | Format-Table -HideTableHeaders
} 
else {
    Write-Host -Foregroundcolor RED "Module does not exist, installing..."
    Install-Module pswindowsupdate -Force    
}

# habilita administracion remota de windows update
Write-Host -Foregroundcolor GREEN "Enabling WU remoting..."
Enable-WURemoting
