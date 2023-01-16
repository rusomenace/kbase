# DKIM, DMARC y SPF

EL siguiente documentacion detalla la implementacion de seguridad contra spam requiere de 3 elementos, dkim,dmarc y spf.

## SPF
El registro txt de spf es creado automaticamente por microsoft cuando se migra los dns a azure, en nuestro caso se ven asi
```
txt spf name:@
txt spf value: v=spf1 include:spf.protection.outlook.com -all
ttl: 1/2 hour
```
**Ref:** https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/set-up-spf-in-office-365-to-help-prevent-spoofing?view=o365-worldwide

## DKIM
Mucho mas sencillo que en implementaciones on prem la configuracion de DKIM implica crear estos 2 registros en los dns
```
Host Name : selector1._domainkey Points to address or value: selector1-tqcorp-com._domainkey.tqcorp.onmicrosoft.com
Host Name : selector2._domainkey Points to address or value: selector2-tqcorp-com._domainkey.tqcorp.onmicrosoft.com
```
A partir de la creacion de los registros se debera habilitar DKIM siguiendo las instrucciones de microsoft utilizando el portal de https://protection.office.com/dkimv2

**Ref y guia:** https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/use-dkim-to-validate-outbound-email?view=o365-worldwide

## DMARC
Siguiendo la guia de referencia de microsoft se crea el siguiente registro txt
```
txt name: _dmarc
txt value: v=DMARC1;  p=reject; sp=reject; rua=mailto:soporte@tqcorp.onmicrosoft.com; ruf=mailto:soporte@tqcorp.onmicrosoft.com; fo=1"
ttl: 1 hour
```
**Ref:** https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/use-dmarc-to-validate-email?view=o365-worldwide

# Documentacion adicional

¿Qué son los registros SPF, DKIM y DMARC?
Los registros o protocolos de autenticación SPF, DKIM y DMARC nos pueden ayudar a evitar que se manden correos suplantando nuestra identidad, una actividad conocida como phishing. También sirven para dar más seguridad a los servidores de destino de nuestros correos y así evitar, dentro de lo posible, que sean marcados como SPAM.

A continuación te explicamos en qué consiste cada registro y te mostramos unos ejemplos de cada uno de ellos. 

## SPF
El Sender Policy Framework, o SPF, se encarga de certificar qué IP pueden mandar correo utilizando el dominio en cuestión. Este registro es eficaz contra los ataques de phishing. También ayuda a que los servidores de destino tengan más confianza y no cataloguen correos legítimos enviados por ti como SPAM.

Un ejemplo de SPF básico: 
```
v=spf1 a mx ~all
```
Con la letra “a” indicamos que la IP del dominio está autorizada a enviar correos. 
Con “mx” permitimos enviar correos desde las IP de los registros mx del dominio. 
El carácter “~”, llamado softfail, indica que puede ser que alguna vez se mande correo desde otra IP no especificada. El correo se acepta, pero posiblemente como no deseado. 
SPF con varias IPs:
```
v=spf1 a mx include:127.0.0.1 ~all
```
include: 127.0.0.1 Con esto autorizamos una IP para que pueda enviar correos bajo este dominio, en este caso la 127.0.0.1. 
SPF para denegar todos los correos:
```
«v=spf1 -all»
```
“-” significa “fail”. Rechaza todos los correos de IP no indicadas en el registro. Al no indicar ningún valor, rechaza todos los correos. 

## DKIM

El DomainKeys Identified Mail, o DKIM, es un registro que permite firmar el correo con tu dominio mediante claves públicas indicadas en las zonas de tu dominio. De este modo, el destinatario está seguro de que el correo ha sido enviado desde tu servidor y no ha sido interceptado y/o reenviado desde otro servidor no autorizado. 

Este registro se puede activar fácilmente desde el Panel de Control. Solo tendrías que acceder al apartado Hosting > Correo > Sobre este correo y hacer clic en el checkbox de DKIM: 

DKIM panel de control Dinahosting

## DMARC

El Domain-based Message Authentication, Reporting and Conformance, o DMARC, que complementa al SPF y DKIM. Este registro indica qué hacer cuando dan error los registros anteriores, para así poder tomar las medidas necesarias lo antes posible. Se crea como un registro TXT desde el apartado de zonas DNS, de la siguiente forma: 
```
Tipo TXT
Host: _dmarc
Ejemplo de cadena de texto: 
v=DMARC1; p=quarantine; rua=mailto:info@dominio-ejemplo.com; ruf=mailto:info@dominio-ejemplo.com
registro dmarc
```
Recuerda seleccionar Subdominio en el desplegable para poder agregar el host _dmarc
- v= es el nombre del registro. En este caso DMARC1. 
- p= Indicamos qué quieres que se haga con nuestros correos. Podría ser: reject, quarantine o none.
    - reject: rechaza todos los correos que no cumplen las comprobaciones del DMARC. 
    - quarantine: los correos que fallan se pondrán en cuarentena. Irán a la carpeta de correos no deseados/SPAM.
    - none: se supervisan los resultados, sin tomar medidas para los mensajes que fallan. 
- rua/ruf= referencia la forma en la que se solicita que se envíen los reportes de errores detectados.
    - rua: se utiliza cuando necesitamos un reporte general.
    - ruf: se emplea cuando queremos recibir los mensajes completos que fallan.