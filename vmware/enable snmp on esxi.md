### Enable SNMP on ESXi 5.1 over SSH
```
esxcli system snmp set -c public
esxcli system snmp set -l warning
esxcli system snmp set -e yes
```
### Enable SNMP on ESXi 5.0 over PowerCLI
```
vicfg-snmp.pl --server 192.168.0.5 -c Public -p 161 -t 192.168.0.8@161/public
```
### Enable SNMP in VMWare
```
esxcli system snmp set --communities public
esxcli system snmp set --targets 10.1.1.33@162/public
esxcli system snmp set --enable true
esxcli system snmp test
esxcli system snmp get
```
### Multiples destinos
```
esxcli system snmp set --targets 192.168.0.8@162/public,192.168.0.62@162/public
```