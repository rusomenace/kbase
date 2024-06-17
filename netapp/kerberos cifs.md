# En NETAPP

Comando para ver tipo de mecanismo de autentication
```
c1n1::> cifs session show -node * -vserver SVM_CIFS -fields auth-mechanism
node    vserver  session-id          connection-id auth-mechanism
------- -------- ------------------- ------------- --------------
c1n1-01 SVM_CIFS 7331578718382457004 514102116     Kerberos
```

Comando para verificar el tipo de encriptacion
```
c1n1::> vserver cifs security show -vserver SVM_CIFS -fields advertised-enc-types
vserver  advertised-enc-types
-------- --------------------
SVM_CIFS aes-128,aes-256
```
Comando para modificar los valores de encriptacion de CIFS
```
c1n1::> vserver cifs security modify -vserver SVM_CIFS -advertised-enc-types aes-128, aes-256
```
Comando para verificar el nivel de seguridad que es importante en LM Compatibility Level
```
c1n1::> vserver cifs security show -vserver SVM_CIFS

Vserver: SVM_CIFS

                            Kerberos Clock Skew:                   5 minutes
                            Kerberos Ticket Age:                  10 hours
                           Kerberos Renewal Age:                   7 days
                           Kerberos KDC Timeout:                   3 seconds
                            Is Signing Required:               false
                Is Password Complexity Required:                true
           Use start_tls for AD LDAP connection:               false
         (DEPRECATED)-Is AES Encryption Enabled:                true
                         LM Compatibility Level:  lm-ntlm-ntlmv2-krb
                     Is SMB Encryption Required:               false
                        Client Session Security:                seal
   (DEPRECATED)-SMB1 Enabled for DC Connections:               false
                SMB2 Enabled for DC Connections:      system-default
  LDAP Referral Enabled For AD LDAP connections:               false
               Use LDAPS for AD LDAP connection:               false
      Encryption is required for DC Connections:               false
   AES session key enabled for NetLogon channel:                true
    Try Channel Binding For AD LDAP Connections:                true
        Encryption Types Advertised to Kerberos:    aes-128, aes-256
```
Comando para modificar el LM Compatibility Level a **"kerberos Only"**
```
c1n1::> vserver cifs security modify -vserver SVM_CIFS -LM-compatibility-level krb
```
Otros comandos interesantesd eribados del security show
```
c1n1::> vserver cifs security modify -vserver SVM_CIFS -is-signing-required true

c1n1::> vserver cifs security modify -vserver SVM_CIFS -is-smb-encryption-required true

c1n1::> vserver cifs security modify -vserver SVM_CIFS -use-ldaps-for-ad-ldap true

c1n1::> vserver cifs security modify -vserver SVM_CIFS -use-start-tls-for-ad-ldap false

c1n1::> vserver cifs security modify -vserver SVM_CIFS -encryption-required-for-dc-connections true
```
- Ref: [ONTAP Requirements for CIFS Kerberos - NetApp Knowledge Base](https://kb.netapp.com/on-prem/ontap/da/NAS/NAS-KBs/ONTAP_Requirements_for_CIFS_Kerberos)
- Ref: [Enable or disable AES encryption for Kerberos-based communication (netapp.com)](https://docs.netapp.com/us-en/ontap/smb-admin/enable-disable-aes-encryption-kerberos-task.html)
- Ref: [How to set an SPN - NetApp Knowledge Base](https://kb.netapp.com/on-prem/ontap/da/NAS/NAS-KBs/How_to_set_an_SPN)
- Ref: [Solved: What authentication method does CIFS server use for CIFS clients? - NetApp Community](https://community.netapp.com/t5/ONTAP-Discussions/What-authentication-method-does-CIFS-server-use-for-CIFS-clients/td-p/158928)

# En Microsoft AD

Comando para verificar cual es el SPN asociado a que servicios del objeto NETAPP, en este caso esta agregado ofimatica pero es necesario vincular el netbios y fqdn name al SPN para que autentique kerberos.
Cuando hablamos de SPN name es el objeto computadora en active directory que recibe la cabina NetApp al momento de ingresarla al dominio.
```
PS C:\Users\hmaslowski> setspn -Q */netapp914
Checking domain DC=conteclab,DC=local
CN=NETAPP914,OU=servers,OU=barcelona,OU=conteclab,DC=conteclab,DC=local
        cifs/ofimatica
        cifs/ofimatica.conteclab.local
        host/192.168.77.216
        cifs/netapp914.conteclab.local
        HOST/netapp914.conteclab.local
        HOST/NETAPP914
```
Como agregar SPN adicionales
Con estos 2 registros el acceso por SMB puede ser de manera indistinta cualquiera de los 2 nombres
```
PS C:\Users\hmaslowski> setspn -s cifs/ofimatica.conteclab.local netapp914
PS C:\Users\hmaslowski> setspn -s cifs/ofimatica netapp914
```
De la misma manera se puede eliminar un SPN
```
PS C:\Users\hmaslowski> setspn -D host/192.168.77.216 netapp914
```
En las GPO de Domain Controller se define en la siguiente ruta se security los elemento de NTLM:\
- 1.Network security: Restrict NTLM: Audit incoming NTLM traffic = enable auditing for all accounts
- 2.Network security: Restrict NTLM: Audit NTLM authentication in this domain = Enable for domain accounts to domain servers
- 3.Network security: Restrict NTLM: Incoming NTLM traffic = Deny all accounts
- 4.Network security: Restrict NTLM: NTLM authentication in this domain = Deny for domain accounts
- 5.Network security: Restrict NTLM: Outgoing traffic to remote servers

### La estrategia inicial es activar la auditoria para ver en el visor de eventos que aplicaciones utilizan NTLM con el fin de convertirlas en autenticacion kerberos. 1 y 2.
### GPO 3, 4 y 5 una vez que no se presenten eventos nuevos de autenticacion NTLM.
### Tambien existe la opcion de autorizar excepciones a servers para autenticacion NTLM (no es recomendado).
