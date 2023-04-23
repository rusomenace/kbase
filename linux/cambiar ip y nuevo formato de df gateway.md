## Editar
```
sudo nano /etc/netplan/00-installer-config.yaml”
```
## Reemplazar
```
network:
  version: 2
#  renderer: NetworkManager # Este comando permite usar actualizaciones con cockpit, habilitar una vez CP este instalado
  ethernets:
    ens160:
      dhcp4: no
      addresses:
        - 192.168.101.7/24
      routes:
      - to: default
        via: 192.168.101.1
      nameservers:
          addresses: [192.168.101.249]
      routes:
      - to: 10.1.1.0/24
        via: 192.168.101.250
```

## Aplicar el plan
```
sudo netplan apply
```

## Alternativa: NMTUI (Network Manager Text User Interface)
```
nmtui
```