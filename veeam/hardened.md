Gui de Veeam: https://www.veeam.com/blog/installing-ubuntu-linux-veeam-hardened-repository.html


# Instalacion y config iSCSI (punto 1 virtual machine)
1. Crear una maquina con ubuntu y editar el archivo vmx, agregar las siguientes entradas:
uefi.secureBoot.enabled = "TRUE"
uefi.allowAuthBypass = "TRUE"
La maquina tiene que tener bios EFI

2. Instalar con opcion Ubuntu Server with the HWE kernel
3. Durante la instalacion aprovechar y crear el BOND de interfaces
    - balancerr es lacp
    - active-backup es sin lacp
  Ejemplo de un BOND de LACP:
  ```
  network:
  bonds:
    lacp-iscsi:
      addresses:
      - 10.210.251.11/24
      interfaces:
      - eno3
      - ens2f1np1
      nameservers:
        addresses: []
        search: []
      parameters:
        lacp-rate: slow
        mode: 802.3ad
        transmit-hash-policy: layer2
    lacp-lan:
      addresses:
      - 10.210.150.30/24
      interfaces:
      - eno4
      - ens2f0np0
      nameservers:
        addresses:
        - 1.1.1.2
        - 1.0.0.2
        search: []
      parameters:
        lacp-rate: slow
        mode: 802.3ad
        transmit-hash-policy: layer2
      routes:
      - to: default
        via: 10.210.150.1
  ethernets:
    eno3: {}
    eno4: {}
    ens2f0np0: {}
    ens2f1np1: {}
  version: 2
  ```
4. El resto de la instalacion corre de manera normal
5. Verificar el estado de secure boot con el comando
```
mokutil --sb-state
```
# Ajustar OS
1. Actualizar e instalar
```
sudo apt-get update
sudo apt-get upgrade
sudo apt install tree
sudo apt install ncdu
```
### Cambiar NTP
Editar el siguiente archivo:
```
sudo nano /etc/systemd/timesyncd.conf
```
Uncomment the NPT= line and define the server you want to be used instead of default:
```
[Time]
NTP=some.ntp.server.com
```
To "audit" the time-synchronization events and verify the server that was contacted, use the following command:
```
cat /var/log/syslog | grep systemd-timesyncd
```
Force sync and service restart
```
sudo systemctl restart systemd-timesyncd
```
### cambiar timezone
```
sudo ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime
```
Restart the service
```
sudo dpkg-reconfigure -f noninteractive tzdata
```
# Inslacion de cockpit
## Ubuntu 22.04
```
sudo apt update; sudo apt install cockpit
sudo systemctl enable cockpit.socket
sudo systemctl status cockpit
```
## Oracle Linux 8.5
```
yum install epel-release
yum install cockpit
systemctl enable --now cockpit.socket
```
## Cockpit fake adapter
updates: Work around the "whilst offline" in Ubuntu & Debian · Issue #16963 · cockpit-project/cockpit · GitHub
Frequently Asked Questions (FAQ) — Cockpit Project (cockpit-project.org)

### Error message about being offline
The software update page shows “packagekit cannot refresh cache whilst offline” on a Debian or Ubuntu system.

Solution
Create a placeholder file and network interface.

### Create
```
sudo nano /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
```
with the contents:
```
[keyfile]
unmanaged-devices=none
```
Set up a “dummy” network interface:
```
sudo nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1
Reboot
```
# iSCSI

