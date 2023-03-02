## Habilitar en automatico y encender servicio Windows Remote Management WinRM

Conectarse por PS ```Enter-PSSession -Computername TQARWSW1035.TQ.COM.AR```

### Salir de la sesion remota
```Exit-PSSession```

## Via PSexec

```.\PsExec.exe \\REPLACE_MACHINENAME -i -s -u replace_user powershell ```

### Habilitar WINRM si no funciona Enter-PSSession

```winrm quickconfig```

o

```Enable-PSRemoting```

## Como detener un proceso

```Stop-Process -Name NombreDelProceso```


## Como ver Top 5 procesos que consumen mayor CPU
```Get-Process | Sort-Object CPU -Descending | Select-Object -First 5```
