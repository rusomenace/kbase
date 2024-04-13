# PHPIPAM Deployment

Copiar todos los archivos de la carpeta phpipam a /opt/phpipam
La estructura debe quedar de la siguiente manera:
```
phpipam:/opt/phpipam# tree
.
├── certs
│   ├── server.crt
│   └── server.key
├── docker-compose.yml
├── nginx.conf
└── nginx.yml
```

En la primera ejecucion se creara la base de datos por lo cual va a requerir las credenciales de mariadb:

username: root
pass: my_secret_mysql_root_pass

**Estas claves estan definidas en el docker-compose y se pueden cambiar a conveniencia**
