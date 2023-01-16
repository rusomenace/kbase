# Introduction 
Creacion de scripts de JAVA para deploy via GPO en red

# Getting Started

1.	Modificacion de script para nueva version
2.	Descarga y ubicacion de archivos

### 1. Modificacion de script para nueva version
Ubicacion de los scripts de java: ```P:\Folders\Soporte\Docs\KBASE\Microsoft\PowerShell\Package Install```
Para tener absoluta certeza de que version se va a instalar se debe actualizar una estacion de trabajo para corroborar la version del ejecutable y asi modificar los scripts.
Modificaciones:

- Reemplazar en java.ps1 la version de java por la mas actualizar
- Reemplazar en java.ps1 el nombre del ejecutable que coincide con la version antes cambiada
- Reemplazar en java2.ps1 el nombre del ejecutable

La version de java se puede ver en las propiedades del ejecutable java.exe, generalmente se encuentra en esta ubicacion: ```C:\Program Files\Java\jre1.xxxxxxxx\bin```
En este repositorio se encuentran los 2 archivos comunmente utilizados, existen 2 ya que se realiza una instalacion primero de una version de x64 y despues una de x86.
En pruebas de laboratorio se intento crear un script unico pero la instalacion simultanea de ambas versiones termina desinstalando una y sobreescribiendola por otra.

Para firmar los archivos ps1 se deberan correr los siguientes comandos:
```
$cert=(dir cert:currentuser\my\ -CodeSigningCert)
Set-AuthenticodeSignature "P:\Folders\Soporte\Docs\KBASE\Microsoft\PowerShell\Package Install\java.ps1" $cert
Set-AuthenticodeSignature "P:\Folders\Soporte\Docs\KBASE\Microsoft\PowerShell\Package Install\java2.ps1" $cert
Remove-Item "\\tq.com.ar\SYSVOL\tq.com.ar\Policies\{3DEBD773-228E-40B7-B000-176CFC9B9C6E}\Machine\Scripts\Startup\java*.ps1"
Copy-Item "P:\Folders\Soporte\Docs\KBASE\Microsoft\PowerShell\Package Install\java*.ps1" "\\tq.com.ar\SYSVOL\tq.com.ar\Policies\{3DEBD773-228E-40B7-B000-176CFC9B9C6E}\Machine\Scripts\Startup"
```


### 2. Descarga y ubicacion de archivos
Descargar los ejecutables de x64 y x86 a un directorio temporal [Java descarga manual](https://www.java.com/en/download/manual.jsp)
Mover los archivos a software: ```\\software\d$\Software\Java\JRE``` o bien ejecutar este PS desde la carpeta de descarga
```
Move-Item *jre*.exe \\software\d$\Software\Java\JRE
```

## Esta metodologia se va a cambiar por una que maneje repos de git y versionado, por el momento es la homologada
