## Un Bug en vcenter genera un archivo que trunca nunca y llena el disco

Revisar los tamaños de las carpetas con el siguiente comando y analizar cual esta llenado todo el espacio:
```
du -h
```
#Ejecutar el siguiente comando via shell para truncar el archivo stdout:
```root@mkrovcenter01 [ /storage/log ]# cat /dev/null > content-library-runtime.log.stdout```

Eliminar todos los archivos con descripciones de este tipo: log-0 log-1

**Ref:** https://communities.vmware.com/t5/vCenter-Server-Discussions/Storage-Log-is-full-due-to-content-library-runtime-log-stdout/td-p/2922340