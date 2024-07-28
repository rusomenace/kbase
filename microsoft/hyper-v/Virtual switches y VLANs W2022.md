# 2022

La metodologia cambia en 2022, no es mas como en 2019 y no se pueden crear virtual switches asociados a interfaces de VLAN de un Team

## Metodologia

1. Obtenemos los datos de la interfaz a utilizar para crear el vSwitch
```
get-vmnetworkadapter -management os
```
2. Creamos un vSwitch asociado a la interfaz que queremos utilizar, en este caso ```"Ethernet 5"```
```
New-VMSwitch -Name "vSwitch VLANs" -NetWorkAdapterName "Ethernet 5" -AllowManagementOS $True
```
3. Creamos las interfaces por PS para cada VLAN
```
Add-VMNetworkAdapter -ManagementOS -Name "VLAN 3" -SwitchName "vSwitch VLANs"
Set-VMNetworkAdapter -VMNetworkAdapterName "VLAN 3" -vlanid 3 -Access -ManagementOS
```
4. Los anteriores comandos se tienen que repetir para todas las VLANS
5. Para habilitar la VLAN en una maquina virtual se debe elegir el "vSwitch VLANs" y manualmente agregar el TAG de la VLAN a utilizar

Ref: https://www.youtube.com/watch?v=aL-dcWS6EhM