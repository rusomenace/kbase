# Variables de Ambiente - Begin
Set-Variable -Scope global -name UsrName -value "hlanfranco"
Set-Variable -Scope global -name Pwd -value "Password1"
Set-Variable -Scope global -name SecPwd -value (ConvertTo-SecureString -String $Pwd -AsPlainText -Force)
Set-Variable -Scope global -name FirstName -value "Hernando"
Set-Variable -Scope global -name LastName -value "Lanfranco"
Set-Variable -Scope global -name OUName -value "OU=DESARROLLO,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar"
Set-Variable -Scope global -name Depto -value "DESARROLLO"
Set-Variable -Scope global -name Cia -value "Team Quality Corporation"
Set-Variable -Scope global -name WKSName -value "TQARWSW1041"
Set-Variable -Scope global -name Cargo -value "Systems Programmer"
# Variables de Ambiente - End

# Se trabaja inicialmente en Domain Controller TQARSVW19DC01
$NetAdminCred=Get-Credential "TQ\NetAdmin"
$CurrSess = New-PSSession -Computer TQARSVW19DC01 -Credential $NetAdminCred
Invoke-Command -Session $CurrSess -ArgumentList $UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo {Param($UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo) New-ADUser -SamAccountName $UsrName -AccountPassword $SecPwd -ChangePasswordAtLogon $False -Name ($FirstName + " " + $LastName)  -DisplayName ($FirstName + " " + $LastName)  -GivenName $FirstName -Surname $LastName -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -Path $OUName -ScriptPath "Login.bat" -Enabled $True -Department $Depto -Company $Cia}
Invoke-Command -Session $CurrSess -ArgumentList $UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo {Param($UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo) Set-ADUser -Identity $UsrName -Clear "proxyAddresses"}
Invoke-Command -Session $CurrSess -ArgumentList $UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo {Param($UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo) Set-ADUser -Identity $UsrName -Add @{ProxyAddresses="SMTP:" + $UsrName.ToLower() + "@tqcorp.com"}}
# Grupos de Seguridad default:
Add-ADPrincipalGroupMembership -Identity $UsrName -MemberOf ISO9000-SGCReadOnly
Add-ADPrincipalGroupMembership -Identity $UsrName -MemberOf DesarrolloListOnly

