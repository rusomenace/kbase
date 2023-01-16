# Se crea un archivo .ps1 firmado con certificados

Utilizar el archivo java.ps1 modificado como punto de partida
```
$cert=(dir cert:currentuser\my\ -CodeSigningCert)
Set-AuthenticodeSignature .\java.ps1 $cert
```
El archivo se ubica en startup script de la GPO que lo aplica
```
\\tq.com.ar\SYSVOL\tq.com.ar\Policies\{3DEBD773-228E-40B7-B000-176CFC9B9C6E}\Machine\Scripts\Startup
GPO Path: Computer Configuration>Policies>Software Settings>Scripts>Startup>Powershell Scripts
```
Valores de configuracion de powershell para java con esto elimina todo rastro de versiones anteriores
uninstall all products exept "and not version" se remueve todo lo anterior que no sea version 8.0.2910.10, este valor se va modificando a partir de nuevas versiones
```gwmi Win32_Product -filter "name like 'Java%' AND vendor like 'Oracle%' AND not version = '8.0.2910.10'" | % { $_.Uninstall() }```

network silent install, tienen que existir los instaladores con extencion .EXE y no MSI
```\\software\Software\Java\JRE\jre-8u291-windows-x64.exe /s```

Proceso de espera que inicializa el siguiente instalador pasados 90 segundos
```Wait-Event -SourceIdentifier "ProcessStarted" -Timeout 90
software\Software\Java\JRE\jre-8u291-windows-i586.exe /s```

## Valores de configuracion para adobe update

```AcroRdrDC2100520058_en_US.exe /sAll /rs /msi EULA_ACCEPT=YES```

network silent install
```software\Software\Java\JRE\jre-8u301-windows-x64.exe /s /L C:\Windows\Logs\301x64.log```