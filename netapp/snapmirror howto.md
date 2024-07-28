# Configuración de Red

## 1. Network Setup

En la cabina origen `C1N1` ya existen 2 SVM que son las de produccion, usamos sus nombres para crear las nuevas de mirror:

- `SVM_CIFS`
- `SVM_NFS`

## 2. Creación de SVM en la segunda cabina

Creamos en la segunda cabina las SVM equivalentes ya que siempre tiene que existir una equivalencia:

- `svm_cifs_mir`
- `svm_nfs_mir`

Estos son los comandos para crear las SVM:

```sh
vserver create -vserver svm_cifs_mir -subtype default -rootvolume svm_cifs_mir_root -rootvolume-security-style ntfs -language C.UTF-8 -snapshot-policy none -data-services data-cifs -foreground true

vserver create -vserver svm_nfs_mir -subtype default -rootvolume svm_nfs_mir_root -rootvolume-security-style unix -language C.UTF-8 -snapshot-policy none -data-services data-nfs -foreground true
```

## 3. Creación de Volúmenes en la cabina de destino

Los volúmenes deben existir en destino (C2N1) con las mismas características que en el origen (C1N1). Comandos para crear los volúmenes donde se define el tamaño que debe ser igual al origen `[ -size {<integer>[KB|MB|GB|TB|PB]} ]`

### CIFS
```sh
volume create -vserver svm_cifs_mir -volume vol_cifs_01_mir -aggregate c2n1_01_FC_1 -size 10GB -type dp
```

### NFS
```sh
volume create -vserver svm_nfs_mir -volume ds_nfs_02_mir -aggregate c2n1_01_FC_1 -size 2GB -type dp
```

Los volúmenes tienen que ser DP (read only) y verificamos eso con el comando:
```sh
volume show -vserver svm_cifs_mir (o la svm que corresponda)
```

## 4. Configuración de Broadcast Domain

La mejor práctica es la siguiente:

- Broadcast domain exclusivo de intercluster.
- VLAN exclusiva de intercluster.
- Segmento IP diferente a todos los conocidos.

Estos comandos deben ejecutarse en ambas cabinas, tanto en C1N1 como en C2N1. Si tenemos un LACP, hay que crear una interfaz del tipo agregado `a0a-2000` donde `[2000]` representa la VLAN tagged de la interfaz. Una vez tenemos la interfaz, la podemos vincular con el siguiente comando:
```sh
broadcast-domain create -broadcast-domain intercluster -mtu 1500 -ports c2n1-01:e0d
network port broadcast-domain show
```

## 5. Creación de Interfaces de Cluster

A continuación, creamos las interfaces de cluster en ambas cabinas, C1N1 y C2N1. El `vserver` que seleccionamos en este comando no es alguno de los que hayamos creado, sino que es el `vserver` a nivel cluster y generalmente es el nombre del cluster. Las direcciones IP que usamos son las siguientes:

- `10.10.10.1/24`: C1N1 [source]
- `10.10.10.2/24`: C2N1 [destination]

Es ideal y buena práctica tener al menos 2 interfaces por cabina para tener redundancia de conectividad.

Comandos de creación de LIFs:
```sh
network interface create -vserver c1n1 -lif intercluster_01 -service-policy default-intercluster -home-node c1n1-01 -home-port e0f -address 10.10.10.1 -netmask 255.255.255.0

network interface create -vserver c2n1 -lif intercluster_01 -service-policy default-intercluster -home-node c2n1-01 -home-port e0d -address 10.10.10.2 -netmask 255.255.255.0
```

Podemos verificar la conectividad con los siguientes comandos de ping:
```sh
c1n1::> network ping -lif intercluster_01 -vserver c1n1 -destination 10.10.10.2

c2n1::> network ping -lif intercluster_01 -vserver c2n1 -destination 10.10.10.1
```

Si el resultado es "is alive" es que hay conectividad.

## 6. Configuración de LACP

Si usamos LACP y compartimos puertos físicos, tenemos que limitar el ancho de banda de la siguiente manera en ambas cabinas:
```sh
c2n1::> options -option-name replication.throttle.enable on
```

El valor que ponemos a continuación en el siguiente comando está expresado en Kilobits por segundo y representa 100 Mbps:
```sh
100 Mbps = 12500 kB/s
```

10 Gbps:
```sh
10,000,000 kbps ÷ 8 = 1,250,000 kB/s
```

5 Gbps:
```sh
5,000,000 kbps ÷ 8 = 625,000 kB/s
```

```sh
c2n1::> options -option-name replication.throttle.outgoing.max_kbs 12500
```

## 7. Cluster Peering

En la cabina destino `C2N1`, la dirección `peer` es la IP de la cabina origen `C1N1`. Si tenemos más de una IP, después de la primera se pone una coma y se agregan las IPs adicionales. Se tiene que usar la misma clave cuando se ejecuta el mismo comando en la cabina origen.

```sh
c2n1::> cluster peer create -peer-addrs 10.10.10.1
```

```sh
Notice: Use a generated passphrase or choose a passphrase of 8 or more characters. To ensure the authenticity of the peering relationship, use a phrase or sequence of characters that would be hard to guess.
```

```sh
Enter the passphrase:
Confirm the passphrase:
```

