$remote_host = Read-Host "Introduzca el nombre del equipo al que desea conectarse"
$session = New-PSSession -ComputerName $remote_host
Invoke-Command -Session $session -ScriptBlock {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 |
        Format-Table -Property ID, ProcessName, CPU
}
$choice = Read-Host "Seleccione el ID del proceso que desea detener"
Invoke-Command -Session $session -ScriptBlock {
    Stop-Process -Id $using:choice -Force
}
Remove-PSSession -Session $session
