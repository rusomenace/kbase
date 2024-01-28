# Change the NTP
Editar el siguiente archivo:
```
sudo nano /etc/systemd/timesyncd.conf
```
Uncomment the NPT= line and define the server you want to be used instead of default:
```
[Time]
NTP=some.ntp.server.com
```
To "audit" the time-synchronization events and verify the server that was contacted, use the following command:
```
cat /var/log/syslog | grep systemd-timesyncd
```
Force sync and service restart
```
sudo systemctl restart systemd-timesyncd
```
# Set the the timezone
```
sudo ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime
```
Restart the service
```
sudo dpkg-reconfigure -f noninteractive tzdata
```