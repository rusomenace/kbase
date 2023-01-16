## Desde VCenter
```
Get-VM remotesupport | select *

Get-VM -Name tqarwsw7* | Set-VM -NumCpu "1" -CoresPerSocket "1" -Confirm:$false
Get-VM -Name tqarwsw10* | Set-VM -NumCpu "3" -CoresPerSocket "3" -Confirm:$false

Get-VM -Name tqarwsw7* | Set-VM -MemoryGB 3 -Confirm:$false
Get-VM -Name tqarwsw10* | Set-VM -MemoryGB 6 -Confirm:$false
```
## Post cambio de CPU y RAM se debe correr este comando para normalizar los shares si no sigue tomando la config anterior
```
Get-VM tqarwsw7* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuSharesLevel "normal"
Get-VM tqarwsw7* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemSharesLevel "normal"

Get-VM tqarwsw10* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuSharesLevel "normal"
Get-VM tqarwsw10* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemSharesLevel "normal"
```
## PS Apagado y encendido por tipo
```
Get-VM -Name tqarwsw10* | Shutdown-VM -Confirm:$false
Get-VM -Name tqarwsw7* | Shutdown-VM -Confirm:$false

Get-VM -Name tqarwsw10* | Start-VM -Confirm:$false
Get-VM -Name tqarwsw7* | Start-VM -Confirm:$false
```
### Server Mods
**3x8**
- EPO
- FS01
- TS01
- DEMO01
- MON01

**3x6**
- todos

**3x12**
- SQLs

**1x1**
- 2003s

```
Get-VM -Name tqarsvw2k3* | Set-VM -NumCpu "1" -CoresPerSocket "1" -Confirm:$false
Get-VM -Name tqarsvw2k3* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuSharesLevel "normal"
Get-VM -Name tqarsvw2k3* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemSharesLevel "normal"

Get-VM -Name tqarsvw12* | Set-VM -NumCpu "3" -CoresPerSocket "3" -Confirm:$false
Get-VM -Name tqarsvw12* | Set-VM -MemoryGB 6 -Confirm:$false
Get-VM -Name tqarsvw12* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuSharesLevel "normal"
Get-VM -Name tqarsvw12* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemSharesLevel "normal"

Get-VM -Name tqarsvw16* | Set-VM -NumCpu "3" -CoresPerSocket "3" -Confirm:$false
Get-VM -Name tqarsvw16* | Set-VM -MemoryGB 6 -Confirm:$false
Get-VM -Name tqarsvw16epo01 | Set-VM -MemoryGB 8 -Confirm:$false
Get-VM -Name tqarsvw16mon01 | Set-VM -MemoryGB 8 -Confirm:$false
Get-VM -Name tqarsvw16fs01 | Set-VM -MemoryGB 8 -Confirm:$false
Get-VM -Name tqarsvw16ts01 | Set-VM -MemoryGB 8 -Confirm:$false
Get-VM -Name tqarsvw16demo01 | Set-VM -MemoryGB 8 -Confirm:$false
Get-VM -Name tqarsvw16sql* | Set-VM -MemoryGB 16 -Confirm:$false
Get-VM -Name tqarsvw16* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuSharesLevel "normal"
Get-VM -Name tqarsvw16* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemSharesLevel "normal"

Get-VM -Name tqarsvw19* | Set-VM -NumCpu "3" -CoresPerSocket "3" -Confirm:$false
Get-VM -Name tqarsvw19* | Set-VM -MemoryGB 6 -Confirm:$false
Get-VM -Name tqarsvw19sql* | Set-VM -MemoryGB 16 -Confirm:$false
Get-VM -Name tqarsvw19* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuSharesLevel "normal"
Get-VM -Name tqarsvw19* | Get-VMResourceConfiguration | Set-VMResourceConfiguration -MemSharesLevel "normal"
```