Start-Transcript -path C:\Tools\ABM\NewABM.txt

# Variables de Ambiente - Begin
## Variable fijas anteriores
## Set-Variable -Scope global -name UsrName -value "falvarez"
## Set-Variable -Scope global -name Pwd -value "uBv4eiTa"
## Set-Variable -Scope global -name SecPwd -value (ConvertTo-SecureString -String $Pwd -AsPlainText -Force)
## Set-Variable -Scope global -name FirstName -value "Francisco"
## Set-Variable -Scope global -name LastName -value "Alvarez"
## Set-Variable -Scope global -name OUName -value "OU=QA,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar"  #Usualmente Dev | QA 
## Set-Variable -Scope global -name Depto -value "Quality Assurance"  # Usualmente Desarrollo | Quality Assurance
## Set-Variable -Scope global -name Cia -value "Team Quality Corporation"
## Set-Variable -Scope global -name WKSName -value "TQARWSW1053"
## Set-Variable -Scope global -name Cargo -value "Test Analyst"   #Usualmente  Systems Programmer | Test Analyst | Project Leader | Functional Analyst
## Set-Variable -Scope global -name Manager -value "elarocca"      #Usualmente  evonschmeling | ascheinkman | elarocca | rkecskemeti

# Variables para ingresar datos de ABM
$UsrName = read-host "Username en formato SAMACCOUNTNAME / nombre de NETBIOS"
$FullUsrName = ($UsrName.ToLower() +"@tqcorp.com")
$Pwd = read-host "Clave"
Set-Variable -Scope global -name SecPwd -value (ConvertTo-SecureString -String $Pwd -AsPlainText -Force)
$FirstName = read-host "Nombre"
$Lastname = read-host "Apellido"
$WKSName = read-host "Workstation o vm asignada"
$Cargo = read-host "Cargo"
Set-Variable -Scope global -name Cia -value "Team Quality Corporation"
# End

# Menu de seleccion para unidad organizativa de AD
Function Get-ProjectType {
    $type=Read-Host "
    OU de Active Directory

    1 - Administration
    2 - Comer
    3 - Dev
    4 - HR
    5 - IT
    6 - QA
    
    Ingresar opcion"
    Switch ($type){
        1 {$choice="administration"}
        2 {$choice="comer"}
        3 {$choice="dev"}
        4 {$choice="hr"}
        5 {$choice="it"}
        6 {$choice="qa"}
    }
    return $choice
}
$ADou=Get-ProjectType
# End

Set-Variable -Scope global -name OUName -value "OU=$ADou,OU=users,OU=site0,OU=arg,DC=tq,DC=com,DC=ar"

# Menu de seleccion para area
Function Get-ProjectType {
    $type=Read-Host "
    Area de la compania

    1 - Administration
    2 - Comex
    3 - Desarrollo
    4 - Recursos Humanos
    5 - IT    
    6 - Quality Assurance
    
    Ingresar opcion"
    Switch ($type){
        1 {$choice="Administration"}
        2 {$choice="Comex"}
        3 {$choice="Desarrollo"}
        4 {$choice="Recursos Humanos"}
        5 {$choice="IT"}        
        6 {$choice="Quality Assurance"}
    }
    return $choice
}
$Depto=Get-ProjectType
# End

