### Consultar todos SKU
```
Get-MsolAccountSku
```
```
AccountSkuId                 ActiveUnits WarningUnits ConsumedUnits
------------                 ----------- ------------ -------------
tqcorp:STREAM                1000000     0            32
tqcorp:POWER_BI_PRO          1           0            1
tqcorp:WINDOWS_STORE         1000000     0            0
tqcorp:FLOW_FREE             10000       0            6
tqcorp:SPB                   3           0            3
tqcorp:EXCHANGESTANDARD      6           0            5
tqcorp:O365_BUSINESS_PREMIUM 95          0            91
tqcorp:POWER_BI_STANDARD     1000000     0            6
tqcorp:TEAMS_EXPLORATORY     100         0            3
tqcorp:AAD_PREMIUM           1           0            1
```
### Consultar los detalles del SKY y sus servicios
```
(Get-MsolAccountSku | where {$_.AccountSkuId -eq "tqcorp:O365_BUSINESS_PREMIUM"}).ServiceStatus
```
```
ServicePlan                     ProvisioningStatus
-----------                     ------------------
RMS_S_BASIC                     Success
POWER_VIRTUAL_AGENTS_O365_P2    Success
CDS_O365_P2                     Success
PROJECT_O365_P2                 Success
DYN365_CDS_O365_P2              Success
MICROSOFT_SEARCH                Success
WHITEBOARD_PLAN1                Success
MYANALYTICS_P2                  Success
DYN365BC_MS_INVOICING           Success
KAIZALA_O365_P2                 Success
STREAM_O365_SMB                 Success
Deskless                        Success
BPOS_S_TODO_1                   Success
MICROSOFTBOOKINGS               Success
FORMS_PLAN_E1                   Success
FLOW_O365_P1                    Success
POWERAPPS_O365_P1               Success
O365_SB_Relationship_Management Success
TEAMS1                          Success
PROJECTWORKMANAGEMENT           Success
SWAY                            Success
INTUNE_O365                     PendingActivation
SHAREPOINTWAC                   Success
OFFICE_BUSINESS                 Success
YAMMER_ENTERPRISE               Success
EXCHANGE_S_STANDARD             Success
MCOSTANDARD                     Success
SHAREPOINTSTANDARD              Success
```
### Consultar los servicios especificos sobre un usuario
```
(Get-MsolUser -UserPrincipalName agutman@tqcorp.com).Licenses.ServiceStatus
```
```
ServicePlan                     ProvisioningStatus
-----------                     ------------------
EXCHANGE_S_FOUNDATION           PendingProvisioning
# Microsoft Stream                Success
RMS_S_BASIC                     PendingProvisioning
POWER_VIRTUAL_AGENTS_O365_P2    Success
CDS_O365_P2                     Success
PROJECT_O365_P2                 Success
DYN365_CDS_O365_P2              Success
MICROSOFT_SEARCH                PendingProvisioning
WHITEBOARD_PLAN1                Success
MYANALYTICS_P2                  Success
DYN365BC_MS_INVOICING           Success
KAIZALA_O365_P2                 Success
# STREAM_O365_SMB                 Disabled
Deskless                        Disabled
BPOS_S_TODO_1                   Disabled
MICROSOFTBOOKINGS               Disabled
FORMS_PLAN_E1                   Disabled
FLOW_O365_P1                    Disabled
POWERAPPS_O365_P1               Disabled
O365_SB_Relationship_Management Disabled
TEAMS1                          Success
PROJECTWORKMANAGEMENT           Disabled
SWAY                            Disabled
INTUNE_O365                     PendingActivation
SHAREPOINTWAC                   Success
OFFICE_BUSINESS                 Success
YAMMER_ENTERPRISE               Disabled
EXCHANGE_S_STANDARD             Success
MCOSTANDARD                     Success
SHAREPOINTSTANDARD              Success
```
### Crear objeto licence quitando servicios
```
$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "Microsoft Stream"
```
### Remover una licencia por sku de usuario
```
Set-MsolUserLicense -UserPrincipalName cdegasperi@tqcorp.com -RemoveLicense tqcorp:STREAM 
```
### Listar todos los usuarios con una licencia specifica
```
Get-MsolUser | Where-Object {($_.licenses).AccountSkuId -match "tqcorp:STREAM"}
```
```
UserPrincipalName       DisplayName        isLicensed
-----------------       -----------        ----------
fgimenez@tqcorp.com     Fernando Gimenez   True
pardizon@tqcorp.com     Pedro Ardizon      True
lgarcia@tqcorp.com      Luis Garcia        True
dignazzi@tqcorp.com     Daniel Ignazzi     True
pferrero@tqcorp.com     Pablo Ferrero      True
apapaianni@tqcorp.com   Ariel Papaianni    True
mmattioli@tqcorp.com    Marcela Mattioli   True
lliquin@tqcorp.com      Luis Liquin        True
mirigoyen@tqcorp.com    Mariana Irigoyen   True
lbilli@tqcorp.com       Laura Billi        True
rkecskemeti@tqcorp.com  Roberto Kecskemeti True
dgarcia@tqcorp.com      Diego Garcia       True
tmorales@tqcorp.com     Tomas Morales      True
mperez@tqcorp.com       Mariangelica Perez True
sgarcia1@tqcorp.com     Sixto Garcia       True
ppereyra@tqcorp.com     Pablo Pereyra      True
czarate@tqcorp.com      Christian Zarate   True
msabbatini@tqcorp.com   Marco Sabbatini    True
lpalazzesi@tqcorp.com   Luis Palazzesi     True
pmedvedovsky@tqcorp.com Pablo Medvedovsky  True
gpace@tqcorp.com        Gustavo Pace       True
ncordoba@tqcorp.com     Nicolas Cordoba    True
lahlfarias@tqcorp.com   Leandro Ahl Farias True
jmoszel@tqcorp.com      Jonathan Moszel    True
iastete@tqcorp.com      Ivan Astete        True
nmazzetti@tqcorp.com    Nicolas Mazzetti   True
slardies@tqcorp.com     Susana Lardies     True
lmole@tqcorp.com        Luciana Mole       True
pmegide@tqcorp.com      Patricia Megide    True
```
### Exportacion a CSV
```
Get-MsolUser | Where-Object {($_.licenses).AccountSkuId -match "tqcorp:STREAM"} | Out-file C:\temp\stream.txt
```
### Remover licencias
```
Get-Content "C:\temp\stream.txt" | ForEach {Set-MsolUserLicense -UserPrincipalName $_ -RemoveLicenses "tqcorp:STREAM"}
```
## Re aplicar licencias
**Listar usuarios con faltantes en licencia (stream smb) asociados a licencia O365_BUSINESS_PREMIUM**
```
Get-MsolUser | Where-Object {($_.licenses).AccountSkuId -match "O365_BUSINESS_PREMIUM"}
```
## Crear un plan
```
$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "Deskless" ,"BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management" ,"PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
```
## Aplicar el plan a esos usuarios conforme txt separado por comas
```
$users = Get-Content "C:\temp\streamsmb.txt"
foreach($user in $users)
{Write-host "Setting Stream SMB on '$user'" -ForegroundColor Black -BackgroundColor Green
Set-MsolUserLicense -UserPrincipalName $user -LicenseOptions $LO
}
```