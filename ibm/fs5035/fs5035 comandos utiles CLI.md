# Comandos utiles Storage IBM FlashSystem 5035

Por defecto, para acceder a los canister (placas de management) es necesario conectar un equipo localmente a traves de un patchcord al puerto T (el que se encuentra a la izquierda de cada canister) para poder acceder localmente a *"IBM Flashsystem 5000 Service Assistant tool"*
La computadora conectada de manera local al canister debe tener configurada la IP 192.168.0.2 ya que el canister por defecto utiliza la .1
* La password de superuser por defecto para ingresar tanto por CLI como por GUI es "passw0rd" [Link](https://www.ibm.com/docs/en/flashsystem-7x00/8.4.x?topic=cs-user-name-password-system-initialization-2)

---
## Configurar Putty para el ingreso por SSH
[Configuring a PuTTY session for the CLI - IBM Documentation](https://www.ibm.com/docs/en/flashsystem-7x00/7.8.x?topic=host-configuring-putty-session-cli)

---
## Setear IP desde CLI (SSH)

### Como cambiar la ip del cluster (cuando ya tiene seteada una IP)
Conectarse por ssh al cluster y ejecutar el siguiente comando:

```
chsystemip -clusterip cluster_ip_address -gw custer_gw -mask 255.255.255.0 -port 1
```

### Como establecer la ip del cluster (si no esta configurado o se reseteó el cluster)

```
satask mkcluster -clusterip 192.168.150.5 -gw 192.168.150.254 -mask 255.255.255.0 
```

### Para setear la ip de los canister (placas de management)

```
satask chserviceip -serviceip replace_canister1_ip -mask 255.255.255.0 -gw canister_gw 781P7B4-1 
satask chserviceip -serviceip replace_canister2_ip -mask 255.255.255.0 -gw canister_gw 781P7B4-2
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

## Apagado del storage

1. Stop all host I/O to volumes on the system.
2. Shut down the system by using the management GUI. Click **Monitoring > System**. From the **System Actions menu, select Power Off System**.
3. Wait for the power LEDs on all node canisters in all control enclosures to flash at 1 Hz, indicating that the shutdown operation completed.