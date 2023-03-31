## Para instalar el servicio  en Windows

***Es necesario JAVA x86 y x64 instalados y la ultima version requiere Java11***

Ejecutar la siguiente secuencia de comandos
c:\users\netamdin\ubiquiti ubifi\
```
java -jar lib\ace.jar installsvc
```
c:\users\netadmin\ubiquiti ubifi\
```
java -jar lib\ace.jar startsvc
```
Para actualizar una version es necesario reinstalar el servicio, se debera pararlo, desinstalarlo y volverlo a instalar
c:\users\netadmin\ubiquiti ubifi\
```
java -jar lib\ace.jar uninstallsvc
java -jar lib\ace.jar installsvc
java -jar lib\ace.jar startsvc
```