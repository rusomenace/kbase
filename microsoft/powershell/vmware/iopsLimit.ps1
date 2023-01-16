foreach($group in (Import-Csv C:\tools\vmware\vmiopslimit.csv -UseCulture | Group-Object -Property vmName)){
  $vm = Get-VM -Name $group.Name
  $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
  $vm.ExtensionData.Config.Hardware.Device |  where {$_ -is [VMware.Vim.VirtualDisk]} | %{
    $dev = New-Object VMware.Vim.VirtualDeviceConfigSpec
    $dev.Operation = "edit"
    $dev.Device = $_
    $label = $_.DeviceInfo.Label
    $dev.Device.StorageIOAllocation.Limit = $group.Group | where {$_.Harddisk -eq $label} | Select -ExpandProperty IOPSLimit
    $spec.DeviceChange += $dev
  }
  $vm.ExtensionData.ReconfigVM_Task($spec)
}