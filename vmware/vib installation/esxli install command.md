**Ref:** https://kb.vmware.com/s/article/2005205

### Subir el archivo a un datastore accesible del server

**Comando para actualizar**
```
esxcli software vib install -d "path al datastore + archivo vib.zip"
```
La ruta puede ser una ubicacion de disco como el ejemplo o una ubicacion clasica de linux /tmp/xxx/ddd

### Ejemplo
```
esxcli software vib install -d "/vmfs/volumes/61f462c6-f51f3d26-dfdc-48df37db591c/intel-nvme-vmd-en_2.0.0.1146-1OEM.700.1.0.15843807_16259168.zip"
```