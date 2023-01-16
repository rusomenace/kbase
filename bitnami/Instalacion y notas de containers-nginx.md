# Moodle container

[https://docs.moodle.org/dev/Moodle_App_Docker_Images](https://docs.moodle.org/dev/Moodle_App_Docker_Images)

**Pero es bitnami lo que va como container**
[https://techexpert.tips/moodle/moodle-docker-installation/](https://techexpert.tips/moodle/moodle-docker-installation/)

## Links importantes

Bitnami apache repo
[https://github.com/bitnami/bitnami-docker-apache#environment-variables](https://github.com/bitnami/bitnami-docker-apache#environment-variables)

Bitnami variables
[https://github.com/bitnami/bitnami-docker-moodle/blob/master/README.md](https://github.com/bitnami/bitnami-docker-moodle/blob/master/README.md)

Bitnami master
[https://github.com/bitnami/bitnami-docker-moodle/blob/master/README.md](https://github.com/bitnami/bitnami-docker-moodle/blob/master/README.md)

## Configuracion de archivo .conf para reverso de NGinx:
``` 
server {
    listen 80;
    server_name academy.tqcorp.com;
    return 301 https://academy.tqcorp.com$request_uri;
}

server  {
  listen 443 ssl;
  server_name academy.tqcorp.com;
  location / {
proxy_pass https://academy.tqcorp.com/; # NGinx resuelve por agregado estatico en /etc/hosts
    }
    ssl_certificate /etc/nginx/cert/cert.crt;
    ssl_certificate_key /etc/nginx/cert/cert.key;
}
```
## Configuracion yaml de docker-compose
```
version: '2'
services:
  mariadb:
    image: bitnami/mariadb:latest
    networks:
      - moodlenet
    environment:
#       ALLOW_EMPTY_PASSWORD is recommended only for development.
#     -  ALLOW_EMPTY_PASSWORD=yes
      - MARIADB_ROOT_PASSWORD=password
      - MARIADB_USER=bn_moodle
      - MARIADB_PASSWORD=password
      - MARIADB_DATABASE=bitnami_moodle
      - MARIADB_CHARACTER_SET=utf8mb4
      - MARIADB_COLLATE=utf8mb4_unicode_ci
    volumes:
      - 'mariadb_data:/bitnami/mariadb'
  moodle:
    image: bitnami/moodle:latest
    ports:
      - '80:8080'
      - '443:8443'
    networks:
      - moodlenet
    environment:
      - MOODLE_DATABASE_HOST=mariadb
      - MOODLE_DATABASE_PORT_NUMBER=3306
      - MOODLE_DATABASE_USER=bn_moodle
      - MOODLE_DATABASE_NAME=bitnami_moodle
      - MOODLE_DATABASE_PASSWORD=password
#       ALLOW_EMPTY_PASSWORD is recommended only for development.
#     - ALLOW_EMPTY_PASSWORD=yes
      - MOODLE_USERNAME=manager
      - MOODLE_PASSWORD=password
      - MOODLE_EMAIL=soporte@tqcorp.onmicrosoft.com
      - MOODLE_HOST=academy.tqcorp.com
      - MOODLE_SITE_NAME=Team Quality Academy
#     - MOODLE_REVERSEPROXY=true
#     - MOODLE_SSLPROXY=true
    volumes:
      - 'moodle_data:/bitnami/moodle'
      - 'moodledata_data:/bitnami/moodledata'
      - /home/uroot/cert:/certs
    depends_on:
      - mariadb
volumes:
  mariadb_data:
    driver: local
  moodle_data:
    driver: local
  moodledata_data:
    driver: local
networks:
  moodlenet:
    driver: bridge
```