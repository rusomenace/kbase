# Date 22.04.2021
# Source
# https://blogs.vmware.com/vsphere/2018/09/automating-upgrade-of-vmware-tools-and-vmware-compatibility.html
# ---------------------------------------------------------------------------------------------------------------------------
# folderSelection pide el nombre de la carpeta donde residen las VMs en vcenter
# El resto del script busca en esas VMs cual de ellas tiene la actualizacion de las Tools en manual y las cambia a automatico

$folderSelection = Read-Host -Prompt 'Input your VMs folder'
$ManualUpdateVMs = Get-Folder $folderSelection|Get-VM|Get-View | Where-Object {$_.Config.Tools.ToolsUpgradePolicy -like "manual"}|select name,@{N='ToolsUpgradePolicy';E={$_.Config.Tools.ToolsUpgradePolicy } }

Foreach ($VM in ($ManualUpdateVMs)) {
$VMConfig = Get-View -VIObject $VM.Name
$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
$vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo
$vmConfigSpec.Tools.ToolsUpgradePolicy = "UpgradeAtPowerCycle"
$VMConfig.ReconfigVM($vmConfigSpec)
}