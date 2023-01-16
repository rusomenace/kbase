
$vm = read-host "Input Virtual Machine Name"
get-vm $vm | New-AdvancedSetting -Name isolation.tools.paste.disable -Value FALSE -Confirm:$false
get-vm $vm | New-AdvancedSetting -Name isolation.tools.copy.disable -Value FALSE -Confirm:$false