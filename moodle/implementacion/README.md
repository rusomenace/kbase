# Introduction 
Implementacion de moodle como herramienta de capacitacion

# Getting Started

1.	Instalacion
2.	Configuracion

# Links

- [Bitnami](https://github.com/bitnami/bitnami-docker-moodle)

## 1.
La solucion de moodle elegida es la provista por BITNAMI (VMWare) 
Se opta por una instalacion de moodle en contenedor que facilita la actualizacion sin mantener una dependencia con librerias que pueden romper la aplicacion.
La actualizacion a diferencia de cualquier imple con containers es mas compleja y manual y no es solamente bajar el stack de docker-compose y actualizar las imagenes, se detalla brevemente el proceso:

- Bajar stack de docker compose
- Descargar del docker server a un path temporal el zip de actualizacion
- Descargar imagenes nuevas
- Respaldar archivos relevantes
- Sobreescribir la carpeta de la aplicacion moodle
- Restaurar en la carpeta anterior los archivos relevantes
- Iniciar nuevamente el stack de docker compose

A pesar de ser compleja o engorrosa la aplicacion de actualizaciones es mucho mas facil en este formato que la instalacion clasica.

## 2. 

### YAML

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
      - MARIADB_ROOT_PASSWORD=pknQxSy3t8j2q4Wm
      - MARIADB_USER=bn_moodle
      - MARIADB_PASSWORD=QwgFKnnRD64S2ABx
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
      - MOODLE_DATABASE_PASSWORD=QwgFKnnRD64S2ABx
#       ALLOW_EMPTY_PASSWORD is recommended only for development.
#     - ALLOW_EMPTY_PASSWORD=yes
      - MOODLE_USERNAME=manager
      - MOODLE_PASSWORD=YeH2sfYZuMhcc2xE
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

## Certificados:

```/home/uroot/cert:/certs ```

Es el mapping al container desde el host, ahi se dejan los archivos de certificados digitales, el nombre es especifico y debe respetarse de la siguiente manera:
- server.crt
- server.key

### NGinx proxy reverso
Configuracion de archivo moodle.conf en el nginx reverso

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
proxy_pass https://academy.tqcorp.com/;
    }
    ssl_certificate /etc/nginx/cert/cert.crt;
    ssl_certificate_key /etc/nginx/cert/cert.key;
}
```