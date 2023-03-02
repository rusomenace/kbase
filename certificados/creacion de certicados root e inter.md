# Creacion de certificados (Brighterion)


El presente documento eplica la creacion de la siguiente estructura de certificados

Root_ca.pem
    |
    └-ca.pem
        |
        └-signed.pem

El objetivo es crear una CA Root que pueda crear una CA Intermedia y esta ultima firmar certificados digitales cliente

## Create self-signed certificates with OpenSSL

### Root CA

#### Create Root CA key (enable password with '-des3' or '-aes' option)
```
openssl genrsa -des3 -out root.key 4096
openssl genrsa -aes256 -out root.key 4096
```

#### Create Root CA
```
openssl req  -new -x509 -sha256 -days 3650 -key root.key -reqexts v3_req -extensions v3_ca -out root.crt
```

### Intermediate CA

#### Create Intermediate CA key
```
openssl genrsa -out ca.key 4096
```

#### Create Intermediate CA request
```
openssl req -new -key ca.key -reqexts v3_req -extensions v3_ca -out ca.csr
```

#### Sign Intermediate CA request
```
openssl x509 -req -in ca.csr -CA root.crt -CAkey root.key -CAcreateserial -CAserial ca.srl -extfile v3_ca.ext -days 3650 -sha256 -out ca.crt
```

#### Create CA chain file
```
cat ca.crt root.crt > ca_chain.crt
```

### Server Certificates

#### Create Server certificate key
```
openssl genrsa -out server.key 4096
```

#### Create Server certificate request
```
openssl req -new -key server.key -out server.csr
```

#### Sign Server certificate
```
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -CAserial server.srl -days 730 -sha256 -out server.crt
```

#### Create Server Certificates with 'Subject Alternative Name' option

> NOTE: `openssl x509` doesn't support creating certificates with SAN option well,
>       use `openssl ca` instead.
```
openssl ca -in server.csr -config ../openssl.cnf -days 1460 -out server.crt
```
#### Create dhparam.pem for TLS
```
openssl dhparam -out dhparam.pem 2048
```

### Client certificates

Similar to server certificates


#### Create PKCS12 format certificates
```
openssl pkcs12 -export -certfile ca_chain.crt -in client.crt -inkey client.key -out client.p12
```

## Verify certificates

### Check if certificate match CA
```
openssl verify -verbose -CAfile ca.crt server.crt
```
### Check if certificate match private key
```
openssl x509 -noout -modulus -in server.crt | openssl md5
openssl rsa -noout -modulus -in server.key | openssl md5
openssl req -noout -modulus -in server.csr | openssl md5
```
### Check SSL protocol
```
openssl s_client -connect HOST:443 -${protocol}
```
`${protocol}` candidates: tls1 tls1_1 tls1_2 tls1_3 ssl2 ssl3

### Check SSL Cipher
```
openssl s_client -connect HOST:443 -cipher ${cipher}
```
`${cipher}` candidates: ECDH RC4-SHA ...

### Check SNI
```
openssl s_client -connect HOST:443 -servername ${sni_host}
```
### Check if client certificate matched
```
openssl s_client -connect HOST:443 \
       -cert client.crt \
       -key client.key  \
       -state -debug
```

## Config file example

### v3_ca.ext
```
    basicConstraints        = CA:TRUE
    subjectKeyIdentifier    = hash
    authorityKeyIdentifier  = keyid:always,issuer:always
    keyUsage                = cRLSign, dataEncipherment, digitalSignature, keyCertSign, keyEncipherment, nonRepudiation
```

### openssl.cnf

