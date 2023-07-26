# Como expandir discos con LVM

Extender el disco desde vSphere al tamaño deseado y reiniciar el servidor.

Para visibilizar el espacio en disco y las unidades disponibles

```bash
df -h
```

Luego, ingresamos a cfdisk para expandir el disco

```bash
sudo cfdisk
```

Seleccionar la linea que contiene el disco que queremos expandir (no la linea del espacio libre). Generalmente la mas comun es **/dev/sdX**

Una vez parados en el disco que deseamos expandir, seleccionamos la opcion **[Resize]**, verificamos que el espacio sugerido sea correcto y confirmar con **Enter**

Una vez que se puede visualizar que el disco tiene todo el espacio libre, seleccionamos la opcion **[Write]**

> Es muy importante que para confirmar los cambios escribamos **"yes"** y luego **Enter**

Ahora es momento de salir con la opcion **[Quit]**

Expandimos el Physical Volume. Donde *sda3* el disco con el que estamos trabajando

```bash
sudo pvresize /dev/sda3 
```

Con Physical Volume Display veremos si el disco ha sido extendido

```bash
sudo pvdisplay | grep "PV Size"
```

Con Local Volume Display podremos ver el path del Local Volume que utilizaremos para extender el volumen.

```bash
sudo lvdisplay | grep LV Path
```
Finalmente extendemos el Local Volume al 100% del espacio libre. Donde /dev/xxxx reemplazar por la ruta del resultado del LV Path del comando anterior

```bash
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv 
```
Luego ejecutar un df -h para visualizar el nombre del mapper
```bash
df -h | grep "/dev/mapper/"
```

Utilizando el resultado del comando anterior, realizamos un el cambio del tamaño del file system
```bash
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

Chequeamos que el espacio en disco se haya actualizado
```bash
df -h
```