#Como definir TAGs
En el siguiente ejemplo de un archivo yml para docker compose se observa el label que es el que hay que modificar para que portainer aplique la acl de acceso a los grupos permitidos

```
version: '3.3'
services:
    schedulerwl:
        volumes:
            - 'C:/Docker/WL/scheduler/schedulersinremotingImple/dataVolumen:c:/TeamQuality/logs'
        container_name: schedulerwl
        ports:
            - '1282:1282'
        image: schedulerwl
        labels:
          - "io.portainer.accesscontrol.teams=WorldLine"
```