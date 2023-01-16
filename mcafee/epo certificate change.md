After web searching and trial and error I have found the way to replace the default web certificate on ePO 4.5 using a Microsoft CA. The process is pretty straightforward as long as each step is taken in turn.

• At various points you will be asked for the passwords for the private key, ensure you write this down.
• Ensure that the CA is trusted by your Enterprise CA and is added in the Trusted Root Certification Authorities list

1. Install Openssl onto the machine you are going to create the certificates. I used a windows 7 terminal as it had access to both the ePO and Certificate Authority web pages.

2. Create a folder labelled “Certs” on your C:\. This is to keep all files together.

3. Open an administrative command prompt (right click, run as) and change to the Openssl directory. By default this is 
```
C:\Openssl-win32\bin.
```

4. Enter the following command to create a new Private Key (note, type directly as I found cutting and pasting caused problems):
```
Openssl genrsa –des3 –out “c:\certs\mcafee.key” 2048
```

5. Enter the following command to export the private key from step 4:
```
Openssl rsa –in “c:\certs\mcafee.key” –out “c:\certs\unsecured.mcafee.key”
```

6. Enter the following command to create a Certificate Signing Request (.csr)using the key created in step 4:
```
Openssl req –new –key “c:\certs\mcafee.key” –out “c:\certs\mcafee.csr”
```

7. You will now be asked for the necessary information for your certificate as below (with sample answers). If you do not know exactly what information to insert most parts can be ignored but the vital section is “Common Name” as this the servername you will enter when connecting to ePO. In a single domain environment then the server name is good enough. If the server is likely to be accessed by machines external to your domain then use the server FQDN:

Enter pass phrase for mcafee.key:
You are about to be asked to enter information that will be incorporated into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter ‘.’, the field will be left blank.
```
Country Name (2 letter code) [US]:US
State or Province Name (full name) [Some-State]:Oregon
Locality Name (eg, city) []:Beaverton
Organization Name (eg, company) [Internet Widgits Pty Ltd]:XYZ Inc.
Organizational Unit Name (eg, section) []:Tech. Support
Common Name (eg, YOUR name) []:EPOSRV
Email Address []:support@xyz.com
Please enter the following ‘extra’ attributes
to be sent with your certificate request
A challenge password []:password
An optional company name []:
```
8. The “mcafee.csr” file will now be created using the information you have supplied in step 7. You will now need to submit this to your Certificate Authority (by default http://servername/certsrv).

9. Select Request a certificate link

10. Click the advanced certificate request.

11. Click the Submit a certificate request by using a base-64-encoded CMC or PKCS #10 file, or submit a renewal request by using a base-64-encoded PKCS #7 file link.

12. Open the certificate request in notepad and paste all text into the Saved Request box.

13. Click Submit.

14. Depending on your Certificate Authority configuration you may receive your certificate immediately or you may need to issue (or get someone else to issue) your certificate.

15. Click Download CA chain

16. Save as c:\certs\ePO.p7b

17. Double click c:\certs\ePO.p7b and navigate to c:\certs\epo.p7b>Certificates

18. Right click on the certificate shown and select Export, select Cryptographic Message Syntax Standard – PKCS #7 Certificates (.P7B), Save as c:\certs\epocert.p7b

19. You should now have the following files available in c:\certs:

a. Epocert.p7b
b. Unsecured.mcafee.key
20. Navigate to your ePO server console and log in. Select Menu, Configuration, Server Settings

21. Select Server Certificate and click Edit

a. For the Certificate (P7B, PEM) select c:\certs\epocert.p7b.
b. For the Private key (PEM) select c:\certs\unsecured.mcafee.key.
c. In the Password field enter the password used when creating the certificates.

22. Reboot the ePO server

23. Now when you connect to the ePO server you should not receive any certificate warnings.

24. Apartado de como crear certificados con multiples SANs
```
Procedure to create CSR with SAN (Windows)
Login into server where you have OpenSSL installed (or download it here)
Go to the directory where openssl is located (on Windows)
Create a file named sancert.cnf  with the following information
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
[ req_distinguished_name ]
countryName                 = Country Name (AR)
stateOrProvinceName         = State or Province Name (Capital)
localityName               = Locality Name (Buenos Aires)
organizationName           = Organization Name (Team Quality)
commonName                 = Common Name (epo.tq.com.ar)
[ req_ext ]
subjectAltName = @alt_names
[alt_names]
DNS.1   = epo.tq.com.ar
DNS.2   = tqarsvw16epo01
DNS.3   = tqarsvw16epo01.tq.com.ar
* You can add even more subject alternative names if you want. Just add DNS.4 = etcetera…
```

Save the file and execute following OpenSSL command, which will generate CSR and KEY file
openssl req -out sslcert.csr -newkey rsa:2048 -nodes -keyout private.key -config sancert.cnf
This will create sslcert.csr and private.key in the present working directory. Request your certificate with the created CSR and you’re all set!
