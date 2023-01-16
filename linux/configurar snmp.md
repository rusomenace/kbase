# Instalacion y configuracion de snmpd

## Instalacion
```
sudo apt-get update
sudo apt-get install snmpd
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

Configurar el servicio para inicio con booteo y reiniciarlo para que rome los cambios
```
sudo systemctl enable snmpd
sudo systemctl restart snmpd
sudo systemctl status snmpd
```

## Permitir puertos SNMP en el firewall
Ejecute los siguientes comandos para permitir los puertos necesarios:
```
ufw allow 161/udp
ufw allow 162/udp
```