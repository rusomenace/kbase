""
""
Write-Host "== Menu de Lucho==" -ForegroundColor DarkCyan
$menu=@"
1 Sesion Powershell Remota
2 Opcion 1 ping 8.8.4.4

Q Quit
Select a task by number or Q to quit
"@
""
do
{
""
$r = Read-Host $menu

Switch ($r) {
"1"
{
$server = Read-Host "Introduce el nombre del servidor"
$session = New-PSSession -ComputerName $server

Function Show-Processes {
    Invoke-Command -Session $session -ScriptBlock {
        Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 |
            Format-Table -Property ID, ProcessName, CPU
    }
}

Show-Processes

Do {
    $choice = Read-Host "Seleccione el ID del proceso que desea detener (escriba 's' para salir el script sin detener ningún proceso, 'a' para actualizar la lista de procesos):"
    if ($choice -eq "s") {
        Write-Host "Script detenido sin detener ningún proceso"
        break
    }
    if ($choice -eq "a") {
        Show-Processes
        continue
    }
    Invoke-Command -Session $session -ScriptBlock {
        Stop-Process -Id $using:choice -Force
    }
} until ($choice -eq "s")

Remove-PSSession -Session $session
}

"2"
{
	ping 8.8.4.4
}

"Q" 
{
	Write-Host "Quitting" -ForegroundColor DarkCyan
    exit
}

default 
{
    Write-Host "I don't understand what you want to do, try again" -ForegroundColor DarkGreen
}
}
} #end switch

until ($selection -eq 'Q')