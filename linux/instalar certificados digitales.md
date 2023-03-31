# Importante
los certificados digitales deben ser extension .crt, los archivos .cer no son reconocidos por el sistema en ningun caso.

## Installing a certificate in PEM form
Assuming a PEM-formatted root CA certificate is in local-ca.crt, follow the steps below to install it.

Note: It is important to have the .crt extension on the file, otherwise it will not be processed.
```
sudo apt-get install -y ca-certificates
sudo cp tqarfw01.crt /usr/local/share/ca-certificates
sudo update-ca-certificates
```
Contenido del bash scrit
```
apt-get install -y ca-certificates
wget http://tqarsvw19dc01/certs/tqarfw01.crt
cp tqarfw01.crt /usr/local/share/ca-certificates
update-ca-certificates
```