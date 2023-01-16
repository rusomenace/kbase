# Menu de seleccion para nodo
Function Get-ProjectType {
    $type=Read-Host "
    Database

    1 - TQ VCenter
    2 - Esxi1
    3 - Esxi2
    4 - Esxi3
    5 - Esxi4
    6 - Esxi6
    7 - Esxi7
    8 - Esxi8
    9 - MKRO VCenter
    
    Ingresar opcion"
    Switch ($type){
        1 {$choice="Connect-VIServer -Server tqarvcenter.tq.com.ar -Protocol https -User administrator@vsphere.local -Password SKYfall1977.."}
        2 {$choice="Connect-VIServer -Server tqarhpvesxi01.tq.com.ar -Protocol https -User root -Password MoltenCore60"}
        3 {$choice="Connect-VIServer -Server tqarhpvesxi02.tq.com.ar -Protocol https -User root -Password MoltenCore60"}
        4 {$choice="Connect-VIServer -Server tqarhpvesxi03.tq.com.ar -Protocol https -User root -Password MoltenCore60"}
        5 {$choice="Connect-VIServer -Server tqarhpvesxi04.tq.com.ar -Protocol https -User root -Password MoltenCore60"}
        6 {$choice="Connect-VIServer -Server tqarhpvesxi06.tq.com.ar -Protocol https -User root -Password MoltenCore60"}
        7 {$choice="Connect-VIServer -Server tqarhpvesxi07.tq.com.ar -Protocol https -User root -Password MoltenCore60"}
        8 {$choice="Connect-VIServer -Server tqarhpvesxi08.tq.com.ar -Protocol https -User root -Password MoltenCore60"}
        9 {$choice="Connect-VIServer -Server mkrovcenter01.mkro.local -Protocol https -User administrator@vsphere.local -Password SKYfall10.11.10"}
    }
    return $choice
}
$sentence=Get-ProjectType
# End
Invoke-Expression $sentence