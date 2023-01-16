## Comandos powershell de consulta en AD
```
Get-ADGroup
Get-ADUser
```
## Opcionales para despliegue de propiedades completas
```
-Properties * | Select *
Get-ADGroup SpamAdmins -Properties * | Select *
```
## Comando para definir ocultar de Global Address List
```
Set-ADGroup SpamAdmins -replace @{msExchHideFromAddressLists=$true}
```