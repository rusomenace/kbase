## Convert .crt files
To convert a certificate file from PEM (certificate.crt) to DER format and then perform a base64 encoding of the DER content, you can use the OpenSSL command-line tool. Here's how you can do it:

Step 1: Convert PEM to DER format:
```
openssl x509 -in certificate.crt -outform der -out certificate.der
``````
Step 2: Base64 encode the DER content:
```
openssl base64 -in certificate.der -out certificate_base64.txt
```
After running these commands, you will have a file named certificate.der, which contains the binary DER-encoded certificate, and certificate_base64.txt, which contains the base64-encoded DER content of the certificate.

## Convert .key files
Step 1: Convert PEM to DER format:
```
openssl rsa -in certificate.key -outform der -out certificate.der
```
Step 2: Base64 encode the DER content:
```
openssl base64 -in certificate.der -out certificate_key_base64.txt
```
After running these commands, you will have a file named certificate.der, which contains the binary DER-encoded private key, and certificate_key_base64.txt, which contains the base64-encoded DER content of the private key.