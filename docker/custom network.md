# Custom NAT-Network

## Delete default NAT			
```
Ubicacion de archivo JSON paara nueva red NAT
		c:\programdata\docker\config\daemon.json
				#Content daemon.json
					
					{
							"bridge" : "none"
					}
```	
## PS para eliminacion previo a cualquier creacion
```
stop-service docker
get-hnsnetwork
get-hnsnetwork | remove-hnsnetwork
start-service docker
```
## Create docker network
```
docker network create --driver nat --subnet 1.2.3.4/24 --gateway 1.2.3.1 newnatnet
```

## Creacion de un container con una red e ip especifico
```
docker run --detach -it --name container1 --hostname container1 --network newnatnet --ip 1.2.3.2 mcr.microsoft.com/windows/servercore/iis:ltsc2019
```

## No usar para resolucion de nombres nslookup si no su alternativa en PS
```
Resolve-DnsName computadora
```

## Creacion de una red con DNS server y sufijo especifico
```
docker network create --driver nat --subnet 1.2.3.4/24 --gateway 1.2.3.1 -o com.docker.network.windowsshim.dnssuffix=tq.com.ar -o com.docker.network.windowsshim.dnsserver=10.1.1.13 -o com.docker.network.windowsshim.disable_gatewaydns=true newnanet
```

##Transparent mode
Es recomendable implementar un segundo adaptador de red para implementar la red de docking "VLAN docker"
Requiere habilitar spoofing para que funcione, VMWare tema a revisar
```
docker network create --driver transparent --subnet 192.168.32.0/24 --gateway 192.168.32.250 -o com.docker.network.windowsshim.dnssuffix=tq.com.ar -o com.docker.network.windowsshim.dnsserver=10.1.1.13 -o com.docker.network.windowsshim.interface="Ethernet1" vlan32
docker network ls
docker network inspect vlan32
docker run --detach -it --name container1 --hostname container1 --network vlan32 --ip 192.168.32.10 --dns 10.1.1.13 mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
```

# Firewall habilitado
Existe en el host de containers

## Powershell Rules
```
Get-NetFirewallRule | ft displayname
```

## Al final de las reglas se aprecian la reglas COMPARTMENT
```
Get-NetCompartment
Get-NetFirewallRule | where displayname -like "*Compartment*"
Get-NetFirewallRule | where displayname -like "*Compartment*" | Get-NetFirewalPortFilter
```

## Bloquear regla entrante
```
Set-NetFirewallRule -DisplayName "display name" -action block
```

#Compose multiple docker and networks
```
version: "3.8"

#
# [ Containers definition ]
#

services:

  cont01:
    image: mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
    hostname: w2019c-01
    container_name: cont1_w2019c-01
    dns: 10.1.1.13
    networks:
      frontend:
        ipv4_address: 192.168.32.10

  cont02:
    image: mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
    hostname: w2019c-02
    container_name: cont2_w2019c-02
    dns: 10.1.1.13
    networks:
      frontend:
        ipv4_address: 192.168.32.11

#
# [ networks definition ]
#
networks:
    frontend:
        external:
            name: vlan32
```
			