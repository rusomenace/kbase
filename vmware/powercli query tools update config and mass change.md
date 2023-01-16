### Obtiene una lista de computadoras y estado de sus tools pero hay que aclarar el folder en el que residen (Remote Desktops)
```
Get-Folder -name "Remote Desktops" | Get-VM | % { get-view $_.id } | select name, @{Name="ToolsVersion"; Expression={$_.config.tools.toolsversion}}, @{ Name="ToolStatus"; Expression={$_.Guest.ToolsVersionStatus}}|Sort-Object Name

Get-Folder -name "Remote Desktops" | Get-VM | % { get-view $_.id } |Where-Object {$_.Guest.ToolsVersionStatus -like "guestToolsNeedUpgrade"} |select name, @{Name=“ToolsVersion”; Expression={$_.config.tools.toolsversion}}, @{ Name=“ToolStatus”; Expression={$_.Guest.ToolsVersionStatus}}| Sort-Object Name
 
Get-Folder "Remote Desktops"|Get-VM|Get-View | select name,@{N='ToolsUpgradePolicy';E={$_.Config.Tools.ToolsUpgradePolicy } } |Sort Name
  
Get-Folder "Remote Desktops"|Get-VM|Get-View | select name,@{N='ToolsUpgradePolicy';E={$_.Config.Tools.ToolsUpgradePolicy } } |Sort Name
```
##
```
$folderSelection = Read-Host -Prompt 'Input your VMs folder'
$ManualUpdateVMs = Get-Folder $folderSelection|Get-VM|Get-View | Where-Object {$_.Config.Tools.ToolsUpgradePolicy -like "manual"}|select name,@{N='ToolsUpgradePolicy';E={$_.Config.Tools.ToolsUpgradePolicy } }

Foreach ($VM in ($ManualUpdateVMs)) {
$VMConfig = Get-View -VIObject $VM.Name
$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
$vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo
$vmConfigSpec.Tools.ToolsUpgradePolicy = "UpgradeAtPowerCycle"
$VMConfig.ReconfigVM($vmConfigSpec)
}

Get-Folder "MS Windows"|Get-VM|Get-View | select name,@{N='ToolsUpgradePolicy';E={$_.Config.Tools.ToolsUpgradePolicy } } |Sort Name
```
**Source:** https://www.starwindsoftware.com/blog/how-to-automate-the-upgrade-of-vmware-tools-and-vm-compatibility