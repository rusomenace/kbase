Se crea un port channel para Heartbeat con IP .2 para switch 1 e IP .3 para el switch 2

Se deberan asociar interfaces, es posible usar cables DAC de 10Gbps
```
interface Eth-Trunk0
undo portswitch
description M-LAG_Heartbeat
ip address 10.254.120.2 255.255.255.0
m-lag unpaired-port reserved
```
<<<<<<< HEAD
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
=======
Se crea un port channel para el Peer-Link

Se pueden utilizar las intefaces de SQFP+ de 100Gbps
>>>>>>> 5cfff7dda610cdd1002bff0aed0d600d9f642297
```
interface Eth-Trunk1
description M-LAG_Peering
stp disable
mode lacp-static
peer-link 1
```
Comandos adicionales a ejecutar en system-view (la mac address es inventada)
```
stp bridge-address 00e0-fc12-3458
stp mode rstp
stp v-stp enable
stp instance 0 root primary
stp bpdu-protection
stp tc-protection
```
Se crea un grupo DFS, en el ejemplo la IP .2 corresponde al switch 1 y la IP .3 al switch 2, se debe invertir las IPs al configurar el switch 2

La priorida del switch 1 es 150 y la del switch 2 es 120
```
dfs-group 1
authentication-mode hmac-sha256 password ClaveSuperFuerte
dual-active detection source ip 10.254.120.2 peer 10.254.120.3
m-lag up-delay 240 auto-recovery interval 10
priority 150
```
Ejemplo de un LAG clasico sin LACP con switches fortinet

**Es importante tener en cuenta que el numero de m-lag es unico por grupo de dfs y por orden siempre se utiliza el numero asociado al LAG, en estew caso el Trunk es el 2 y el m-lag es 2**
```
interface Eth-Trunk2
description trunk-forti
port link-type trunk
undo port trunk allow-pass vlan 1
port trunk allow-pass vlan 4 100 140 150 160 170 180 200 250 2000
dfs-group 1 m-lag 2
```
Ejemplo de un LAG LACP de cabina NetApp
```
interface Eth-Trunk3
description A150_PROD_01
port link-type trunk
undo port trunk allow-pass vlan 1
port trunk allow-pass vlan 240 250 to 251 2000
stp edged-port enable
mode lacp-dynamic
dfs-group 1 m-lag 3
```
Ejemplo de un LAG LACP modo access con servidor Windows
```
interface Eth-Trunk6
description ESBCLXVEEAM01_LAN
port default vlan 150
stp edged-port enable
mode lacp-dynamic
dfs-group 1 m-lag 6
```
Salvar la config desde el prompt < >
```
save
```
Con el comando display-startup se puede verificar cual es el archivo de configuracion que se utilizara para el siguiente boot
```
<SWITCH>display startup
Startup saved-configuration file:          flash:/vrpcfg_bck.zip
Next startup saved-configuration file:     flash:/vrpcfg_bck.zip
```
Para certificar de que los cambios se han respaldados se puede verificar fecha y hora de modificacion del archivo con el comando **dir**
```
<SWITCH>dir flash:/vrpcfg_bck.zip
Directory of flash:/

  Idx  Attr     Size(Byte)  Date        Time       FileName
    0  -rw-          2,950  Feb 19 2024 10:13:56   vrpcfg_bck.zip

1,014,632 KB total (747,660 KB free)
```
Comandos de referencia para verificar el estado del m-lag
```
display dfs-group 1 m-lag
display dfs-group 1 m-lag brief
display dfs-group 1 heartbeat
display dfs-group 1 peer-link
display dfs-group 1 node (x) m-lag
```

Ref:
- https://support.huawei.com/hedex/hdx.do?docid=EDOC1100278118&id=EN-US_TASK_0000001171488291
- https://support.huawei.com/enterprise/en/doc/EDOC1000137639/75f81d1f/configuring-leaf-nodes (PUNTO 6)