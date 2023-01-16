#2022-06-13 - Requiere Install-Module ExchangeOnlineManagement

# Variables de Ambiente - Begin
Set-Variable -Scope global -name UsrName -value "falvarez"
Set-Variable -Scope global -name Pwd -value "uBv4eiTa"
Set-Variable -Scope global -name SecPwd -value (ConvertTo-SecureString -String $Pwd -AsPlainText -Force)
Set-Variable -Scope global -name FirstName -value "Francisco"        # Si es un SFE Developer, el First Name es "SFE Developer 00" , EXACTAMENTE ASÍ, con el capitalizado y espacios. Por ejemplo: SFE Developer 07
Set-Variable -Scope global -name LastName -value "Alvarez"           # Si es un SFE Developer, el Last Name es el Nombre y Apellido del usuario asignado inicialmente. Por ejemplo Sebastian Diaz
Set-Variable -Scope global -name OUName -value "OU=QA,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar"  #Usualmente Dev | QA 
Set-Variable -Scope global -name Depto -value "Quality Assurance"  # Usualmente Desarrollo | Quality Assurance
Set-Variable -Scope global -name Cia -value "Team Quality Corporation"
Set-Variable -Scope global -name WKSName -value "TQARWSW1053"
Set-Variable -Scope global -name Cargo -value "Test Analyst"   #Usualmente  Systems Programmer | Test Analyst | Project Leader | Functional Analyst
Set-Variable -Scope global -name Manager -value "elarocca"     #Usualmente  cgoicochea| ascheinkman | elarocca | pferrero | lpisani
# Se trabaja inicialmente en Domain Controller TQARSVW19DC01
Set-Variable -Scope global -name ADController -Value "TQARSVW19DC01"
# Variables de Ambiente - End

Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: New User creation Script execution"
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Using Active Directory Domain Controller: $ADController"
# 2021-02-10 Current user Credentials
#$NetAdminCred=Get-Credential "TQ\administrator"
#$CurrSess = New-PSSession -Computer TQARSVW19DC01 -Credential $NetAdminCred
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Creating Active Directory User object..." 
$CurrSess = New-PSSession -Computer $ADController 
#210617 Invoke-Command -Session $CurrSess -ArgumentList $UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager {Param($UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager) New-ADUser -Server $ADController -SamAccountName $UsrName -AccountPassword $SecPwd -ChangePasswordAtLogon $False -Name ($FirstName + " " + $LastName)  -DisplayName ($FirstName + " " + $LastName)  -GivenName $FirstName -Surname $LastName -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -Path $OUName -ScriptPath "Login.bat" -Enabled $True -Department $Depto -Company $Cia -Manager $Manager -Title $Cargo}
#210629 New-ADUser -Server $ADController -SamAccountName $UsrName -AccountPassword $SecPwd -ChangePasswordAtLogon $False -Name ($FirstName + " " + $LastName)  -DisplayName ($FirstName + " " + $LastName)  -GivenName $FirstName -Surname $LastName -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -Path $OUName -ScriptPath "Login.bat" -Enabled $True -Department $Depto -Company $Cia -Manager $Manager -Title $Cargo
#210629 - Se agrega EmailAddress para asignación en SD Service Desk
#211019 - Ajuste por Display Name para los usuarios genéricos de SFE
If ($UsrName.Substring(0, 4).ToUpper() -eq "SFED") {
	New-ADUser -Server $ADController -SamAccountName $UsrName -AccountPassword $SecPwd -ChangePasswordAtLogon $False -Name ($FirstName + " " + $LastName)  -DisplayName $FirstName                      -GivenName $FirstName -Surname $LastName -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -Path $OUName -ScriptPath "Login.bat" -Enabled $True -Department $Depto -Company $Cia -Manager $Manager -Title $Cargo -EmailAddress ($UsrName.ToLower() +"@tqcorp.com")
} else {
	New-ADUser -Server $ADController -SamAccountName $UsrName -AccountPassword $SecPwd -ChangePasswordAtLogon $False -Name ($FirstName + " " + $LastName)  -DisplayName ($FirstName + " " + $LastName)  -GivenName $FirstName -Surname $LastName -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -Path $OUName -ScriptPath "Login.bat" -Enabled $True -Department $Depto -Company $Cia -Manager $Manager -Title $Cargo -EmailAddress ($UsrName.ToLower() +"@tqcorp.com")
}


