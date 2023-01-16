Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Restarting docker"
 
foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Running"}))
{
    $svc | Stop-Service -ErrorAction Continue -Confirm:$false -Force
    $svc.WaitForStatus('Stopped','00:00:20')
}
 
Get-Process | Where-Object {$_.Name -ilike "*docker*"} | Stop-Process -ErrorAction Continue -Confirm:$false -Force
 
foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Stopped"} ))
{
    $svc | Start-Service
    $svc.WaitForStatus('Running','00:00:20')
}

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker restarted"

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Restarting docker"
 
foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Running"}))
{
    $svc | Stop-Service -ErrorAction Continue -Confirm:$false -Force
    $svc.WaitForStatus('Stopped','00:00:20')
}
 
Get-Process | Where-Object {$_.Name -ilike "*docker*"} | Stop-Process -ErrorAction Continue -Confirm:$false -Force
 
foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Stopped"} ))
{
    $svc | Start-Service
    $svc.WaitForStatus('Running','00:00:20')
}

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker restarted"
