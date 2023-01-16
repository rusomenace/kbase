# Instalacion de xrdp
```
sudo apt update
sudo apt install xrdp
sudo systemctl status xrdp
sudo systemctl enable xrdp
```
## Incremento de performance de la sesion
Respaldar y editar el archivo de configuracion de xrdp
```
sudo systemctl status xrdp
nano /etc/xrdp/xrdp.ini
```
Modificar las siguiente entradas
```
max_bpp=16
xserverbpp=16
crypt_level=low
```
Agregar la entrada debajo de "max_bpp"
```use_compression=yes```

Reiniciar servicios post modificaciones
```systemctl restart xrdp.service```

## Esconder usuarios en pantalla de login
```
xhost SI:localuser:gdm
sudo -u gdm gsettings set org.gnome.login-screen disable-user-list true
```
