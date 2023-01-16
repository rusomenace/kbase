# Variable pregunta el host
$computerName = read-host "Computer Name"

# Menu de seleccion para cpu o memoria
Function Get-ProjectType {
    $type=Read-Host "
    Dispositivo

    1 - Cpu
    2 - Memoria
    
    Ingresar opcion"
    Switch ($type){
        1 {$choice="CpuHotAddEnabled"}
        2 {$choice="MemoryHotAddEnabled"}
    }
    return $choice
}
$resource=Get-ProjectType

# Menu de seleccion para habilitar o deshabilitar
Function Get-ProjectType {
    $type=Read-Host "
    Dispositivo

    1 - Enable
    2 - Disable
    
    Ingresar opcion"
    Switch ($type){
        1 {$choice=true}
        2 {$choice=false}
    }
    return $choice
}
$option=Get-ProjectType

# Ejecucion de seleccion
$vm = Get-VM -Name $computerName
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec."$($resource)" = "$($option)"
$vm.ExtensionData.ReconfigVM($spec)

# Chequea estado de equipo
Get-VM $computerName | Get-View | Select Name, `
@{N="CpuHotAddEnabled";E={$_.Config.CpuHotAddEnabled}}, `
@{N="MemoryHotAddEnabled";E={$_.Config.MemoryHotAddEnabled}}
