# Cambiar el conector de AAD connect luego de una migracion de los DC
Ingresar por RDP al servidor TQARSVW16AAD01 con credenciales de “TQ\Administrator”
Ingresar a la consola de Synchronization Service Manager en el servidor TQARSVW16AAD01

![](https://github.com/rusomenace/kbase/blob/main/microsoft/adsync/1.png)

Seleccionar el botón connectors -> marcar tq.com.ar y en el menú action, ingresar a propiedades. Luego Seleccionar Configure Directory Partitions y hacer clic en el botón “configure

![](https://github.com/rusomenace/kbase/blob/main/microsoft/adsync/2.png)

Borra el objeto viejo y agregar el nuevo y reinicie el servidor

![](https://github.com/rusomenace/kbase/blob/main/microsoft/adsync/3.png)

Luego ejecute el asistente para sync full y por último en una consola de PS ejecutar el siguiente comando para validar el Preferred Domain controller.
```
((Get-ADSyncConnector).Partitions.Parameters | ? {$_.Name -eq 'last-dc'}).value
```
