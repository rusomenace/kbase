## Ejemplo Port-Channel S4810

***PO5***
```
DC_S4810_01(conf-if-po-5)#switchport
DC_S4810_01(conf-if-po-5)#mtu 12000
```

***TenG 0/36***
```
DC_S4810_01(conf-if-te-0/36-lacp)#int ten 0/36
DC_S4810_01(conf-if-te-0/36)#mtu 12000
DC_S4810_01(conf-if-te-0/36)#port-channel-protocol lacp
DC_S4810_01(conf-if-te-0/36-lacp)#port-channel 5 mode active
```

***TenG 1/36***
```
DC_S4810_01(conf-if-te-0/36-lacp)#int ten 1/36
DC_S4810_01(conf-if-te-1/36)#mtu 12000
DC_S4810_01(conf-if-te-1/36)#port-channel-protocol lacp
DC_S4810_01(conf-if-te-1/36-lacp)#port-channel 5 mode active
```

***VLAN Range***
```
DC_S4810_01(conf-if-po-5)#interface range vlan 2 - 10
DC_S4810_01(conf-if-range-vl-2-10)#tagged po5
```
***Borrar Port-Channel***
```
DC_S4810_01(conf-if)#no po5
```
***Spanning Tree en el nuevo switch***
```
protocol spanning-tre rstp
no disable
```
