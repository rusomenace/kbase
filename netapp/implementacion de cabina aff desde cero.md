# Startup

1. Cambiar las direcciones IP de los service processors para que apunten a la VLAN230, con esto se cambian las direcciones IP
```
system service-processor network modify -node A150_PROD-01 -enable true -ip-address 10.210.230.14 -netmask 255.255.255.0 -gateway 10.210.230.1 -address-family IPv4
```
2. Cambiamos el nombre de la interfaz de cluster para que refleje la de la documentación
```
A150_PROD::> network interface rename -vserver A150_PROD -lif cluster_mgmt -newname A150_PROD_CLT
```
3. Verificar pertenencia de discos para ver su asociación en relación a los nodos
```
A150_PROD::> disk show
                     Usable           Disk    Container   Container
Disk                   Size Shelf Bay Type    Type        Name      Owner
---------------- ---------- ----- --- ------- ----------- --------- --------

Info: This cluster has partitioned disks. To get a complete list of spare disk capacity use "storage aggregate show-spare-disks".
1.0.0                3.49TB     0   0 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_01
                                                                    A150_PROD-01
1.0.1                3.49TB     0   1 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_01
                                                                    A150_PROD-01
1.0.2                3.49TB     0   2 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_01
                                                                    A150_PROD-01
1.0.3                3.49TB     0   3 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_01
                                                                    A150_PROD-01
1.0.4                3.49TB     0   4 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_01
                                                                    A150_PROD-01
1.0.5                3.49TB     0   5 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01
                                                                    A150_PROD-01
1.0.18               3.49TB     0  18 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_02
                                                                    A150_PROD-02
1.0.19               3.49TB     0  19 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_02
                                                                    A150_PROD-02
1.0.20               3.49TB     0  20 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_02
                                                                    A150_PROD-02
1.0.21               3.49TB     0  21 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_02
                                                                    A150_PROD-02
1.0.22               3.49TB     0  22 SSD     shared      aggr_A150_PROD_01_01, aggr_A150_PROD_02_01, aggr_ROOT_A150_PROD_02
                                                                    A150_PROD-02
1.0.23               3.49TB     0  23 SSD     shared      -         A150_PROD-02
12 entries were displayed.
```
4. Listar particiones de disco donde se muestran su asignación y su tamaño 
```
A150_PROD::> set diagnostic
Warning: These diagnostic commands are for use by NetApp personnel only.
Do you want to continue? {y|n}: y
A150_PROD::*> storage disk partition show
                          Usable  Container     Container
Partition                 Size    Type          Name              Owner
------------------------- ------- ------------- ----------------- -----------------
1.0.0.P1                   1.72TB spare         Pool0             A150_PROD-01
1.0.0.P2                   1.72TB spare         Pool0             A150_PROD-02
1.0.0.P3                  62.35GB aggregate     /aggr0_A150_PROD_01/plex0/rg0
                                                                  A150_PROD-01
1.0.1.P1                   1.72TB spare         Pool0             A150_PROD-01
1.0.1.P2                   1.72TB spare         Pool0             A150_PROD-02
1.0.1.P3                  62.35GB aggregate     /aggr0_A150_PROD_01/plex0/rg0
                                                                  A150_PROD-01
1.0.2.P1                   1.72TB spare         Pool0             A150_PROD-01
1.0.2.P2                   1.72TB spare         Pool0             A150_PROD-02
1.0.2.P3                  62.35GB aggregate     /aggr0_A150_PROD_01/plex0/rg0
                                                                  A150_PROD-01
1.0.3.P1                   1.72TB spare         Pool0             A150_PROD-01
1.0.3.P2                   1.72TB spare         Pool0             A150_PROD-02
1.0.3.P3                  62.35GB aggregate     /aggr0_A150_PROD_01/plex0/rg0
                                                                  A150_PROD-01
1.0.4.P1                   1.72TB spare         Pool0             A150_PROD-01
1.0.4.P2                   1.72TB spare         Pool0             A150_PROD-02
1.0.4.P3                  62.35GB aggregate     /aggr0_A150_PROD_01/plex0/rg0
                                                                  A150_PROD-01
1.0.5.P1                   1.72TB spare         Pool0             A150_PROD-01
1.0.5.P2                   1.72TB spare         Pool0             A150_PROD-02
1.0.5.P3                  62.35GB spare         Pool0             A150_PROD-01
1.0.18.P1                  1.72TB spare         Pool0             A150_PROD-01
1.0.18.P2                  1.72TB spare         Pool0             A150_PROD-02
1.0.18.P3                 62.35GB aggregate     /aggr0_A150_PROD_02/plex0/rg0
                                                                  A150_PROD-02
1.0.19.P1                  1.72TB spare         Pool0             A150_PROD-01
1.0.19.P2                  1.72TB spare         Pool0             A150_PROD-02
1.0.19.P3                 62.35GB aggregate     /aggr0_A150_PROD_02/plex0/rg0
                                                                  A150_PROD-02
1.0.20.P1                  1.72TB spare         Pool0             A150_PROD-01
1.0.20.P2                  1.72TB spare         Pool0             A150_PROD-02
1.0.20.P3                 62.35GB aggregate     /aggr0_A150_PROD_02/plex0/rg0
                                                                  A150_PROD-02
1.0.21.P1                  1.72TB spare         Pool0             A150_PROD-01
1.0.21.P2                  1.72TB spare         Pool0             A150_PROD-02
1.0.21.P3                 62.35GB aggregate     /aggr0_A150_PROD_02/plex0/rg0
                                                                  A150_PROD-02
1.0.22.P1                  1.72TB spare         Pool0             A150_PROD-01
1.0.22.P2                  1.72TB spare         Pool0             A150_PROD-02
1.0.22.P3                 62.35GB aggregate     /aggr0_A150_PROD_02/plex0/rg0
                                                                  A150_PROD-02
1.0.23.P1                  1.72TB spare         Pool0             A150_PROD-01
1.0.23.P2                  1.72TB spare         Pool0             A150_PROD-02
1.0.23.P3                 62.35GB spare         Pool0             A150_PROD-02
```
5. Simulamos agregar un aggregate que es la creación de un pool de almacenamiento que está formado por discos.
Si quitamos del comando ```-simulate``` creara el agregado
```
A150_PROD::> aggregate create -aggregate aggr_A150_PROD_01_01 -diskcount 11 -node A150_PROD-01 -simulate true -maxraidsize 12
  (storage aggregate create)
### Resultado del comando ###
The layout for aggregate "aggr_A150_PROD_01_01" on node "A150_PROD-01" would be:
First Plex
  RAID Group rg0, 11 disks (block checksum, raid_dp)
                                                      Usable Physical
    Position   Disk                      Type           Size     Size
    ---------- ------------------------- ---------- -------- --------
    shared     1.0.0                     SSD               -        -
    shared     1.0.1                     SSD               -        -
    shared     1.0.2                     SSD          1.72TB   1.72TB
    shared     1.0.3                     SSD          1.72TB   1.72TB
    shared     1.0.4                     SSD          1.72TB   1.72TB
    shared     1.0.18                    SSD          1.72TB   1.72TB
    shared     1.0.19                    SSD          1.72TB   1.72TB
    shared     1.0.20                    SSD          1.72TB   1.72TB
    shared     1.0.21                    SSD          1.72TB   1.72TB
    shared     1.0.22                    SSD          1.72TB   1.72TB
    shared     1.0.5                     SSD          1.72TB   1.72TB
Aggregate capacity available for volume use would be 13.90TB.
```
6. Creamos los 2 agregates, cada uno presenta un tamaño máximo que es el resultado de todo el espacio disponible en cada disco que este asociado a la controladora PROD-01 y PROD-02. El tamaño total del Tier de SSD es de 27.8 TiB
La cantidad total de discos de esta cabina son 12 por eso el comando ```-diskcount 11``` dejo uno fuera para que cumpla la función de spare.
```
A150_PROD::> aggregate create -aggregate aggr_A150_PROD_01_01 -diskcount 11 -node A150_PROD-01 -maxraidsize 12
A150_PROD::> aggregate create -aggregate aggr_A150_PROD_02_01 -diskcount 11 -node A150_PROD-02 -maxraidsize 12
```
7. Listamos los discos de spare para saber cuáles son
El 1.0.5 automáticamente es elegido por la cabina como spare del ROOT aggregate
El 1.0.23 automáticamente es elegido por la cabina como spare de todos los aggregates
```
A150_PROD::> storage aggregate show-spare-disks

### Resultado del comando ###
Original Owner: A150_PROD-01
 Pool0
  Root-Data1-Data2 Partitioned Spares
                                                              Local    Local
                                                               Data     Root Physical
 Disk             Type   Class          RPM Checksum         Usable   Usable     Size Status
 ---------------- ------ ----------- ------ -------------- -------- -------- -------- --------
 1.0.5            SSD    solid-state      - block                0B  62.35GB   3.49TB zeroed
 1.0.23           SSD    solid-state      - block            1.72TB       0B   3.49TB zeroed

Original Owner: A150_PROD-02
 Pool0
  Root-Data1-Data2 Partitioned Spares
                                                              Local    Local
                                                               Data     Root Physical
 Disk             Type   Class          RPM Checksum         Usable   Usable     Size Status
 ---------------- ------ ----------- ------ -------------- -------- -------- -------- --------
 1.0.23           SSD    solid-state      - block            1.72TB  62.35GB   3.49TB zeroed
3 entries were displayed.
```
8. Creamos los port channels utilizando todas las interfaces de 10Gb que son 4 en total por nodo. Los port channel por defecto en NetApp empiezan como a0a, a0b, etc.
```
A150_PROD::> network port ifgrp create -node A150_PROD-01 -ifgrp a0a -distr-func ip -mode multimode_lacp
A150_PROD::> network port ifgrp create -node A150_PROD-02 -ifgrp a0a -distr-func ip -mode multimode_lacp
```
9. Creadas las interfaces de port channel tenemos que asignarles las interfaces físicas de cada nodo, esta cabina tiene 4 módulos por nodo: e0c, e0d, e0e y e0f. En este ejemplo se da de alta solo el nodo 1 pero se realiza en ambos. 
```
A150_PROD::> ifgrp add-port -node A150_PROD-01 -ifgrp a0a -port e0c
A150_PROD::> ifgrp add-port -node A150_PROD-01 -ifgrp a0a -port e0d
A150_PROD::> ifgrp add-port -node A150_PROD-01 -ifgrp a0a -port e0e
A150_PROD::> ifgrp add-port -node A150_PROD-01 -ifgrp a0a -port e0f
```
10. La creación de VLANs asociadas a puerto a0a se debe hacer por nodo 
```
A150_PROD::> vlan create -node A150_PROD-01 -vlan-name a0a-230
A150_PROD::> vlan create -node A150_PROD-02 -vlan-name a0a-230
```
11. Verificamos la correcta creacion y asignación de cada VLAN con la interfaz a0a 
```
A150_PROD::> vlan show
                 Network Network
Node   VLAN Name Port    VLAN ID  MAC Address
------ --------- ------- -------- -----------------
A150_PROD-01
       a0a-230
                 a0a     230      d2:39:ea:b1:80:33
       a0a-240
                 a0a     240      d2:39:ea:b1:80:33
       a0a-250
                 a0a     250      d2:39:ea:b1:80:33
A150_PROD-02
       a0a-230
                 a0a     230      d2:39:ea:b1:83:05
       a0a-240
                 a0a     240      d2:39:ea:b1:83:05
       a0a-250
                 a0a     250      d2:39:ea:b1:83:05
6 entries were displayed.
```
12. Cambiamos el MTU de la interfaz a0a a Jumbo 9000
```
A150_PROD::> network port modify -port a0a -node A150_PROD-01 -mtu 9000
Warning: This command will cause a several second interruption of service on this network port.
Do you want to continue? {y|n}: y
A150_PROD::> network port modify -port a0a -node A150_PROD-02 -mtu 9000
Warning: This command will cause a several second interruption of service on this network port.
Do you want to continue? {y|n}: y
```
13. Cambiamos el nombre del broadcast domain por defecto, en este caso se llamara Gestion
En el contexto de los sistemas de almacenamiento de NetApp, un "dominio de difusión-broadcast domain" se refiere típicamente a un agrupamiento lógico de dispositivos de red que reciben los mensajes de difusión de los demás. Los mensajes de difusión son paquetes que se envían a todos los dispositivos en un segmento de red.
```
A150_PROD::> broadcast-domain rename -broadcast-domain Default -new-name Gestion
```
14. Cambiamos los MTU del broadcast domain a Jumbo 9000
```
A150_PROD::> broadcast-domain modify -broadcast-domain Gestion -mtu 9000 -ipspace Default
  (network port broadcast-domain modify)
```
15. Listamos los broadcast domains para verificar los MTU
```
A150_PROD::> broadcast-domain show
  (network port broadcast-domain show)
IPspace Broadcast                                         Update
Name    Domain Name    MTU  Port List                     Status Details
------- ----------- ------  ----------------------------- --------------
Cluster Cluster       9000
                            A150_PROD-02:e0a              complete
                            A150_PROD-02:e0b              complete
                            A150_PROD-01:e0a              complete
                            A150_PROD-01:e0b              complete
Default Gestion       9000
                            A150_PROD-02:e0M              complete
                            A150_PROD-01:e0M              complete
2 entries were displayed.
```
16. Inicialmente el acceso a los nodos es a través de la interfaz e0M pero al no tener redundancia genera un error en los eventos de este tipo
```
12/11/2023 13:26:31 A150_PROD-01     ALERT         vifmgr.lifs.noredundancy: No redundancy in the failover configuration for 1 LIFs assigned to node "A150_PROD-01". LIFs: A150_PROD:A150_PROD-01_mgmt1
12/11/2023 13:31:26 A150_PROD-02     ALERT         vifmgr.lifs.noredundancy: No redundancy in the failover configuration for 1 LIFs assigned to node "A150_PROD-02". LIFs: A150_PROD:A150_PROD-02_mgmt1
```
17. Para poder solucionar este inconveniente se asignan las interfases a0a que anteriormente se tagearon a la vlan230
```
A150_PROD::> broadcast-domain add-ports -broadcast-domain Gestion -ports A150_PROD-01:a0a-230 -ipspace Default
  (network port broadcast-domain add-ports)
A150_PROD::> broadcast-domain add-ports -broadcast-domain Gestion -ports A150_PROD-02:a0a-230 -ipspace Default
  (network port broadcast-domain add-ports)
```
18. Renombrar aggregate ROOT para evitar confusión y quitar el aggr0 y dejar aggr solamente 
```
A150_PROD::> aggregate rename -aggregate aggr0_A150_PROD_01 -newname aggr_ROOT_A150_PROD_01
  (storage aggregate rename)
[Job 51] Job succeeded: DONE
A150_PROD::> aggregate rename -aggregate aggr0_A150_PROD_02 -newname aggr_ROOT_A150_PROD_02
  (storage aggregate rename)
[Job 52] Job succeeded: DONE
```
19. Habilitar modo privilegiado **DIAG**, en el ultimo comando se debera definir una clave
```
security login show -username diag
security login unlock -username diag
security login password -username diag
```
20. Comandos de NTP
Se deben crear 3 entradas para que deje de alarmar la recomendacion, en un ambiente con servicio de CIFS se deberan colocar los controlares de dominio y la tercera entrada puede corresponder al NTP server que usa el servidor con roles de NTP/FSMO
```
ntp server create pool.ntp.org
ntp server create 0.es.pool.ntp.org
ntp server create 1.es.pool.ntp.org
```