# Procedimiento instalación Libertya

[Link Manual oficial](https://www.libertya.org/wiki/lib/exe/fetch.php?media=wiki:instalacion_en_linux.pdf)


# Instalacion en Linux (Ubuntu)

## Tareas Previas

### Actualizar sistema

```bash
sudo apt update && sudo apt upgrade -y
```

### Establecer nombre de equipo

```bash
sudo hostnamectl set-hostname nuevo-nombre
```

Actualizamos el host con el nuevo nombre

```bash
sudo nano /etc/hosts
```

Actualizamos la linea donde figura la ip **127.0.1.1** para que quede de la siguiente forma

```
127.0.1.1 nuevo-nombre
```

Con esto se envita la lentitud de bash y el mensaje de error "sudo: unable to resolve host"

## Instalación Java

Descargar OpenJDK 8 desde la pagina [Descarga OpenJDK 8](https://adoptium.net/temurin/releases/?version=8)
Subir el archivo descargado al directorio home del usuario con el que se esta corriendo la instalación.
Mover el .tar.gz al directorio /opt
```bash
sudo mv OpenJDK8U-jdk_x64_linux_hotspot_8u372b07.tar.gz /opt
```
> Reemplazar con la version de OpenJDK descargada

Ingresar al directorio /opt y descomprimir java
```bash
cd /opt
gunzip OpenJDK8U-jdk_x64_linux_hotspot_8u372b07.tar.gz.tar.gz
tar -xvf OpenJDK8U-jdk_x64_linux_hotspot_8u372b07.tar.gz.tar
```

Esto deja java listo. Para comprobarlo podemos hacerlo con el siguiente comando:
```bash
ls /opt
```
Y deberiamos encontrar un directorio similar a **jdk8u372-b07**

### Configuración de Java

Agregar las siguientes lineas al archivo **/etc/profile**

```bash
sudo cp /etc/profile /etc/profile.orig.pre-java
echo -e "\n\n# Linea agregada para la configuracion de JAVA en Libertya\nexport JAVA_HOME=/opt/jdk8u372-b07\neexport PATH=$JAVA_HOME/bin:$PATH" | sudo tee -a /etc/profile
```

Realizar un reload de bash para que las nuevas variables se apliquen sin necesidad de cerrar la sesion

```bash
source /etc/profile
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

## Instalación de PostgreSQL

Descargar PostgreSQL
```bash
curl -v -O https://ftp.postgresql.org/pub/source/v10.11/postgresql-10.11.tar.gz
```

Descomprimimos PostgreSQL
```bash
gunzip postgresql-10.11.tar.gz
tar -xvf postgresql-10.11.tar
```

Instalar dependencias previas a la compilación de PostgreSQL

```bash
sudo apt update && sudo apt install build-essential gcc make zlib1g-dev libreadline-dev flex bison libxml2-dev libxslt-dev libssl-dev libperl-dev unzip postgresql-client postgresql-client-common
```

### Compilar PostgresSQL

```bash
/configure
make
su
sudo make install # Si no se esta corriendo como root
sudo adduser postgres
sudo mkdir /usr/local/pgsql/data
sudo chown postgres /usr/local/pgsql/data
su - postgres # Se debe colocar la password creada anteriormente
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &
```

### Configuracion PostgreSQL: Permisos de acceso

Ejecutar el siguiente comando para agregar las lineas necesarias al archivo **/usr/local/pgsql/data/pg_hba.conf**

```bash
sudo cp /usr/local/pgsql/data/pg_hba.conf /usr/local/pgsql/data/pg_hba.conf.orig
sudo sed -i '/# IPv4 local connections:/a host\tall\t\tall\t\t0/0\t\t\t\ttrust' /usr/local/pgsql/data/pg_hba.conf
```

### Configuracion PostgreSQL: Direccion de escucha
Ejecutar el siguiente comando para agregar las lineas necesarias al archivo **/usr/local/pgsql/data/postgresql.conf** 
```bash
sudo cp /usr/local/pgsql/data/postgresql.conf /usr/local/pgsql/data/postgresql.conf.orig
sudo sed -i 's/^#listen_addresses.*/listen_addresses = '\''*'\''/' /usr/local/pgsql/data/postgresql.conf
```

### Configuracion PostgreSQL: Permisos usuario postgres
El dueño de estos archivos debe ser el usuario postgres, con lo cual se deberá modificar el owner de los mismos

```bash
sudo chown postgres /usr/local/pgsql/data/pg_hba.conf
sudo chown postgres /usr/local/pgsql/data/postgresql.conf
```

### Configuracion PostgreSQL: Configurar variables de entorno
Ejecutar el siguiente comando para incorporar en **/etc/profile** a fin de especificar la ubicación de postgres y sus bases de datos:
```bash
sudo cp /etc/profile /etc/profile.orig.pre-postgre
echo -e "\n\n# Linea agregada para la configuracion de PosgresSQL en Libertya\nexport PGDATA=/usr/local/pgsql/data\nexport PATH=/usr/local/pgsql/bin/:\$PATH" | sudo tee -a /etc/profile
```

Una vez finalizada la instalación, la instancia de postgres quedará ubicada en **/usr/local/pgsql**


### Configuracion PostgreSQL: Iniciando postgres y verificando conexión
Como iniciar postgres luego de un reinicio del servidor:

```bash
su - postgres
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &
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

## Binarios Libertya ERP

Descargar los binarios desde la web de Libertya o desde (el sitio de sourceforge)[https://sourceforge.net/projects/libertya/files/libertya/release/]
Una vez subidos los binarios al servidor (por ejemplo *ServidorOXP_V19.07_PyME.zip*) hay que descomprimirlos:

```bash
unzip ServidorOXP_V19.07_PyME.zip
sudo unzip ~/ServidorOXP_V19.07_PyME.zip -d /
cd /ServidorOXP
sudo chmod ugo+x *.sh -R
```

Configuramos la variable de entorno **OXP_HOME** en el archivo */etc/profile* y/o */root/.bashrc*

```bash
sudo cp /etc/profile /etc/profile.orig.pre-oxp
sudo cp /root/.bashrc /root/.bashrc.orig.pre-oxp
echo -e "\nexport OXP_HOME=/ServidorOXP" | sudo tee -a /etc/profile
echo -e "\nexport OXP_HOME=/ServidorOXP" | sudo tee -a /root/.bashrc
```

### Configurar la instancia (para /etc/profile)
Por cuestiones de compatibilidad debemos correr el instalador como usuario *root*:

```bash
sudo su
cd /ServidorOXP
source /etc/profile # Es opcional, fuerza que se carguen todas las variables agregadas en /etc/profile
./Configurar.sh
```

## Configurar Libertya desde la terminal
Debemos correr el script como usuario root

```bash
sudo su
cd /ServidorOXP # Si no estamos ya en el directorio
cp LibertyaEnvTemplate.properties LibertyaEnv.properties
```
Y editamos el archivo de propiedades para adecuarlo con los parametros necesarios:

```bash
nano LibertyaEnv.properties
```

Parametros a modificar del archivo *LibertyaEnv.properties*

```
#Libertya home
OXP_HOME=/ServidorOXP

#Java home
JAVA_HOME=/opt/jdk8u372-b07

#Database name
NOMBRE_BD_OXP=libertya      # Cambiar por el nombre de DB deseado

#Application server host name
SERVIDOR_APPS_OXP=localhost 

#Application server port
PUERTO_JNP_OXP=1099
PUERTO_WEB_OXP=8080
PUERTO_SSL_OXP=8443

#Deploy location
DEPLOY_APPS_OXP=/ServidorOXP/jboss/server/openXpertya/deploy

#Keystore settings
KEYSTORE_OXP=/ServidorOXP/keystore/myKeystore
CODIGOALIASKEYSTORE_OXP=libertya
```

> Es importante respetar los numeros de puertos caso contrario pueden presentarse problemas al iniciar el servidor automáticamente *(daemon libertyad)*
> Verificar que no haya espacios en ninguna de las variables, especialmente al final donde no se ven a simple vista. Esto puede generar errores al momento de levantar Libertya que son dificiles de detectar

## Iniciando el servidor de aplicaciones
```bash
cd /ServidorOXP/utils
./IniciarServidor.sh
```

Esto iniciará el proceso de booteo del contenedor web JBoss. Si no se presentan inconvenientes, se visualizará como última salida en la terminal un mensaje similar al siguiente:

```
13:04:54,150 INFO  [Server] JBoss (MX MicroKernel) [4.0.2 (build: CVSTag=JBoss_4_0_2 date=200505022023)] Started in 5s:172ms
```

Esto significa que el servidor ha iniciado correctamente. Si se desea finalizar la ejecución del mismo, simplemente podemos presionar *CTRL+C* desde el teclado.

## Inicio de PostgreSQL en arranque del sistema

Copiamos el script de arranque desde el directorio donde descargamos las fuentes hacia el directorio de systemd:

```bash
sudo cp ~/postgresql-10.11/contrib/start-scripts/linux /etc/init.d/postgresql && sudo chmod ugo+x /etc/init.d/postgresql
```

Configuramos en ubuntu:

```bash
update-rc.d postgresql defaults
```

Agregamos las siguientes lineas al script de inicio de systemd:

```bash
sudo nano /etc/init.d/postgresql
```

```
#! /bin/sh
### BEGIN INIT INFO
# Provides: postgresql
# Required-Start: $local_fs $network
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
### END INIT INFO
```

> Nota: el shebang (#! /bin/sh) ya esta incluido al inicio del script. Debe reemplazarse (o mantenerse el mismo) pero solo debe quedar 1 como primera linea

Habilitamos la unidad de **postgresql**

```bash
sudo systemctl enable postgresql
```

Verificamos si el servicio esta funcionando correctamente

```bash
sudo systemctl status postgresql
```

## Inicio de Libertya ERP en arranque del sistema

Agregar el usuario **libertya**

```bash
sudo adduser libertya
```

Hacer owner del directorio de Libertya al usuario libertya recien creado:

```bash
cd / ; sudo chown libertya:libertya /ServidorOXP -R
```

El servicio se iniciará con el usuario libertya y asignará un PID asociado a ese usuario. Sin embargo como en /var/run ese usuario no dispone de permisos de escritura al momento de iniciar el proceso debemos crear previamente el directorio libertya y asignar al usuario libertya como owner:

```bash
sudo mkdir /var/run/libertya && sudo chown libertya:libertya /var/run/libertya -R
```

Copiamos el script necesario para agregarlo al inicio del sistema:

```bash
sudo cp /ServidorOXP/utils/unix/libertyad_ubuntu-debian.sh /etc/init.d/libertyad && sudo chmod ugo+x /etc/init.d/libertyad
```

Y actualizamos para ubuntu

```bash
sudo update-rc.d libertyad defaults
```

Creamos la unidad de systemd para Libertya:

```bash
sudo nano /etc/init.d/libertyad
```

```
#!/bin/bash
### BEGIN INIT INFO
# Provides: libertyad
# Required-Start: $ALL
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
### END INIT INFO
```

> Nota: el shebang (#! /bin/sh) ya esta incluido al inicio del script. Debe reemplazarse (o mantenerse el mismo) pero solo debe quedar 1 como primera linea

### Habilitamos la unidad de **libertyad**

Iniciamos la unidad de libertyad y la configuramos para el inicio del sistema:

```bash
sudo systemctl enable --now libertyad
```

Verificamos si el servicio esta funcionando correctamente

```bash
sudo systemctl status libertyad
```

## Configuracion de ufw

Verificamos que el firewall este arriba:

```bash
sudo ufw status
```

Habilitamos el firewall:

```bash
sudo ufw enable
```

Permitir el puerto 22 y 8080:

```bash
sudo ufw allow in 8080
sudo ufw allow in 22
```

## Configuracion de DNS

Editamos el archivo **/etc/resolv.conf**

```bash
sudo nano /etc/resolv.conf
```

y agregamos los dns de TQ:

```
nameserver 10.1.1.13
nameserver 10.1.1.16
```

Reiniciamos el servicio de red

```bash
sudo systemctl restart networking
```

Se puede limpiar el cache del dns

```bash
sudo systemd-resolve --flush-caches
```