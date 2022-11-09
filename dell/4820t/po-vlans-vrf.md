# Port Channels
```
MKROSW#show running-config interface port-channel 1
!
interface Port-channel 1
 description mkrovm18
 no ip address
 mtu 9000
 switchport
 no spanning-tree
 channel-member TenGigabitEthernet 0/18
 channel-member TenGigabitEthernet 1/18
 no shutdown
 ```
 ```
MKROSW#show running-config interface port-channel 2
!
interface Port-channel 2
 description bgp
 no ip address
 switchport
 no spanning-tree
 channel-member TenGigabitEthernet 0/47
 channel-member TenGigabitEthernet 1/47
 no shutdown
 ```
 ```
MKROSW#show running-config interface port-channel 3
!
interface Port-channel 3
 description fortigate
 no ip address
 switchport
 no spanning-tree
 channel-member TenGigabitEthernet 0/46
 channel-member TenGigabitEthernet 1/46
 no shutdown
```
# Elementos pertenecientes a bgp y fortigate
```
MKROSW#sh interfaces description | grep bgp
TenGigabitEthernet 0/47       NO  up         down        port-channel_2-bgp
TenGigabitEthernet 1/47       NO  up         down        port-channel_2-bgp
Port-channel 2                NO  up         down        bgp
Vlan 393                      NO  up         down        bgp
MKROSW#sh interfaces description | grep fortigate
TenGigabitEthernet 0/46       NO  up         down        port-channel_3-fortigate
TenGigabitEthernet 1/46       NO  up         down        port-channel_3-fortigate
Port-channel 3                NO  up         down        fortigate
```
# VLANs
```
MKROSW#show vlan

Codes: * - Default VLAN, G - GVRP VLANs, R - Remote Port Mirroring VLANs, P - Primary, C - Community, I - Isolated
       O - Openflow, Vx - Vxlan
Q: U - Untagged, T - Tagged
   x - Dot1x untagged, X - Dot1x tagged
   o - OpenFlow untagged, O - OpenFlow tagged
   G - GVRP tagged, M - Vlan-stack, H - VSN tagged
   i - Internal untagged, I - Internal tagged, v - VLT untagged, V - VLT tagged

    NUM    Status    Description                     Q Ports
*   1      Inactive                                  U Po3(Te 0/46,Te 1/46)
                                                     U Te 0/2
    2      Active    mkro                            T Po1(Te 0/18,Te 1/18)
                                                     U Te 0/1
    44     Inactive  mkro_management                 T Po1(Te 0/18,Te 1/18)
    254    Inactive  mkro_vmotion
    393    Inactive  bgp 
```
# VRF
```
MKROSW#show ip vrf
VRF-Name                         VRF-ID Interfaces
default                          0       Te 0/0,3-17,19-45,
                                          Fo 0/48,56,
                                          Te 1/0-17,19-45,
                                          Fo 1/48,56,
                                          Ma 0/0,
                                          Ma 1/0,
                                          Nu 0,
                                          Vl 1-2,44,254
bgp                              1       Vl 393
```