# Menu de seleccion para Manager
Function Get-ProjectType {
    $type=Read-Host "
    Responsable directo

    1 - Alan Scheinkman
    2 - Adriana Mastache
    3 - Bruno Blanco
    4 - Carlos Goicochea
    5 - Emiliano La Rocca
    6 - Leonardo Pisani
    7 - Patricia Megide
    8 - Roberto Kecskemeti
    
    Ingresar opcion"
    Switch ($type){
        1 {$choice="ascheinkman"}
		2 {$choice="amastache"}
        3 {$choice="bblanco"}
        4 {$choice="cgoicochea"}
        5 {$choice="elarocca"}
        6 {$choice="lpisani"} 
        7 {$choice="pmegide"}
        8 {$choice="rkecskemeti"}        
    }
    return $choice
}
$Manager=Get-ProjectType
""
Write-Host -Foregroundcolor CYAN "Verifique los datos ingresados"
""
Write-Host "Nombre de usuario NETBIOS: " -ForegroundColor White -NoNewline; Write-Host "$UsrName" -ForegroundColor yellow
Write-Host "Password: " -ForegroundColor White -NoNewline; Write-Host "$Pwd" -ForegroundColor yellow
Write-Host "Nombre: " -ForegroundColor White -NoNewline; Write-Host "$FirstName" -ForegroundColor yellow
Write-Host "Apellido: " -ForegroundColor White -NoNewline; Write-Host "$Lastname" -ForegroundColor yellow
Write-Host "Workstation o vm asignada: " -ForegroundColor White -NoNewline; Write-Host "$WKSName" -ForegroundColor yellow
Write-Host "Cargo: " -ForegroundColor White -NoNewline; Write-Host "$Cargo" -ForegroundColor yellow
Write-Host "Unidad organizativa en AD: " -ForegroundColor White -NoNewline; Write-Host "$OUName" -ForegroundColor yellow
Write-Host "Departamento: " -ForegroundColor White -NoNewline; Write-Host "$Depto" -ForegroundColor yellow
Write-Host "Responsable directo: " -ForegroundColor White -NoNewline; Write-Host "$Manager" -ForegroundColor yellow
""
$input = $(Write-Host " Presionar cualquier tecla para continuar o CTRL+C para salir " -ForegroundColor yellow -BackgroundColor black -NoNewLine; Read-Host)
# End
# Variables de Ambiente - End

Import-Module ActiveDirectory
Set-Variable -Scope global -name ADController -value "tqarsvw19dc01"

# 2021-02-10 Current user Credentials
#$NetAdminCred=Get-Credential "TQ\administrator"
#$CurrSess = New-PSSession -Computer TQARSVW19DC01 -Credential $NetAdminCred
Write-Host -Foregroundcolor CYAN "INFO: Creating Active Directory User object..." 
#$CurrSess = New-PSSession -Computer tqarsvw19dc01
#210617 Invoke-Command -Session $CurrSess -ArgumentList $UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager {Param($UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager) New-ADUser -Server $ADController -SamAccountName $UsrName -AccountPassword $SecPwd -ChangePasswordAtLogon $False -Name ($FirstName + " " + $LastName)  -DisplayName ($FirstName + " " + $LastName)  -GivenName $FirstName -Surname $LastName -UserPrincipalName $FullUsrName -Path $OUName -ScriptPath "Login.bat" -Enabled $True -Department $Depto -Company $Cia -Manager $Manager -Title $Cargo}
#210629 New-ADUser -Server $ADController -SamAccountName $UsrName -AccountPassword $SecPwd -ChangePasswordAtLogon $False -Name ($FirstName + " " + $LastName)  -DisplayName ($FirstName + " " + $LastName)  -GivenName $FirstName -Surname $LastName -UserPrincipalName $FullUsrName -Path $OUName -ScriptPath "Login.bat" -Enabled $True -Department $Depto -Company $Cia -Manager $Manager -Title $Cargo
#210629 - Se agrega EmailAddress para asignación en SD Service Desk
New-ADUser -Server $ADController -SamAccountName $UsrName -AccountPassword $SecPwd -ChangePasswordAtLogon $False -Name ($FirstName + " " + $LastName)  -DisplayName ($FirstName + " " + $LastName)  -GivenName $FirstName -Surname $LastName -UserPrincipalName $FullUsrName -Path $OUName -ScriptPath "Login.bat" -Enabled $True -Department $Depto -Company $Cia -Manager $Manager -Title $Cargo -EmailAddress $FullUsrName
Set-ADUser $UsrName -UserPrincipalName $FullUsrName

#210617 Fuerzo replicación de AD Controllers en Datacenter y Branch
(Get-ADDomainController -Filter *).Name | Foreach-Object {repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A | Out-Null}

