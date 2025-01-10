# Notas Importantes

- El Stack por M-LAG requiere gestionar cada switch de manera independiente. Esto significa que cada configuración realizada en un switch debe replicarse en el otro. En algunos casos, la configuración es idéntica; en otros, cambia ligeramente dependiendo de lo que se esté configurando.
- El M-LAG utiliza el grupo DFS (DFS Group) para enlazar las configuraciones entre los switches. Esto se refleja en los Eth-Trunk, cada uno de los cuales lleva un `dfs-group 1 m-lag 1,2,3,...` y debe ser igual en ambos switches, además de ser único para cada Trunk.

Se crea un port channel para el Heartbeat, con la IP `.2` para el Switch 1 y la IP `.3` para el Switch 2.

La recomendación de Huawei es usar las interfaces MEth para el heartbeat, pero en este caso se creó un `PO0` de 10 GB para tal fin:
### SW01
```
interface Eth-Trunk0
undo portswitch
description M-LAG_Heartbeat
ip address 10.254.120.2 255.255.255.0
m-lag unpaired-port reserved
```
### SW02
```
interface Eth-Trunk0
undo portswitch
description M-LAG_Heartbeat
ip address 10.254.120.3 255.255.255.0
m-lag unpaired-port reserved
```
### Zona Horaria (Madrid-Barcelona)
```
clock timezone UTC add 01:00:00
```
## Configuración del Grupo DFS para M-LAG
El Switch 2 tiene la misma configuración que el Switch 1, pero con una prioridad de 120. Se crea un grupo DFS; en este ejemplo, la IP .2 corresponde al Switch 1 y la IP .3 al Switch 2. Al configurar el Switch 2, se deben invertir las IPs.
La prioridad del Switch 1 es 150, y la del Switch 2 es 120:
SW01
```
dfs-group 1
authentication-mode hmac-sha256 password ClaveSuperFuerte
dual-active detection source ip 10.254.120.2 peer 10.254.120.3
m-lag up-delay 240 auto-recovery interval 10
priority 150
```
SW02
```
dfs-group 1
authentication-mode hmac-sha256 password ClaveSuperFuerte
dual-active detection source ip 10.254.120.1 peer 10.254.120.2
m-lag up-delay 240 auto-recovery interval 10
priority 120
```
### Configuracion de NTP apuntado al Domain Controller
```
ntp unicast-peer 10.210.160.11
ntp unicast-server 10.210.160.11
```
### Creacion de VLANs
```
vlan batch 4 100 140 150 to 151 160 170 180 190 230 240
```
### Configuraciones de STP en ambos switches de M-LAG L2
```
stp bridge-address 00e0-fc12-3458
stp instance 0 root primary
ipv4-family
```
### Port trunk para enlazar ambos switches

Se crea un port channel para el Peer-Link

Se deben utilizar las intefaces de SQFP+ de 100Gbps
```
interface Eth-Trunk1
description M-LAG_Peering
stp disable
mode lacp-static
peer-link 1
```
Comandos adicionales a ejecutar en system-view (la mac address no es real, se usa una creada que comparten los 2 switches)
```
stp bridge-address 00e0-fc12-3458
stp mode rstp
stp v-stp enable
stp instance 0 root primary
stp bpdu-protection
stp tc-protection
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
Ejemplo de un LAG LACP
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
