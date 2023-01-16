```
version: '3.8'
services:
    linkapi:
        volumes:
            - 'C:/Docker/Link/linkapi/dataVolumen:c:/TeamQuality/logs'
        ports:
            - '7000:7000'
            - '8000:8000'
        networks:
            - link_overlay
        image: linkapi:latest
        deploy:
            mode: replicated
            replicas: 2
            placement:
                constraints: [node.labels.os == windows]
                max_replicas_per_node: 1


    linkapiproxy:
        ports:
            - '7001:7001'
            - '8001:8001'
        networks:
           - link_overlay
        image: linkapiproxy:latest
        deploy:
            mode: replicated
            replicas: 2
            placement:
                constraints: [node.labels.os == windows]
                max_replicas_per_node: 1

networks:
    link_overlay:
        driver: overlay
```

## Comando de ejecucion
```
docker stack deploy --compose-file filename.yml linkstack
```

## Comando de eliminacion
```
docker service rm servicio
```

## Se deberan aplicar los siguientes labels a los nodos que participan de swarm
```
docker node update --label-add os=windows nodename
docker node update --label-add os=linux nodename
```
