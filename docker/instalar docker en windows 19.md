# Instalacion en Windows Server 2019
Source: Prep Windows operating system containers | Microsoft Docs

## Hyper-V y Modulos
```
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
```

## Containers
```
Install-WindowsFeature containers
```

## Docker provider install	
```
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
```

## Listar Docker
```
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Install-Package -Name docker -ProviderName DockerMsftProvider 
```
## Version especifica
```
Install-Package -Name docker -ProviderName DockerMsftProvider -Force -RequiredVersion 19.03 
```

## Consultar por nuevas actualizaciones
```
Find-Package -Name docker -ProviderName DockerMsftProvider
```
## Actualizar
```
Stop-Service docker
Install-Package -Name Docker -ProviderName DockerMSFTProvider -Update -Force
Start-Service docker
Docker version
```

## Open firewall port 2375
```
netsh advfirewall firewall add rule name="docker engine" dir=in action=allow protocol=TCP localport=2375
```

## Configure Docker daemon to listen on both pipe and TCP (replaces docker --register-service invocation above)
```
Stop-Service docker
dockerd --unregister-service
dockerd -H npipe:// -H 0.0.0.0:2375 --register-service
Start-Service docker
```

## Verificar docker
```
docker version
```

## Compose
**Fuente:** [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)
```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest " https://github.com/docker/compose/releases/download/1.27.2/docker-compose-Windows-x86_64.exe" -UseBasicParsing -OutFile $Env:ProgramFiles\Docker\docker-compose.exe
```

## Alternativa en SSH
```
Get-WindowsCapability -Online -Name *OpenSSH*
```

**En el caso de falla del anterior comando descargar manualmente el servidor siguiendo las siguientes instrucciones:**
[https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH)

**Se debera instalar el cliente en la imagen**

##Instalar modulo de server SSH
```
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
get-service *ssh*
```

##Setear automatico
```
Get-Service *ssh* | Set-Service -StartupType Automatic
Get-Service *ssh* | Start-Service
```

## Set Default Powershell as prompt - Optional for SSH Server
```
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
```

## Pull Images
```
docker image pull mcr.microsoft.com/windows/servercore:ltsc2019
docker image pull mcr.microsoft.com/windows/nanoserver:1809  
```

## .net Core Images
```
docker image pull mcr.microsoft.com/dotnet/core/aspnet:3.0
docker image pull mcr.microsoft.com/dotnet/core/sdk:3.0.100  
```

## IIS Image
```
docker pull mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
```