1. La configuracion iscsi esta basado en esto 2 links:
    - [Ubuntu 22.04 LTS : Configure iSCSI Initiator : Server World (server-world.info)](https://www.server-world.info/en/note?os=Ubuntu_22.04&p=iscsi&f=3)
    - [https://benpiper.com/2014/12/creating-linux-lvm-logical-volume-iscsi-san/](https://benpiper.com/2014/12/creating-linux-lvm-logical-volume-iscsi-san/)

2. Mostrar el IQN de iscsi
```
sudo cat /etc/iscsi/initiatorname.iscsi
```
3. Descubrir el target
```
sudo iscsiadm -m discovery -t sendtargets -p 192.168.78.247
```
4.  Confirma estado de descubrimiento
```
sudo iscsiadm -m node -o show | grep -e node.name -e node.tpgt -e node.startup
```
5.  Iniciar sesion
```
sudo iscsiadm -m node --login -p 192.168.78.247
```
6.  Confirmar la conexion
```
sudo iscsiadm -m session -o show
```
7.  Habilitar inicio automatico
```
sudo iscsiadm -m node -p 192.168.78.247 -o update -n node.startup -v automatic
```
8.  Listar particiones (en este caso figura como sdb)
```
sudo cat /proc/partitions
major minor  #blocks  name

   7        0      54536 loop0
   7        1     114636 loop1
   7        2      64972 loop2
  11        0    1048575 sr0
   8        0   41943040 sda
   8        1    1100800 sda1
   8        2    2097152 sda2
   8        3   38743040 sda3
 253        0   19369984 dm-0
   8       16  104857600 sdb

```
9. Mutipath es algo normal y que se puede dar cuando una cabina de alacenamiento tiene mas de un puerto de red de iscsi, en este caso la cabina tiene 4 interfaces de red accesibles.
Verificar la instalacion de los modulos
```
sudo apt install open-iscsi
sudo apt install multipath-tools
```
10. Iniciar sesion en cada portal iscsi
```
sudo iscsiadm -m node --login -p 10.210.240.12
sudo iscsiadm -m node --login -p 10.210.240.13
sudo iscsiadm -m node --login -p 10.210.240.14
sudo iscsiadm -m node --login -p 10.210.240.15
```
11. Verificamos el estado de login
```
sudo iscsiadm -m session -o show
tcp: [1] 10.210.251.15:3260,2 iqn.1992-08.com.netapp:2806.6d039ea000b1146a00000000654d1636 (non-flash)
tcp: [2] 10.210.251.12:3260,1 iqn.1992-08.com.netapp:2806.6d039ea000b1146a00000000654d1636 (non-flash)
tcp: [3] 10.210.251.13:3260,1 iqn.1992-08.com.netapp:2806.6d039ea000b1146a00000000654d1636 (non-flash)
tcp: [4] 10.210.251.14:3260,2 iqn.1992-08.com.netapp:2806.6d039ea000b1146a00000000654d1636 (non-flash)

```
12. Inicio automatico de cada conexion iscsi
```
sudo iscsiadm -m node -p 10.210.240.12 -o update -n node.startup -v automatic
sudo iscsiadm -m node -p 10.210.240.13 -o update -n node.startup -v automatic
sudo iscsiadm -m node -p 10.210.240.14 -o update -n node.startup -v automatic
sudo iscsiadm -m node -p 10.210.240.15 -o update -n node.startup -v automatic
```
13. Verificamos el estado de multipath
```
sudo multipath -ll
mpatha (36d039ea000b119ac000000d465b8b748) dm-1 NETAPP,INF-01-00
size=10T features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 alua' wp=rw
|-+- policy='service-time 0' prio=50 status=active
| |- 23:0:0:0 sdf 8:80 active ready running
| `- 20:0:0:0 sdc 8:32 active ready running
`-+- policy='service-time 0' prio=10 status=enabled
  |- 22:0:0:0 sde 8:64 active ready running
  `- 21:0:0:0 sdd 8:48 active ready running
```
14. En el siguiente documento de ubuntu oficial se expresa que multiples paths generan multiples volumenes que pueden aparecer como sde, sdf, sdg, etc. Todas esas unidades representan el path de acceso y cuando se ejecuta 

    
# Particionado
1. Ejecutamos para ver particion
```
sudo fdisk -l

Disk /dev/sdb: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: QUANTASTOR
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 65536 bytes
I/O size (minimum/optimal): 65536 bytes / 65536 bytes
```
2. Comandos fdisk
```
sudo fdisk /dev/sdb
Command (m for help): p
Command (m for help): n
p para primario
1 para numero de particion
Primer y ultimo sector por defecto
t
8e (Linux LVM)
verificamos con "p" la configuracion
w para guardar
```
### En el caso de volumenes de mas de 2TB hay que hacerlo de otra manera y es usando GPARTED. Este ejemplo asume que el disco es de 10TB. La otra particularidad del ejemplo es que se usa un volumen multipath iscsi de una cabina e-series

```
sudo parted /dev/mapper/mpatha
p chequea particiones existentes
mklabel gpt
unit TB
mkpart primary 0 10
```
```
p imprime el resultado

GNU Parted 3.4
Using /dev/mapper/mpatha
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p
Model: Linux device-mapper (multipath) (dm)
Disk /dev/mapper/mpatha: 11.0TB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  11.0TB  11.0TB               primary

```
El resultado cuando se consulta con el comando sudo **fdisk -l** muestra al final de todo el volumen mpatha y el dispositivo particionado

```
Disk /dev/mapper/mpatha: 10 TiB, 10995116277760 bytes, 21474836480 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: B8A08D5A-C09E-409B-87A6-4BDC29872004

Device                   Start         End     Sectors Size Type
/dev/mapper/mpatha-part1  2048 21474834431 21474832384  10T Linux filesystem
```

3. Creacion de volumen fisico
```
sudo pvcreate /dev/sdb1
sudo vgcreate vg_veeam_u01 /dev/sdb1
sudo lvcreate vg_veeam_u01 -L 100G -n lv_veeam_u01
sudo lvdisplay vg_veeam_u01
```
Formatear en xfs con el bloque de 4k
```
sudo mkfs.xfs -b size=4096 /dev/vg_veeam_u01/lv_veeam_u01
```
4. Montaindo el volumen
```
sudo mkdir veeam_repo1
sudo mount /dev/vg_veeam_u01/lv_veeam_u01 /veeam_repo/
```
5. Se otorga pertenencia del repo
```
sudo chown -cR veeam:veeam /veeam_repo/
```
# FSTAB para autoiniciar montura
1. Realizar copia de respaldo de fstab
```
sudo cp /etc/fstab /etc/fstab.old
```
2. Obtener el UUID de la particion
```
sudo lsblk -o NAME,FSTYPE,UUID,SIZE,LABEL
```
3. sudo nano /etc/fstab
```
UUID=60258404-2861-4cb7-ada0-66eee675b66b /veeam_repo xfs rw,user,x-systemd.automount 0 0
```