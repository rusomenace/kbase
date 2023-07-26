## Modulo pswindowsupdate

Para instalarlo ejecutar los siguientes comandos
```powershell
Install-PackageProvider -Name NuGet -Force
Install-Module pswindowsupdate -Force
Enable-WURemoting
```
## Ejecutar una actualizacion full via PS con autoreinicio
```powershell
Get-WindowsUpdate -AcceptAll -Install -AutoReboot
```
## Se debe crear una regla conforme las siguiente configuraciones:

New inbound firewall rule, custom:

- program path: %SystemRoot%\System32\dllhost.exe
- protocol type: TCP
- local port: RPC Dynamic Ports
- remote port: all ports.

*En caso de dominio se debe habilitar solo en Domain*

## Powershell script para invocar remotamente una actualizacion con nombre de equipo
```powershell
$RemoteServer = read-host "Server name"
Get-WindowsUpdate -verbose -computer $RemoteServer -AcceptAll -Install -AutoReboot
```

## Script completo de instalacion de modulo de PSWindowsUpdate y actualizacion de repositorio de Nuget
Este script se debe crear y voncular en una GPO para que aplique a todos los equipos
```powershell
# Verifica existencia de repositorio nuget si no lo instala

Set-ExecutionPolicy RemoteSigned -Force -Scope CurrentUser
Import-Module PowerShellGet

if (Get-PackageProvider NuGet -ErrorAction Ignore) {
    Write-Host -Foregroundcolor GREEN "Package provider exists"
    Get-PackageProvider NuGet -ErrorAction Ignore | Select-Object Version | Format-Table -HideTableHeaders
} 
else {
    Write-Host -Foregroundcolor RED "Package provider does not exist, installing..."
    Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
    Set-PSRepository -InstallationPolicy Trusted -Name PSGallery
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
```

## Archivo ```ServerList.csv```
Este archivo contiene el listado de los servers a ser actualizados, esta es una manera manual de invocar a los servidores.
La manera automatica de hacerlo es utilizando el comando ```Get-ADComputer``` de powershell y bajando a CSV el listado completo de los servidores.
```
servername
server_numero_1
server_numero_2
server_numero_3
```
## Actualizar todos los servidores de la lista
El siguiente script fuerza la actualizacion mediante el modulo de PSWindows update

_Nota: Es obligatorio que la regla del firewall este presente para poder correr este comando_

```powershell
$ServerList=Import-Csv "C:\tools\ServerList.csv"
foreach ($Row in $ServerList){
$RemoteServer=$Row.servername
Get-WindowsUpdate -verbose -computer $RemoteServer -AcceptAll -Install -AutoReboot
}
```
Se debe reemplazar la ruta **C:\tools** por la ruta correcta donde reside el archivo .csv.
