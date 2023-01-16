## Regeneracion de certificados
El siguiente procedimiento se aplica generalmente cuando los certificados caducan.
En el caso de esto pase lo mas conveniente es ingresar a los almacenes de certificados de raiz de confianza en todas las computadoras con Windows que lo tengan instalado y eliminarlo.

## VCenter
Ingresar a vcenter por ssh -> shell y navegar hasta la siguiente ruta:
```/usr/lib/vmware-vmca/bin/```

Ejecutar el script **certificate-manager**
Del menu elegir la opcion **8 (Reset all certificates)**
Dejar que el script corra y aplique todos los certificados

El siguiente es un extracto de la ejecuccion de la herramienta:

```
Type the administrator@vsphere.local password when prompted.
If this is the first time VMCA certificates are re-generated on this system, you are asked to configure the certool.cfg. On subsequent tasks, you are offered to re-use these values.

Note: These values are used to define certificates issued by VMCA.

Enter these values as prompted by the VMCA (See Step 5 to confirm the Name/Hostname/VMCA):

Please configure certool.cfg file with proper values before proceeding to next step.
Press Enter key to skip optional parameters or use Default value.
Enter proper value for 'Country' [Default value : US] : (Note: Value for Country should be only 2 letters)
Enter proper value for 'Name' [Default value : CA] :
Enter proper value for 'Organization' [Default value : VMware] :
Enter proper value for 'OrgUnit' [Default value : VMware Engineering] :
Enter proper value for 'State' [Default value : California] :
Enter proper value for 'Locality' [Default value : Palo Alto] :
Enter proper value for 'IPAddress' [optional] :
Enter proper value for 'Email' [Default value : email@acme.com] :
Enter proper value for 'Hostname' [Enter valid Fully Qualified Domain Name(FQDN), For Example : example.domain.com] :
Enter proper value for VMCA 'Name': (Note: This information will be requested from vCenter Server 6.0 U3, 6.5 and later builds, you may use the FQDN/PNID of vCenter Server for this field. It will be used as a Common Name for the VMCA Root Certificate)
 
Type Yes (Y) to the confirmation request to proceed.

You are going to regenerate Root Certificate and all other certificates using VMCA
Continue operation : Option[Y/N] ? : Y
```

**Note: The Name, Hostname and VMCA values should match the PNID of the Node where you are replacing the Certificates. PNID should always match the Hostname. In order to obtain the PNID please run these commands:
For vCenter Server Appliance (VCSA)
En el punto anterior se hace referencia al hostname fqdn (tqarvcenter.tq.com.ar)**

```/usr/lib/vmware-vmafd/bin/vmafd-cli get-pnid --server-name localhost```
