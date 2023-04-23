# Monitorear updates de linux en PRTG

## Crear el script de updates en el servidor a moniteorear
Crear las siguiente carpetas si no existen en el linux destino. Esto debe realizarse en todos los servidores que van a ser monitoreados
```
sudo mkdir -p /var/prtg/scripts
```
Crear el script que PRTG leerá para indicar si hay updates disponibles en el sistema
```
sudo nano /var/prtg/scripts/updates.sh
```

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