# Instalar Ansible Semaphore desde repositorios en Ubuntu

## Actualizar e instalar Git

```bash
sudo apt update
sudo apt install git curl wget software-properties-common
```

Confirmar que la version de Git es superior a la 2.x.

```bash
$ git --version
git version 2.25.1
```

## Instalar Ansible en Ubuntu

```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y
```

Confirmar la version de Ansible

```bash
ansible --version
```

## Instalar MariaDB/MySQL

```bash
curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash -s --
```

Una vez agregado el repositorio instalar el paquete de server y cliente

```bash
sudo apt install mariadb-server mariadb-client
```

Securizar la instalacion

```bash
sudo mariadb-secure-installation
```

Configurar de la siguiente manera:

```
Switch to unix_socket authentication [Y/n] n
Change the root password? [Y/n] y
Remove anonymous users? [Y/n] y
Disallow root login remotely? [Y/n] y
Remove test database and access to it? [Y/n] y
Reload privilege tables now? [Y/n] y
```

## Descargar Semaphore en Ubuntu

```bash
VER=$(curl -s https://api.github.com/repos/ansible-semaphore/semaphore/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
wget https://github.com/ansible-semaphore/semaphore/releases/download/v${VER}/semaphore_${VER}_linux_amd64.deb
```

Instalar el paquete

```bash
sudo apt install ./semaphore_${VER}_linux_amd64.deb
```

Chequear si Semaphore esta instalado

```bash
which semaphore
/usr/bin/semaphore

semaphore  -version
v2.8.53
```

## Instalar Semaphore en Ubuntu

```bash
sudo semaphore setup
```

Utilizar las siguientes opciones:

```
Hello! You will now be guided through a setup to:

1. Set up configuration for a MySQL/MariaDB database
2. Set up a path for your playbooks (auto-created)
3. Run database Migrations
4. Set up initial semaphore user & password

What database to use:
   1 - MySQL
   2 - BoltDB
   3 - PostgreSQL
 (default 1): 1
   DB Hostname (default 127.0.0.1:3306): 127.0.0.1:3306
   DB User (default root): root
   DB Password: <root Password>  
   DB Name (default semaphore): semaphore
   Playbook path (default /tmp/semaphore): /opt/semaphore
   Web root URL (optional, example http://localhost:8010/):  http://localhost:8010/
   Enable email alerts (y/n, default n): n
   Enable telegram alerts (y/n, default n): n
   Enable LDAP authentication (y/n, default n): n 
```

> Por defecto, el archivo de configuracion se genera en **/root/config.json**

## Configurar systemd para Semaphore

```bash
sudo nano /etc/systemd/system/semaphore.service
```

Agregar al archivo:

```
[Unit]
Description=Semaphore Ansible UI
Documentation=https://github.com/ansible-semaphore/semaphore
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/bin/semaphore server --config /etc/semaphore/config.json
SyslogIdentifier=semaphore
Restart=always

[Install]
WantedBy=multi-user.target
```

Crear el directorio de configuracion de Semaphore

```bash
sudo mkdir /etc/semaphore
```



