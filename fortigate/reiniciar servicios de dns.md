## Reiniciar los servicios de DNS
```
diag test application dnsproxy 9
diag test application dnsproxy 5
diag test application dnsproxy 4
```

There is also another variant that can be used to test and query a specific url and follow the dns lookup request on the Fortigate, this can be done by enabling the following debug and the perfoming an ICMP test, in this example we use www.fortinet.com  :
```
diag debug application dnsproxy -1
```