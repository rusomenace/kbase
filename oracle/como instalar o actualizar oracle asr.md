# Instalacion ASR

- [Descargas JAVA 8](https://www.oracle.com/java/technologies/downloads/)
- [Descargas de ASR](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=134961940475612&parent=EXTERNAL_SEARCH&sourceId=REFERENCE&id=2152198.1&_afrWindowMode=0&_adf.ctrl-state=gjvyixde2_4#aref_section31)
- [Instalacion de ASR](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=138268390398319&id=2857309.2&_afrWindowMode=0&_adf.ctrl-state=gjvyixde2_503)


Nota: Se deberan utilizar las credenciales autorizadas para descargas (oraclesupport@tqcorp.com)

En el siguiente documento se utilizara como ejemplo el RPM de ASR version 22.2.0 y es para instalacion de cero.
En el caso de upgrade ovbiar la instalacion de JAVA 8

- Descargar la ultima version de ASR del link superior
- Descargar JAVA 8 archivo jdk-8u361-linux-x64.rpm

Pasar los archivos al servidor de linux por winscp

## Istalacion de JAVA 8
```
rpm -ivh jdk-8u361-linux-x64.rpm
java -version
```
## Instalacion de ASR
```
unzip p34966218_2220_Linux-x86-64.zip
rpm -ivh asrmanager-22.2.0-20221010085235.rpm
```
## Registracion de ASR guia de Oracle
Log in to the ASR console:
```
asr
```
To register the ASR Manager:
```
asr> register
Enter 1 to select:

1) transport.oracle.com
Enter proxy server details:
```
If you are using a proxy server to access the internet, see the instructions in 2.4 Configuring ASR Manager to Use a Proxy Server.

If you are not using a proxy server, enter a hyphen: -

Enter the username and password of your My Oracle Support (MOS) account when prompted.

Upon entry of your MOS credentials, ASR will validate the login. Once validated, the registration is complete.

Check the registration status of ASR:
```
asr> show_reg_status
```
 A message is displayed on the screen indicating whether ASR is registered with the transport server.
To be sure that ASR can send information to the transport server:
```
asr> test_connection
```
This command sends a test message (ping) to the transport server.

Upon successful results of the above commands, the registration of the ASR Manager is complete.