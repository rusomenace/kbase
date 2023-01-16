### En windows 7 cambiar la siguiente entrada de registro:
```
HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server
```
Then add a DWORD value named “AllowRemoteRPC” and change its value to 1."

### Comando para verificar el ID de la sesion:
```
query session /server:tqarwsw706
```
### Comando para conectarse remoto sin consulta del usuario en forma SHADOW
```
mstsc /shadow:1 /v:tqarwsw705 /control /noConsentPrompt
```