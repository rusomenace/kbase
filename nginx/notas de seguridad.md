# Mejoras de la seguridad

- Wiki recomendaciones de encripcion de TLS siempre actualizado
[https://wiki.mozilla.org/Security/Server_Side_TLS](https://wiki.mozilla.org/Security/Server_Side_TLS)

- Herramienta para configurar web server con encriptacion donde se selecciona el tipo de web server y el modo de encriptacion. Da una configuracion aplicable en cada caso
[https://ssl-config.mozilla.org/#server=nginx&version=1.19.8&config=modern&openssl=1.1.1d&guideline=5.6](https://ssl-config.mozilla.org/#server=nginx&version=1.19.8&config=modern&openssl=1.1.1d&guideline=5.6)

- Test externo de nivel de encripcion y vulnerabilidades
[https://www.ssllabs.com/ssltest/index](https://www.ssllabs.com/ssltest/index)

- SSL Chequer
https://www.geocerts.com/ssl-checker

## Para deshabilitar el sitio por defecto comentar todo lo del siguiente archivo en NGinx
```
/etc/nginx/sites-available/default
```
## Siio para analisis profundo
https://intranet.bound4blue.com