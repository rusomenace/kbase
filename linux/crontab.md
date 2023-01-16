# Crontab

Creacion de una tarea en crontab para ejecucion automatica cada hora desde script y liberar memoria algo que se debe hacer regularmente en servidores de docker con muchos deploys ya que el proceso containerd no libera la memoria ram consumida

## Crear un archivo .sh que contendra el script
```
nano /opt/docker_purge.sh
```
## Incorporar los siguientes comandos
```
sync
echo 1 > /proc/sys/vm/drop_caches
docker system prune -f
```
## Habilitar al script para su ejecucion
```
chmod +x docker_purge.sh
```
## Ingresar al crontab
```
crontab -e
```
## Sie es la primera vez que se ejecuta aparecera un menu de seleccion de editor, se elije [1]
```
no crontab for root - using an empty one

Select an editor.  To change later, run 'select-editor'.
  1. /bin/nano        <---- easiest
  2. /usr/bin/vim.basic
  3. /usr/bin/vim.tiny
  4. /bin/ed

Choose 1-4 [1]: 1
```
## Agregar la siguiente instruccion al final del documento, salvar y salir
```
0 * * * * /opt/docker_purge.sh```
```
- El comando ```crontab -l``` lista toda la configuracion existente
- El comando ```crontab -r``` Elimina las tareas actuales
