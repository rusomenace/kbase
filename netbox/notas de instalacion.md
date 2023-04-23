## Credenciales de servicios
```
uroot
xyZM55UMBJwZ4Ps9

Netbox:
DxxdnHi2TQ8Gf4LN

Secret key:
DPtCilkJPys6E&&gMon9N0AUYvnMulHf$fTGeWiB$V9i5V4puW
```
## Instalacion
```
apt update -y && apt upgrade -y
apt install -y postgresql libpq-dev
```
## Creacion de base de datos y usuario
```
sudo -u postgres psql
CREATE DATABASE netbox;
CREATE USER netbox WITH PASSWORD 'r5t6^7$%gyuuyt4';
GRANT ALL PRIVILEGES ON DATABASE netbox TO netbox;
\q
```
## Instalacion de redis
```
apt install redis-server -y
redis-cli ping
```
## Instalacion de netbox
```
apt install -y python3 python3-pip python3-venv python3-dev build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev
```
## Upgrade de pip3
```
pip3 install --upgrade pip

```
## Crear directorios de instalacion
```
mkdir -p /opt/netbox/ && cd /opt/netbox/
git clone -b master https://github.com/netbox-community/netbox.git .
```
## Agregar usuario de sistema e instalar
```
sudo adduser --system --group netbox
sudo chown -R netbox /opt/netbox/netbox/media/
cd /opt/netbox/netbox/netbox/
cp configuration_example.py configuration.py
ln -s /usr/bin/python3 /usr/bin/python
/opt/netbox/netbox/generate_secret_key.py
```
## The KEY!
```
OFz2q5hP##dTIhce+BEkRHm7un+yt*HoBR&f_4rx(mTJ)uH_js
```
## Editar la configuracion y agregar el bloque de codigo
```
nano /opt/netbox/netbox/netbox/configuration.py
```
## Bloque
```
ALLOWED_HOSTS = ['*']

DATABASE = {
'NAME': 'netbox', # Database name you created
'USER': 'netbox', # PostgreSQL username you created
'PASSWORD': 'r5t6^7$%gyuuyt4', # PostgreSQL password you set
'HOST': 'localhost', # Database server
'PORT':'', # Database port (leave blank for default)
}

SECRET_KEY = 'OFz2q5hP##dTIhce+BEkRHm7un+yt*HoBR&f_4rx(mTJ)uH_js'
```
## Continus la isntalacion
```
/opt/netbox/upgrade.sh
source /opt/netbox/venv/bin/activate
cd /opt/netbox/netbox
python3 manage.py createsuperuser
cp /opt/netbox/contrib/gunicorn.py /opt/netbox/gunicorn.py
cp -v /opt/netbox/contrib/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl start netbox netbox-rq
systemctl enable netbox netbox-rq
```
# Instalacion de NGINX
```
apt install -y nginx
cp /opt/netbox/contrib/nginx.conf /etc/nginx/sites-available/netbox
nano /etc/nginx/sites-available/netbox
```
## Cambiar el hostname como se indica y continuar con los comandos
```
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/netbox /etc/nginx/sites-enabled/netbox
```
# Creacion de certificados digitales para NGINX
```
cd /etc/ssl/certs/
openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -out netbox.crt -keyout netbox.key
mv netbox.key /etc/ssl/private/netbox.key
systemctl restart nginx
systemctl enable nginx
```
- Ref: [Instalacion en ubuntu 22](https://www.hostnextra.com/kb/install-netbox-on-ubuntu/)
- Ref: [Repositorio de objetos](https://github.com/netbox-community/devicetype-library)






