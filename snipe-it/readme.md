# Certificados digitales
La estructura de los archivos provistos al container estan ubicados en la siguiente carpeta de TQARSVLU22DK01
```
/home/uroot/data/snipe_it
```
La anterior es la ubicacion que se le pasa al container durante su ejecucion desde docker compose
```
    volumes:
      - /root/data/snipe_it:/config
```
Esto mapea los certificados en el contenedor en la siguiente ubicacion
```
ssl_certificate /config/keys/cert.crt;
ssl_certificate_key /config/keys/cert.key;
```
Para renovar simplemente reemplazar cert.crt y cert.key en:
```
/home/uroot/data/snipe_it/keys
```
Reiniciar el stack de contenedor con docker compose

**Ref:** https://snipe-it.readme.io/docs/configuration
**Discord:** https://discord.com/channels/849770616521359401/953725309864263723

