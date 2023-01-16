#Control de Versión de Powershell
IF ($psversiontable.PSVersion.Major -ne 5) 
{
	Write-Host -Foregroundcolor RED -BackgroundColor WHITE "ERROR: This Tool should be run in Powershell Version 5 Only - Current Version is" $psversiontable.PSVersion.Major
	RETURN
}

$TranscriptDate = Get-Date -format "yyyy.MM.dd.HHmm"
$TranscriptFileName = $PSScriptRoot+'\Log\'+[System.IO.Path]::GetRandomFileName()
Start-Transcript -path $TranscriptFileName

# Variables para ingresar datos de ABM
$UsrName = read-host "Username en formato SAMACCOUNTNAME / nombre de NETBIOS"
$FullUsrName = ($UsrName.ToLower() +"@tqcorp.com")
$Pwd = read-host "Clave"
Set-Variable -Scope global -name SecPwd -value (ConvertTo-SecureString -String $Pwd -AsPlainText -Force)
$FirstName = read-host "Nombre"
$FirstName =(Get-Culture).TextInfo.ToTitleCase(($FirstName).tolower())
$Lastname = read-host "Apellido"
$Lastname =(Get-Culture).TextInfo.ToTitleCase(($Lastname).tolower())
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
    4 - Pablo Ferrero
    5 - Emiliano La Rocca
    6 - Leonardo Pisani
    7 - Patricia Megide
    8 - Thomas Hatcherian
    
    Ingresar opcion"
    Switch ($type){
        1 {$choice="ascheinkman"}
		2 {$choice="amastache"}
        3 {$choice="bblanco"}
        4 {$choice="pferrero"}
        5 {$choice="elarocca"}
        6 {$choice="lpisani"} 
        7 {$choice="pmegide"}
        8 {$choice="thatcherian"}        
    }
    return $choice
}
$Manager=Get-ProjectType

$List = Read-Host "Ingrese la lista de Grupos de Seguridad a asignar separados por coma"
$GroupList = $List.Split(',')

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
Write-Host "Grupos de Seguridad: " -ForegroundColor White -NoNewline; Write-Host "$List" -ForegroundColor yellow
""
$input = $(Write-Host " Presionar cualquier tecla para continuar o CTRL+C para salir " -ForegroundColor yellow -BackgroundColor black -NoNewLine; Read-Host)
# End

# Se trabaja inicialmente en Domain Controller TQARSVW19DC01
Import-Module ActiveDirectory
Set-Variable -Scope global -name ADController -value "tqarsvw19dc01"

Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: New User creation Script execution"
Write-Host -Foregroundcolor CYAN  "INFO: Using Active Directory Domain Controller: $ADController"

Write-Host -Foregroundcolor CYAN "INFO: Creating Active Directory User object..." 
New-ADUser -Server $ADController -SamAccountName $UsrName -AccountPassword $SecPwd -ChangePasswordAtLogon $False -Name ($FirstName + " " + $LastName)  -DisplayName ($FirstName + " " + $LastName)  -GivenName $FirstName -Surname $LastName -UserPrincipalName $FullUsrName                        -Path $OUName -ScriptPath "Login.bat" -Enabled $True -Department $Depto -Company $Cia -Manager $Manager -Title $Cargo -EmailAddress $FullUsrName

#Fuerzo replicación de AD Controllers en Datacenter y Branch
(Get-ADDomainController -Filter *).Name | Foreach-Object {repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A | Out-Null}

