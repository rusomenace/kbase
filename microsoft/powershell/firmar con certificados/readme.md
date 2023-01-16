# Se crea un archivo .ps1 firmado con certificados

```
$cert=(dir cert:currentuser\my\ -CodeSigningCert)
Set-AuthenticodeSignature .\java.ps1 $cert
```
La parte que no se menciona es que se debera contar con un certificado digital con capacida de firma, en este caso la entidad de AD tq.com.ar como certificadora tiene una plantilla que lo permite y se asocia al usuario de AD.