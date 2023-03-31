# Ubuntu 22.04
```
sudo apt update; sudo apt install cockpit
systemctl enable cockpit.socket
systemctl status cockpit
```
# Oracle Linux 8.5
```
yum install epel-release
yum install cockpit
systemctl enable --now cockpit.socket