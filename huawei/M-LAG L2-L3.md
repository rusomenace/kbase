Se crea un port channel para Heartbeat con IP 2 para switch 1 e IP 3 para el switch 2

Se deberan asociar interfaces, es posible usar cables DAC de 10Gbps
```
interface Eth-Trunk0
undo portswitch
description M-LAG_Heartbeat
ipv6 enable
ip address 10.254.120.2 255.255.255.0
m-lag unpaired-port reserved
```
Se crea un port channel para el Peer-Link

Se pueden utilizar las intefaces de SQFP+ de 100Gbps
```
interface Eth-Trunk1
description M-LAG_Peering
stp disable
mode lacp-static
peer-link 1
```
Comandos adicionales
```
stp bridge-address 00e0-fc12-3458
stp mode rstp
stp v-stp enable
stp instance 0 root primary
stp bpdu-protection
stp tc-protection
```
Se crea un grupo dfs, en el ejemplo la IP 2 corresponde al switch 1 y la IP 3 al switch 2, se debe invertir las IPs al confgiurar el switch 2

La priorida del switch 1 es 150 y la del switch 2 es 120
```
dfs-group 1
authentication-mode hmac-sha256 password ClaveSuperFuerte
dual-active detection source ip 10.254.120.2 peer 10.254.120.3
m-lag up-delay 240 auto-recovery interval 10
priority 150
```
Ejemplo de un LAG clasico sin LACP con switches fortinet

**Es importante tener en cuenta que el numero de m-lag es unico por grupo de dfs y por orden siempre se utiliza el numero asociado al LAG**
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
MainBoard:
Configured startup system software:        flash:/CE6820_V300R022C00SPC200.cc
Startup system software:                   flash:/CE6820_V300R022C00SPC200.cc
Next startup system software:              flash:/CE6820_V300R022C00SPC200.cc
Startup saved-configuration file:          flash:/vrpcfg_bck.zip
Next startup saved-configuration file:     flash:/vrpcfg_bck.zip
Startup paf file:                          default
Next startup paf file:                     default
Startup patch package:                     flash:/CE6820_V300R022SPH121.PAT
Next startup patch package:                flash:/CE6820_V300R022SPH121.PAT
Startup feature software:                  NULL
Next startup feature software:             NULL
```
Para certificar de que los cambios se han respaldados se puede verificar fecha y hora de modificacion del archivo con el comando **dir**
```
<SWITCH>dir flash:/vrpcfg_bck.zip
Directory of flash:/

  Idx  Attr     Size(Byte)  Date        Time       FileName
    0  -rw-          2,950  Feb 19 2024 10:13:56   vrpcfg_bck.zip

1,014,632 KB total (747,660 KB free)
```