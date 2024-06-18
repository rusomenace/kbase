Start OpenSSL from the OpenSSL\bin folder.

Open the command prompt and go to the folder that contains your .pfx file.
Run the following command to extract the private key:
```
openssl pkcs12 -in [yourfile.pfx] -nocerts -out [drlive.key]
```
You will be prompted to type the import password.
Type the password that you used to protect your keypair when you created the .pfx file.

You will be prompted again to provide a new password to protect the .key file that you are creating. Store the password to your key file in a secure place to avoid misuse.

Run the following command to extract the certificate:
```
openssl pkcs12 -in [yourfile.pfx] -clcerts -nokeys -out [drlive.crt]
```
Run the following command to decrypt the private key:
```
openssl rsa -in [drlive.key] -out [drlive-decrypted.key]
```
Type the password that you created to protect the private key file in the previous step.
The .crt file and the decrypted and encrypted .key files are available in the path, where you started OpenSSL.