Write-Host -Foregroundcolor CYAN "INFO: Waiting Active Directory User creation..."
$count = 0
$success=$False
do{
    try{Get-ADUser -Server $ADController -Identity $UsrName.ToLower() -ErrorAction Stop | Select-Object SamAccountName, UserPrincipalName
        $success = $true
        Write-Host -Foregroundcolor CYAN "INFO: Active Directory User created, continuing script execution"
    } catch{
        Write-Host -Foregroundcolor YELLOW "WAIT: Active Directory User not available, next attempt in 60 seconds"
        Start-sleep -Seconds 60
    }   
    $count++
}until($count -eq 10 -or $success)
if(-not($success)){
	Read-Host -Prompt "HALT: Active Directory User not created. Script cannot continue. Press Enter to exit"
	exit
	}

Write-Host -Foregroundcolor CYAN "INFO: Creating User Mail address..."
#210617 Invoke-Command -Session $CurrSess -ArgumentList $UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager {Param($UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager) Set-ADUser -Identity $UsrName -Clear "proxyAddresses"}
#210617 Invoke-Command -Session $CurrSess -ArgumentList $UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager {Param($UsrName,$SecPwd,$FirstName,$LastName,$OUName,$Depto,$Cia,$WKSName,$Cargo, $Manager) Set-ADUser -Identity $UsrName -Add @{ProxyAddresses="SMTP:" + $UsrName.ToLower() + "@tqcorp.com"}}
Set-ADUser -Server $ADController -Identity $UsrName -Clear "proxyAddresses"
Set-ADUser -Server $ADController -Identity $UsrName -Add @{ProxyAddresses="SMTP:" + "$FullUsrName"}

# Grupos de Seguridad default:
Write-Host -Foregroundcolor CYAN "INFO: Assigning User default AD Security Group Memberships..."
Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf ISO9000-SGCReadOnly
Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf DesarrolloListOnly
# En Pandemia, VPN.
Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf Grp-VPN_All

#Ad-hoc Groups Semi automatizado
#QA Users - 2021-08-13 - Call con ELAROCCA
#If ($OUName.Substring(3, 2).ToUpper() -eq "QA") {
#	Write-Host -Foregroundcolor CYAN "INFO: QA User, assigning ad hoc AD Security Group Memberships" 
#	Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf SFTP-Outbound
#    Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf QATesting
#	}

# Ad-hoc - Example
# Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf QATestingReadOnly

#Next Line Added 2020-12-04 - Foto en AD On Premise
Write-Host -Foregroundcolor CYAN "INFO: Setting Active Directory User Profile Picture..."
if (Test-Path  "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg") {Set-ADUser -Server $ADController -Identity $UsrName -Replace @{thumbnailPhoto=([byte[]](Get-Content "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg" -Encoding byte))}} else {echo "Sin foto disponible"}

