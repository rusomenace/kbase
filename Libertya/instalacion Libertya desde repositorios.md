# Procedimiento instalación Libertya

[Link Manual oficial](https://www.libertya.org/wiki/lib/exe/fetch.php?media=wiki:instalacion_en_linux.pdf)

## Preguntas/Dudas
Funciona con una version mas reciente de Java? Que versiones estan probadas para su funcionamiento?
Cuales son las diferencias entre la version de Linux y la version de Windows? Cual es la preferida?
Cuales son los requisitos de sistema?

# Instalacion en Linux (Ubuntu)

Realizar un reload de bash para que las nuevas variables se apliquen sin necesidad de cerrar la sesion

```bash
source /etc/profile
```

## Instalar OpenJDK8 desde repositorios
```bash
sudo apt update && sudo apt install openjdk-8-jdk -y
sudo apt-mark hold openjdk-8-jdk
```

Ejecutamos
```bash
java -version
```

El resultado debe ser algo similar a esto:
```
openjdk version "1.8.0_372"
OpenJDK Runtime Environment (Temurin)(build 1.8.0_372-b07)
OpenJDK 64-Bit Server VM (Temurin)(build 25.372-b07, mixed mode)
```

### Configuración de Java

Agregar las siguientes lineas al archivo **/etc/profile**

```bash
sudo cp /etc/profile /etc/profile.orig.pre-java
echo -e "\n\n# Linea agregada para la configuracion de JAVA en Libertya\nexport JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\neexport PATH=$JAVA_HOME/bin:$PATH" | sudo tee -a /etc/profile
```

Realizar un reload de bash para que las nuevas variables se apliquen sin necesidad de cerrar la sesion

```bash
source /etc/profile
```

## Instalación de PostgreSQL

```bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update && sudo apt install postgresql-10 -y && sudo apt-mark hold postgresql-10
```

### Configuracion PostgreSQL: Permisos de acceso (Instalacion Repositorios)

Ejecutar el siguiente comando para agregar las lineas necesarias al archivo **/etc/postgresql/10/main/pg_hba.conf**

```bash
sudo cp /etc/postgresql/10/main/pg_hba.conf /etc/postgresql/10/main/pg_hba.conf.orig
sudo sed -i '/# IPv4 local connections:/a host\tall\t\tall\t\t0/0\t\t\ttrust' /etc/postgresql/10/main/pg_hba.conf
```


### Configuracion PostgreSQL: Direccion de escucha (Instalacion Repositorios)
Ejecutar el siguiente comando para agregar las lineas necesarias al archivo **/etc/postgresql/10/main/postgresql.conf** 
```bash
sudo cp /etc/postgresql/10/main/postgresql.conf /etc/postgresql/10/main/postgresql.conf.orig
sudo sed -i 's/^#listen_addresses.*/listen_addresses = '\''*'\''/' /etc/postgresql/10/main/postgresql.conf
```

### Configuracion PostgreSQL: Permisos usuario postgres (Instalacion Repositorios)
El dueño de estos archivos debe ser el usuario postgres, con lo cual se deberá modificar el owner de los mismos

```bash
sudo chown postgres /etc/postgresql/10/main/pg_hba.conf
sudo chown postgres /etc/postgresql/10/main/postgresql.conf
```

### Configuracion PostgreSQL: Configurar variables de entorno (Instalacion repositorios)
Ejecutar el siguiente comando para incorporar en **/etc/profile** a fin de especificar la ubicación de postgres y sus bases de datos:
```bash
sudo cp /etc/profile /etc/postgresql/10/main/profile.orig
sudo bash -c 'echo -e "\n# Lineas agregadas por la instalacion de PostgreSQL en Libertya\nexport PGDATA=/etc/postgresql/10/main/\nexport PATH=\"/usr/lib/postgresql/10/bin/:\$PATH\"" >> /etc/profile'
```

### Cambiar la contraseña del usuario postgres

```bash
sudo passwd postgres
```

### Configuracion PostgreSQL: Iniciando postgres y verificando conexión
Como iniciar postgres luego de un reinicio del servidor:

Por defecto el usuario post
sudo chmod -R u+w /etc/postgresql/10/main/

```bash
su - postgres
/usr/lib/postgresql/10/bin/postgres -D /etc/postgresql/10/main/ >logfile 2>&1 &
exit
```

### Configuracion PostgreSQL: Verificar el estado de la conexion de la base de datos

```bash
/usr/local/pgsql/bin/psql -h localhost -U postgres -c "select 1"
```

El resultado deberá ser similar al siguiente:

```
?column?
----------
1
(1 row)
```

## Instalación Libertya

### Descarga Libertya

Descargar la ultima version [desde la web de libertya](https://www.libertya.org/descargas)

Al momento de la creación de este documento, [la ultima versión disponible es la 22](https://sourceforge.net/projects/libertya/files/libertya/release/22.0/multi-platform/) pero puede chequearse desde (sourceforge)[https://sourceforge.net/projects/libertya/files/libertya/release/]
En caso de utilizar una version de postgreSQL superior a la 9.5 como en este caso, iremos con el archivo **dump_libertya_22.0ar_postgres9.5.sql.zip**

### Creación de usuario libertya (a nivel postgres)
Libertya utiliza un usuario y schema (de postgres) llamados libertya. Por única vez será necesario entonces realizar la creación correspondiente:

```sql
psql -h localhost -U postgres -c "CREATE ROLE libertya LOGIN PASSWORD 'libertya'
SUPERUSER CREATEDB CREATEROLE VALID UNTIL 'infinity' IN ROLE postgres"
```

### Creación Base de Datos
Subir el archivo descargado en el paso anterior *(con scp o winscp por ejemplo)* y descomprimirlo:
```bash
cd ~/
unzip dump_libertya_22.0ar_postgres9.5.sql.zip
```

Posteriormente debemos crear la base de datos y volcar allí el contenido del archivo descargado. El nombre de la base de datos puede ser cualquiera, en este caso utilizaremos el nombre **libertya_prod**:

```bash
cd ~/
```
```sql
psql -h localhost -U postgres -c "CREATE DATABASE libertya_prod WITH ENCODING='UTF8' OWNER=libertya TEMPLATE=template1;"
psql -U libertya -d libertya_prod -f dump_libertya_22.0ar_postgres9.5.sql
```
El último comando efectuará el restore del dump descargado en la base de datos libertya_prod, lo cual requerirá de cierto tiempo para ser completado.