Ahora usamos el mismo comando en la cabina origen `C1N1`:
```sh
c1n1::> cluster peer create -peer-addrs 10.10.10.2
```

```sh
Notice: Use a generated passphrase or choose a passphrase of 8 or more characters. To ensure the authenticity of the peering relationship, use a phrase or sequence of characters that would be hard to guess.
```

```sh
Enter the passphrase:
Confirm the passphrase:
```

Verificamos el estado del cluster peer en ambas cabinas con el siguiente comando. El resultado tiene que ser el mismo en ambas y en el caso de `health` tiene que ser `true`:
```sh
c1n1::> cluster peer show
```

```sh
Peer Cluster Name         Cluster Serial Number Availability   Authentication
------------------------- --------------------- -------------- --------------
c2n1                      1-80-000008           Available      ok
```

```sh
c2n1::> cluster peer health show
```

```sh
Node       Cluster-Name                 Node-Name
           Ping-Status               RDB-Health Cluster-Health Availability
---------- --------------------------- --------- --------------- ------------
c2n1-01    c1n1                        c1n1-01
           Data: interface_reachable
           ICMP: -                   true      true            true
```

## 8. VServer Peering

Una vez que tenemos el cluster peer montado, debemos crear el cluster peer de los vservers CIFS y NFS. El comando se ejecuta desde la cabina origen `C1N1`:

```sh
c1n1::> vserver peer create -vserver SVM_CIFS -peer-vserver svm_cifs_mir -peer-cluster c2n1 -applications snapmirror
```

```sh
Info: [Job 120] 'vserver peer create' job queued
```

```sh
c1n1::> vserver peer create -vserver SVM_NFS -peer-vserver svm_nfs_mir -peer-cluster c2n1 -applications snapmirror
```

```sh
Info: [Job 121] 'vserver peer create' job queued
```

En la cabina de destino `C2N1`, tenemos que aceptar el peering de las SVM, con este comando vemos el estado de `pending accept`:
```sh
c2n1::> vserver peer show
```

```sh
Peer        Peer                           Peering        Remote
Vserver     Vserver     State        Peer Cluster      Applications   Vserver
----------- ----------- ------------ ----------------- -------------- ---------
svm_cifs_mir SVM_CIFS    pending      c1n1              snapmirror     SVM_CIFS
svm_nfs_mir  SVM_NFS     pending      c1n1              snapmirror     SVM_NFS
2 entries were displayed.
```

Tenemos que aceptar ambos requerimientos:
```sh
c2n1::> vserver peer accept -vserver svm_cifs_mir -peer-vserver SVM_CIFS
```

```sh
Info: [Job 120] 'vserver peer accept' job queued
``

`

```sh
c2n1::> vserver peer accept -vserver svm_nfs_mir -peer-vserver SVM_NFS
```

```sh
Info: [Job 121] 'vserver peer accept' job queued
```

Finalmente, verificamos que el vserver peering esté activo:
```sh
c2n1::> vserver peer show
```

```sh
Peer        Peer                           Peering        Remote
Vserver     Vserver     State        Peer Cluster      Applications   Vserver
----------- ----------- ------------ ----------------- -------------- ---------
svm_cifs_mir SVM_CIFS    peered      c1n1              snapmirror     SVM_CIFS
svm_nfs_mir  SVM_NFS     peered      c1n1              snapmirror     SVM_NFS
2 entries were displayed.
```

## 9. Creación de los SnapMirror Relationships

Finalmente, creamos el SnapMirror. Este comando se ejecuta en la cabina origen `C1N1` con los nombres de las SVM que se originan y los volúmenes que corresponden en cada SVM origen y destino:

### CIFS
```sh
snapmirror create -source-path SVM_CIFS:vol_cifs_01 -destination-path svm_cifs_mir:vol_cifs_01_mir -type DP
```

```sh
Info: [Job 123] 'snapmirror create' job queued
```

### NFS
```sh
snapmirror create -source-path SVM_NFS:ds_nfs_02 -destination-path svm_nfs_mir:ds_nfs_02_mir -type DP
```

```sh
Info: [Job 124] 'snapmirror create' job queued
```

Una vez que hemos creado los SnapMirror relationships, los inicializamos. Este comando se ejecuta desde la cabina destino `C2N1`:

### CIFS
```sh
snapmirror initialize -destination-path svm_cifs_mir:vol_cifs_01_mir
```

### NFS
```sh
snapmirror initialize -destination-path svm_nfs_mir:ds_nfs_02_mir
```

Verificamos el estado de los SnapMirror con este comando:
```sh
snapmirror show
```

### Posibles Estados:
```sh
State: Snapmirrored, Transfer Status: Idle
```

```sh
State: Snapmirrored, Transfer Status: Transferring
```

## 10. Snaplock
Si los volumenes tienen snaplock es necesario que la cabina destino tambien lo tenga habilitado

Ref:
- [Initialize the Compliance Clock](https://docs.netapp.com/us-en/ontap/snaplock/initialize-complianceclock-task.html#enable-compliance-clock-resynchronization-for-an-ntp-configured-system)
- [snaplock compliance-clock initialize](https://docs.netapp.com/us-en/ontap-cli/snaplock-compliance-clock-initialize.html#description)