#PKI

## CA se comporta como:
Certificate auth: Como CA
Certification auth: Como servidores que crean los certificados

## Las 4 responsabilidades

- Validacion de datos en el certificado
- Integridad de los datos usando la funcion de hash
- Confidencialidad utilizando encripcion
- No repudio de uso tipico lega- poco claro

## Root CA
Siempre hay uno y es tope
Self signed

## Certificate Authtorities
Subord e intermidiates son casi lo mismo: se otorga para delegar permisos especificos de accion

## Lineamientos de encripcion se definen como:
Se encripta informacion con llave publica
Se desencripta informacion con llave privada
Se valida autenticacion

## Signing data
Se encripta informacion con llave privada
Se desencripta informacion llave publica
Se valida emisor

## Certificate signing request
Escrito en formato Distinguished Name
Puede contener datos adicionales llamados extensions

## OCSP
Online Certificate Status Proto
Protocolo de pregunta y respuesta para determinar la validez de un certificado

# Key Pairs

## Criptografia asimetrica
Una llave es privada y otra llave es publica
La unica desventaja es que la encripcion asimetrica agrega un payload adicional al paquete que se encripta y envia

## Standard de formato de certificados
PKCS#12

## Tipos de certs
- Cert. request
- Certificate
- Cert. revocation list
- CSR CRL attribute certificates

## Estructura de certificados
x.509
- version: actual V3
- serial number: es unico pero dentro de la CA
- algorito de firma: SHA256RSA
- Issuer: usualmente un CN: C=US,O=airlines,OU=security,CN=Verisign
- Subject: -Issuer: usualmente un CN: C=US,O=airlines,OU=security,CN=Hernan
- Validity: Fecha de validez
- Public Key
- Extentions: Descripcion de que privilegios tiene el certificado

## Certificate Signature Request
Contiene 4 campos
- version: x.509v3
- subject: DN
- Public Key
- Extentions
