# Robocopy

Para copiar todo de un source a un destination

- /MIR equivale a todo el contenido, folders, subfolders, files
- /COPY:DATSOU mantiene acl y atributos de los archivos
- /E copia subdirectorios incluidos los que estan vacios

Ejecutar el CMD como administrador copia origen a destino manteniendo permisos y dejando un log de actividad en C:\Temp. Tiene paralelismo de x10 y excluye todos los archivos .TMP.
```
robocopy "\\172.26.40.63\cor" "\\192.168.110.11\cor" /E /MIR /COPY:DAT /LOG:C:\temp\cor.log /TEE /MT:10 /XF *.tmp
```
