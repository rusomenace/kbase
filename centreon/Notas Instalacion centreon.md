# Notas Instalacion centreon

dnf module reset php
dnf module install php:remi-8.1

echo "date.timezone = America/Argentina/Buenos_Aires" | sudo tee -a /etc/php.d/50-centreon.ini


ALTER USER 'root'@'localhost' IDENTIFIED BY 'Chupetin!500';

https://computingforgeeks.com/install-centreon-monitoring-tool-on-centos-rocky-linux/?utm_content=cmp-true


# Isntalacion de Centreon 22.10
Ref: https://docs.centreon.com/docs/installation/installation-of-a-central-server/using-packages/

Se elije por estabilidad Rocky Linux 8.7

# Instalacion en Rocky
Ref: https://computingforgeeks.com/install-centreon-monitoring-tool-on-centos-rocky-linux/

clave de root de mariadb: P6QV89wg6S34qpYT
clave de admin centreon: tNG5VozTzz9qV4QC!

ALTER USER 'root'@'localhost' IDENTIFIED BY 'P6QV89wg6S34qpYT';
flush privileges;
exit;

systemctl restart cbd centengine gorgoned



# Actualizacion de version 22.04 a 22.10
Ref: https://docs.centreon.com/docs/upgrade/upgrade-from-22-04/

# Instalacin de un poller 22.10
Ref: https://docs.centreon.com/docs/installation/installation-of-a-poller/using-packages/#


# crear una CA propia
Ref: https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-on-ubuntu-22-04
clave de ca: ca021

# NPM
info@021informatics.com
GyXSGx9wKothbpau

# GMail app password
iflwtohdloxyraho

# Cockpit y ubuntu

Step1: Create the file ```/etc/NetworkManager/conf.d/10-globally-managed-devices.conf``` Contents of 10-globally-managed-devices.conf ->
```
[keyfile]
unmanaged-devices=none
```
Step2: Create the fake interface by running the following command
```
nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1
```
Step3: reboot, and cockpit updates work perfectly.

Having this issue on Jammy, that is Ubuntu Server 22.04. Adding the line renderer: NetworkManager to /etc/netplan/00-installer-config.yaml like others have said worked for me.
```
network:
  renderer: NetworkManager
  ethernets:
    enp3s0:
      dhcp4: true
  version: 2
  ```

  # Certificado personal

  openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -out example.crt -keyout example.key

  # Set time chrony

  https://wiki.crowncloud.net/?How_to_Sync_Time_in_CentOS_8_using_Chrony

  # Bitwarden

hernan@021informatics.com
INSTALLATION ID: f5bc3fee-6d96-4b8a-9f47-afbd009e76e1
INSTALLATION KEY: lLowFsZzfZEjl0qJjpYw


https://bitwarden.com/

# Instalar docker y docker-compose 
apt-get install docker.io docker-compose -y

# Bajar script bitwarden
curl -Lso bitwarden.sh https://go.btwrdn.co/bw-sh \
    && chmod +x bitwarden.sh

# Correr el instalador
./bitwarden.sh install

# Credenciales de INFO@021....

MzM]e+G`9A-_b_4)

cqsuyoqrexnusycr

# Docker Compose
```
version: '3'

services:
  vaultwarden:
    restart: always
    container_name: vaultwarden
    image: vaultwarden/server:latest
    volumes:
      - /var/vaultwarden/data:/data/
    ports:
      - 8883:80
    environment:
      - SMTP_HOST=smtp.gmail.com
      - SMTP_FROM=hernan.maslowski@gmail.com
      - SMTP_FROM_NAME=VaultWarden021
      - SMTP_SECURITY=starttls
      - SMTP_PORT=587
      - SMTP_USERNAME=hernan.maslowski@gmail.com
      - SMTP_PASSWORD=cqsuyoqrexnusycr
      - SMTP_TIMEOUT=30
      - SMTP_AUTH_MECHANISM="Plain"
      - LOGIN_RATELIMIT_MAX_BURST=10
      - LOGIN_RATELIMIT_SECONDS=60
      - DOMAIN=https://vaultwarden.021informatics.com:8882
      - INVITATION_ORG_NAME=HomeVault
      - INVITATIONS_ALLOWED=true
      - ADMIN_TOKEN=j;lk897J89f7d3k.das3
      - SIGNUPS_ALLOWED=false
      - SIGNUPS_DOMAINS_WHITELIST=021informatics.com
      - SIGNUPS_VERIFY=true
      - SIGNUPS_VERIFY_RESEND_TIME=3600
      - SIGNUPS_VERIFY_RESEND_LIMIT=6
      - EMERGENCY_ACCESS_ALLOWED=true
      - SENDS_ALLOWED=true
      - WEB_VAULT_ENABLED=true
```