## Agreements numbers:

6565790, 6565796, 5655797, 5655796
6565802, 5655803, 5655808, 6565811
6565821, 6565822, 6565833, 6565835
6565836, 6565842


# Instalacion

Role-based:
***Remote Desktop Services***

Role Services:
***Remote desktop licensing
Remote Desktop Session Host***

## Reiniciar

### Ejecutar las siguientes acciones
RD Licensing Manager (submenu Remote Desktop Services)
Ejecutar RD Licensing Manager
Activate Server
Automatic connection
Completar campo de nombre, apellido y empresa
Dejar tildado "Start Install Licenses Wizard now"
Enterprise Agreements
Product Version: Windows Server 2016
License Type: RDS Per Device Cal
Quantity: 9999
Click derecho All servers - Nombre de servidor - Install Licenses
Enterprise Agreements
Ingresar mismo agreement anterior
Product Version: Windows Server 2016
Licese Type: RDS Per User CAL
Quantity: 9999

Cargar RD Licensing Diagnoser
gpedit.msc
Computer Configuration
Administrative Templates
Windows Componentes
Remote Desktop Services
Remote Desktop Session Host
Licensing
Use the specified Remote Desktop license servers
Enabled
Ingresar el nombre de NETBIOS del servidor
Aceptar
Set the Remote Desktop licensing mode
Enabled
Per Device
Aceptar
RD Licensing Diagnoser
REFRESH

Aplicar certificado
Configurarlo en el IIS
Configurar RD Remote Gateway
Asignar FQDN asociado al certificado
Configurar certificado luego que procese el remote gateway
