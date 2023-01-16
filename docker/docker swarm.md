#Docker Swarm Single Node

##Ubicacion de archivo JSON para habilitar features experimental
```
c:\programdata\docker\config\daemon.json
```

##Content daemon.json
```						
{
	"experimental" : true
}
```

##Verficacion: 
```
docker info
docker version
docker info | grep swarm
```
##Inicializar Swarm
```
docker swarm init --advertise-addr 192.168.32.x
```

To add a manager to this swarm, run ```docker swarm join-token manager``` and follow the instructions.

##Verificar el estado con
```
docker node ls
docker node inspect self
```	

## Run Docker as a service
Para iniciar un contenedor en swarm y no en el docker debe hacerme como servicio
Es una definicion de una aplicacion y describe su estado
```
docker service --help
```

web=nombre del servicio
nginx=nombre de la imagen
	
##Creacion
```
docker service create --name web --publish 80:80 nginx
```
	
#Remove
```
docker service rm "nombre"
```
Tambien de esta forma elimina todos los container en un solo comando

##Updating inc. o dec. la cantidad de containers en swarm
```
docker service update --replicas=2 web
docker service scale IIS=3
```
	
##Create a service (Ejemplo IIS)
```
docker service create --name IIS --publish 80:80 mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
```
##Igual a lo anterior pero con un parametro para balancear el servicio entre los nodos (modo global un container por nodo)
```
docker service create --name IIS --mode=global --publish 80:80 mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
```

##Verificar estado del container
```
docker service ps IIS
```

## Apache Benchmark para probar la perfo de un website con utilidad xampp en windows
```
ab -n 1000 -c 4 http://
```
	
#Portainer

Herramienta de alto nivel para gestiona de dockers de manera remota
Seguir la guia de instalacion de Portainer

##Para consultas posteriores de token correr desde nodo master a fin obtener el comando
	docker swarm join-token worker

##Actualizar estado de nodos
```
docker node update
docker node update --availability=drain TQARSVW19LAB02
```
Con el comando anterior los nodos quedan en un estado tipo mantenimiento
```
ID               						             HOSTNAME         		    STATUS       	  AVAILABILITY 
kzwxcfzscbo6891ql5biccwtg *	 TQARSVW19LAB01      Ready               Active   
hziu7eetl5ratmb4ut9zi4o6x     	 TQARSVW19LAB02      Ready               Drain    
ldmizlhztda7h0ik2i7zn70wy     	 TQARSVW19LAB03      Ready               Active  
```

#Para sacarlo de ese estado de drain
```
docker node update --availability=active TQARSVW19LAB02
```

##Networking

Swarm crea un switch especifico para manejar el trafico y ruteo entrante, todo es automatico
```
docker network ls
```
```
NETWORK ID         NAME               DRIVER          SCOPE
wcdap09m6i4a        ingress             overlay             swarm
```

Vale mencionar que esta red-switch balancea automaticamente el acceso hacia el container aunque el nodo contactado no tenga un container activo

##Ruteo externo

- Se puede hacer un agregado en los DNS con roun-robin pero puede fallar
- Se puede crear un load-balancer externo apuntando a las direcciones de los dockers, NLB tipo forti o netscaler

##Como opera swarm en tolerancia a fallos de operaciones
Los container existentes son siempre monitoreados, si fallara alguno por problemas en la app seria re creado automaticamente en otro working node

# Servicios como pausarlos
En vez de eliminar un servicio se puede scalar a 0 para eliminar los containers y que no corra
	docker service scale IIS=0
	
##Actualizacion de servicios, ejemplo: cambio de versiones
En el caso de estar corriendo una version de aplicacion que debe ser actualizada hay que realizar un update de swarm apuntando a la imagen tageada como latest o deseable
Suponiendo que el servicio existente se llama registry
```
docker service update --image registry:latest registry 
```

##Incorporar un delay a la actualizacion
```
docker service update --image registry:latest --update-delay=20s registry 
```

##Con paralelismo se ejecutan de manera simultanea como se indica en el switch parallellsm
```
docker service update --image registry:latest --update-delay=20s --update-parallelism=2 registry 
```