#210617 Fuerzo replicación de AD Controllers en Datacenter y Branch
(Get-ADDomainController -Filter *).Name | Foreach-Object {repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A | Out-Null}

Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Waiting Active Directory User creation..."
$count = 0
$success=$False
do{
    try{Get-ADUser -Server $ADController -Identity $UsrName.ToLower() -ErrorAction Stop | Select-Object SamAccountName, UserPrincipalName
        $success = $true
        Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Active Directory User created, continuing script execution"
    } catch{
        Write-Host -Foregroundcolor YELLOW (Get-Date -format "yyyyMMdd-HHmmss") "WAIT: Active Directory User not available, next attempt in 60 seconds"
        Start-sleep -Seconds 60
    }   
    $count++
}until($count -eq 10 -or $success)
if(-not($success)){
	Read-Host -Prompt "HALT: Active Directory User not created. Script cannot continue. Press Enter to exit"
	exit
	}

Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Creating User Mail address..."
#210617 Invoke-Command -Session $CurrSess -ArgumentList $UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager {Param($UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager) Set-ADUser -Identity $UsrName -Clear "proxyAddresses"}
+#210617 Invoke-Command -Session $CurrSess -ArgumentList $UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager {Param($UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager) Set-ADUser -Identity $UsrName -Add @{ProxyAddresses="SMTP:" + $UsrName.ToLower() + "@tqcorp.com"}}
Set-ADUser -Server $ADController -Identity $UsrName -Clear "proxyAddresses"
Set-ADUser -Server $ADController -Identity $UsrName -Add @{ProxyAddresses="SMTP:" + $UsrName.ToLower() + "@tqcorp.com"}

# Grupos de Seguridad default:
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Assigning User default AD Security Group Memberships..."
Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf ISO9000-SGCReadOnly
Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf DesarrolloListOnly
# En Pandemia, VPN.
# Grp-VPN_All removido por HMASLOWSKI 2022-05-24, ahora Forti por necesidd de Fortitoken, requiere definir cada usuario.  
# Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf Grp-VPN_All

#Ad-hoc Groups Semi automatizado
#QA Users - 2021-08-13 - Call con ELAROCCA
#           2021-10-13 - Call con ELAROCCA y documentado en TQIT-92978
If ($OUName.Substring(3, 2).ToUpper() -eq "QA") {
		Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: QA User, assigning ad hoc AD Security Group Memberships" 
		Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf SFTP-Outbound
		Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf QATesting
    Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf Grp-Arc_QA-RW
	} else {
		# Ad-hoc - Not QA Example
		# Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf QATestingReadOnly
	}

#Next Line Added 2020-12-04 - Foto en AD On Premise
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Setting Active Directory User Profile Picture..."
if (Test-Path  "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg") {Set-ADUser -Server $ADController -Identity $UsrName.ToLower() -Replace @{thumbnailPhoto=([byte[]](Get-Content "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg" -Encoding byte))}} else {Write-Host -Foregroundcolor RED (Get-Date -format "yyyyMMdd-HHmmss") "WARNING: No $UsrName.jpg file in TQPhoto folder"}

