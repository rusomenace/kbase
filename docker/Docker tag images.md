# Realizar el tag correspondiente entre la imagen y lo que se va a subir a registry

## Imagen: smartopen.latest
```
docker login registry.tqcorp.com/link/smartopen
docker tag smartopen:latest registry.tqcorp.com/link/smartopen:latest
docker push registry.tqcorp.com/link/smartopen:latest
```

## Cambiar el nombre o tag de una imagen
```
docker image tag server:latest myname/server:latest
```
o
```
docker image tag d583c3ac45fd myname/server:latest
```