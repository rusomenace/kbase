Until version 6.5 of VCSA, the operating system dispatched with the Appliance was SUSE, with VCSA 6.5 you get the new open source minimal Linux container host optimized, Photon OS.

With VCSA 6.5 embedded VUM there was the need to enable internet access to the appliance using a static route.

This was accomplished by running the command:

# route add -net <TargetNetwork> netmask <NetmaskAddress> gw <GatewayAddress> dev <interface>

e.g.:

# route add -net 192.168.0.0 netmask 255.255.0.0 gw 10.20.30.40 dev eth0

Note that after you add your route using the above command, it will not be persistent, this means if you reboot your VCSA the route will be deleted from the routing table.

To make the route persistent you need to add it to the static route config file which is located under:

# /etc/systemd/network/XX-eth#.network

Where X can take any number depending on your system and # is the number of the interface you want to add the static route to.

The file should look like this:
```
[Match]
Name=eth0

[Network]
Gateway=10.20.20.20
Address=10.10.10.10/26
DHCP=no

[DHCP]
UseDNS=false
Add a new section at the end of the file:
```
```
[Match]
Name=eth0

[Network]
Gateway=10.20.20.20
Address=10.10.10.10/26
DHCP=no

[DHCP]
UseDNS=false

[Route]
Gateway=10.20.30.40
Destination=192.168.0.0/16
```
Save the file and run the following command to restart network daemon

```systemctl restart systemd-networkd.service```

Check if your route is still present by running:

```route -n```

Your new route should be there.