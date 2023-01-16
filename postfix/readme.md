# Postfix

## La configuracion de postfix existe en
```
/etc/postfix/main.cf
```
## Ejemplo de postif relax productivo
```
# See /usr/share/postfix/main.cf.dist for a commented, more complete version


# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname

smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 2 on
# fresh installs.
compatibility_level = 2



# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_tls_security_level=may

smtp_tls_CApath=/etc/ssl/certs
smtp_tls_security_level=may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache


smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = postfix.tq.com.ar
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = postfix.tqcorp.com, $myhostname, tqarsvlu20smtp01, localhost.localdomain, localhost
relayhost = tqcorp-com.mail.protection.outlook.com
mynetworks = 192.168.150.6/32 192.168.27.14/32 192.168.27.2/32 192.168.11.14/32 10.1.1.0/24 192.168.29.0/24 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all

# Transport mapping
transport_maps = texthash:/etc/postfix/transport
```

# Limitar el transport a uno o mas dominios especificos

## You can add a transport map in main.cf:
```
transport_maps = texthash:/etc/postfix/transport
```
Then edit /etc/postfix/transport with your favorite editor and add this:
```
tqcorp.com smtp:
rocker.com.ar smtp:
* error:only mail to @tqcorp.com & @rochel.com.ar will be delivered
```
This will bounce every mail with recipients other than *@example.com. If you need to be able to change the transport_map on the fly use hash instead of texthash, but you have to use postmap on the file once you changed it to update the corresponding .db file and so postfix notices it has changed. If you don't want to bounce other mails use this instead:
```
example.com smtp:
* discard:
```

# Pasar las opciones de limite de envio al container