> NOTE: The 'subjectAltName' option is used to specify certificate's SAN option
```
    [ca]
    default_ca          = CA_default            # The default ca section

    [CA_default]
    dir                 = .                     # top dir
    database            = $dir/index.txt        # index file.
    new_certs_dir       = $dir                  # new certs dir

    certificate         = $dir/ca.crt           # The CA cert
    serial              = $dir/ca.srl           # serial no file
    private_key         = $dir/ca.key           # CA private key
    RANDFILE            = $dir/.rand            # random number file

    default_days        = 1460                  # how long to certify for
    default_crl_days    = 30                    # how long before next CRL
    default_md          = sha256                # md to use

    policy              = policy_any            # default policy
    email_in_dn         = no                    # Don't add the email into cert DN
    x509_extensions     = v3_req

    name_opt            = ca_default            # Subject name display option
    cert_opt            = ca_default            # Certificate display option
    copy_extensions     = copy                  # Copy extensions from request

    [policy_any]
    countryName            = supplied
    stateOrProvinceName    = optional
    organizationName       = optional
    organizationalUnitName = optional
    commonName             = supplied
    emailAddress           = optional


    [req]
    default_bits        = 4096
    #default_keyfile    = req.key
    #attributes         = req_attributes

    distinguished_name  = req_distinguished_name
    x509_extensions     = v3_ca
    #req_extensions     = v3_req
    default_md          = sha256

    utf8                = yes
    dirstring_type      = nobmp

    [req_distinguished_name]
    emailAddress = test@email.address
    countryName                 = Country Name (2 letter code)
    countryName_default         = CN
    countryName_min             = 2
    countryName_max             = 2

    stateOrProvinceName         = State or Province Name (full name)
    #stateOrProvinceName_default = Some-State

    localityName                = Locality Name (eg, city)

    0.organizationName          = Organization Name (eg, company)
    #0.organizationName_default  = Internet Widgits Pty Ltd

    # we can do this but it is not needed normally :-)
    #1.organizationName         = Second Organization Name (eg, company)
    #1.organizationName_default = World Wide Web Pty Ltd

    organizationalUnitName      = Organizational Unit Name (eg, section)
    #organizationalUnitName_default =

    commonName                  = Common Name (eg, YOUR name)
    commonName_max              = 64

    emailAddress                = Email Address
    emailAddress_max            = 40

    [req_attributes]
    challengePassword       = A challenge password
    challengePassword_min   = 4
    challengePassword_max   = 20


    [v3_ca]
    basicConstraints        = CA:TRUE
    subjectKeyIdentifier    = hash
    authorityKeyIdentifier  = keyid:always,issuer:always
    keyUsage                = cRLSign, dataEncipherment, digitalSignature, keyCertSign, keyEncipherment, nonRepudiation

    [v3_req]
    basicConstraints        = CA:FALSE
    subjectKeyIdentifier    = hash
    keyUsage                = digitalSignature, keyEncipherment, nonRepudiation
    subjectAltName         = @altNames


    [altNames]
    DNS.1 = example.com
    DNS.2 = *.example.com## Create self-signed certificates with OpenSSL
```
### Root CA

#### Create Root CA key (enable password with '-des3' option)
```
openssl genrsa -des3 -out root.key 4096
```

#### Create Root CA
```
openssl req  -new -x509 -sha256 -days 3650 -key root.key -reqexts v3_req -extensions v3_ca -out root.crt
```

### Intermediate CA

#### Create Intermediate CA key
```
openssl genrsa -out ca.key 4096
```

#### Create Intermediate CA request
```
openssl req -new -key ca.key -reqexts v3_req -extensions v3_ca -out ca.csr
```

#### Sign Intermediate CA request
```
openssl x509 -req -in ca.csr -CA root.crt -CAkey root.key -CAcreateserial -CAserial ca.srl -extfile v3_ca.ext -days 3650 -sha256 -out ca.crt
```

#### Create CA chain file
```
cat ca.crt root.crt > ca_chain.crt
```

### Server Certificates

#### Create Server certificate key
```
openssl genrsa -out server.key 4096
```

#### Create Server certificate request
```
openssl req -new -key server.key -out server.csr
```

#### Sign Server certificate
```
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -CAserial server.srl -days 730 -sha256 -out server.crt
```

#### Create Server Certificates with 'Subject Alternative Name' option

> NOTE: `openssl x509` doesn't support creating certificates with SAN option well,
>       use `openssl ca` instead.
```
openssl ca -in server.csr -config ../openssl.cnf -days 1460 -out server.crt
```
#### Create dhparam.pem for TLS
```
openssl dhparam -out dhparam.pem 2048
```

### Client certificates

Similar to server certificates


#### Create PKCS12 format certificates
```
openssl pkcs12 -export -certfile ca_chain.crt -in client.crt -inkey client.key -out client.p12
```

## Verify certificates

### Check if certificate match CA
```
openssl verify -verbose -CAfile ca.crt server.crt
```
### Check if certificate match private key
```
openssl x509 -noout -modulus -in server.crt | openssl md5
openssl rsa -noout -modulus -in server.key | openssl md5
openssl req -noout -modulus -in server.csr | openssl md5
```
### Check SSL protocol
```
openssl s_client -connect HOST:443 -${protocol}
```
`${protocol}` candidates: tls1 tls1_1 tls1_2 tls1_3 ssl2 ssl3

### Check SSL Cipher
```
openssl s_client -connect HOST:443 -cipher ${cipher}
```
`${cipher}` candidates: ECDH RC4-SHA ...

### Check SNI
```
openssl s_client -connect HOST:443 -servername ${sni_host}
```
### Check if client certificate matched
```
openssl s_client -connect HOST:443 \
       -cert client.crt \
       -key client.key  \
       -state -debug
```

## Config file example

