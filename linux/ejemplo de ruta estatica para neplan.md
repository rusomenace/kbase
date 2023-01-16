## This is the network config written by 'subiquity'
```
network:
  ethernets:
    enp0s3:
      dhcp4: false
      addresses: [192.168.1.100/24]
      gateway4: 192.168.1.1
      nameservers:
              addresses: [8.8.8.8]
      routes:
        - to: 192.168.2.0/24
          via: 192.168.1.100
          metric: 100
        - to: 192.168.10.100
          via: 192.168.1.100
          metric: 100
  version: 2
```