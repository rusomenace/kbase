1. Creacion paso a paso de NFS
Creacion de cero de broadcast domain y agregar interfaz de nodo 2
```
A150_PROD::> broadcast-domain create -broadcast-domain NFS -mtu 9000 -ipspace Default -ports A150_PROD-01:a0a-240
  (network port broadcast-domain create)
A150_PROD::> broadcast-domain add-ports -broadcast-domain NFS -ports A150_PROD-02:a0a-240 -ipspace Default
  (network port broadcast-domain add-ports)
```
2. Creacion SVM
```
150_PROD::> vserver create -vserver SVM_NFS -aggregate aggr_A150_PROD_01_01 -subtype default -rootvolume SVM_NFS_root -rootvolume-security-style unix -language C.UTF-8 -snapshot-policy default -data-services data-nfs -foreground true
[Job 53] Job succeeded:
Vserver creation completed.
```
3. Crear las LIFS para esta SVM
```
A150_PROD::> network interface create -vserver SVM_NFS -lif LIF_A150_PROD_01_NFS_01 -address 10.210.240.11 -netmask 255.255.255.0 -home-node A150_PROD-01 -home-port a0a-240 -service-policy default-data-files -status-admin up -broadcast-domain NFS
A150_PROD::> network interface create -vserver SVM_NFS -lif LIF_A150_PROD_02_NFS_01 -address 10.210.240.12 -netmask 255.255.255.0 -home-node A150_PROD-02 -home-port a0a-240 -service-policy default-data-files -status-admin up -broadcast-domain NFS
```
4. Cambiar protocoles y permitir solo NFS
```
A150_PROD::> vserver modify -vserver SVM_NFS -allowed-protocols nfs
A150_PROD::> vserver show -vserver SVM_NFS -fields allowed-protocols,disallowed
vserver allowed-protocols disallowed-protocols
------- ----------------- ---------------------------
SVM_NFS nfs               cifs,fcp,iscsi,ndmp,nvme,s3
```
5. Habilitar NFS v3 y v4.1 en vserver NFS
```
A150_PROD::> nfs create -vserver SVM_NFS -access true -v3 enabled -v4.1 enabled
```
6. Crear Export Policy y reglas para permitir solamente que los 3 hosts esxi puedan acceder
```
vserver export-policy create -policyname EP_SVM_NFS -vserver SVM_NFS
vserver export-policy rule create -policyname EP_SVM_NFS -clientmatch 10.210.150.11 -rwrule sys -rorule sys -allow-suid true -allow-dev true -vserver SVM_NFS -protocol nfs, nfs3, nfs4 -superuser sys
vserver export-policy rule create -policyname EP_SVM_NFS -clientmatch 10.210.150.12 -rwrule sys -rorule sys -allow-suid true -allow-dev true -vserver SVM_NFS -protocol nfs, nfs3, nfs4 -superuser sys
vserver export-policy rule create -policyname EP_SVM_NFS -clientmatch 10.210.150.13 -rwrule sys -rorule sys -allow-suid true -allow-dev true -vserver SVM_NFS -protocol nfs, nfs3, nfs4 -superuser sys
```
7. Snapshot Policy especifica de NFS, hacemos esto para que cada SVM por servicio tenga la politica mas adecuada.
La presente es una politica valida para volumenes NFS que si bien es igual a la Default en un futuro se puede modificar sin afectar los snapshots de otros volumenes
```
A150_PROD::> snapshot policy create -policy SP_SVM_NFS -enabled true -schedule1 hourly -count1 6 -schedule2 daily -count2 2 -schedule3 weekly -count3 2
```
Se lee de la siguiente manera:
- schedule1 | count1: un snapshot por hora y se mantienen hasta 6
- schedule2 | count2: un snapshot por dia y se mantienen hasta 2
- schedule3 | count3: un snapshot por semana y se mantienen hasta 2
8. Crear Volumenes, en este caso 4 volumenes 
- 2 asociados a Nodo 01
- 2 asociados al nodo 2
```
A150_PROD::> volume create -volume DS_NFS_01 -state online -policy EP_SVM_NFS -unix-permissions ---rwxr-xr-x -type RW -snapshot-policy SP_SVM_NFS -foreground true -vserver SVM_NFS -aggregate aggr_A150_PROD_01_01 -size 2TB -junction-path /DS_NFS_01 -language C.utF-8 -security-style unix -percent-snapshot-space 20
A150_PROD::> volume create -volume DS_NFS_02 -state online -policy EP_SVM_NFS -unix-permissions ---rwxr-xr-x -type RW -snapshot-policy SP_SVM_NFS -foreground true -vserver SVM_NFS -aggregate aggr_A150_PROD_02_01 -size 2TB -junction-path /DS_NFS_02 -language C.utF-8 -security-style unix -percent-snapshot-space 20
A150_PROD::> volume create -volume DS_NFS_03 -state online -policy EP_SVM_NFS -unix-permissions ---rwxr-xr-x -type RW -snapshot-policy SP_SVM_NFS -foreground true -vserver SVM_NFS -aggregate aggr_A150_PROD_01_01 -size 8TB -junction-path /DS_NFS_03 -language C.utF-8 -security-style unix -percent-snapshot-space 20
A150_PROD::> volume create -volume DS_NFS_04 -state online -policy EP_SVM_NFS -unix-permissions ---rwxr-xr-x -type RW -snapshot-policy SP_SVM_NFS -foreground true -vserver SVM_NFS -aggregate aggr_A150_PROD_02_01 -size 8TB -junction-path /DS_NFS_04 -language C.utF-8 -security-style unix -percent-snapshot-space 20
```
9. Comprobamos la creacion de todos los volumenes en este caso tanto NFS como CIFS
```
A150_PROD::> volume show
Vserver   Volume       Aggregate    State      Type       Size  Available Used%
--------- ------------ ------------ ---------- ---- ---------- ---------- -----
A150_PROD-01
          vol0         aggr_ROOT_A150_PROD_01
                                    online     RW      151.3GB    105.4GB   26%
A150_PROD-02
          vol0         aggr_ROOT_A150_PROD_02
                                    online     RW      151.3GB    124.0GB   13%
SVM_CIFS  SVM_CIFS_root
                       aggr_A150_PROD_01_01
                                    online     RW          1GB    972.4MB    0%
SVM_CIFS  VOL_VIFS_01  aggr_A150_PROD_01_01
                                    online     RW          1TB    819.2GB    0%
SVM_NFS   DS_NFS_01    aggr_A150_PROD_01_01
                                    online     RW          2TB     1.60TB    0%
SVM_NFS   DS_NFS_02    aggr_A150_PROD_02_01
                                    online     RW          2TB     1.60TB    0%
SVM_NFS   DS_NFS_03    aggr_A150_PROD_01_01
                                    online     RW          8TB     6.40TB    0%
SVM_NFS   DS_NFS_04    aggr_A150_PROD_02_01
                                    online     RW          8TB     6.40TB    0%
SVM_NFS   SVM_NFS_root aggr_A150_PROD_01_01
                                    online     RW          1GB    972.1MB    0%
9 entries were displayed.
```