## Objetivo
El presente documento tiene el objetivo de explicar conceptos de respaldo de NetApp y la configuración para copiar esos respaldos en un sitio remoto
## Conceptos
Backups automáticos: Si no se modificaron nunca los respaldos automáticamente la cabina respalda de la siguiente manera:
- Cada 8 horas
- Diariamente
- Semanalmente
Modo privilegiado: Es el modo en el que hay que entrar para modificar o ver los respaldos de la cabina, el comando es:
set -privilege advanced

URL Remotas: los siguiente son los protocolos soportados para respaldo remoto:
- HTTP
- HTTPS
- FTP
- FTPS
- TFTP
Respaldos locales y remotos: NetApp confirmo que la copia programada a un sitio remoto no suplanta el respaldo local. El respaldo se ejecuta según este programado y automáticamente se copia al sitio remoto manteniendo así un respaldo en cada nodo y un tercero en el sitio remoto

Documentación oficial: https://docs.netapp.com/us-en/ontap/pdfs/sidebar/Back_up_and_restore_cluster_configurations__cluster_administrators_only_.pdf
## Procedimiento
1.	Nos conectamos a la cabina por SSH
2.	Ejecutamos el comando set -privilege advanced y aceptamos la advertencia
Ejecutamos system configuration backup settings show -instance para listar los respaldos programados y verificar su existencia. El resultado debe ser similar a este:
```
                  Backup Destination URL: -
                Username for Destination: -
            Validate Digital Certificate: -
                              Schedule 1: 8hour
Number of Backups to Keep for Schedule 1: 2
                              Schedule 2: daily
Number of Backups to Keep for Schedule 2: 2
                              Schedule 3: weekly
Number of Backups to Keep for Schedule 3: 2
```
3.	Ejecutamos el comando system configuration backup show para listar todos los respaldos existentes en cada nodo, el formato y características de los respaldos es similar a este: SJD-A220.8hour.2023-11-15.18_15_00.7z -node SJD-A220-01
4.	Es recomendable realizar una prueba de subida para asegurar que el repositorio destino esta disponible y que el archivo sube correctamente
En este ejemplo utilizamos FTP:
```
system configuration backup upload -backup FAS2552.8hour.2023-11-15.02_15_00.7z -node FAS2552-01 -destination ftp://10.1.1.200/FAS2552
```
Al momento de ejecutar el comando nos va a solicitar usuario y contraseña
5.	Una vez la subida es exitosa ejecutamos el comando para modificar la URL en todas las tareas programadas:
```
system configuration backup settings modify -numbackups1 2 -numbackups2 2 -numbackups3 2 -destination ftp://10.1.1.200/AFF220 -username netapp
```
6.	El comando anterior modifico la URL y definió un usuario para la subida, pero la clave debe definirse con un comando adicional:
```
system configuration backup settings set-password
```
7.	Una vez modificado todo ejecutamos backup settings show -instance y el resultado debe ser similar a este:
```
system configuration backup settings show -instance
                  Backup Destination URL: ftp://10.1.1.200/AFF220
                Username for Destination: netapp
            Validate Digital Certificate: false
                              Schedule 1: 8hour
Number of Backups to Keep for Schedule 1: 2
                              Schedule 2: daily
Number of Backups to Keep for Schedule 2: 2
                              Schedule 3: weekly
Number of Backups to Keep for Schedule 3: 2

Importante, notas de seguridad 
```
Se recomienda utilizar usuario y clave para el acceso a las URLs remotas
Se recomienda definir acceso exclusivo a estas URLs desde las direcciones ip de las cabinas
Se recomienda armar paths o puntos de montura específicos para cada cabina a fin de mantener separados y ordenados los respaldos de cada una de ellas
