### Install Powershell Module
```
Install-Module -Name VMware.PowerCLI -AllowClobber
```
**Quick fix**

### PowerShell
```
Install-Module -Name VMware.PowerCLI 
```
***accept repo warning and install***

copy over file to fix 64-bit issue
```
$newDir = "C:\Windows\assembly\GAC_64\log4net\1.2.10.0__692fbea5521e1304"
New-Item $newDir -ItemType directory -Force
$file = gci "C:\Program Files\WindowsPowerShell\Modules\VMware.VimAutomation.Sdk" | select -last 1 | gci -Recurse -Filter "log4net.dll" | select -first 1
Copy-Item $file.FullName $newDir
```
Verify log4net.dll has copied over
```
Get-ChildItem $newDir
```
close all instances of VS Code, Powershell ISE, or Powershell console
Open x64 powershell and run import-module vmware.powercli
Ignorar certificados
```
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
```