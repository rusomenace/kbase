## Cambiar de portgroupp
```
$newnet = "DvPG-VL27"
Get-VM merlin | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $newnet -Confirm:$false
```
## Consultar resultado
```
Get-NetworkAdapter -VM MERLIN
```
