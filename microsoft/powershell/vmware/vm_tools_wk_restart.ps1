#rem Connect-VIServer  TQARVCENTER.tq.com.ar
$Service = "VMtools"
$VMs = Get-VM | Where-Object {
        $_.PowerState -eq "PoweredON" `
        -and `
        $_.Name -match "TQARWS"
    }
    
foreach($VM in $VMs)
{
#    Write-Host "-------------------------------------------"
    Write-Host "Restarting the VMware Tools Service on" $VM
        $Svc = Get-WmiObject -Computer $VM win32_service `
        -filter "name='$Service'"
 #rem           $Result = $Svc.StopService()
 #rem           sleep 5
            $Result = $Svc.StartService()
#    Write-Host "Done.. "
#    Write-Host "-------------------------------------------"
}
#rem Disconnect-VIServer -Confirm:$false