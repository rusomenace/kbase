# Machete de comando utiles

## Listar tamaño de disco y espacio libre
```df -h```
## Muestra el espacio libre sin asignar
```vgdisplay```
## Eliminar una carpeta incluyendo todo lo que contenga (recursivo)
``` rm -r /carpeta/a/borrar```
## Listar archivos y y su tamaño en el nivel actual
```
du -sh *
du --summarize --human-readable *
```
## Liberar memoria del servicio de docker
```
sync
echo 1 > /proc/sys/vm/drop_caches
```
## Version de sistema operativo
```
lsb_release -a
```
```
cat /etc/os-release
```
## Modulo para navegar los directorios (ubuntu)
ncdu

## Listar gran cantidad de files y tambien eliminarlos
```
find . -name "*.pdf" -delete
```

## Listar todos los servicios disponibles
```
systemctl list-units --type=service
OR
systemctl --type=service
```
El mismo comando se puede utilizar con la opcion grep para buscar un servicio en particular
```
systemctl list-units --type=service | grep snmpd
```