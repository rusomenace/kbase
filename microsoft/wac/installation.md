**Source:** https://docs.microsoft.com/en-us/windows-server/manage/windows-admin-center/deploy/install

## Comando de instalacion modelo:
```
msiexec /i <WindowsAdminCenterInstallerName>.msi /qn /L*v log.txt SME_PORT=<port> SME_THUMBPRINT=<thumbprint> SSL_CERTIFICATE_OPTION=installed
```

## Comando productivo:
```
msiexec /i <WindowsAdminCenterInstallerName>.msi /qn /L*v log.txt SME_PORT=443 SME_THUMBPRINT=D349360672CBD243A7ACB2F3368AA65FBE189F16 SSL_CERTIFICATE_OPTION=installed
```

## Obtener el thumbprint del certificado instalado
```
Get-ChildItem -Path Cert:LocalMachine\MY
```

## Instalar un certificado en Windows Core .pfx
```
$mypwd = Get-Credential -UserName 'Enter password below' -Message 'Enter password below'
Import-PfxCertificate -FilePath C:\mypfx.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $mypwd.Password
```

***Para delegar los permisos de kerberos referirse al powershell kcdelegation.ps1***

## Para limpiar el token de kerberos en un equipo esperar 15 minutos o ejecutar este script
```
Invoke-Command -ComputerName servername -ScriptBlock {
    klist purge -li 0x3e7
}
```