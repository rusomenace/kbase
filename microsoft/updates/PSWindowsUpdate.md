# Utilizacion de PSWindowsUpdate en powershell para la instalacion de updates de windows

## Chequear si hay updates disponibles
Get-WindowsUpdate

## Solo descargar updates
Download-WindowsUpdate

## Instalar updates
Install-WindowsUpdate

## Chequeo si es necesario reiniciar
Get-WURebootStatus

## Ver el historial de updates en el sistema
Get-WUHistory

## Instalar un update especifico
Install-WindowsUpdate -KBArticleID KB4012606 -AcceptAll -AutoReboot

## Instalar solo updates de seguridad
Get-WindowsUpdate -Category 'SecurityUpdates' | Install-WindowsUpdate

## Esconder un update especifico
Hide-WindowsUpdate -KBArticleID KB4012606