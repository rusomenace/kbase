## Guia de instalacion de portainer

**Descargar la ultima version de portainer**
```
docker pull portainer/portainer:latest
```
**Crear un archivo portainer.yml y colocar lo siguiente**
```
version: '2'

services:
  portainer:
    image: portainer/portainer
    container_name: portainer
    restart: always
    ports:
      - 9000:9000
      - 8000:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
      - /etc/docker/certs.d/tqcorp.com:/certs
    command:
            --ssl
            --sslcert /certs/ca.crt
            --sslkey /certs/ca.key
volumes:
  portainer_data:
```
Los archivos ca.key y ca.crt se encuentran en esa ruta por ser el mismo docker server donde se instalo Harbor

**Iniciar el contenedor**
```
sudo docker-compose -f portainer.yml up -d
```
**Configuracion de integracion con ldap**
```
LDAP Server: 10.1.1.13:369
Reader DN: CN=Administrator,CN=Builtin,DC=tq,DC=com,DC=ar
Base DN: OU=site0,OU=arg,DC=tq,DC=com,DC=ar
Username Attribute: userPrincipalName
Group Base DN: OU=groups,OU=site0,OU=arg,DC=tq,DC=com,DC=ar
Group Membership Attribute: member
```
