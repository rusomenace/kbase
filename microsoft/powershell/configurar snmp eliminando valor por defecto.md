## Windows

### Agrega todos los features de SNMP
```
Get-WindowsFeature -name SNMP* | Add-WindowsFeature -IncludeManagementTools | Out-Null
```

### Agrega una comunidad de read only
```
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v $string /t REG_DWORD /d 4 /f | Out-Null
```

### Borra el localhost como defecto
```
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v 1 /f
```

### Agrega una ip como manager
```
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v 1 /t REG_SZ /d 192.168.101.2 /f | Out-Null
```

### Powershell script to run
```
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v public /t REG_DWORD /d 4 /f | Out-Null
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v 1 /t REG_SZ /d 10.1.1.33 /f | Out-Null
```

