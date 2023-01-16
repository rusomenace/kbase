# Date 22.04.2021
# Source
# https://blogs.vmware.com/vsphere/2018/09/automating-upgrade-of-vmware-tools-and-vmware-compatibility.html
# ---------------------------------------------------------------------------------------------------------------------
# folderSelection pide el nombre de la carpeta donde residen las VMs en vcenter
# El resto del script despliega la configuracion de actualizacion de VMWare Tools de cada VM, los valores posibles son:
# -manual
# -upgradeAtPowerCycle

$folderSelect = Read-Host -Prompt 'Input your VMs folder'
Get-Folder $folderSelect|Get-VM|Get-View | select name,@{N='ToolsUpgradePolicy';E={$_.Config.Tools.ToolsUpgradePolicy } } |Sort Name