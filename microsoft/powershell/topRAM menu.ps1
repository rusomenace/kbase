$server = Read-Host "Introduce el nombre del servidor"
$session = New-PSSession -ComputerName $server
Invoke-Command -Session $session -ScriptBlock {
    Get-Process | Sort-Object WS -Descending | Select-Object -First 5 |
        Format-Table -Property ID, ProcessName, WS
}
$choice = Read-Host "Seleccione el ID del proceso que desea detener"
Invoke-Command -Session $session -ScriptBlock {
    Stop-Process -Id $using:choice -Force
}
Remove-PSSession -Session $session