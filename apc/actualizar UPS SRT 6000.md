# Proceso de actualizacion UPS APC SRT 6000

## Detalles UPS Echeverria

### TQARAPC03
* Model: Smart-UPS SRT 6000
* UPS SN: AS1646371937
* UPS SKU: SRT6KXLI
* Battery SKU: APCRBC140
* NMCv2 Model Number: AP9537SUM
* NMCv2 SN: 5A1646T34349
* MAC Address: 00 C0 B7 DA B1 1A

### TQARAPC04
* Model: Smart-UPS SRT 6000
* UPS SN: AS1646371935
* UPS SKU: SRT6KXLI
* Battery SKU: APCRBC140
* NMCv2 Model Number: AP9537SUM
* NMCv2 SN: 5A1646T34349
* MAC Address: 00 C0 B7 DA B1 1A

## Proceso actualizacion Firmware UPS

Si bien existen varias maneras, la mas segura es a traves de la utilidad de APC.
Es necesario contar con un cable USB tipo B (comunmente utilizado en las impresoras). Conectar un extremo a la UPS y el otro al dispositivo donde se efectua el update. Este metodo no requiere acceso serial.

Descargar el software **APC Smart-UPS Firmware Upgrade Wizard** [desde la web](https://www.apc.com/us/en/faqs/FA279197/) o desde la carpeta software: 
\\\software\Software\APC\Smart-UPS Firmware Upgrade Wizard\

> **IMPORTANTE:** Antes de realizar la actualización es necesario apagar la UPS o los outlet de salida. Tambien pueden desconectarse los cables de salida antes de realizar la actualización.

La utilidad encontrará una conexion por USB y detectará automaticamente el firmware correspondiente al equipo. En el caso de la *APC Smart-UPS SRT 6000* el archivo será **SRT1013UPS_15-0.enc** que instalará la version **UPS 15.0**.
Una vez finalizado reiniciará la UPS y es muy probable que tambien **apague la PC donde se esta corriendo la utilidad para realizar la actualización**.

Luego, encender la UPS manualmente desde el boton de encendido y seleccionar la opcion *Turn on inmediatly* y la UPS deberia estar actualizada y operativa.

## Proceso actualizacion Firmware NMCv2

La actualizacion de la interfaz de management puede realizarse de manera local (ssh, telnet, Serial) pero se detallará el proceso de actualizacion de red.

Para ello se debe contar con las credenciales de acceso a la UPS y acceso de red (se debe poder acceder a traves de la red). De no contar con alguno de ellos, realizar las tareas necesarias y volver al procedimiento.

Es necesario saber el tipo de placa de red instalada. Se puede obtener desde la interfaz web si se tiene acceso o a traves de cable consola corriendo el comando **about** nos confirmará que para la NMCv2 instalada el tipo es **sumx**. Este dato es de vital importancia.

Dado que la documentación de APC es bastante deficiente excepto para los equipos modernos, es necesario saber que la placa instalada es una **AP9537SUM** que no cuenta con documentación especifica en el sitio de APC. Sin embargo el firmware adecuado para este modelo es el compatible para los modelos AP9530/31/35.
Las utilidades fueron mutando y aunque no esta explito en la web ya que todo apunta a una utilidad y firmware no disponible, la utilidad para hacer flash de firmware del es el siguiente:

[Network Management Card 2 (NMC2) v7.1.2 Firmware for Smart-UPS with AP9630/31 (7.1.2)](https://www.se.com/us/en/product/SFSUMX708/ups-network-management-card-v7-0-8-firmware-for-smartups-galaxy-3500-with-ap9630-31-35/)

\\\software\Software\APC\Network Management Card 2 (NMC2) v7.1.2 Firmware for Smart-UPS with AP963031 (7.1.2)\

Ejecutar **apc_hw05_aos712_sumx712_bootmon109** para extraer la utilidad. Allí estará disponible el asistente **NMCFirmwareUpdateUtility**

> Es importante verificar en la esquina superior derecha que el binario de la aplicación contenga **SUMX** para tener compatibilidad con la NMCv2. Caso contrario no podrá comunicarse correctamente con la UPS

Ingresar la direccion IP de la placa de management conjuntamente con el usuario y contraseña. Siempre es preferible utilizar la opción **scp** pero suele ocurrir viniendo de versiones muy antiguas que el unico protocolo que funcione sea **ftp** que aunque es menos seguro y estable es mas compatible con versiones anteriores.

Comenzar el proceso con el botón **Start Update**. Es normal que la opción *Backup log files prior update* no funcione en la mayoria de los casos, especialmente viniendo desde versiones antiguas.

El proceso puede demorar entre 5 y 15 minutos. Es fundamental observar el log en pantalla que de forma cronologica nos mostrará el proceso y las etapas en las que se encuentra. No detener ni cerrar la utilidad hasta que la misma termine.

Una vez finalizado podremos acceder a la interfaz a traves de la IP configurada. El proceso restablecerá la configuración de usuarios, comunidades SNMP etc por lo que deberán ser seteadas nuevamente.