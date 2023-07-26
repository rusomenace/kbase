# Fortigate Debug Command
## Diag Commands

To filter out VPNs so that you focus on the one VPN you are trying to troubleshoot
```
diagnose vpn ike log-filter 
```
Above you can see the different filtering criteria.  This allows you to filter a VPN to a destination of 2.2.2.2 as an example:
```
diagnose vpn ike log-filter dst-addr4 2.2.2.2
```
Now you can run the following commands
```
diag debug app ike -1 
diag debug enable
```


Ref: https://infosecmonkey.com/troubleshooting-ipsec-vpns-on-fortigate-firewalls/