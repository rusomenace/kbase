# Dozzle
Herramienta para ver el log de los containers
Repo: https://github.com/amir20/dozzle

## Imagen
```
docker pull amir20/dozzle:latest
```

## yml file compose y swarm
```
version: "3"
services:
  dozzle:
    image: amir20/dozzle:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 8080:8080
    deploy:
      placement:
        constraints: [node.role == manager]
```