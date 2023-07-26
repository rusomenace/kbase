Se puede ejecutar el siguiente comando de manera local o en ps session
```
While(1) {ps | sort -des cpu | select -f 15 | ft -a; sleep 1; cls}
```
Este da los 10 que mas consumen
```
Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 Name, Id, @{Name="CPU (%)"; Expression={"{0:N1}" -f $_.CPU}} | Format-Table
```