# Firma de Correo 2021-04-22
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Creating Mail Signature files..."
IF (-Not (Test-Path -Path \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName)) {MD \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName}
COPY \\software\d$\Software\TQOutlookSetSignature\Signatures\_Template\TQCorp* \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName 
Get-ChildItem -LiteralPath \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName -include TQCorp* | ForEach {(Get-Content $_.FullName | ForEach {$_ -replace "Nombre Apellido", [System.String]::Concat($FirstName, " ", $LastName.ToUpper())})| Set-Content $_.FullName}
Get-ChildItem -LiteralPath \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName -include TQCorp* | ForEach {(Get-Content $_.FullName | ForEach {$_ -replace "Cargo", $Cargo})| Set-Content $_.FullName}
# Folder de Usuario
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Creating User's personal folders..."
IF (-Not (Test-Path -Path P:\Users\$UsrName)) {MD P:\Users\$UsrName}
ICACLS P:\Users\$UsrName /grant """TQ\$UsrName"":(OI)(CI)(M)" /T 

# Configuraciones Locales del equipo asignado - Begin
#Local Administrador
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Granting Workstation Local Administration rights..."
$TmpSess = New-PSSession -Computer $WKSName 
Invoke-Command -Session $TmpSess -ArgumentList $UsrName {Param($UsrName) Add-LocalGroupMember -Group "Administrators" -Member ("TQ\" + $UsrName.ToLower())}

#Computer Description
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Setting Workstation's Description..."
Set-Variable -name cFullName -value ([System.String]::Concat($FirstName," ",$LastName))
#Invoke-Command -Session $TmpSess -ArgumentList $cFullName {Param($cFullName) net config server /srvcomment:""$cFullName""}
$PC = Get-WmiObject -class Win32_OperatingSystem -computername $WKSName
$PC.Description = $cFullName
$PC.Put()
Set-ADComputer -Server $ADController -Identity $WKSName -Description $cFullName

#VM Notes en vCenter *** NOTA: Requiere VMware.PowerCLI ***
if (Get-Module -ListAvailable -Name "VMware.PowerCLI") {
	Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Setting VMWare VM Notes to Match username as Active Directory Computer Description..."
	Connect-VIServer -Server tqarvcenter.tq.com.ar
	Get-VM -Name $WKSName | Set-VM -Notes "$($_.Notes)$FirstName $LastName" -Confirm:$false | Out-Null
	Get-VM -Name $WKSName | Select-Object Name, Notes
} else {
    Write-Host "***WARNING: VMware.PowerCLI not available. Please manually update VM Notes to Match username as Active Directory Computer Description"
}
# Configuraciones Locales del equipo asignado - End

#210716
#RETURN

# Synchro en AAD: Azure Active Directory 
#$TmpSess = New-PSSession -Computer TQARSVW16AAD01 -Credential $NetAdminCred
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Syncing Local Active Directory with Azure AD..."
$TmpSess = New-PSSession -Computer TQARSVW16AAD01
Invoke-Command -Session $TmpSess {C:\Tools\Sync.ps1}
#2020-02-27 - CleanUp
Remove-PSSession $CurrSess
Remove-PSSession $TmpSess

#2022-06-09
Write-Host -Foregroundcolor YELLOW (Get-Date -format "yyyyMMdd-HHmmss") "PENDING: AD user creation in Fortigate TQARFW01..."

# Office 365
#210617 Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Accessing Office 365 environment, please provide Administrative Account password..."
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Accessing Office 365 environment..."
$O365Usr="soporte@tqcorp.onmicrosoft.com"
$O365Pwd = Get-Content 'P:\Folders\Soporte\Docs\KBASE\Microsoft\Office365\soportesecurestring.txt' | ConvertTo-SecureString
$O365Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $O365Usr,$O365Pwd
# 2022-06-13 $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -Credential $O365Cred
###Import-PSSession $Session -AllowClobber -DisableNameChecking | Out-Null
# Azure Active Directory v1.0
Import-Module MsOnline 
Connect-MsolService -Credential $O365Cred

# 2DO: ESPERAR un par de minutos que la sincronización cree los objetos en AzureAD
# Se puede chequear con:
# Get-MSOlUser -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") | Select-Object UserPrincipalName, LastDirSyncTime
# Experimental 2020-02-08
# Si da error espero unos segundos, sino, sale del loop
#while($true) {try{Get-MSOlUser -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -ErrorAction Stop | Select-Object UserPrincipalName, LastDirSyncTime} catch {start-sleep -s 30} break }
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Waiting for MS Online User creation..."
$count = 0
$success=$False
do{
    try{Get-MSOlUser -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -ErrorAction Stop | Select-Object UserPrincipalName, LastDirSyncTime
        $success = $true
        Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: MS Online User created, continuing script execution"
    } catch{
        Write-Host -Foregroundcolor YELLOW (Get-Date -format "yyyyMMdd-HHmmss") "WAIT: MS Online User not available, next attempt in 60 seconds"
        Start-sleep -Seconds 60
    }   
    $count++
}until($count -eq 10 -or $success)
if(-not($success)){
	Read-Host -Prompt "HALT: MS Online User not created. Script cannot continue. Press Enter to exit"
	exit
	}

#Aplicar licencia del plan creado a usuario
# ExchangeOnlyUsers: Licenses: {tqcorp:TEAMS_EXPLORATORY, tqcorp:EXCHANGESTANDARD}
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Assigning MS Online User with proper Office 365 License..."
Set-MsolUser -UsageLocation AR -ObjectId (Get-MSoluser -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com")).ObjectId
Set-MsolUserLicense -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -AddLicenses "tqcorp:O365_BUSINESS_PREMIUM" 
#Crear un detalle de opciones del SKU para definir roles a usuarios
##$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "Deskless" ,"BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management" ,"TEAMS1" ,"PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
# Update 2019-11-14 - Lista en https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference / Lista detallada: Get-MsolAccountSku | Select -ExpandProperty ServiceStatus
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Setting Office 365 License permissions..."
$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "MYANALYTICS_P2", "KAIZALA_O365_P2",  "DYN365BC_MS_INVOICING", "Deskless","BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management","PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
Set-MsolUserLicense -UserPrincipalName ($UsrName.ToLower() +"@tqcorp.com") -LicenseOptions $LO

# 2DO: ESPERAR que se cree el Mailbox, y aplicar config regional
# Se puede chequear con:
# Get-Mailbox -Identity ($UsrName.ToLower() +"@tqcorp.com") | Select-Object UserPrincipalName, IsMailboxEnabled, WhenMailboxCreated, ServerName
# Experimental 2020-02-08
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Waiting for User Mailbox creation..."
$count = 0
$success=$False
do{
    try{Get-Mailbox -Identity ($UsrName.ToLower() +"@tqcorp.com")  -ErrorAction Stop | Select-Object UserPrincipalName, IsMailboxEnabled, WhenMailboxCreated, ServerName
        $success = $true
        Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: User Mailbox created, continuing script execution"
   } catch{
        Write-Host -Foregroundcolor YELLOW (Get-Date -format "yyyyMMdd-HHmmss") "WAIT: User Mailbox not available, next attempt in 60 seconds"
        Start-sleep -Seconds 60
    }   
    $count++
}until($count -eq 10 -or $success)
if(-not($success)){
	Read-Host -Prompt "HALT: User Mailbox not created. Script cannot continue. Press Enter to exit"
	exit
	}

#Configuración regional
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Setting User Mailbox standard Regional Settings..."
Set-MailboxRegionalConfiguration -Identity ($UsrName.ToLower() +"@tqcorp.com") -Language en-US -DateFormat dd-MMM-yy -TimeZone "Argentina Standard Time" 
# Next line Added 2020-12-07
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Setting User Mailbox standard Language..."
Set-MailboxSpellingConfiguration -Identity ($UsrName.ToLower() +"@tqcorp.com") -DictionaryLanguage Spanish
# Next Line added 2019-10-18 - Default todo desactivado excepto MAPI (Outlook)
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Setting User Mailbox Protocol permissions..."
Set-CasMailbox -Identity ($UsrName.ToLower() +"@tqcorp.com") -OWAEnabled $False -ActiveSyncEnabled $False -PopEnabled $False -ImapEnabled $False -MapiEnabled $True

#Next Lines Added 2020-01-06 - Updated 2020-2-10 (SI no se dispone no se asigna nada, ni siquiera u default, para poder buscar los "pendientes" de asignar foto
#if (Test-Path  "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg") {$PhotoFile="P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg"} else {$PhotoFile="P:\Folders\Soporte\Docs\Fotos\TQPhoto\_default.jpg"}
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Setting User Mailbox Profile Picture..."
if (Test-Path  "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg") {Set-UserPhoto -Identity ($UsrName.ToLower() +"@tqcorp.com") -PictureData ([System.IO.File]::ReadAllBytes("P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg")) -Confirm:$false} else {echo "Sin foto disponible"}

 
# Activar Archiving
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Enabling User Mailbox Archive Policy..."
Enable-Mailbox -Identity ($UsrName.ToLower() +"@tqcorp.com") -Archive | Select-Object UserPrincipalName, ArchiveStatus
# Cambio de Space - 2019-03-25
# Add-UnifiedGroupLinks -Identity "Team Quality" -LinkType Members -Links ($UsrName.ToLower() +"@tqcorp.com")
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Assigning User Global Groups memberships..."
Add-UnifiedGroupLinks -Identity "teamqualityallgrp@tqcorp.com.ar" -LinkType Members -Links ($UsrName.ToLower() +"@tqcorp.com")

# Salir correctamente de la PS365
Remove-PSSession $Session

#Salida de Powershell (Desafectada 2021-02-11 ya que se invoca ahora todo este File desde consola PS, si se sale, se pierden mensajes)
#Read-Host -Prompt "INFO: Script completed. Press Enter to exit"
#exit
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Script completed"
