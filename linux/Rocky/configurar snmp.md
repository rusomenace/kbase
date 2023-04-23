# SNMP
```
dnf update
dnf install net-snmp net-snmp-libs net-snmp-utils
systemctl enable --now snmpd
systemctl status snmpd
```
## Para habilitar el servicio con inicio de OS
```
systemctl enable snmpd
```
## Editar la configuracion
```
nano /etc/snmp/snmpd.conf
```

Establezca la cadena comunitaria de solo lectura SNMP v1 como 'pública' agregando la línea
```
rocommunity public
```

agentAddress udp es la dirección IP desde la cual el servidor aceptará las solicitudes SNMP. Por lo tanto, descomentar la línea y cambiar el valor de 127.0.0.1 por la ip del equipo
```
agentaddress  udp:10.1.1.1:161
```

Comentar para deshabilitar las siguientes 2 entradas
```
#rocommunity  public default -V systemonly
#rocommunity6 public default -V systemonly
```

Ajustar la comunidad segun corresponda y declarar la IP del servidor de logs destino
```
rocommunity public 10.1.1.33
```
El siguiente comando agrega la comunidad directamente en el archivo de configuracion
```
echo -e "# SNMP version 2c community\nrocommunity public 10.1.1.33" >> /etc/snmp/snmpd.conf
```
