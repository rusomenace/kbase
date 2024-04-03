# Full install

## Downloads

- [ADMT v3.2](https://www.microsoft.com/en-us/download/details.aspx?id=56570)
- [PES v3.1 (x64)](https://www.microsoft.com/en-us/download/details.aspx?id=1838)
- [SQL Express 2019](https://www.microsoft.com/en-us/download/details.aspx?id=101064)

## Trust rel
1. Agregar en ambos dominios en los DNS Conditional forwarders el DC FSMO del otro dominio

[How to setup DNS Conditional Forwarders](https://www.youtube.com/watch?v=kOc4P59SIEU)

2. Crear una relacion de confianza con las siguientes caracteristicas:
- Type: Forest
- Transitive: yes 

3. Plantear accion para evitar problemas de claves, generalmente se deshabilitar en origen cambio de clave y caducidad de la clave para mantener la misma hasta finalizado el ADMT.
Es importante tener en cuenta que previo a quitar la caducidad de clave se debera volver a colocar la clave en la cuenta para que el contador de dias desde el ultimo cambio vuelva a cero y no bloquee la cuenta.

4. Reequerimientos y descargas de ADMT Tool v3.2
https://www.microsoft.com/en-us/download/details.aspx?id=56570

5. Puertos necesarios para habilitar en controladore de dominio destino:

**TCP**
- 389 – LDAP
- 88 – Kerberos
- 53 – DNS
- 445 – SMB/CIFS
- 3268 – Global Catalog (GC)
- 135 – RPC
- 137
- 138
- 1024-65535 – Dynamic Port Range
- 49152 – 65535 – Dynamic Port Range

**UDP**
- 137
- 138

6. Se recomienda la instalacion en Windows Server 2019

https://danteict.nl/2021/03/install-and-use-admt-3-2-on-windows-server-2019/

7. Instalar SQL Express en el server de ADMNT, es necesario para la migracion.

8. En el caso de querer migrar las cuentas manteniendo la clave de origen se debera ejecutar el siguiente comando en la carpeta de admt powershell admin:
```
PS C:\Windows\admt> .\admt.exe key /option:create /sourcedomain:inke.local /keyfile:c:\FileMigPass.pes /keypassword:Pass@123
```

9. Crear cuenta en dominio destino\adm-admt
10. Agregar cuenta destino\adm-admt al grupo **Builtin\Administrators** del dominio origen
11. Solucion al problema de migracion parcial como solucionar el problema de proxyaddress en ADMT. Con esta solucion se remueve la exclusion de los valores **mail** y **proxyaddresses** que no se migraban con ADMT.

    11a. Create a new VBS script by coping the following info a Notepad document, then saving as ```DisplayExclusionList.vbs``` en C:\Temp

    11b. 2. Open an Administrative Command Prompt, navigate to **C:\Windows\SysWow64**, then run the the command
    ```
    cscript.exe C:\Temp\DisplayExclusionList.vbs
    ```
    11c. Once you have done this, you will see the list of all the items that are in the exclusions list.  From here you can create a similar script which will amend that list and remove **mail** and **proxyAddress**
    ```
    Set o = CreateObject("ADMT.Migration")
    
    o.SystemPropertiesToExclude = "msDS-PSOApplied,msDS-HostServiceAccount,attributeCertificateAttribute,audio,carLicense,departmentNumber,employeeNumber,employeeType,gecos,gidNumber,homePostalAddress,houseIdentifier,ipHostNumber,jpegPhoto,labeledURI,loginShell,memberUid,msDFSR-ComputerReferenceBL,msDFSR-MemberReferenceBL,msDS-ObjectReferenceBL,msDS-SourceObjectDN,msExchAssistantName,msExchHouseIdentifier,msExchLabeledURI,msRADIUS-FramedIpv6Route,msRADIUS-SavedFramedIpv6Route,msSFU30Aliases,msSFU30Name,msSFU30NisDomain,msSFU30PosixMember,msSFU30PosixMemberOf,networkAddress,nisMapName,otherMailbox,photo,preferredLanguage,registeredAddress,roomNumber,secretary,shadowExpire,shadowFlag,shadowInactive,shadowLastChange,shadowMax,shadowMin,shadowWarning,textEncodedORAddress,uid,uidNumber,unixHomeDirectory,unixUserPassword,userPKCS12,userSMIMECertificate,x500uniqueIdentifier"
    ```
    11d. Whilst this might look like a really long command, all I did was copy the output from the DisplayExclusionsList.vbs file, then input it at the end of the script.
    11e. Ref: https://blog.arkwright.com.au/2018/12/proxyaddress-attribute-doesnt-copy-when.html

12. La instalacion de PES tiene que ser en un controlador de dominio destino y esta soportado un PES y un dominio por controlador de dominio.

Durante la instalacion de PES colocar los datos de origen\adm-admt y la password export key
Si no se tiene acceso con la cuenta de ADMT al domain controller donde se instala PES se pueden ejecutar estos comandos para instalarlo con una cuenta Domain Admin en el controlador de dominio elegido:
```
runas /netonly /user:origen\adm-admt cmd.exe
msiexec /i pwdmig.msi
```
13. Recomendacion de Microsoft para migrar las cuentas:
    1. Grupos
    2. Usuarios
    3. Computadoras
14. Para poder migrar cuentas hay que iniciar sesion con destino\adm-admt en el server de ADMT para poder acceder al password exporter

## Ref:
- [ADMT 3.2 Step by Step Installation and Migration Full](https://www.youtube.com/watch?time_continue=1892&v=wXsLjzpb9ZA&embeds_referring_euri=https%3A%2F%2Fvschamarti.wordpress.com%2F&source_ve_path=MTM5MTE3LDIzODUx&feature=emb_title)
- [ADMT Part1 ADMT 3.2 Step by Step Installation and Migration
](https://www.youtube.com/watch?time_continue=1892&v=wXsLjzpb9ZA&embeds_referring_euri=https%3A%2F%2Fvschamarti.wordpress.com%2F&source_ve_path=MTM5MTE3LDIzODUx&feature=emb_title)
- [Interforest Migration with ADMT 3.2 – Part 3
](https://mcselles.wordpress.com/2016/02/22/interforest-migration-with-admt-3-2-part-3/)

## Powershell scripts

1. PS para obtener datos de cuenta en Active Directory
```
# Import the Active Directory module
Import-Module ActiveDirectory

# Prompt for the username
$username = Read-Host -Prompt "Please enter the username"

# Get the user details
$user = Get-ADUser -Identity $username -Properties UserPrincipalName, ProxyAddresses, ObjectGUID, EmailAddress, SID, SIDHistory

# Print the attributes in cyan
Write-Host "UserPrincipalName: $($user.UserPrincipalName)" -ForegroundColor Green
Write-Host "ProxyAddresses: $($user.ProxyAddresses)" -ForegroundColor DarkGreen
Write-Host "ObjectGUID: $($user.ObjectGUID)" -ForegroundColor Green
Write-Host "UPN: $($user.UserPrincipalName)" -ForegroundColor DarkGreen
Write-Host "Email Addresses: $($user.EmailAddress)" -ForegroundColor DarkGreen
Write-Host "SID: $($user.SID)" -ForegroundColor DarkGreen
Write-Host "SIDHistory: $($user.SIDHistory)" -ForegroundColor DarkGreen
```