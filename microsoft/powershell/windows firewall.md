***Ref:*** http://woshub.com/manage-windows-firewall-powershell/


### Enable disable rules
```
Show-NetFirewallRule | where {$_.enabled -eq 'true' -AND $_.direction -eq 'inbound'} | Enable-NetFirewallRule
Show-NetFirewallRule | where {$_.enabled -eq 'true' -AND $_.direction -eq 'inbound'} | Disable-NetFirewallRule
```

### Profile enable disable
```
netsh advfirewall set allprofiles state off
netsh advfirewall set allprofiles state on
```

### Listar regla por display name
```
Get-NetFirewallRule -DisplayName '*sshd*'
```

### Habilitar regla consultando el nombre
```
Get-NetFirewallRule -DisplayName '*sshd*' | Enable-NetFirewallRule
```

### Habilita una IP para ingreso total
```
New-NetFirewallRule -Name Allow10.1.1.97 -DisplayName 'Allow from 10.1.1.97' -Enabled True -Direction Inbound -Protocol ANY -Action Allow -Profile ANY -RemoteAddress 10.1.1.97
```

### Habilitar especificamente un puerto para ingreso
```
New-NetFirewallRule -Name AllowNGinx7000 -DisplayName 'Allow from NGinx 7001' -Enabled True -Direction Inbound -Protocol TCP -LocalPort 7001 -Action Allow -Profile ANY -RemoteAddress 10.1.1.94
```

