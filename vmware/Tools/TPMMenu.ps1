function Check-VirtualTPM {
    param (
        [string]$status = "All"
    )

    # Get all VMs (replace with your vCenter server details)
    $vms = Get-VM -Server vcenter.inke.local | Where-Object { $_.Name -notlike "vcls*" }

    foreach ($vm in $vms) {
        $vmName = $vm.Name
        $vtpmStatus = $vm.ExtensionData.Config.Hardware.Device | Where-Object { $_.DeviceInfo.Label -eq "Virtual TPM" }

        if ($status -eq "All" -or ($status -eq "Enabled" -and $vtpmStatus) -or ($status -eq "Disabled" -and -not $vtpmStatus)) {
            $statusText = if ($vtpmStatus) { "enabled" } else { "disabled" }
            $statusColor = if ($vtpmStatus) { "Green" } else { "Red" }

            Write-Host -ForegroundColor $statusColor "Virtual TPM is $statusText on $vmName."
        }
    }
}

do {
    # Display menu
    Write-Host "Menu:"
    Write-Host "1. All TPM"
    Write-Host "2. Enable TPM Devices"
    Write-Host "3. Disable TPM Devices"
    Write-Host "4. Exit"

    # Prompt user for choice
    $choice = Read-Host "Select an option"

    # Process user choice
    switch ($choice) {
        "1" { Check-VirtualTPM -status "All" }
        "2" { Check-VirtualTPM -status "Enabled" }
        "3" { Check-VirtualTPM -status "Disabled" }
    }

} while ($choice -ne "4")
