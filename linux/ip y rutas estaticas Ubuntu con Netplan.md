# Como establecer IP estatica o agregar rutas estaticas en Ubuntu 22.04 utilizando netplan

Listar las rutas estaticas que tenemos actualmente y documentarlas en caso de tener que volver a la configuración original:
```
ip route s
```

Editar el netplan

```
sudo nano /etc/netplan/00-installer-config.yaml
```

Agregar las lineas correspondientes a la ruta estatica especifica y mantener la ruta por default (si asi se desea)
routes:
```
- to: 10.1.1.0/24
via: 192.168.101.250
```

Aplicar el netplan

```
sudo netplan apply
```