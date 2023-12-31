Gui de Veeam: https://www.veeam.com/blog/installing-ubuntu-linux-veeam-hardened-repository.html


# Instalacion y config iSCSI
1. Crear una maquina con ubuntu y editar el archivo vmx, agregar las siguientes entradas:
uefi.secureBoot.enabled = "TRUE"
uefi.allowAuthBypass = "TRUE"
La maquina tiene que tener bios EFI

2. Instalar con opcion Ubuntu Server with the HWE kernel
3. Durante la instalacion aprovechar y crear el BOND de interfaces
    - balancerr es lacp
    - active-backup es sin lacp
4. El resto de la instalacion corre de manera normal
5. Verificar el estado de secure boot con el comando
```
mokutil --sb-state
```
6. La configuracion iscsi esta basado en esto 2 links:
    - [Ubuntu 22.04 LTS : Configure iSCSI Initiator : Server World (server-world.info)](https://www.server-world.info/en/note?os=Ubuntu_22.04&p=iscsi&f=3)
    - [https://benpiper.com/2014/12/creating-linux-lvm-logical-volume-iscsi-san/](https://benpiper.com/2014/12/creating-linux-lvm-logical-volume-iscsi-san/)

7. Actualizar
```
sudo apt-get update
sudo apt-get upgrade
sudo apt install tree
```
8. Mostrar el IQN de iscsi
```
sudo cat /etc/iscsi/initiatorname.iscsi
```
9. Descubrir el target
```
sudo iscsiadm -m discovery -t sendtargets -p 192.168.78.247
```
10. Confirma estado de descubrimiento
```
sudo iscsiadm -m node -o show | grep -e node.name -e node.tpgt -e node.startup
```
11. Iniciar sesion
```
sudo iscsiadm -m node --login -p 192.168.78.247
```
12. Confirmar la conexion
```
sudo iscsiadm -m session -o show
```
13. Habilitar inicio automatico
```
sudo iscsiadm -m node -p 192.168.78.247 -o update -n node.startup -v automatic
```
14. Listar particiones (en este caso figura como sdb)
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
3. Creacion de volumen fisico
```
sudo pvcreate /dev/sdb1
sudo lvcreate vg_veeam_u01 -L 100G -n lv_veeam_u01
sudo lvcreate vg_veeam_u01 -L 99G -n lv_veeam_u01
sudo lvdisplay vg_veeam_u01
```
Formatear en xfs con el bloque de 4k
```
sudo mkfs.xfs -b size=4096 /dev/vg_veeam_u01/lv_veeam_u01
```
4. Montaindo el volumen
```
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
2. Obtener el UUID de la aprticion
```
sudo lsblk -o NAME,FSTYPE,UUID,SIZE,LABEL
```
3. sudo nano /etc/fstab
```
UUID=60258404-2861-4cb7-ada0-66eee675b66b /veeam_repo xfs rw,user,x-systemd.automount 0 0
```