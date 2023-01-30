Como instalar SSH en Ubuntu
======

# Instalar SSH Client

```
sudo apt get update && sudo apt install openssh-client
```

Para conectarse simplemente
```
ssh usuario@destino
```

### Si necesitamos copiar archivos? SCP

```scp archivo user@server:/directorio/de/destino/```

```
scp demo.txt uroot@192.168.1.13:/tmp/
```

# Instalar SSH Server

```
sudo apt get update && sudo apt install openssh-server
```

### Una vez instalado, es necesario habiliar SSH

```
sudo systemctl enable ssh
```

### Y agregamos la regla en el firewall

```
sudo ufw allow ssh
```

### Como podemos comprobar el estadio del demonio de SSH?

```
sudo systemctl status ssh
```

### En caso de falla o de necesidad de reiniciar el demonio de SSH, podemos reiniciarlo de la siguiente manera

```
sudo systemctl restart ssh
```

## Desactivar/Remover SSH

### Si debemos detener el servicio SSH

```
sudo systemctl stop ssh
```

* Nota: El servicio se detendrá para la sesion actual, dependiendo de la configuración podrá iniciarse nuevamente al reiniciar el servidor. Para asegurarnos que el demonio de SSH no iniciará cuando se reinicie el servidor podemos colocar el siguiente comando:

```
sudo systemctl disable ssh
```

Si queremos tambien borrar la entrada en el firewall

```
sudo ufw delete allow ssh
```