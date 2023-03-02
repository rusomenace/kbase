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










# Actualizacion de version 22.04 a 22.10
Ref: https://docs.centreon.com/docs/upgrade/upgrade-from-22-04/

# Instalacin de un poller 22.10
Ref: https://docs.centreon.com/docs/installation/installation-of-a-poller/using-packages/#