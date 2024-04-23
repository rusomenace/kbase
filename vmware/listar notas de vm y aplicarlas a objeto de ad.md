# Connect to your vCenter Server or ESXi host
Connect-VIServer -Server Your-vCenter-Server

# Replace 'Your-VM-Name' with the name of your VM
$vmName = "Your-VM-Name"

# Retrieve VM notes
$vm = Get-VM -Name $vmName
$vmNotes = $vm.Notes

# Disconnect from vCenter Server or ESXi host
Disconnect-VIServer -Server Your-vCenter-Server -Confirm:$false

# Connect to Active Directory
Import-Module ActiveDirectory

# Retrieve computer object from Active Directory using the same name as the VM
$adComputer = Get-ADComputer -Identity $vmName

if ($adComputer -ne $null) {
    # Set the description of the computer object to the VM's notes
    Set-ADComputer -Identity $vmName -Description $vmNotes
    Write-Host "Description updated for computer object: $vmName"
} else {
    Write-Host "Computer object not found in Active Directory."
}