# Firma de Correo
MD \\tq\NETLOGON\Firmas2012\$UsrName 
COPY \\tq\NETLOGON\Firmas2012\_Template\TQCorp* \\tq\NETLOGON\Firmas2012\$UsrName 
Get-ChildItem -LiteralPath \\tq\NETLOGON\Firmas2012\$UsrName -include TQCorp* | ForEach {(Get-Content $_.FullName | ForEach {$_ -replace "Nombre Apellido", [System.String]::Concat($FirstName, " ", $LastName.ToUpper())})| Set-Content $_.FullName}
Get-ChildItem -LiteralPath \\tq\NETLOGON\Firmas2012\$UsrName -include TQCorp* | ForEach {(Get-Content $_.FullName | ForEach {$_ -replace "Cargo", $Cargo})| Set-Content $_.FullName}
# Folder de Usuario
MD P:\Users\$UsrName
ICACLS P:\Users\$UsrName /grant """TQ\$UsrName"":(OI)(CI)(M)" /T 

# Configuraciones Locales del equipo asignado - Begin
#Local Administrador
$TmpSess = New-PSSession -Computer $WKSName -Credential $NetAdminCred
Invoke-Command -Session $TmpSess -ArgumentList $UsrName {Param($UsrName) Add-LocalGroupMember -Group "Administrators" -Member ("TQ\" + $UsrName.ToLower())}

#Computer Description
Set-Variable -name cFullName -value ([System.String]::Concat($FirstName," ",$LastName))
Invoke-Command -Session $TmpSess -ArgumentList $cFullName {Param($cFullName) net config server /srvcomment:""$cFullName""}
Set-ADComputer $WKSName -Description $cFullName
# Configuraciones Locales del equipo asignado - End


# Synchro en AAD: Azure Active Directory 
$TmpSess = New-PSSession -Computer TQARSVW16AAD01 -Credential $NetAdminCred
Invoke-Command -Session $TmpSess {C:\Tools\Sync.ps1}

# Office 365
$O365Cred = Get-credential "soporte@tqcorp.onmicrosoft.com"
# Exchange Online #$O365Cred
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session -AllowClobber
# Azure Active Directory v1.0
Import-Module MsOnline
Connect-MsolService -Credential $O365Cred

# 2DO: ESPERAR un par de minutos que la sincronización cree los objetos en AzureAD
# Se puede chequear con:
# Get-MSOlUser -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") | Select-Object UserPrincipalName, LastDirSyncTime

#Aplicar licencia del plan creado a usuario
Set-MsolUser -UsageLocation AR -ObjectId (Get-MSoluser -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com")).ObjectId
Set-MsolUserLicense -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -AddLicenses "tqcorp:O365_BUSINESS_PREMIUM" 
#Crear un detalle de opciones del SKU para definir roles a usuarios
##$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "STREAM_O365_SMB" ,"Deskless" ,"BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management" ,"TEAMS1" ,"PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
# Update 2019-11-14 - Lista en https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference / Lista detallada: Get-MsolAccountSku | Select -ExpandProperty ServiceStatus
$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "MYANALYTICS_P2", "KAIZALA_O365_P2",  "DYN365BC_MS_INVOICING", "STREAM_O365_SMB","Deskless","BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management","PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
Set-MsolUserLicense -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -LicenseOptions $LO

# 2DO: ESPERAR que se cree el Mailbox, y aplicar config regional
# Se puede chequear con:
# Get-Mailbox -Identity ($UsrName.ToLower() +"@tqcorp.com") | Select-Object UserPrincipalName, IsMailboxEnabled, WhenMailboxCreated, ServerName

#Configuración regional
Set-MailboxRegionalConfiguration -Identity ($UsrName.ToLower() +"@tqcorp.com") -Language en-US -DateFormat dd-MMM-yy -TimeZone "Argentina Standard Time" 
# Next Line added 2019-10-18 - Default todo desactivado excepto MAPI (Outlook)
Set-CasMailbox -Identity ($UsrName.ToLower() +"@tqcorp.com") -OWAEnabled $False -ActiveSyncEnabled $False -PopEnabled $False -ImapEnabled $False -MapiEnabled $True

# Activar Archiving
Enable-Mailbox -Identity ($UsrName.ToLower() +"@tqcorp.com") -Archive
# Cambio de Space - 2019-03-25
# Add-UnifiedGroupLinks -Identity "Team Quality" -LinkType Members -Links ($UsrName.ToLower() +"@tqcorp.com")
Add-UnifiedGroupLinks -Identity "teamqualityallgrp@tqcorp.com.ar" -LinkType Members -Links ($UsrName.ToLower() +"@tqcorp.com")

# Salir correctamente de la PS365
Remove-PSSession $Session

### Desactivado 2019-11-14
#### 2DO: ESPERAR Unos 15 mins y Configurar perfil de SFB: Requiere tener instalado SFB Online Connector mediante "\\software\Software\Microsoft\Office365\Skype for Business\vc_redist.x64.exe" y "\\software\Software\Microsoft\Office365\Skype for Business\SkypeOnlinePowerShell.Exe"
###Import-Module SkypeOnlineConnector
####Skype For Business 
###$sfbSession = New-CsOnlineSession -Credential $O365Cred
###Import-PSSession $sfbSession
###grant-csconferencingpolicy -policyname tag:BposSAllModalityNoFT -identity ($UsrName.ToLower() +"@tqcorp.com")
#### Cambio de Space - 2019-03-25
#### Add-UnifiedGroupLinks -Identity "Team Quality" -LinkType Members -Links ($UsrName.ToLower() +"@tqcorp.com")

#Salida de Powershell
exit