### v3_ca.ext
```
    basicConstraints        = CA:TRUE
    subjectKeyIdentifier    = hash
    authorityKeyIdentifier  = keyid:always,issuer:always
    keyUsage                = cRLSign, dataEncipherment, digitalSignature, keyCertSign, keyEncipherment, nonRepudiation
```

### openssl.cnf

> NOTE: The 'subjectAltName' option is used to specify certificate's SAN option
```
    [ca]
    default_ca          = CA_default            # The default ca section

    [CA_default]
    dir                 = .                     # top dir
    database            = $dir/index.txt        # index file.
    new_certs_dir       = $dir                  # new certs dir

    certificate         = $dir/ca.crt           # The CA cert
    serial              = $dir/ca.srl           # serial no file
    private_key         = $dir/ca.key           # CA private key
    RANDFILE            = $dir/.rand            # random number file

    default_days        = 1460                  # how long to certify for
    default_crl_days    = 30                    # how long before next CRL
    default_md          = sha256                # md to use

    policy              = policy_any            # default policy
    email_in_dn         = no                    # Don't add the email into cert DN
    x509_extensions     = v3_req

    name_opt            = ca_default            # Subject name display option
    cert_opt            = ca_default            # Certificate display option
    copy_extensions     = copy                  # Copy extensions from request

    [policy_any]
    countryName            = supplied
    stateOrProvinceName    = optional
    organizationName       = optional
    organizationalUnitName = optional
    commonName             = supplied
    emailAddress           = optional


    [req]
    default_bits        = 4096
    #default_keyfile    = req.key
    #attributes         = req_attributes

    distinguished_name  = req_distinguished_name
    x509_extensions     = v3_ca
    #req_extensions     = v3_req
    default_md          = sha256

    utf8                = yes
    dirstring_type      = nobmp

    [req_distinguished_name]
    emailAddress = test@email.address
    countryName                 = Country Name (2 letter code)
    countryName_default         = CN
    countryName_min             = 2
    countryName_max             = 2

    stateOrProvinceName         = State or Province Name (full name)
    #stateOrProvinceName_default = Some-State

    localityName                = Locality Name (eg, city)

    0.organizationName          = Organization Name (eg, company)
    #0.organizationName_default  = Internet Widgits Pty Ltd

    # we can do this but it is not needed normally :-)
    #1.organizationName         = Second Organization Name (eg, company)
    #1.organizationName_default = World Wide Web Pty Ltd

    organizationalUnitName      = Organizational Unit Name (eg, section)
    #organizationalUnitName_default =

    commonName                  = Common Name (eg, YOUR name)
    commonName_max              = 64

    emailAddress                = Email Address
    emailAddress_max            = 40

    [req_attributes]
    challengePassword       = A challenge password
    challengePassword_min   = 4
    challengePassword_max   = 20


    [v3_ca]
    basicConstraints        = CA:TRUE
    subjectKeyIdentifier    = hash
    authorityKeyIdentifier  = keyid:always,issuer:always
    keyUsage                = cRLSign, dataEncipherment, digitalSignature, keyCertSign, keyEncipherment, nonRepudiation

    [v3_req]
    basicConstraints        = CA:FALSE
    subjectKeyIdentifier    = hash
    keyUsage                = digitalSignature, keyEncipherment, nonRepudiation
    subjectAltName         = @altNames


    [altNames]
    DNS.1 = example.com
    DNS.2 = *.example.com
```
Testing:
Ejecutar el siguiente comando a cada archivo .pem para verificar la emicion y subject

```
openssl x509 -in nombre_de_archivo.pem -text
```
Resulado de ejemplo
```
root_ca.pem: root ca
Issuer:  C = AR, ST = Buenos Aires, L = Capital, O = Team Quality, CN = My Private Root CA
Subject: C = AR, ST = Buenos Aires, L = Capital, O = Team Quality, CN = My Private Root 

ca.pem: intermedia ca
Issuer: C = AR, ST = Buenos Aires, L = Capital, O = Team Quality, CN = My Private Root CA
Subject: C = AR, ST = Buenos Aires, L = Capital, O = Team Quality, CN = My Private Intermediate CA

signed.pem
Issuer: C = AR, ST = Buenos Aires, L = Capital, O = Team Quality, CN = My Private Intermediate CA
Subject: C = AR, ST = Buenos Aires, L = Capital, O = Team Quality, CN = My mTLS Client
```

Ref:
- [Documentacion detallada](https://gist.github.com/gmassawe/b29643dc98e9905303a43c5affa0e278)
- [Ejemplo enviado por Brighterion](https://aws.amazon.com/blogs/compute/introducing-mutual-tls-authentication-for-amazon-api-gateway/)