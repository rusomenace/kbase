### Mostrar version de sistema operativo
```
display current-configuration
!Software Version V300R022C00SPC200
```
### Se define el timezone (Madrid-Barcelona)
```
clock timezone UTC add 01:00:00
```
### Nombre del switch
```
sysname ESBCSWDTC01
```
Grupo de DFS para M-LAG, el switch 2 es igual pero tiene prioridad 120
Las direcciones IP corresponden a las interfaces Meth 0/0/0 de management OOB, "no es ideal"
En este caso se puede armar un port trunk exclusivo para el 
```
dfs-group 1
 authentication-mode hmac-sha256 password %+%##!!!!!!!!!"!!!!"!!!!*!!!!2hdyF"u+y=u:;#5*N1x#+)GoAjYYbVeZe(>!!!!!2jp5!!!!!!>!!!!lE7XA{3x*2THdiNXD6pUwj~PM@Vo!0"@o*NY`LwU%+%#
 dual-active detection source ip 10.210.230.18 peer 10.210.230.19
 priority 150
```
### Configuracion de NTP apuntado al Domain Controller
```
ntp unicast-peer 10.210.160.11
ntp unicast-server 10.210.160.11
```
### Estas son todas las vlans creadas, por algun motivo se ve en 2 lineas
```
vlan batch 4 100 140 150 to 151 160 170 180 190 230 240
vlan batch 250 to 251
```
### Configuraciones de STP en ambos switches de M-LAG L2
```
stp bridge-address 00e0-fc12-3458
stp instance 0 root primary
ipv4-family
```
### Interfaz de gestion y de heart beat de M-LAG
```
interface MEth0/0/0
 description OOB_Gestion
 ip address 10.210.230.18 255.255.255.0
```
### Port trunk para enlazar ambos switches
```
interface Eth-Trunk1
 description M-LAG
 stp disable
 mode lacp-static
 peer-link 1
```
### Port trunk clasico de conexion contra un servidor usando LACP
```
interface Eth-Trunk5
 description Po5_ESBCNTVEEAM01-NIC1
 port default vlan 150
 stp edged-port enable
 mode lacp-dynamic
 dfs-group 1 m-lag 1
 ```
 #### *(El numero de m-lag es unico por grupo dfs, se recomienda usar el mismo numero del Po)*

### Configuracion clasica de una boca de red sin LAG o LACP con tag de VLANs multiples
```
interface 10GE1/0/21
 description ESBCESXI01-vmnic0
 port link-type trunk
 port trunk allow-pass vlan 4 100 140 150 to 151 160 170 180 250
```
### Ruteos estaticos
```
ip route-static 10.210.230.18 255.255.255.255 10.210.230.1
return
```

Ref:
- M-LAG L2: https://support.huawei.com/hedex/hdx.do?docid=EDOC1100278118&id=EN-US_TASK_0000001171488291
- M-LAG L3: https://support.huawei.com/hedex/hdx.do?docid=EDOC1100278118&id=EN-US_TASK_0000001171568181