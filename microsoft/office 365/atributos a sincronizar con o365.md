**Attribute Editor desde Domain Controller con Syncro en Office365-Azure AD**
Direccion de SMTP por defecto
```
proxyAddresses: SMTP:hmaslowski@tqcorp.com.ar (Mayuscula setea la principal)
smtp:hmaslowski@tqcorp.com
```
**Login - UPN por defecto**
```
userPrincipalName: hmaslowski@tqcorp.com.ar
Get-ADUser mdojman -Properties * | select *

Set-ADUser -Identity "mdojman" -Replace @{UserPrincipalName="mdojman@tqcorp.com"}
Set-ADUser -Identity "mdojman" -Clear "proxyAddresses"
Set-ADUser -Identity "mdojman" -Add @{ProxyAddresses="SMTP:mdojman@tqcorp.com"}
```