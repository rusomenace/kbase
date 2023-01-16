# Ejecutar los siguientes compandos:

Listar los containers activos
```
docker ps
```
Tomar nota del numero de container ejemplo: 7a4377648305
Parar el container
```
docker stop 7a4377648305
```

Eliminar container
```
docker rm 7a4377648305
```

Listar imagenes ejemplo
```
docker image ls
```

Ejemplo de resultado

REPOSITORY               TAG       IMAGE ID       CREATED      SIZE
portainer/portainer-ce   latest    5121527e11b8   7 days ago   206MB

Actualizar la imagen y verificar su descarga
```
docker pull portainer/portainer-ce:latest

docker image ls
```

## **Atencion: si quedaran 2 imagenes se debe eliminar la obsoleta con el comando docker rm nombre-de-image -f**

## En el servidor de portainer en la ruta /home/uroot/yml/portainer se encuentran los siguientes archivos:
- docker-compose.yml
- up.sh **(Este script inicia el stack de servicio con un nombre especifico de proyecto)
- down.sh **(Script que para todo el stack de servicio)**