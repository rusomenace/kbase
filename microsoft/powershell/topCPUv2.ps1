$server = Read-Host "Introduce el nombre del servidor"
$session = New-PSSession -ComputerName $server
Invoke-Command -Session $session -ScriptBlock {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 |
        Format-Table -Property ID, ProcessName, CPU
}
$choice = Read-Host "Seleccione el ID del proceso que desea detener (escriba 's' para detener el script sin detener ningún proceso)"
if ($choice -eq "s") {
    Write-Host "Saliendo sin detener ningun proceso"
    return
}
Invoke-Command -Session $session -ScriptBlock {
    Stop-Process -Id $using:choice -Force
}
Remove-PSSession -Session $session
