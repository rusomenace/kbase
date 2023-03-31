#Oracle Basic KBASE

##Oracle Client

**Instalación**

Las distintas versiones para instalar están en \\software\Software\Oracle\
Al 2023-02-03 allí tenemos Ver 11g(11.2.0.3) hasta 19c (19.0.x)
Puede haber más de una vesión minor, por ejemplo, 11.2.0.3 y 11.2.0.4. Preferir la mas nueva.
En todos los casos suele haber vesióin de 32bit y 64bit. Usualmente se utiliza 64bit en servidores (a confirmar). 32bit en Clientes, o equipos donde se requiere depurar o utilizar Toad. 
En el folder específico de la versión, hay un BAT de instalación automatizada de nombre TQ-OraClientStandard{x86-x64}{Version}Setup.BAT. Por ejemplo: TQ-OraClientStandardX8611204Setup.
Ese BAT de instalación utiiliza un *response file* con el mismo nombre pero con extensión .RSP

Nota: 
En versiones previas a 12.2, la instalación no requiere un usuario específico. A partir de 12.2, se requiere un usuario (similar a lo que hace linux). Se ha optado por estandarizar con el local user *OraInstall*
Es por ello que en la raíz del folder de Oracle existe el BAT llamado TQOracleServiceUser.bat que controla esta existencia y en caso necesario lo crea. 

Cuando se encuentra instaladas multiples versiones de Oracle Client, por default toma la ultima instalada, pues está primera en el PATH, ya que así fue configurado en la instalación.
Puede configurarse para usar una especifica configurando un ORACLE_HOME, y utilizando esa variable de ambiente para invocar las utilidades, por ejemplo:
SET ORACLE_HOME=C:\oracle\product\11.2.0\client_1
%ORACLE_HOME%\bin\tnsping ODA12
TNS Ping Utility for 32-bit Windows: Version 11.2.0.4.0 - Production on 03-FEB-2023 10:02:43
Copyright (c) 1997, 2013, Oracle.  All rights reserved.
Used parameter files:
C:\oracle\product\19.0.0\client_1\network\admin\sqlnet.ora
Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = TQODA-scan)(PORT = 1521))) (CONNECT_DATA = (SERVICE_NAME=PDB01)))
OK (30 msec)



**Configuración de TNS**
Maneras de resolver nombres en TQ: TNSNAMES y EZCONNECT.
Esto está configurado en {ORACLE_HOME}\network\admin\sqlnet.ora 
En TQ se usa mayormente TNSNAMES

El archivo de nombres de TNSNAMES está configurado en {ORACLE_HOME}\network\admin\tnsnames.ora 

Ambos archivos se configuran en forma estándar con la Tool *TQSTDTNSNames.bat* que está en \\software\Software\Oracle. 

Cuando se encuentra instaladas multiples versiones de Oracle Client, toma el archivo TNSNAMES de la versión en uso, lo que corresponda a %ORACLE_HOME%
En TQ, por simplicuidad, se ha configurado la variable de ambiente TNS_ADMIN que indica qué ambiente de Oracle network debe usar, con lo que esta configuración se hace en un solo lugar, y no debe repetirse en todos los Oracle Client instalados. 
Por ejemplo: SET TNS_ADMIN=C:\oracle\product\19.0.0\client_1\network\admin



**Uso de TOAD**

 

 

##TASKS Habituales

 

Permisos de Acceso?

                GRANT de Accesos – Cruzados entre Schemas, lo hacen los OWNERS

                GRANT de Objetos de SYS, sólo en creación

Espacio en Tablespaces

                Depuracion

                Shrink

 