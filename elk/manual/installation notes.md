## Elastic: URL de documentacion para la instalacion de todos los modulos de ELK actualizados.
## En este documento se trata con la version 8.8
- [Elastic Docs](https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html)
- [Pluralsight curso de ELK](https://app.pluralsight.com/library/courses/installing-elastic-stack/table-of-contents)


# Fase de instalacion
La fase de instalacion no resulta tan simple y se deben tener en cuenta los siguientes puntos:

- Instalar modulo por modulo elasticsearch -> kibana -> logstash, la configuracion tambien debe obedecer el mismo criterio
- La configuracion de ELK esta directamente ligada con lo siguientes archivos YML:
    * /etc/elasticsearch/elasticsearch.yml
    * /etc/kibana/kibana.yml
    * /etc/logstash/logstash

# Elasticsearch
- Durante la instalacion inicial de elasticseach se debe de tomar nota de la clave auto generada, este es un ejemplo:
```
--------------------------- Security autoconfiguration information ------------------------------

Authentication and authorization are enabled.
TLS for the transport and HTTP layers is enabled and configured.

The generated password for the elastic built-in superuser is : fkg3-TGVK-c7kXkWkgzE

If this node should join an existing cluster, you can reconfigure this with
'/usr/share/elasticsearch/bin/elasticsearch-reconfigure-node --enrollment-token <token-here>'
after creating an enrollment token on your existing cluster.

You can complete the following actions at any time:

Reset the password of the elastic built-in superuser with 
'/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic'.

Generate an enrollment token for Kibana instances with 
 '/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana'.

Generate an enrollment token for Elasticsearch nodes with 
'/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node'.

-------------------------------------------------------------------------------------------------
```
- La instalacion por defecto de elasticsearch publica la API via certificados https autogenerados, en todos los casos salvo que se configure lo contrario la url es la siguiente: https://1.1.1.1:9200 (la ip cuadruple 1 es de ejemplo)
- En el caso de hacer pruebas de conectividad o de escritura manual en elastic se debe invocar el certificado, el usuario y la clave (mas sobre este tema en pruebas de logstash)

## Campos a modificar post instalacion elasticsearch en /etc/elasticsearch/elasticsearch.yml:

- cluster.name: Nombre generico de fantasia
- network.host: Si requiere exposicion que por lo general es asi y se usa el 0.0.0.0 o la ip del server, si es de uso en un unico servidor se puede dejar como localhost para dar mas seguridad
- http.port: 9200 por defecto o se puede cambiar
- Tambien se pueden definir los certificados digitales a usar como en este ejemplo con tqcorp.dev pero esta prueba no ha dado buenos resultados por lo que se opta por dejar los certificados originales
```
# Enable encryption for HTTP API client connections, such as Kibana, Logstash, and Agents
xpack.security.http.ssl:
  enabled: true
  certificate: certs/server.crt
  key: certs/server.key
  certificate_authorities: certs/ca.crt
#  keystore.path: certs/http.p12
```

# Kibana
La instalacion de la herramienta se sigue segun los pasos de la documentacion de Elastics.
Una vez finalizado el proceso de instalacion se ejecuta la creacion del token de kibana:
```
'/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana'
```
## Ejemplo de un token generado:
```
eyJ2ZXIiOiI4LjguMCIsImFkciI6WyIxOTIuMTY4LjEwMS45OTo5MjAwIl0sImZnciI6ImNkMjZiMWJhY2JlZTNkMzM5ZDE4MmJkMGIyNDE1M2ZkMjU5MWU0MTlmMzIyNzA4NzdiZmFkM2UyOThhMWFiYWMiLCJrZXkiOiJIbTFJYzRnQnhvOU0wZXZwR1VIYTp4bks2LVVpVFF5R2dEeGdvRFlsVElnIn0=
```
## Campos a modificar post instalacion elasticsearch en /etc/kibana/kibana.yml
- server.host: "0.0.0.0" Permite el ingreso externo a kibana
- server.port: 5601 por defecto
- server.name: "serverelk" El nombre generalmente esta asociado al nombre de la instancia de linux
### Los campos a continuacion son para asegurar el ingreso a la consola via https pero para ello la entrada de HOSTS en el server debe hacer referencia a la URL configurada
- server.ssl.enabled: true
- server.ssl.certificate: /etc/kibana/certs/cert.crt
- server.ssl.key: /etc/kibana/certs/cert.key
- server.publicBaseUrl: "https://elk.tqcorp.dev:5601"

Una vez terminada la fase de instalacion y modificacion se ingresa a la URL en el puerto 5601, de ahi en adelante es intuitivo, se debe colocar el token antes generado y en el server se debe ejecutar el siguiente script para que devuelva 6 digitos como si fuera un doble factor.
## Comando para codigo de 6 digitos:
```
/usr/share/kibana/bin/kibana-verification-code
```
Toda esta tarea es para vincular kibana con logstash, si el proceso es correcto todas las entradas asociadas a la configuracion se encuentran en la parte inferior del archivo ```/etc/kibana/kibana.yml```

## Registros de hosts
Editar /etc/hosts y agregar la URL publica del servidor asociada a 127.0.0.1

## Como remover _source, _id, _index, _score
Simply go to Advanced Settings, under metafields, remove _id, _type, _index, and _score, and _source if you like to remove those from the Discover table view.

# Nota importante: El login de kibana por defecto es:
username: elastic

The generated password for the elastic built-in superuser is : fkg3-TGVK-c7kXkWkgzE
Crear un usuario con los privilegios necesarios

# Logstash
La instalacion de la herramienta se sigue segun los pasos de la documentacion de Elastics, una vez finalizado el proceso no se requieren ajustes en el archivo yml.
Para poder verificar el correcto funcionamiento se puede correr a mano logstash vinculandolo con elasticsearch, el comando es el siguiente:
```
/usr/share/logstash/bin/logstash -e 'input { stdin {} } output { elasticsearch { hosts => ["https://192.168.101.99:9200"] ssl => true cacert => "/etc/elasticsearch/certs/http_ca.crt" user => "elastic" password => "fkg3-TGVK-c7kXkWkgzE" } }'
```
## Descripcion del comando:
- hosts => : direccion ip, protocolo https y puerto de publicacion
- ssl => true : SSL obligatorio
- cacert => : Ubicacion del archivo que usa el web server para publicar la API, si el certificado es valido y la root CA conocida, este punto se puede ovbiar
- user => | password => : Como es SSL requiere credenciales para utilizar la API

Cuando el comando se ejecuta inicia logstash y queda en modo prompt.
En ese punto se pueden escribir mensajes de prueba que quedaran en creados en elasticsearch comprobando asi la correcta integracion de elastic y logstash.
Cada entrada se debe finalizar con ENTER
Para salir control+C

## Verificar mensajes escritos
El siguiente curl hace un query y trae todos mensajes escritos manualmente en formato json:
```
curl -u elastic:fkg3-TGVK-c7kXkWkgzE --cacert /etc/elasticsearch/certs/http_ca.crt -XGET "https://192.168.101.99:9200/_search?pretty=true" -H "Content-Type: application/json" -d'
{
  "query": {
    "match_all": {}
  }
}'
```
&nbsp;

# Documentacion a generar-revisar

## En la documentacion de ELK se hace referencia a configuraciones post instalacion para el correcto funcionamiento del stack, se deben configurar y testear los valores siguientes
---
## Incrementar el NOFILES

If you want to increase the limit shown by ulimit -n, modify below files.

/etc/systemd/user.conf

/etc/systemd/system.conf

in both file add the following line in addition

  DefaultLimitNOFILE=65536
/etc/security/limits.conf with the following lines

         *  soft    nofile  65536
         *  hard    nofile  65536
         elasticsearch   soft    nofile  65536
         elasticsearch   hard    nofile  65536
         elasticsearch   memlock unlimited

Ref: [Process is too low](https://stackoverflow.com/questions/46771233/max-file-descriptors-for-elasticsearch-process-is-too-low)

---
## Script de instalacion elastic
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

# Install elasticsearch
sudo apt-get update && sudo apt-get install elasticsearch

# Install Kibana
sudo apt-get update && sudo apt-get install kibana

# Install Logstash
sudo apt-get update && sudo apt-get install logstash

# Enable auto-start all
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
sudo /bin/systemctl enable kibana.service
sudo /bin/systemctl enable logstash.service
```
# Meta fields
Meta fields
Fields that exist outside of _source to merge into our document when displaying it: _source, _id, _index, _score
# Cambiar los ulimit
```
nano /etc/security/limits.conf
```
## Agregar el siguiente valor
```
elasticsearch  -  nofile  65535
```
## Como chequearlo
```
ps aux | grep elasticsearch
cat /proc/ID/limits
```
## El resultado deberia ser el siguiente:
```
Limit                     Soft Limit           Hard Limit           Units     
Max open files            65535                65535                files     
```
## Systemd configuration
sudo systemctl edit elasticsearch which opens the file automatically inside your default editor). Set any changes in this file, such as:
```
[Service]
LimitMEMLOCK=infinity
```
Once finished, run the following command to reload units:
```
sudo systemctl daemon-reload
```
# Virtual memory
On Linux, you can increase the limits by running the following command as root:
```
sysctl -w vm.max_map_count=262144
```
To set this value permanently, update the ```vm.max_map_count``` setting in ```/etc/sysctl.conf```. To verify after rebooting, run ```sysctl vm.max_map_count```