Write-Host -Foregroundcolor CYAN "INFO: Waiting Active Directory User creation..."
$count = 0
$success=$False
do{
    try{Get-ADUser -Server $ADController -Identity $UsrName -ErrorAction Stop | Select-Object SamAccountName, UserPrincipalName
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
Set-ADUser -Server $ADController -Identity $UsrName -Clear "proxyAddresses"
Set-ADUser -Server $ADController -Identity $UsrName -Add @{ProxyAddresses="SMTP:" + "$FullUsrName"}

# Grupos de Seguridad default:
Write-Host -Foregroundcolor CYAN "INFO: Assigning User default AD Security Group Memberships..."
Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf ISO9000-SGCReadOnly
Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf DesarrolloListOnly

#Ad-hoc Groups 
If ($OUName.Substring(3, 2).ToUpper() -eq "QA") {
		# 2021-10-13 - Call con ELAROCCA y documentado en TQIT-92978, comment de ELAROCCA 13/10/2021 18:14:03
		Write-Host -Foregroundcolor CYAN  "INFO: QA User, assigning specific AD Security Group Memberships" 
		Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf SFTP-Outbound
		Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf QATesting
		Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf Grp-Arc_QA-RW
	} else {
		Write-Host -Foregroundcolor CYAN "INFO: Assigning Ad-hoc AD Security Group Memberships..."
		ForEach ($Group in $GroupList) {
		IF ($Group.Length -ne 0) {
				Write-Host Membership Assignment: ($Group).Trim()
				Add-ADPrincipalGroupMembership -Server $ADController -Identity $UsrName -MemberOf ($Group).Trim()}
			}
	}

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
$PC = Get-WmiObject -class Win32_OperatingSystem -computername $WKSName
$PC.Description = $cFullName
$PC.Put()
Set-ADComputer -Server $ADController -Identity $WKSName -Description $cFullName

#VM Notes en vCenter *** NOTA: Requiere VMware.PowerCLI ***
Import-Module vmware.powercli
if (Get-Module -ListAvailable -Name "VMware.PowerCLI") {
	Write-Host -Foregroundcolor CYAN "INFO: Setting VMWare VM Notes to Match username as Active Directory Computer Description..."
	Connect-VIServer -Server tqarvcenter.tq.com.ar
	Get-VM -Name $WKSName | Set-VM -Notes "$($_.Notes)$FirstName $LastName" -Confirm:$false | Out-Null
	Get-VM -Name $WKSName | Select-Object Name, Notes
} else {
    Write-Host "WARNING: VMware.PowerCLI not available. Please manually update VM Notes to Match username as Active Directory Computer Description"
}
# Configuraciones Locales del equipo asignado - End

# Synchro en AAD: Azure Active Directory, utilizando Tool del Servidor
Write-Host -Foregroundcolor CYAN "INFO: Syncing Local Active Directory with Azure AD..."
$TmpSess = New-PSSession -Computer TQARSVW16AAD01
Invoke-Command -Session $TmpSess {C:\Tools\Sync.ps1}
#2020-02-27 - CleanUp
Remove-PSSession $TmpSess

# Fortigate - Requiere Install-Module -Name SSHSessions
Write-Host -Foregroundcolor CYAN "INFO: Creating AD user in fortigate TQARFW01..."
$user = [System.Environment]::GetEnvironmentVariable('username').ToLower() # "bblanco"
#$password = Get-Content "C:\Tools\ABM\forticreds.txt" | ConvertTo-SecureString
$pwdfile=$PSScriptRoot+"\key\"+[System.Environment]::GetEnvironmentVariable('username').ToLower()+".fw.key"
$password = Get-Content $pwdfile | ConvertTo-SecureString


$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $user, $password
Get-SSHSession | Remove-SSHSession
New-SshSession -ComputerName "tqarfw01.tqcorp.com" -Credential $cred 

$Command = @"
config user local
edit $FullUsrName
set email-to "$FullUsrName"
set type ldap
set ldap-server "tq.com.ar"
end
config user group
edit "ldap_grp-tq_all"
append member "$FullUsrName"
end
"@

Invoke-SSHCommand -Command $Command -SessionId 0
# CleanUp
Get-SSHSession | Remove-SSHSession

# Office 365
Write-Host -Foregroundcolor CYAN "INFO: Accessing Office 365 environment..."
$O365Usr= ([System.Environment]::GetEnvironmentVariable('username').ToLower()+"@tqcorp.com") 
#$O365Pwd = Get-Content "C:\Tools\Office365\tenantcreds.txt" | ConvertTo-SecureString
$pwdfile=$PSScriptRoot+"\key\"+[System.Environment]::GetEnvironmentVariable('username').ToLower()+".tenant.key"
$O365Pwd = Get-Content $pwdfile | ConvertTo-SecureString
$O365Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $O365Usr,$O365Pwd
#EXO reemplaza este tipo de sesion 13.06.2022 $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -Credential $O365Cred -ShowBanner:$false
# Azure Active Directory v1.0
Import-Module MsOnline 
Connect-MsolService -Credential $O365Cred

#La creación del usuario en 365 es asincrónica. Se hace Wait Loop para continuar
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
}until($count -eq 20 -or $success)
if(-not($success)){
	Read-Host -Prompt "HALT: MS Online User not created. Script cannot continue. Press Enter to exit"
	exit
	}

#Aplicar licencia del plan creado a usuario
Write-Host -Foregroundcolor CYAN "INFO: Assigning MS Online User with proper Office 365 License..."
Set-MsolUser -UsageLocation AR -ObjectId (Get-MSoluser -UserPrincipalName $FullUsrName).ObjectId
Set-MsolUserLicense -UserPrincipalName $FullUsrName -AddLicenses "tqcorp:O365_BUSINESS_PREMIUM"
# Lista en https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference / Lista detallada: Get-MsolAccountSku | Select -ExpandProperty ServiceStatus
Write-Host -Foregroundcolor CYAN "INFO: Setting Office 365 License permissions..."
$LO = New-MsolLicenseOptions -AccountSkuId "tqcorp:O365_BUSINESS_PREMIUM" -DisabledPlans "MYANALYTICS_P2", "KAIZALA_O365_P2",  "DYN365BC_MS_INVOICING", "Deskless","BPOS_S_TODO_1" ,"MICROSOFTBOOKINGS" ,"FORMS_PLAN_E1" ,"FLOW_O365_P1" ,"POWERAPPS_O365_P1" ,"O365_SB_Relationship_Management","PROJECTWORKMANAGEMENT" ,"SWAY" ,"YAMMER_ENTERPRISE"
Set-MsolUserLicense -UserPrincipalName $FullUsrName -LicenseOptions $LO

#La creación del Mailbox en 365 es asincrónica. Se hace Wait Loop para continuar
Write-Host -Foregroundcolor CYAN "INFO: Waiting for User Mailbox creation..."
$count = 0
$success=$False
<#
2022-07-04 Se actualiza Get-Mailbox por siguiente leynda.
New update available!
You are using an older version of Exchange PowerShell cmdlets which may be using (soon to be deprecated) Basic authentication.
Please install version 2.0.6 of the ExchangeOnlineManagement module to upgrade to the latest version of cmdlets, which are REST based, more secure, reliant and performant than the remote PowerShell cmdlets that you are currently using.
#>
do{
#    try{Get-Mailbox -Identity $FullUsrName  -ErrorAction Stop | Select-Object UserPrincipalName, IsMailboxEnabled, WhenMailboxCreated, ServerName
    try{Get-EXOMailbox -Identity $FullUsrName -Properties UserPrincipalName, IsMailboxEnabled, WhenMailboxCreated  -ErrorAction Stop | Select-Object UserPrincipalName, IsMailboxEnabled, WhenMailboxCreated
        $success = $true
        Write-Host -Foregroundcolor CYAN "INFO: User Mailbox created, continuing script execution"
   } catch{
        Write-Host -Foregroundcolor YELLOW "WAIT: User Mailbox not available, next attempt in 60 seconds"
        Start-sleep -Seconds 60
		$count++
    }   
  }until($count -eq 60 -or $success)   #Reintenta 1 hora... En 2022-07-04 se demoró 20 mins...

if(-not($success)){
		#Read-Host -Prompt "HALT: User Mailbox not created. Script cannot continue. Press Enter to exit"
		#exit
		Write-Host -Foregroundcolor WHITE -BackgroundColor RED "HALT: User Mailbox not created. Script cannot continue"
	} else {
		#Configuración regional Mailbox
		Write-Host -Foregroundcolor CYAN "INFO: Setting User Mailbox standard Regional Settings..."
		Set-MailboxRegionalConfiguration -Identity $FullUsrName -Language en-US -DateFormat dd-MMM-yy -TimeZone "Argentina Standard Time" 
		Write-Host -Foregroundcolor CYAN "INFO: Setting User Mailbox standard Language..."
		Set-MailboxSpellingConfiguration -Identity $FullUsrName -DictionaryLanguage Spanish
		Write-Host -Foregroundcolor CYAN "INFO: Setting User Mailbox Protocol permissions..."
		Set-CasMailbox -Identity $FullUsrName -OWAEnabled $False -ActiveSyncEnabled $False -PopEnabled $False -ImapEnabled $False -MapiEnabled $True

		#Profile Photo- SI no se dispone no se asigna nada, ni siquiera u default, para poder buscar los "pendientes" de asignar foto
		Write-Host -Foregroundcolor CYAN "INFO: Setting User Mailbox Profile Picture..."
		if (Test-Path  "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg") {Set-UserPhoto -Identity $FullUsrName -PictureData ([System.IO.File]::ReadAllBytes("P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg")) -Confirm:$false} else {echo "Sin foto disponible"}

		# Activar Archiving
		Write-Host -Foregroundcolor CYAN "INFO: Enabling User Mailbox Archive Policy..."
		Enable-Mailbox -Identity $FullUsrName -Archive | Select-Object UserPrincipalName, ArchiveStatus
		# Mail Groups
		Write-Host -Foregroundcolor CYAN "INFO: Assigning User Global Groups memberships..."
		Add-UnifiedGroupLinks -Identity "teamqualityallgrp@tqcorp.com.ar" -LinkType Members -Links $FullUsrName
	}

#HouseKeeping
# Salir correctamente de la Sesión 365
#EXO reemplaza este tipo de sesion 13.06.2022 Remove-PSSession $Session
[Microsoft.Online.Administration.Automation.ConnectMsolService]::ClearUserSessionState()
# Feedback final
Write-Host -Foregroundcolor CYAN (Get-Date -format "yyyyMMdd-HHmmss") "INFO: Script completed"
Stop-Transcript
# Resguardo del Transcript
Rename-Item -Path $TranscriptFileName -NewName "$UsrName.$TranscriptDate.txt"