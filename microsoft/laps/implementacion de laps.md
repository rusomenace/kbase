# Implementacion Microsoft LAPS (Deprecado)

- [Que es Windows LAPS?](https://learn.microsoft.com/es-es/windows-server/identity/laps/laps-overview)
- [Video sintetizado](https://www.youtube.com/watch?v=iI1XA2G420U&t=604s)
- [Descargas en MS](https://www.microsoft.com/en-us/download/details.aspx?id=46899)

## Notas importantes
- La instalacion de LAPS requiere permisos de modificacion del esquema de Active Directory
- La instalacion del modulo de LAPS requiere que los servidores o estaciones de trabajo involucradas reinicien minimamente 1 vez y puede que hasta 2
- El deploy de LAPS es via GPO

## Implementacion

1
Realizar instalacion completa de LAPS en el controlador de dominio. Cuando se dice completa es elegir todos los componentes en wizard de instalacion.
El archivo necesario para servidores y estaciones de trabajo de 64 bits es: LAPS.x64.msi

# Implementacion de Windows LAPS
Nueva version de LAPS que viene incorporada en windows 2016 en adelante:

Ref: https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-scenarios-windows-server-active-directory

Este es el nuevo script de consulta desde el domain controller:
```
# Prompt for the remote computer name
$RemoteComputer = Read-Host -Prompt "Enter the remote computer name or IP address"

# Use Invoke-Command to run gpupdate remotely
Invoke-Command -ComputerName $RemoteComputer -ScriptBlock {
    gpupdate /force
}

# Get the LAPS password for the specified computer
$Password = Get-LapsADPassword -Identity $RemoteComputer -AsPlainText

# Check if the password was found and display it on the same line
if ($Password) {
    Write-Host "LAPS Password for $RemoteComputer = $($Password.Password)" -ForegroundColor Green
} else {
    Write-Host "LAPS Password for $RemoteComputer not found."
}

# Add an empty line for space
Write-Host ""

```