# Comandos utiles Storage IBM FlashSystem 5035

Por defecto, para acceder a los canister (placas de management) es necesario conectar un equipo localmente a traves de un patchcord al puerto T (el que se encuentra a la izquierda de cada canister) para poder acceder localmente a "IBM Flashsystem 5000 Service Assistant tool"
La computadora conectada de manera local al canister debe tener configurada la IP 192.168.0.2 ya que el canister por defecto utiliza la .1
* La password de superuser por defecto para ingresar tanto por CLI como por GUI es "passw0rd" [Link](https://www.ibm.com/docs/en/flashsystem-7x00/8.4.x?topic=cs-user-name-password-system-initialization-2)

---
## Configurar Putty para el ingreso por SSH
[Configuring a PuTTY session for the CLI - IBM Documentation](https://www.ibm.com/docs/en/flashsystem-7x00/7.8.x?topic=host-configuring-putty-session-cli)

---
## Setear IP desde CLI (SSH)
Para setear la ip del cluster

```
satask mkcluster -clusterip 192.168.150.5 -gw 192.168.150.254 -mask 255.255.255.0 
```
Para setear la ip de los canister (placas de management)
```
satask chserviceip -serviceip 192.168.150.6 -mask 255.255.255.0 -gw 192.168.150.254 781P7B4-1 
satask chserviceip -serviceip 192.168.150.7 -mask 255.255.255.0 -gw 192.168.150.254 781P7B4-2
```
* 781P7B4-1 y 781P7B4-2 son los nombres de las controladoras
---
## Reset del cluster
```
satask chvpd -resetclusterid
```
Y volver a correr los comandos para establecer las direcciones IP de ser necesario

---
## Reboot de los canister
```
satask stopnode -reboot 781P7B4-1   
```
Donde 781P7B4-1 reemplazar por -2 si se quiere rebootear tambien el canister 2