Ejecutar este parametro tambien modifica las politicas de actualizacion en el servicio

Revisar modulo 7 Rolling Updates en Watch con linux, quizas implementar un Linux como Swarm master
##Roll-Back una configuracion de servicio
```
docker service update --rollback IIS
```

##Volver a empujar los cambios, vuelve a impactar la configuracion del servicio y sus politicas
```
docker service update  --force IIS
```

##Internal traffic entre containers
Definicionesde la aplicacion publicada
- WEB: Servidor web IIS o front
- DB:Motor de base de datos SQL o back
Creacion de red con driver overlay
Es importante entender que entre el servicio de WEB y DB para que se establezca la comunicacion no es mas necesario publicar el puerto en el servicio DB

##Creacion de switch especifico para comunicacion entre WEB y DB - Subnet aleatoria no existente en la red
```
docker network create -d overlay --subnet=172.16.9.0/24 backnet
```

##Creacion de servicio para WEB publicado en 80 con acceso a la nueva red de backnet
```
docker service create --name web-front -p 80:80 --network=backnet mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
```

##Creacion de backend
```
docker service create --name db-back --network backnet mcr.microsoft.com/windows/servercore/sql:windowsservercore-ltsc2019
```

##Desplegar configuraciones con archivos yaml
La manera de hacerlo es con docker stack, jeraquia:
> service > task > container
stack > service > task > container
> service > task > container

```
docker stack deploy -c archivo.yml stack01
docker service ps stack01
docker stack ls
docker stack services stack01
docker stack ps stack01
```

##Para actualizar un stack modificar el archivo yml y ejecutar el mismo comando inicial
```
docker stack deploy -c archivo.yml stack01
```

##Remove stack
```
docker stack rm docker01
```
	
##Equivalencias y manejos
```
docker run es equivalente a docker service create
docker-compose es equivalente a docker stack deploy
```

##Health Check 
Edicion en el archivo yml, reveer en funcion de necesidad de aplicacion
 
#Protect secrets
 
##Comando de creacion de secretos
```
echo supersecretpassword | docker secret create sql_sa -
docker secret ls
```
	
##Como acceder a ese secreto una vez creado
Acceder al container directamente
buscar dentro de la carpeta secrets y listar la definida anteriormente: sql_sa
Dentro del archivo se encuentra la clave: supersecretpassword

##Pasos
1.crear secret (compartido por todos los managers de swarm)
2.dar acceso al servicio por comando o por archivo yml
3.Las apps leen los secrets desde /secrets en el container

##Remover secret
	docker secret rm sql_sa
No tiene que estar en uso si no hay que quitar todo lo que usa previo a eliminarlo

###La mejor convencion para actualizar secretos es versionarlo

##Notas de curso Swarm Nigel Paulton
El curso es de 2016 por lo que no es valido lo de la implementacion con containers, referirse a la docu mas actual:
https://docs.docker.com/engine/swarm/admin_guide/ puntualmente los manager nodes
En ambientes de produccion correr el swarm manager en HA es mandatorio
1 x Primary
N x Secondaries
En caso de falla se genera una eleccion automatica de fondo

##Filtering and Scheduling
3 tipos de Filtros:
- Afinidad: Correr container en el mismo nodo al lado de ciertos containers o imagenes
- Constrain: Estandard data y custom Labels
- Resource: Correr container en funciond e recursos como puertos libres
**Labels es lo que va**

Listar todos los labels y nodos:
```
docker node ls -q | xargs docker node inspect \ -f ‘{{ .ID }} [{{ .Description.Hostname }}]: {{ .Spec.Labels }}’
```

##3 tipos de scheduling
Random
Spread: Despiegla en el que tiene menos containers de manera pareja
Binpack: Despliega en el nodo con mas containers hasta el maximo y despues salta, elige siempre primero el nodo mas chico en hard. Hay que especificar ram y cpu para que tenga un limite. Tambien cuentan los containers apagados como containers

Un nodo swarm solo puede haber una estrategia de scheduling por vez

#Certificates






