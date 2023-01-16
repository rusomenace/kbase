**Atencion! Se recomienda crear un snapshot de la virtual para prevenir cualquier inconveniente**

# Introduction 
El siguiente es un detalle basico de la ultima actualizacion, cuando ocurra la siguiente se detallaran todos los pasos necesarios:

- [Upgrade](https://docs.bitnami.com/aws/apps/moodle/administration/upgrade/)
- [Ultima actualizacion .tar stable](https://download.moodle.org/releases/latest/)

## Ubicacion de los archivos de configuracion y de docker-compose
```
/home/uroot/
```
Descargar del link de actualizaciones estables la ultima version como tgz en directorio backups, se recomienda hacerlo via winscp ya que el wget fallo descargando el archivo .tgz

## Descomprimir el tgz en el directorio de moodle
```
/backups tar -xzvf moodle-latest_release.tgz
```
## Apagar el stack de servicio
```
/home/uroot/compose/down.sh
```
# Respaldar todo el directorio de moodle y limpiar el directorio operativo
```
rsync -a /var/lib/docker/volumes/compose_moodle_data/_data/ /home/uroot/backups/moodle.backup
rm -r /var/lib/docker/volumes/compose_moodle_data/_data/*
```
# Actualizar a la nueva version descomprimida y restaurar archivos de configuracion
```
rsync -a /home/uroot/backups/moodle/ /var/lib/docker/volumes/compose_moodle_data/_data/
rsync -a /home/uroot/backups/moodle.backup/config.php /var/lib/docker/volumes/compose_moodle_data/_data/config.php
mkdir /var/lib/docker/volumes/compose_moodle_data/_data/blocks/xp
rsync -a /home/uroot/backups/moodle.backup/blocks/xp/ /var/lib/docker/volumes/compose_moodle_data/_data/blocks/xp/
```
## Eliminar imagen de moddle, generalmente la que se comenta a continuacion pero el IMAGE ID puede cambiar
```
bitnami/moodle          latest    43a7e4e70e0a   2 months ago   652MB
```
## Iniciar el stack de servicio
```
/home/uroot/compose/up.sh
```

# Plugins
Los plugins se actualizan a mano, se debe descargar el archivo .zip y reemplazar en la ubicacion correspondiente al plugin.
Una vez reemplazados los archivos actualizar la web page de moodle y seguir las instrucicones de actualizacion de la base de datos y demas, el siguiente es un ejemplo de rsync en linux
```
rsync -a /source/folder/plugin/ /destination/folder/plugin/
```