# Firma de Correo 2021-04-22
Write-Host -Foregroundcolor CYAN "INFO: Creating Mail Signature files..."
IF (-Not (Test-Path -Path \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName)) {MD \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName}
COPY \\software\d$\Software\TQOutlookSetSignature\Signatures\_Template\TQCorp* \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName 
Get-ChildItem -LiteralPath \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName -include TQCorp* | ForEach {(Get-Content $_.FullName | ForEach {$_ -replace "Nombre Apellido", [System.String]::Concat($FirstName, " ", $LastName.ToUpper())})| Set-Content $_.FullName}
Get-ChildItem -LiteralPath \\software\d$\Software\TQOutlookSetSignature\Signatures\$UsrName -include TQCorp* | ForEach {(Get-Content $_.FullName | ForEach {$_ -replace "Cargo", $Cargo})| Set-Content $_.FullName}
# Folder de Usuario
Write-Host -Foregroundcolor CYAN "INFO: Creating User's personal folders..."
IF (-Not (Test-Path -Path P:\Users\$UsrName)) {MD P:\Users\$UsrName}
ICACLS P:\Users\$UsrName /grant """TQ\$UsrName"":(OI)(CI)(M)" /T 

# Configuraciones Locales del equipo asignado - Begin
#Local Administrador
Write-Host -Foregroundcolor CYAN "INFO: Granting Workstation Local Administration rights..."
$TmpSess = New-PSSession -Computer $WKSName 
Invoke-Command -Session $TmpSess -ArgumentList $UsrName {Param($UsrName) Add-LocalGroupMember -Group "Administrators" -Member ("TQ\" + $UsrName.ToLower())}

#Computer Description
Write-Host -Foregroundcolor CYAN "INFO: Setting Workstation's Description..."
Set-Variable -name cFullName -value ([System.String]::Concat($FirstName," ",$LastName))
# Invoke-Command -Session $TmpSess -ArgumentList $cFullName {Param($cFullName) net config server /srvcomment:""$cFullName""} | parametro anteriora reemplazado por clase mas abajo
$PC = Get-WmiObject -class Win32_OperatingSystem -computername $WKSName
$PC.Description = $cFullName
$PC.Put()
Set-ADComputer -Server $ADController -Identity $WKSName -Description $cFullName

#VM Notes en vCenter *** NOTA: Requiere VMware.PowerCLI ***
if (Get-Module -ListAvailable -Name "VMware.PowerCLI") {
	Write-Host -Foregroundcolor CYAN "INFO: Setting VMWare VM Notes to Match username as Active Directory Computer Description..."
	Connect-VIServer -Server tqarvcenter.tq.com.ar
	Get-VM -Name $WKSName | Set-VM -Notes "$($_.Notes)$FirstName $LastName" -Confirm:$false | Out-Null
	Get-VM -Name $WKSName | Select-Object Name, Notes
} else {
    Write-Host "***WARNING: VMware.PowerCLI not available. Please manually update VM Notes to Match username as Active Directory Computer Description"
}
# Configuraciones Locales del equipo asignado - End

# Synchro en AAD: Azure Active Directory 
#$TmpSess = New-PSSession -Computer TQARSVW16AAD01 -Credential $NetAdminCred
Write-Host -Foregroundcolor CYAN "INFO: Syncing Local Active Directory with Azure AD..."
C:\Tools\Sync.ps1

# Office 365
#210617 Write-Host -Foregroundcolor CYAN "INFO: Accessing Office 365 environment, please provide Administrative Account password..."
Write-Host -Foregroundcolor CYAN "INFO: Accessing Office 365 environment..."
$O365Usr="hmaslowski@tqcorp.com"
$O365Pwd = Get-Content "C:\Tools\Office365\tenantcreds.txt" | ConvertTo-SecureString
$O365Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $O365Usr,$O365Pwd
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session -AllowClobber | Out-Null
# Azure Active Directory v1.0
Import-Module MsOnline 
Connect-MsolService -Credential $O365Cred

# 2DO: ESPERAR un par de minutos que la sincronización cree los objetos en AzureAD
# Se puede chequear con:
# Get-MSOlUser -UserPrincipalName $FullUsrName | Select-Object UserPrincipalName, LastDirSyncTime
# Experimental 2020-02-08
# Si da error espero unos segundos, sino, sale del loop
#while($true) {try{Get-MSOlUser -UserPrincipalName $FullUsrName -ErrorAction Stop | Select-Object UserPrincipalName, LastDirSyncTime} catch {start-sleep -s 30} break }
Write-Host -Foregroundcolor CYAN "INFO: Waiting for MS Online User creation..."
$count = 0
$success=$False
do{
    try{Get-MSOlUser -UserPrincipalName $FullUsrName -ErrorAction Stop | Select-Object UserPrincipalName, LastDirSyncTime
        $success = $true
        Write-Host -Foregroundcolor CYAN "INFO: MS Online User created, continuing script execution"
    } catch{
        Write-Host -Foregroundcolor YELLOW "WAIT: MS Online User not available, next attempt in 60 seconds"
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
Write-Host -Foregroundcolor CYAN "INFO: Assigning MS Online User with proper Office 365 License..."
Set-MsolUser -UsageLocation AR -ObjectId (Get-MSoluser -UserPrincipalName $FullUsrName).ObjectId
Set-MsolUserLicense -UserPrincipalName $FullUsrName -AddLicenses "tqcorp:O365_BUSINESS_PREMIUM"
#Crear un detalle de opciones del SKU para definir roles a usuarios
##$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "Deskless" ,"BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management" ,"TEAMS1" ,"PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
# Update 2019-11-14 - Lista en https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference / Lista detallada: Get-MsolAccountSku | Select -ExpandProperty ServiceStatus
Write-Host -Foregroundcolor CYAN "INFO: Setting Office 365 License permissions..."
$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "MYANALYTICS_P2", "KAIZALA_O365_P2",  "DYN365BC_MS_INVOICING", "Deskless","BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management","PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
Set-MsolUserLicense -UserPrincipalName $FullUsrName -LicenseOptions $LO

# 2DO: ESPERAR que se cree el Mailbox, y aplicar config regional
# Se puede chequear con:
# Get-Mailbox -Identity $FullUsrName | Select-Object UserPrincipalName, IsMailboxEnabled, WhenMailboxCreated, ServerName
# Experimental 2020-02-08
Write-Host -Foregroundcolor CYAN "INFO: Waiting for User Mailbox creation..."
$count = 0
$success=$False
do{
    try{Get-Mailbox -Identity $FullUsrName  -ErrorAction Stop | Select-Object UserPrincipalName, IsMailboxEnabled, WhenMailboxCreated, ServerName
        $success = $true
        Write-Host -Foregroundcolor CYAN "INFO: User Mailbox created, continuing script execution"
   } catch{
        Write-Host -Foregroundcolor YELLOW "WAIT: User Mailbox not available, next attempt in 60 seconds"
        Start-sleep -Seconds 60
    }   
    $count++
}until($count -eq 10 -or $success)
if(-not($success)){
	Read-Host -Prompt "HALT: User Mailbox not created. Script cannot continue. Press Enter to exit"
	exit
	}

#Configuración regional
Write-Host -Foregroundcolor CYAN "INFO: Setting User Mailbox standard Regional Settings..."
Set-MailboxRegionalConfiguration -Identity $FullUsrName -Language en-US -DateFormat dd-MMM-yy -TimeZone "Argentina Standard Time" 
# Next line Added 2020-12-07
Write-Host -Foregroundcolor CYAN "INFO: Setting User Mailbox standard Language..."
Set-MailboxSpellingConfiguration -Identity $FullUsrName -DictionaryLanguage Spanish
# Next Line added 2019-10-18 - Default todo desactivado excepto MAPI (Outlook)
Write-Host -Foregroundcolor CYAN "INFO: Setting User Mailbox Protocol permissions..."
Set-CasMailbox -Identity $FullUsrName -OWAEnabled $False -ActiveSyncEnabled $False -PopEnabled $False -ImapEnabled $False -MapiEnabled $True

#Next Lines Added 2020-01-06 - Updated 2020-2-10 (SI no se dispone no se asigna nada, ni siquiera u default, para poder buscar los "pendientes" de asignar foto
#if (Test-Path  "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg") {$PhotoFile="P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg"} else {$PhotoFile="P:\Folders\Soporte\Docs\Fotos\TQPhoto\_default.jpg"}
Write-Host -Foregroundcolor CYAN "INFO: Setting User Mailbox Profile Picture..."
if (Test-Path  "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg") {Set-UserPhoto -Identity $FullUsrName -PictureData ([System.IO.File]::ReadAllBytes("P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg")) -Confirm:$false} else {echo "Sin foto disponible"}

 
# Activar Archiving
Write-Host -Foregroundcolor CYAN "INFO: Enabling User Mailbox Archive Policy..."
Enable-Mailbox -Identity $FullUsrName -Archive | Select-Object UserPrincipalName, ArchiveStatus
# Cambio de Space - 2019-03-25
# Add-UnifiedGroupLinks -Identity "Team Quality" -LinkType Members -Links $FullUsrName
Write-Host -Foregroundcolor CYAN "INFO: Assigning User Global Groups memberships..."
Add-UnifiedGroupLinks -Identity "teamqualityallgrp@tqcorp.com.ar" -LinkType Members -Links $FullUsrName

# Salir correctamente de la PS365
Remove-PSSession $Session

#Salida de Powershell (Desafectada 2021-02-11 ya que se invoca ahora todo este File desde consola PS, si se sale, se pierden mensajes)
#Read-Host -Prompt "INFO: Script completed. Press Enter to exit"
#exit
Write-Host -Foregroundcolor CYAN "INFO: Script completed"
Stop-Transcript
$date = Get-Date -format "HHmm.dd.MM.yyyy"
Rename-Item -Path "C:\Tools\ABM\NewABM.txt" -NewName "$UsrName.$date.txt"