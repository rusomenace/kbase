Se puede ejecutar el siguiente comando de manera local o en ps session
```
While(1) {ps | sort -des cpu | select -f 15 | ft -a; sleep 1; cls}
```