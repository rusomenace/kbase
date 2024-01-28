# Ubuntu 22.04
```
sudo apt update; sudo apt install cockpit
sudo systemctl enable cockpit.socket
sudo systemctl status cockpit
```
# Oracle Linux 8.5
```
yum install epel-release
yum install cockpit
systemctl enable --now cockpit.socket
```
## Cockpit fake adapter
updates: Work around the "whilst offline" in Ubuntu & Debian · Issue #16963 · cockpit-project/cockpit · GitHub
Frequently Asked Questions (FAQ) — Cockpit Project (cockpit-project.org)

### Error message about being offline
The software update page shows “packagekit cannot refresh cache whilst offline” on a Debian or Ubuntu system.

Solution
Create a placeholder file and network interface.

### Create
```
sudo nano /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
```
with the contents:
```
[keyfile]
unmanaged-devices=none
```
Set up a “dummy” network interface:
```
sudo nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1
Reboot
```