## Docker Image IIS

Create dockerfile con archivo demo contbuilderiis
#Configuracion de dockerfile para la creacion de una imagen con objetos de IIS
-------------------------------------------------------------------------------------------------------------
```
# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell -Command " `
 Install-WindowsFeature Web-Server,Web-Asp-Net45,Web-Mgmt-Service -Verbose ; `
 New-ItemProperty -Path HKLM:\software\microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1 -Force ; `
 Set-Service -Name wmsvc -StartupType Automatic ; `
 New-LocalUser iisadmin -Password ( 'Password1' | ConvertTo-SecureString -AsPlainText -Force) ; `
 Add-LocalGroupMember -Group Administrators -Member iisadmin `
"

ENTRYPOINT "ping -t localhost > NULL"
```
-------------------------------------------------------------------------------------------------------------
## Desde el server correr el siguiente comando de build:
```
docker image build --tag contiisbuilder .
```

## En la ubicacion donde creamos el contiis ejecutar
```
docker image build --tag it-next .
```

## Configuracion de dockerfile para creacion de build IIS Final map port 8001
-------------------------------------------------------------------------------------------------------------
```
# escape=`

FROM contiisbuilder

ENTRYPOINT powershell -Command " `
 Remove-Website -Name 'Default Web Site' ; `
 New-Website -Name it-next -PhysicalPath C:\voliis\it-next ; `
 Stop-Website -Name it-next ; Start-Website -Name it-next ; `
 New-IISSiteBinding -Name "it-next" -BindingInformation "*:8001:" -Protocol http ; `
 ping -t localhost > NULL `
"

HEALTHCHECK --interval=2s `
 CMD powershell -Command `
  try { `
   $result = Get-Service W3SVC ; `
   if ($result.status -eq 'Running') { exit 0 } `
   else { exit 1 } ; `
  } catch { exit 1 }
```
-------------------------------------------------------------------------------------------------------------
## Correr el container con mapeo
```
docker run --detach -it --publish 8001:8001 --name it-next --volume C:\voliis\it-next:C:\voliis\it-next it-next
docker run --detach -it --publish 8001:8001 --name it-next-cont1 pwsh -c $(cat test.ps1) it-next	
```

## Map Persistent network drive
```
Set-ExecutionPolicy bypass C:\PS\map.ps1
New-Item C:\PS
New-Item C:\PS\map.ps1
Set-Content C:\PS\map.ps1 '$User = "tq\hmaslowski"'
Add-Content C:\PS\map.ps1 '$PWord = ConvertTo-SecureString -String "Macoco78." -AsPlainText -Force'
Add-Content C:\PS\map.ps1 '$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord'
Add-Content C:\PS\map.ps1 'New-PSDrive -Name "W" -Root "\\10.1.1.37\sites" -Persist -PSProvider "FileSystem" -Credential $cred'
Add-Content C:\PS\map.ps1 'New-PSDrive -Name "D" -Root "\\10.1.1.37\data" -Persist -PSProvider "FileSystem" -Credential $cred'
```

# Nano for windows
```
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install nano
```