Ejemplo de IP estatica 2 Bonds LACP: lacp-lan y lacp-iscsi

```
# This is the network config written by 'subiquity'
network:
  bonds:
    lacp-iscsi:
      addresses:
      - 10.210.251.11/24
      interfaces:
      - eno3
      - ens2f1np1
      nameservers:
        addresses: []
        search: []
      parameters:
        lacp-rate: slow
        mode: 802.3ad
        transmit-hash-policy: layer2
    lacp-lan:
      addresses:
      - 10.210.150.30/24
      interfaces:
      - eno4
      - ens2f0np0
      nameservers:
        addresses:
        - 1.1.1.2
        - 1.0.0.2
        search: []
      parameters:
        lacp-rate: slow
        mode: 802.3ad
        transmit-hash-policy: layer2
      routes:
      - to: default
        via: 10.210.150.1
  ethernets:
    eno3: {}
    eno4: {}
    ens2f0np0: {}
    ens2f1np1: {}
  version: 2
```