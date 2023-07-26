## Correr el server en DEV MODE en una ip especifica de listen con token ROOT
```
vault server -dev -dev-listen-address=192.168.77.201:8200 -dev-root-token-id=root
```
## Habilitar modo de autenticacion
```
vault auth enable userpass

```

## Crear usuarios en repo openldap
```
vault write auth/openldap/users/user1 password=superpass1
vault write auth/openldap/users/user2 password=superpass2
vault list auth/openldap/users
```

## Consultar un secreto
```
vault kv get /openldap/users/basic/user1
```

## Script todo en uno
### Script que levanta las variable del vault y las guarda en variables que se utilizan a posterior en docker compose
```
#!/bin/bash

# Fetch the secrets from Vault and store them as environment variables
export ADMIN_PASSWORD=$(vault kv get -format=json /openldap/users/basic/admin | jq -r '.data.data.password')
export USER1_PASSWORD=$(vault kv get -format=json /openldap/users/basic/user1 | jq -r '.data.data.password')
export USER2_PASSWORD=$(vault kv get -format=json /openldap/users/basic/user2 | jq -r '.data.data.password')
# Add more lines for fetching additional secrets if needed

# Run Docker Compose with the fetched secrets as environment variables
docker-compose up -d
```
### El docker compose que invoca el script
```
version: '2'

services:
  openldap:
    image: docker.io/bitnami/openldap:2.6
    ports:
      - '389:1389'
    environment:
      - 'LDAP_ROOT=dc=openldap,dc=local'
      - LDAP_ADMIN_USERNAME=openldapadmin
      - LDAP_ADMIN_PASSWORD=${ADMIN_PASSWORD}
      - LDAP_USERS=user1,user2
      - LDAP_PASSWORDS=${USER1_PASSWORD},${USER2_PASSWORD}
    volumes:
      - 'openldap_data:/bitnami/openldap'
    restart: always

volumes:
  openldap_data:
    driver: local
```

## Modo API
### Este script toma los datos de vault y los propaga durante el spinup del container de openldap
```
#!/bin/bash

# Set the Vault API URL and token
VAULT_URL="http://192.168.77.201:8200/v1"
VAULT_TOKEN="root"

# Make the curl request and save the JSON response to a variable
curl_output=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/openldap/data/users/basic/admin")

# Use jq to extract the password field and save it to a variable
export ADMIN_PASSWORD=$(echo "$curl_output" | jq -r '.data.data.password')

# Run Docker Compose
docker-compose up -d
```

### V3 | Este ultimo dispara todo y suma request de user 1 y 2
```
VAULT_URL="http://192.168.77.201:8200/v1"
VAULT_TOKEN="root"

## Admin
# Make the curl request and save the JSON response to a variable
curl_output=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/openldap/data/users/basic/admin")

# Use jq to extract the password field and save it to a variable
export ADMIN_PASSWORD=$(echo "$curl_output" | jq -r '.data.data.password')

## Basic Users
# User1
curl_output=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/openldap/data/users/basic/user1")
export USER1_PASSWORD=$(echo "$curl_output" | jq -r '.data.data.password')

# User2
curl_output=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/openldap/data/users/basic/user2")
export USER2_PASSWORD=$(echo "$curl_output" | jq -r '.data.data.password')

# pferrero
curl_output=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_URL/openldap/data/users/basic/pfererro")
export PFERRERO_PASSWORD=$(echo "$curl_output" | jq -r '.data.data.password')

# Run Docker Compose
docker-compose up -d
```

### V4 | Preparando para TLS con certificado de tqcorp.dev
```
version: '2'

services:
  openldap:
    image: docker.io/bitnami/openldap:latest
    ports:
      - '389:1389'
      - '636:1636'
    environment:
      - 'LDAP_ROOT=dc=openldap,dc=local'
      - LDAP_ADMIN_USERNAME=openldapadmin
      - LDAP_ADMIN_PASSWORD=${ADMIN_PASSWORD}
      - LDAP_USERS=user1,user2,pferrero
      - LDAP_PASSWORDS=${USER1_PASSWORD},${USER2_PASSWORD},${PFERRERO_PASSWORD}
      - LDAP_ENABLE_TLS=yes  # Enable TLS
      - LDAP_TLS_CERT_FILE=certs/tqcorp.crt
      - LDAP_TLS_KEY_FILE=certs/tqcorp.key
      - LDAP_TLS_CA_FILE=certs/the-ca.crt
      - LDAP_LDAPS_PORT_NUMBER=1636
      - LDAP_TLS_VERIFY_CLIENT=try
    volumes:
      - 'openldap_data:/bitnami/openldap'
      - './tls_certs:/certs:ro'  # Mount TLS certificate directory as read-only
    restart: always

volumes:
  openldap_data:
    driver: local

```
