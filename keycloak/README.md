# Introduction 
Herramienta para generar authentication OAUTH2

# Getting Started

1.	Notas
2.	Instalacion


## 1. Notas

Referirse al siguiente link para el pre armado de un container, variables y requerimientos:
- [Bitnami Keycloak repo](https://github.com/bitnami/bitnami-docker-keycloak)
- [Bitnami Postgresql repo](https://github.com/bitnami/bitnami-docker-postgresql)

KC tiene dependencia de un motor de base de datos por lo cual hay que elegir entre las siguientes opciones: dev-file, dev-mem, mariadb, mssql, mysql, oracle, postgres.
Se puede montar un stack de docker-compose completo de KC con la DB propia, referirse al link superior en **Relevant Options** para ver todas las variables posibles.

## 2. Instalacion
Se realiza la instalacion utilzando como base un archivo yaml para todo el stack:

```
version: '2'
services:
  postgresql:
    image: docker.io/bitnami/postgresql:latest
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
      - POSTGRESQL_USERNAME=bn_keycloak
      - POSTGRESQL_DATABASE=bitnami_keycloak
    volumes:
      - 'postgresql_data:/bitnami/postgresql'
  keycloak:
    image: docker.io/bitnami/keycloak:latest
    ports:
      - "8080:8080"
    environment:
      - KEYCLOAK_CREATE_ADMIN_USER=true
    depends_on:
      - postgresql
volumes:
  postgresql_data:
    driver: local
```

La configuracion es base y no tiene customizadas muchas de las opciones para entrar a produccion pero si esta armado el stack con dependendia en postgre sql y eso es requerimiento del ambien productivo.

Scrip para iniciar keycloak como proyecto sin pisar los existentes (./up.sh):

```
docker-compose -p keycloak up -d
```

### Detalles de la implementacion:
- Servidor: **TQARSVLU20DEV02**
- Path a los archivos: **/home/uroot/yml/keycloak**
- docker-compose.yml (stack de servicio para docker-compose)
- up.sh (Script para levantar el stack con definicion de proyecto)
- down.sh (Script para bajar todo el stack)
- URL: [http://keycloak.tq.com.ar:8080/](http://keycloak.tq.com.ar:8080/)
- Usuario y clave: **user / bitnami**

### Creacion de un realm
- Se creo un reino con nombre **Dev**
- Se creo un usuario y clave de test: **keycloak / S3cret**

Se adjunta en files un POST de POSTMAN para obtener el access_token del usuario de pruebas