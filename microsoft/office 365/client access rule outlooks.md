**Crea una regla que permite acceso exclusivo al CAS desde las IPs autorizadas**
```
New-ClientAccessRule -Name "OutlookAccessOnlyFromTQ" -Action DenyAccess -AnyOfProtocols OutlookAnywhere -ExceptAnyOfClientIPAddressesOrRanges 200.16.126.251,190.210.97.186	
```
**Configuracion de permiso**
```
Set-ClientAccessRule -Identity "OutlookAccessOnlyFromTQ" -Action DenyAccess -AnyOfProtocols UniversalOutlook,OutlookAnywhere -AnyOfClientIPAddressesOrRanges 0.0.0.0/0 -ExceptAnyOfClientIPAddressesOrRanges 200.16.126.251/32
```
**Configuracion actual de TQ**
```
Set-ClientAccessRule -Identity "OutlookAccessOnlyFromTQ" -Action DenyAccess -AnyOfProtocols UniversalOutlook,OutlookAnywhere -AnyOfClientIPAddressesOrRanges 0.0.0.0/0 -ExceptAnyOfClientIPAddressesOrRanges 200.16.126.251/32,190.210.97.186/32,190.104.235.128/24
```
**Verifica**
```
Get-ClientAccessRule OutlookAccessOnlyFromTQ | FL
```
**Chequear casillas con OWA Enabled**
```
Get-CASMailbox | where { $_.OWAEnabled } | ft DisplayName, OWAEnabled
```
**Lista de mailboxes con OWA Status**
```
Get-CASMailbox | ft DisplayName, OWAEnabled
```