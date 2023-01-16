#$vmName = 'labsv01'
#$vm = Get-VM -Name $vmName
$vm = Get-VM -Name *
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.CpuHotAddEnabled = $false
$spec.MemoryHotAddEnabled = $false
$vm.ExtensionData.ReconfigVM($spec)