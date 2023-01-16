## Ejemplo con puerto 1/0/48
```
interface GigabitEthernet 1/0/48
description Avaya-BTU-Users
no ip address
portmode hybrid
switchport
power inline auto
service-class dynamic dot1p
no shutdown
```