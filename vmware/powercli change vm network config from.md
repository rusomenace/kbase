Cambio de interfaces en virtuales

### Listar distributed port groups
```
Get-VDPortGroup
```
### Listar la insterfase de la maquina virtual
```
Get-VM -Name vlantest | Get-NetworkAdapter
```
### Cambiar la asociacion de red
```
Get-VM -Name vlantest | Get-NetworkAdapter | Set-NetworkAdapter -PortGroup DvPG-VLAN27 -Confirm:$false
```
### Cambio masivo con wildcards
```
Get-VM -Name lab* | Get-NetworkAdapter | Set-NetworkAdapter -PortGroup DvPG-VLAN4000 -Confirm:$false
```