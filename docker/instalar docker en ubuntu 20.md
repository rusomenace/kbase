#Instalacion en Ubuntu 20.04

## Actualizacion
```
sudo apt update && sudo apt upgrade -y
```
	
## Verificar espacio en disco
```
df -BG -h
```	

##Seguir la guia de instalacion
[https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

##Verificar estado de docker
```
systemctl status docker
```

##Instalar docker-compose
```
sudo apt install docker-compose
```
##Verificar instalacion de docker-compose
```
sudo docker-compose version
```

##Ejecucion sin admin de docker commands
```
sudo usermod -aG docker $USER
```

##Instalar herramientas de red
```
sudo apt install net-tools
```

Enabling Docker Remote API ( for Ubuntu 16.04)
In Ubuntu 16.04 , above procedure doesn�t have any effect on docker and is not able to open up the tcp port for docker host. For that open up the /lib/systemd/system/docker.service file by running the command. (For this command , you need nano or you can use an editor like vi as I mentioned above)
```
sudo nano /lib/systemd/system/docker.service
```

Then you have to update the file like this,
```
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock
```

You have to replace <port> with your desired port. In my case it�s like this,
```
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:4243
```
now save your changes with ctrl+o and exit from the editor using ctrl+x

Then restart the docker service runningg below commands
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

For verifying whether the port is working, you can either use the method I mentioned earlier for earlier versions of ubuntu or run the following command
```
curl -X GET http://localhost:4243/images/json
```
##Enable autostart
```
sudo systemctl enable docker
```

##Cambio de direccion IP a estatico
Editar el siguiente archivo:
```
 /etc/netplan/00-installer-config.yaml
```

Incorporar los siguientes datos con el indent correcto
```
network:
    ethernets:
        enp0s3:
            dhcp4: false
            addresses: [192.168.1.202/24]
            gateway4: 192.168.1.1
            nameservers:
              addresses: [8.8.8.8,8.8.4.4,192.168.1.1]
    version: 2
```
##Correr
```
sudo netplan apply
sudo reboot
```

