## Trae el resultado de cuentas con script
```
Get-ADUser -Filter * | Set-ADUser -HomeDrive $null -ScriptPath $null
```

## Limpia el resultado de cuentas con script
```
Get-ADUser -Filter vssremote | Set-ADUser -scriptpath $null
```

## Guia conceptual para la depuracion de los scripts
https://www.oxfordsbsguy.com/2013/04/29/powershell-get-aduser-to-retrieve-logon-scripts-and-home-directories-part-2/

## Guia conceptual de manejo de mapeos con gpo
https://activedirectorypro.com/map-network-drives-with-group-policy/

## Dump de status de profiles
```
Get-ADUser -filter * -properties scriptpath, homedrive, homedirectory | ft Name, scriptpath, homedrive, homedirectory > C:\temp\users.txt
```