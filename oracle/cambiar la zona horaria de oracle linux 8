# Cambio de hora y timezone

## Verificamos la hora
```
date

/usr/bin/timedatectl | grep 'Time zone:'
```
## Listar todas las zona disponibles
```
/usr/bin/timedatectl list-timezones
```
## Buscamos la zona horaria de Argentina
```
/usr/bin/timedatectl list-timezones | grep -i Argentina
```
## Configurar la nueva zona
```
/usr/bin/timedatectl set-timezone America/Argentina/Buenos_Aires
```
## Volvemos a verificar la hora
```
date

/usr/bin/timedatectl | grep 'Time zone:'
```
