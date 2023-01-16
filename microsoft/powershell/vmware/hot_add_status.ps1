$computerName = read-host "VM Name"
Get-VM $computerName | Get-View | Select Name, `
@{N="CpuHotAddEnabled";E={$_.Config.CpuHotAddEnabled}}, `
@{N="CpuHotRemoveEnabled";E={$_.Config.CpuHotRemoveEnabled}}, `
@{N="MemoryHotAddEnabled";E={$_.Config.MemoryHotAddEnabled}}
