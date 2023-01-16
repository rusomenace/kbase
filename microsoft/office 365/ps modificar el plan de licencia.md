### Consulta de SKU
```
Get-MsolAccountSku
```
```
AccountSkuId                   ActiveUnits WarningUnits ConsumedUnits
------------                   ----------- ------------ -------------
tqcorp:FLOW_FREE               10000       0            1
tqcorp:O365_BUSINESS_PREMIUM   81          0            71
tqcorp:POWER_BI_STANDARD       1000000     0            3
```
### Consulta licencia aplicada a usuario y sus opciones
```
(Get-MsolUser -UserPrincipalName amartinez@tqcorp.com).Licenses.ServiceStatus
```
### Crear un plan dentro del SKU para definir roles a usuarios
```
$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "STREAM_O365_SMB" ,"Deskless" ,"BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management" ,"TEAMS1" ,"PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
```
### Aplicar licencia del plan creado a usuario
```
Set-MsolUserLicense -UserPrincipalName amartinez@tqcorp.com -LicenseOptions $LO
```
```
Set-Variable -name UsrName -value "mcaluki"
```
### Aplicar licencia del plan creado a usuario
```
Set-MsolUser -UsageLocation AR -ObjectId (Get-MSoluser -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com")).ObjectId
Set-MsolUserLicense -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -AddLicenses "tqcorp:O365_BUSINESS_PREMIUM" 
```
### Crear un detalle de opciones del SKU para definir roles a usuarios
```
$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "Deskless" ,"BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management" ,"PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
Set-MsolUserLicense -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -LicenseOptions $LO
```