```powershell
if (!(Get-Module -Name MSOnline -ListAvailable)) {
    Write-Host "El modulo MSOnline no está instalado, iniciando la instalación..."
    Install-Module -Name MSOnline -Force
    Import-Module -Name MSOnline
} else {
    Write-Host "El modulo MSOnline ya está instalado, importando..."
    Import-Module -Name MSOnline
}
```