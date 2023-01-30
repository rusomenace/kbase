# Mutual TLS

## Procedimiento proviste por AWS
El siguiente documento describe la instalacion de una CA en ubuntu para conectarse a un endpoint via sesion mutua de TLS.
El requerimiento proviene de desarrollo para la consulta de API de brighterion.

Ref: https://aws.amazon.com/blogs/compute/introducing-mutual-tls-authentication-for-amazon-api-gateway/

1.You first create a new certificate authority with signed client certificate using OpenSSL:

Create the private certificate authority (CA) private and public keys:
```
openssl genrsa -out RootCA.key 4096
openssl req -new -x509 -days 3650 -key RootCA.key -out RootCA.pem
```
2.Provide the requested inputs for the root certificate authority’s subject name, locality, organization, and organizational unit properties. Choose your own values for these prompts to customize your root CA.
3.You can optionally create any intermediary certificate authorities (CAs) using the previously issued root CA. The certificate chain length for certificates authenticated with mutual TLS in API Gateway can be up to four levels.
4.Once the CA certificates are created, you create the client certificate for use with authentication.
5.Create client certificate private key and certificate signing request (CSR):
```
openssl genrsa -out my_client.key 2048
openssl req -new -key my_client.key -out my_client.csr
```
6.Enter the client’s subject name, locality, organization, and organizational unit properties of the client certificate. Keep the optional password challenge empty default.
7.Sign the newly created client cert by using your certificate authority you previously created:
```
openssl x509 -req -in my_client.csr -CA RootCA.pem -CAkey RootCA.key -set_serial 01 -out my_client.pem -days 3650 -sha256
```
8.You now have a minimum of five files in your directory (there are additional files if you are also using an intermediate CA):
- RootCA.key (root CA private key)
- RootCA.pem (root CA public key)
- my_client.csr (client certificate signing request)
- my_client.key (client certificate private key)
- my_client.pem (client certificate public key)

## Testing desde una VM a brighterion
```
curl -v --location 'https://bna.uat.eu.brighterion.io/health-check/status' --key my_client.key --cert my_client.pem
```
Ejemplo de resultado:
```
*   Trying 18.192.93.216:443...
* Connected to bna.uat.eu.brighterion.io (18.192.93.216) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.0 (OUT), TLS header, Certificate Status (22):
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.2 (IN), TLS handshake, Request CERT (13):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS header, Certificate Status (22):
* TLSv1.2 (OUT), TLS handshake, Certificate (11):
* TLSv1.2 (OUT), TLS header, Certificate Status (22):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS header, Certificate Status (22):
* TLSv1.2 (OUT), TLS handshake, CERT verify (15):
* TLSv1.2 (OUT), TLS header, Finished (20):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS header, Certificate Status (22):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS header, Finished (20):
* TLSv1.2 (IN), TLS header, Certificate Status (22):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=bna.uat.eu.brighterion.io
*  start date: Dec 13 00:00:00 2022 GMT
*  expire date: Jan 12 23:59:59 2024 GMT
*  subjectAltName: host "bna.uat.eu.brighterion.io" matched cert's "bna.uat.eu.brighterion.io"
*  issuer: C=US; O=Amazon; CN=Amazon RSA 2048 M01
*  SSL certificate verify ok.
* Using HTTP2, server supports multiplexing
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* Using Stream ID: 1 (easy handle 0x56360120be80)
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
> GET /health-check/status HTTP/2
> Host: bna.uat.eu.brighterion.io
> user-agent: curl/7.81.0
> accept: */*
>
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
* TLSv1.2 (OUT), TLS header, Supplemental data (23):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
* TLSv1.2 (IN), TLS header, Supplemental data (23):
< HTTP/2 403
< x-amzn-requestid: dee88114-90a4-43bf-91ac-a5fe8283e440
< x-amzn-errortype: ForbiddenException
< x-amz-apigw-id: fQAjYFBrliAFUCg=
< content-type: application/json
< content-length: 23
< date: Tue, 24 Jan 2023 13:46:48 GMT
<
* Connection #0 to host bna.uat.eu.brighterion.io left intact
```