# Workaround para corregir problema de activacion de Office 365 en VM con Windows 10

## Problema
Office no se puede activar en la sesion del usuario en VM que corren Windows 10. Arroja mensaje que Office no está activado y no se puede activar.

Mensaje de error:
```
Microsoft Office Activation Wizard
Microsoft Office 365 Business
Activation Wizard
We couldn't contact the server. Please try again in a few minutes. ( 0x80072F8F )
```

## Workaround
Ingresar al [Forti 01](https://10.1.1.254:10443/ng/firewall/address)

Policy & Objects => Addresess

Dentro de *IP range/subnet* editar la direccion con el nombre: **"wildcard-vlan27"**

Reemplazar la direccion IP con la dirección de la VM. Esto permitirá la salida de internet directa para conectarse a la nube de Microsoft.

Realizar la activación de office desde la sesión del usuario y volver a poner la ip que estaba asignada originalmente. Estos son los valores con los que debe quedar una vez finalizado:
```
Name: wildcard-vlan27
IP/Netmask: 192.168.27.254 255.255.255.255
Interface: general (vlan27)
```