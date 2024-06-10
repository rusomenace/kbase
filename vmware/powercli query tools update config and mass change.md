### Obtiene una lista de computadoras y estado de sus tools pero hay que aclarar el folder en el que residen (Remote Desktops)
```
Get-Folder -name "Remote Desktops" | Get-VM | % { get-view $_.id } | select name, @{Name="ToolsVersion"; Expression={$_.config.tools.toolsversion}}, @{ Name="ToolStatus"; Expression={$_.Guest.ToolsVersionStatus}}|Sort-Object Name

Get-Folder -name "Remote Desktops" | Get-VM | % { get-view $_.id } |Where-Object {$_.Guest.ToolsVersionStatus -like "guestToolsNeedUpgrade"} |select name, @{Name=“ToolsVersion”; Expression={$_.config.tools.toolsversion}}, @{ Name=“ToolStatus”; Expression={$_.Guest.ToolsVersionStatus}}| Sort-Object Name
 
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

# V2

Obtengo una lista completa de estado version de todas las maquinas virtuales:
```
# Get all VMs and select the required properties
Get-VM | % { Get-View $_.id } | Select-Object Name, 
    @{Name="ToolsVersion"; Expression={$_.Config.Tools.ToolsVersion}}, 
    @{Name="ToolStatus"; Expression={$_.Guest.ToolsVersionStatus}}, 
    @{Name="ToolsUpgradePolicy"; Expression={$_.Config.Tools.ToolsUpgradePolicy}} | 
    Sort-Object Name
```
Modificar todas las VMs para que tengan auto update de Tools
```
# Get all VMs with manual tools upgrade policy
$ManualUpdateVMs = Get-VM | Get-View | Where-Object {$_.Config.Tools.ToolsUpgradePolicy -like "manual"} | Select-Object Name, @{N='ToolsUpgradePolicy';E={$_.Config.Tools.ToolsUpgradePolicy}}

# Loop through each VM and set the tools upgrade policy to UpgradeAtPowerCycle
foreach ($VM in $ManualUpdateVMs) {
    $VMConfig = Get-View -VIObject $VM
    $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $vmConfigSpec.Tools = New-Object VMware.Vim.ToolsConfigInfo
    $vmConfigSpec.Tools.ToolsUpgradePolicy = "UpgradeAtPowerCycle"
    $VMConfig.ReconfigVM($vmConfigSpec)
}

# Verify the changes by listing the VMs and their ToolsUpgradePolicy
Get-VM | Get-View | Select-Object Name, @{N='ToolsUpgradePolicy';E={$_.Config.Tools.ToolsUpgradePolicy}} | Sort-Object Name
```
