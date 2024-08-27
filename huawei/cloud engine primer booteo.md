# Huawei Cloud Engine 6820 OS V300

### Admin mode
```
system-view
```
### Nombre del switch
```
sysname NOMBREDELSWITCH
```
### Timezone Madrid-Barcelona
```
clock timezone UTC add 1:00:00
```
### Definir NTP server
```
undo ntp server disable
ntp unicast-peer 10.210.160.11
ntp unicast-server 10.210.160.11
```
### Habilitar consola VTY para SSH
```
user-interface vty 0 4
authentication-mode aaa
protocol inbound ssh
quit
```
### Crear usuario de acceso
```
aaa
local-user adm-contec password irreversible-cipher valoco*12
local-user adm-contec privilege level 3
local-user adm-contec service-type telnet terminal ssh ftp
quit
```
### Habilitar server stelnet
```
stelnet server enable
```
## Permitir usuario anterior acceso a stelnet
```
ssh user contecnow authentication-type password
ssh user contecnow service-type stelnet
```
## Cambiar el rsa key
```
ssh server rsa-key min-length 3072
rsa local-key-pair create (default = 3072)
undo ssh server keepalive disable
ssh server-source -i MEth 0/0/0
```
## Nos aseguramos que el servidor de telnet esta deshabilitado
```
telnet server disable
```
## Editar interfaz de management (si tuviera alguna configuracion eliminar previamente con UNDO y despues agregar IP)
```
interface MEth0/0/0
undo ip binding vpn-instance _management_vpn_
ip address 10.210.230.18 255.255.255.0
```
## Ruta statica por defecto
```
ip route-static 0.0.0.0 0.0.0.0 10.96.69.1
```
## Ejecutar commit regularmente para aplicar los cambios
```
commit
```
## Des el prompt < > ejecutar
```
save
```