1. Creación de cero de broadcast domain y agregar interfaz de nodo 2 
```
A150_PROD::> broadcast-domain create -broadcast-domain CIFS -mtu 9000 -ipspace Default -ports A150_PROD-01:a0a-250
A150_PROD::> broadcast-domain add-ports -broadcast-domain CIFS -ports A150_PROD-02:a0a-250 -ipspace Default
```
2. Creación de SVM
```
150_PROD::> vserver create -vserver SVM_CIFS -aggregate aggr_A150_PROD_01_01 -subtype default -rootvolume SVM_CIFS_root -rootvolume-security-style ntfs -language C.UTF-8 -snapshot-policy default -data-services data-cifs -foreground true
[Job 65] Job succeeded:
Vserver creation completed.
```
Crear las LIFS para esta SVM
```
A150_PROD::> network interface create -vserver SVM_CIFS -lif LIF_A150_PROD_01_CIFS_01 -address 10.210.250.11 -netmask 255.255.255.0 -home-node A150_PROD-01 -home-port a0a-250 -service-policy default-data-files -status-admin up -broadcast-domain CIFS
A150_PROD::> network interface create -vserver SVM_CIFS -lif LIF_A150_PROD_02_CIFS_01 -address 10.210.250.12 -netmask 255.255.255.0 -home-node A150_PROD-02 -home-port a0a-250 -service-policy default-data-files -status-admin up -broadcast-domain CIFS
```
3. Cambiar los protocolos y permitir solo CIFS listando primero que es lo que hay
```
A150_PROD::> vserver modify -vserver SVM_CIFS -allowed-protocols cifs, ndmp
A150_PROD::> vserver show -vserver SVM_CIFS -fields allowed-protocols,disallowed
vserver  allowed-protocols disallowed-protocols
-------- ----------------- ---------------------
SVM_CIFS cifs,ndmp         nfs,fcp,iscsi,nvme,s3
```
4. Creamos la Export Policy asociada a la SVM_CIFS que va a permitir a las redes acceder. Este punto es opcional y funciona sin export policy pero de hacerlo agrega un nivel de seguridad adicional permitiendo unicamente los CIDRs configurados
```
A150_PROD::> vserver export-policy create -policyname EP_SVM_CIFS -vserver SVM_CIFS
```
5. Ahora creamos cada una de las reglas definiendo cada red que necesita acceso a CIFS
```
A150_PROD::> vserver export-policy rule create -policyname EP_SVM_CIFS -clientmatch 10.210.160.0/24 -rwrule any -rorule any -vserver SVM_CIFS -allow-suid true -allow-dev true -protocol cifs -superuser any
```
6. Creación de un volumen CIFS
```
A150_PROD::> volume create -volume VOL_CIFS_01 -state online -vserver SVM_CIFS -policy EP_SVM_CIFS -foreground true -aggregate aggr_A150_PROD_01_01 -snapshot-policy default -size 1TB -language C.UTF-8 -junction-path /VOL_CIFS_01 -security-style ntfs -percent-snapshot-space 20
```
7. Se deberan crear los Shares correspondientes y la estrategia puede ser crear un share y asociarlo a un volumen o bien crear multiples shares asociados a un solo volumen
```
vserver cifs share create -vserver SVM_CIFS -share-name Archive -share-properties browsable ,changenotify ,oplocks ,show-previous-versions -path /VOL_CIFS01
```
8. Se deberan definir los DC preferidos para que la funcionan de autodescubrimiento de DNS no se propague, en el caso de tener Conditional forwarders puede ser un problema ya que busca DNS fuera del sitio y esto da lugar a un error de acceso de LDAP en la cabian
Modificamos los servers preferido
```
vserver cifs domain preferred-dc add -vserver SVM_CIFS -domain inke.local -preferred-dc 10.210.160.11,10.210.160.12
```
9. Definimos el descrumiento a NONE
```
vserver cifs domain discovered-servers discovery-mode modify -vserver SVM_CIFS -mode none
```
10. En el caso de requerir la funcion de SEAL and SIGNED en SMB por parte de windows se deberan ejecutar los siguientes comandos
```
cifs show -vserver 
cifs security show -vserver SVM_CIFS -fields session-security-for-ad-ldap
cifs security modify -vserver SVM_CIFS -session-security-for-ad-ldap <sign or seal>
cifs security show -vserver SVM_CIFS -fields session-security-for-ad-ldap
```