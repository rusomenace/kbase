## Instalacion
```

```
## Iniciar el servicio definir que autoarrance
```
systemctl enable snmpd.service
systemctl start snmpd.service
```
## Configurar opciones de snmpd
```
nano /etc/snmp/snmpd.conf
```
Agregar lo siguiente
```
#com2sec notConfigUser  default       public
rocommunity public 10.1.1.33
```
