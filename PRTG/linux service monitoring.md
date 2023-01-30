# Monitorear servicios en linux

## Creacion de script de ejecucion
Crear las siguiente carpetas si no existen en el linux destino. Cada OS debera contener su carpeta con su script para ser ejecutado desde prtg
```
/var/prtg/scripts
```
Incluir el siguiente archivo 
```
query_process.sh
```
Editar el documento
```
nano query_process.sh
```
Incluir el siguiente script
```
#!/bin/sh

service $1 status 2>&1 1>/dev/null

if [ $? -ne 0 ]; then
  echo "1:$?:$1 down"
else
  echo "0:$?:OK"
fi
```
Permitir que el script se pueda ejecutar
```
chmod +x query_process.sh
```

## Sensor en prtg
### Creacion del sensor
El sensor a crear es del tipo **SSH SCRIPT**
En los sensor settings, en parameters colocar el nombre del servicio

### Ajustes del sensor
En la pantalla de vision general del sensor modificar los valores con la rueda de "edit channel settings"
Seleccionar "enable limits"
Lower Error Limit (#): 0

*Nota: Es importante que las credenciales de SSH sean correctas y que tenga permisos de SUDO*