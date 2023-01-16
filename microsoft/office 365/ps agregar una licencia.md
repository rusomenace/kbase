### Definir usage location para usuario
```
Set-MsolUser -UsageLocation AR -ObjectId 245100f1-1b46-47d9-a4a4-5294354596b6
```
### Agregar licencia a usuario
```
Set-MsolUserLicense -UserPrincipalName "mcaluki@tqcorp.com" -AddLicenses "tqcorp:O365_BUSINESS_PREMIUM"
```
### Consultar configuracion completa de usuario
```
Get-MsolUser -UserPrincipalName "mcaluki@tqcorp.com" | FL
```
