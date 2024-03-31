En el siguiente ejemplo se quiere remover entradas del registro de Windows que no son modificables por el administrador local.
Para ello utilizamos una aplicacion de SYSINTERNAL para elevar el CMD a un nivel superior y que nos permita eliminarlas.

1-Descargar el siguiente software y colocarlo en el directorio c:\temp
https://learn.microsoft.com/en-us/sysinternals/downloads/psexec

2-Ejecutar el siguiente comando para iniciar la consola
```
Start-Process -FilePath cmd.exe -Verb Runas -ArgumentList '/k C:\temp\PSTools\Psexec.exe -I -s powershell.exe'
```
3-Los siguientes comando eliminan las entradas de registro protegidas
```
Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM\*" -Recurse
Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceClasses\*" -Recurse
Remove-Item -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider\*" -Recurse
```

