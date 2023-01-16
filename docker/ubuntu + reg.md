#Harbor
https://thenewstack.io/tutorial-install-the-docker-harbor-registry-server-on-ubuntu-18-04/

#Montar disco adicional - cambiar hdd por lo que guste mas
Crear particion
	sudo fdisk /dev/sdb
#Opciones
	n: new
	p: primary
	w: escribir los cambios
#Particionado - ejemplo un disco todo el espacio
#Start parted as follows:
	sudo parted /dev/sdb
#Create a new GPT disklabel (aka partition table):
	(parted) mklabel gpt
#Set the default unit to GB:
(parted) unit GB
#mkpart
	Seguir las instrucciones para crear una particion, se borra con comando RM
#Visualizar cambios
	print
#guardar y salir
	quit
#formatear la particion
	sudo mkfs -t ext4 /dev/sdb1
#Listar particiones
	sudo fdisk -l
#Montar la particion
	sudo mount /dev/sdb1 /mnt/registry
#Create one partition occupying all the space on the drive. For a 4TB drive:
#Create a mount point
	sudo mkdir /registry
#Agregar permisos irrestrictos sobre la carpeta
	mkdir path/foldername
	chmod 777 path/foldername 
#Edit /etc/fstab
Open /etc/fstab file with root permissions:
	sudo nano /etc/fstab
#And add following to the end of the file:
/dev/sdb1    /dev/registry    ext4    defaults    0    0

@Docker Registry
#Comando para correrlo - si la imagen no esta la descarga
	sudo docker run -it -d -p 5000:5000 --restart=always --name registry registry:2
o
	sudo docker run -it -d -p 5000:5000 --restart=always --name registry -v registry-data:/registry registry:2

#Sin el comando --rm los volumenes quedan persitentes
	sudo docker volume ls
	
#Se recomienda descargar JSON Beatiful and editor para edge chromium
#Chequear URL de registry
	http://10.1.1.8:5000/v2/_catalog

#Estructura

			> repository1 > SQL image > Tag:latest - 3.0
registry2	> repository1 > IIS image > Tag:2.1
			> repository1 > NGinx image > Tag:1.0

#La API para gestion es : HTTP API V2
docs.docker.com/regsitry/spec/api

#Composicion de comando TAG
	docker tag hello-world registry.tqcorp.com:5000/hello-world:latest
	
hello-world: source image en el servidor que se empuja
registry.tqcorp.com:5000: URL direccion del servidor privado de registry y puerto
/hello-world: Repository
:latest: TAG puede ser latest o version en particular

La imagen se mapea al repositorio
Si no se tagea utiliza como si fuera default LATEST

#En el caso de testing con registry inseguro se debe modificar parametros segun esta guia:
	sudo nano /etc/docker/daemon.json
Agregar los siguientes parametros:
Es importante que el bind sea a nombre o IP pero el tag anterior debe respetar un formato o fqdn o IP, no esta soportado ambos metodos de acceso


{
	"insecure-registries": ["registry.tqcorp.com:5000"]
}

	sudo systemctl daemon-reload
	sudo systemctl restart docker
	cat /etc/docker/daemon.json

	sudo docker push registry.tqcorp.com:5000/hello-world:1.0

#Obtener listado de imagenes

Windows: wget http://registry.tqcorp.com:5000/v2/_catalog (con IExplorer inicializado)
Linux: curl registry.tqcorp.com:5000/v2/_catalog
Navegador web con extension: JSON Beautifier y Editor

#Como importar imagen
	sudo docker image pull registry.tqcorp.com:5000/hello-world

#Verificar via web los tags
	http://registry.tqcorp.com:5000/v2/hello-world/tags/list
	
#WebUI
Alternativa de konradkleine
https://hub.docker.com/r/konradkleine/docker-registry-frontend

	sudo docker pull konradkleine/docker-registry-frontend:latest

sudo docker run -d --name registry-ui --restart=always \
-e ENV_DOCKER_REGISTRY_HOST=registry.tqcorp.com \
-e ENV_DOCKER_REGISTRY_PORT=5000 \
-p 8080:80 \
konradkleine/docker-registry-frontend:v2

Revisar la documentacion para implementar SSL o no, es solo consultas para gente de DEV

#Volumen
Revisar documentacion para declarar el volumen estatico donde van a estar ubicadas las imagenes que se suben
Profundizar en el caso de linux o ir por windows mucho mas facil

@Registry Mirroring
Consiste en tener en cache de regsitry imagenes actualizadas de docker y proveer de esas imagenes localmente

Esta soportado en hardware especifico de synology
https://www.synology.com/en-sg/dsm/packages/Docker
Modelo DS420+ soporta aplicaciones como docker registry corriendo directamente en el NAS

#Creacion de docker compose docker registry mirror yml file
Por precaucion eliminar docker registry existente con parametro -v de volumen
Limpiar volumenes
	sudo docker volume rm $(sudo docker volume ls -q)

version: "3.5"

services:
  registry:
    image: registry:2
    ports:
      - "5000:5000"
    volumes:
      - registry:/mnt/registry
    restart: always
    environment:
      REGISTRY_PROXY_REMOTEURL: https://registry-1.docker.io

volumes:
  registry:

#Comando para ejecutar compose desde un archivo modo detach
	sudo docker-compose -f registry.yml up --detach
	
#Configuracion de mirror y insecure registry en simultaneo archivo daemon.json se usa la , para multiples parametros
	sudo nano /etc/docker/daemon.json
{
        "insecure-registries": ["registry.tqcorp.com:5000"],
        "registry-mirrors": ["http://registry.tqcorp.com:5000"]
}

@Cleanup

#Instalacion de consola para gestion similar a la anterior docker-regsitry-frontend
https://hub.docker.com/r/hyper/docker-registry-web/
	docker pull hyper/docker-registry-web

#Estructura de archivo de configuracion

registry:
  # Docker registry url
  url: http://registry.tqcorp.com:5000/v2
  # Docker registry fqdn
  name: registry.tqcorp.com:5000
  # To allow image delete, should be false
  readonly: false
  auth:
     # Disable authentication
     enabled: false


#Comando para correr archivo de configuracion
sudo docker run -it -d -p 8080:8080 --name registry-web --link registry -v $(pwd)/config.yml:/conf/config.yml:ro hyper/docker-registry-web

#Hay que habilitar un parametro mas para eliminacion en registry, revisar con imagen de windows

Garbage collection hace referencia a la eliminacion de la data de registry a eliminar
Previo a eliminacion es importante no escribir en la registry y ponerlo modo readonly
Verificar en documentacion de storage maintenance: readonly: enable: true

Hay 2 posibles TAGs, ininmutables cada tag esta asociado a una imagen especifica
En el caso de latest quedan los digest huerfanos de las versiones anteriores
Para evitar esto es recomendable tagear con version y latest

@Security

Tipos de autenticacion
-Basic user/pass: apache htpasswd









