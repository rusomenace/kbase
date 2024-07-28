

1. Primero hay que elegir que interfaz se va a utilizar para iSCSI, pueden ser una o mas.
El sigueinte comando lista las interfaces disponibles pero la GUI de administracion es mas sencilla de entender.
En este ejemplo usaremos e0d
```
c2n1::*> network port show

Node: c2n1-01
                                                                       Ignore
                                                  Speed(Mbps) Health   Health
Port      IPspace      Broadcast Domain Link MTU  Admin/Oper  Status   Status
--------- ------------ ---------------- ---- ---- ----------- -------- ------
e0a       Default      Default          up   1500  auto/1000  healthy  false
e0b       Default      Default          up   1500  auto/1000  healthy  false
e0c       Default      Default          up   1500  auto/1000  healthy  false
e0d       Default      Default-1        up   1500  auto/1000  healthy  false
```

2. Como mejor practica es conveniente isolar el trafico iSCSI en su propio broadcast domain y esto puede realizarse por una interfaz a la vez o por un grupo.
Con direct attach es mejor crear un brodcast domain por interfaz.
```
c2n1::*> broadcast-domain create -broadcast-domain bd-lif01_e0d-iscsi -mtu 1500 -ports c2n1-01:e0d -ipspace Default
  (network port broadcast-domain create)
```
**La creacion puede dar error si el puerto pertenece a otro broadcast domain por lo cual sera necesario quitarlo antes de asignarlo al nuevo broadcast domain**

3. Creamos el VServer o SVM
```
c2n1::*> vserver create -vserver svm_iscsi -subtype default -rootvolume svm_iscsi_root -rootvolume-security-style unix -language C.UTF-8 -snapshot-policy none -data-services data-iscsi -foreground true -aggregate c2n1_01_FC_1 -auto-enable-analytics true -anti-ransomware-auto-switch-from-learning-to-enabled true
[Job 35] Job succeeded:
Vserver creation completed.
````

4. Creamos la LIF asociada a la SVM y a su vez al broadcast domain especifico
```
c2n1::*> network interface create -vserver svm_iscsi -lif lif01_e0d-iscsi -service-policy default-data-iscsi -address 192.168.99.215 -netmask 255.255.255.0 -home-node c2n1-01 -home-port e0d -status-admin up -auto-revert true -broadcast-domain bd-lif01_e0d-iscsi
```

5. Para poder crear la LUN es necesario crear el volumen que la va a contener

```
c2n1::*> volume create  -volume vol_iscsi01 -state online -policy default -unix-permissions ---rwxr-xr-x -junction-active true -vsroot false -type RW -snapshot-policy none -aggregate c2n1_01_FC_1 -vserver svm_iscsi -size 10GB -autosize-mode off -percent-snapshot-space 5 -language C.UTF-8 -foreground true -analytics-state on -anti-ransomware-state enabled -junction-path /vol_iscsi01 -comment "This is a iSCSI Volumen 1" -activity-tracking-state on
```
**La opcion de ransomware estara disponible si esta licenciado, en las nuevas netapps eso es asi siempre pero no en el caso del simbox**

6. Creamos el servicio de iSCSI en la SVM
```
c2n1::*> vserver iscsi create -vserver svm_iscsi
```

7. Creamos la LUN
```
c2n1::*> lun create -path /vol/vol_iscsi01/lun_iscsi01 -ostype vmware -space-reserve enabled -space-allocation enabled -vserver svm_iscsi -size 9.4GB

Created a LUN of size 9.4g (10093173248)
```
**El tamaño va a variar por lo que hay que ir probando el maximo si es lo que se quiere ocupar**

8. Los siguientes puntos se pueden realizar de manera sencilla desde la GUI:

- Crear en HOST SAN initiators groups los hosts iSCSI y crear un grupo que lo contenga.
- Agregar a cada host el IQN correspondiente
- Crear un grupo de hosts y seleccionar cada uno que lo integre
- Finalmente hay que ir a la LUN(s) y mapearla al correspondiente host o SAN initiator group

