## Redhat

Verificar los modulos instalados
```
yum list installed | grep nginx
```
El resultado va a mostrar varios modulos asociados a la version de nginx actualmente instalada, a continuacion se muestra un ejemplo de modulo nginx 1.14
```
nginx.x86-64        1:1.14.1-9.module_el8.0.0+184+e34fea82 @AppStream
```
### Desinstalacion
```
yum remove nginx
```
Verificar el estado de los modulos desinstalados
```
yum list installed | grep nginx
ls /etc/nginx
```
El resultado del **LS** deberia ser No such file or directory
