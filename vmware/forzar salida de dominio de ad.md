First, checking the status from CLI:
```
root@vcsa-1 [ ~ ]# /opt/likewise/bin/domainjoin-cli query
Error: LW_ERROR_KRB5KDC_ERR_C_PRINCIPAL_UNKNOWN [code 0x0000a309]
Client not found in Kerberos database
```
Erroneous once more. Trigger a the domain leave:
```
root@vcsa-1 [ ~ ]# /opt/likewise/bin/domainjoin-cli leave
Leaving AD Domain:   VRACCOON.LAB
SUCCESS
root@vcsa-1 [ ~ ]#
```
Now, I had only to reboot the vCenter. Afterwards, the domain was gone.