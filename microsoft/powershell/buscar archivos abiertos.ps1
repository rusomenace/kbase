$file = read-host "Nombre del archivo"
# Menu de seleccion para nodo
Function Get-ProjectType {
    $type=Read-Host "
    Database

    1 - Buscar archivo
    2 - Forcar cierre de un archivo
    
    Ingresar opcion"
    Switch ($type){
        1 {$choice="Get-SmbOpenFile | Where-Object -Property ShareRelativePath -Match $file"}
        2 {$choice="Get-SmbOpenFile | Where-Object -Property ShareRelativePath -Match $file | Close-SmbOpenFile"}        
    }
    return $choice
}
$sentence=Get-ProjectType
# End
Invoke-Expression $sentence