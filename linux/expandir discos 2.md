(This example uses Ubuntu Server 12.04, but it works for 14.04, 16.04 and 18.04 as well.)
After you make the additional space available in VMWare/Xen/Hyper-V, first reboot your Ubuntu server so it can see the new free space. Then we'll run the GNU partition editor to examine our disk:
```
root@myserver:/# parted
GNU Parted 2.2
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) print free
Model: VMware Virtual disk (scsi)
Disk /dev/sda: 42.5GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos 
 
Number  Start   End     Size    Type      File system  Flags
        32.3kB  32.8kB  512B              Free Space
 1      32.8kB  255MB   255MB   primary   ext2         boot
        255MB   255MB   8192B             Free Space
 2      255MB   16.1GB  15.8GB  extended
 5      255MB   16.1GB  15.8GB  logical                lvm
 3      16.1GB  21.5GB  5365MB  primary
        21.5GB  21.5GB  6856kB            Free Space 
        21.5GB  42.5GB  21.0GB            Free Space <------
```
You can see your free space, so let's partition it:
```
$ cfdisk
```
Pick your free space, select New, then choose a Primary or Logical partition. For a small server, it probably doesn't matter too much.

** Remember in x86 Linux that you can have a maximum of 4 primary + extended partitions per disk. **
** Beyond that, you'll need to begin adding logical partitions in your extended partitions. **

Use partition type Linux LVM (8e).
Select the Write command to create the partition, then (if necessary) reboot your system.

When your system comes back up, check on your new partition:
```
$ fdisk -l /dev/sda
 
Disk /dev/sda: 42.5 GB, 21474836480 bytes
255 heads, 63 sectors/track, 2610 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000d90ee
 
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          31      248832   83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sda2              31        1958    15476768    5  Extended
/dev/sda3            1958        2610     5239185   83  Linux
/dev/sda4            2610        3608    16815191   83  Linux <-----
/dev/sda5              31        1958    15476736   8e  Linux LVM
```
So now let's pull it into our LVM configuration. First we'll create the physical volume:
```
$ pvcreate /dev/sda4
  Physical volume "/dev/sda4" successfully created
```
Let's take a look at our physical volumes:
$ pvdisplay
 
  --- Physical volume ---
  PV Name               /dev/sda5
  VG Name               ubuntu-1004
  PV Size               14.76 GiB / not usable 2.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              3778
  Free PE               0
  Allocated PE          3778
  PV UUID               f3tYaB-YCoK-ZeRq-LfDX-spqd-ggeV-gdsemo
 
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               ubuntu-1004
  PV Size               5.00 GiB / not usable 401.00 KiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              1279
  Free PE               11
  Allocated PE          1268
  PV UUID               rL0QG1-OmuS-d4qL-d9u3-K7Hk-4a1l-NP3DtQ
 
  "/dev/sda4" is a new physical volume of "20.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sda4
  VG Name
  PV Size               20.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               uaJn0v-HbRz-YKv4-Ez83-jVUo-dfyH-Ky2oHV
```
Now, extend our volume group (ubuntu-1004) into our new physical volume (/dev/sda4):
```
$ vgextend ubuntu-1004 /dev/sda4
  Volume group "ubuntu-1004" successfully extended
```
The whole purpose of this exercise is to expand the root filesystem, so let's find our main logical volume:
```
$ lvdisplay
 
  --- Logical volume ---
  LV Name                /dev/ubuntu-1004/root
  VG Name                ubuntu-1004
  LV UUID                UJQUwV-f3rI-Tsd3-dQYO-exIk-LSpq-2qls13
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                19.39 GiB
  Current LE             1892
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:0
```
Now, let's extend the logical volume to all free space available:
```
$ lvextend -l+100%FREE /dev/ubuntu-1004/root
```
Next, extend the filesystem:
```
$ resize2fs /dev/mapper/ubuntu--1004-root
```
Finally, let's check our free space:
```
$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--1004-root
                       39G   14G   24G  37% /   <---- 
none                  495M  176K  495M   1% /dev
none                  500M     0  500M   0% /dev/shm
none                  500M   36K  500M   1% /var/run
none                  500M     0  500M   0% /var/lock
none                  500M     0  500M   0% /lib/init/rw
/dev/sda1             228M  144M   72M  67% /boot

Algunos filesystems no utilizan resize2fs como en este caso y se utilizo el siguiente comando final para extender el filesystem:

```
sudo xfs_growfs /dev/rootvg/rootlv
```
# Linux Centos-Rocky-RedHat expandir disco virtual
```
fdisk /dev/sda
```
Ver opciones
```
m
```
Crear particion, dar a todo por defecto
```
n
```
Mostrar cambios
```
p
```
Cambiar el tipo a LVM
```
t
opcion 30 de LVM
```
Guardar cambios
```
w
```
Crear un volumen fisico con nombre del VG
```
pvcreate rl_rocky91 /dev/sda4
pvdisplay
```
Extender el LV con el disco nuevo y verificar el espacio libre
```
vgextend rl_rocky91 /dev/sda4 
vgs
```
Listar los volumenes con 
```
df -h
```
Incrementar el size block
```
lvextend -l +100%FREE /dev/mapper/rl_rocky91-root
```
Extender el filesystem
```
xfs_growfs /dev/mapper/rl_rocky91-root
```
