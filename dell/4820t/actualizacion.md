### Unidad flash compatible
- Cumple con los requisitos de USB 2.0 
- Partición única
- FAT-32

La extension de los archivos generalmente es .bin
```
upgrade system usbflash: b:
Source file name []: firmware.bin
```
Verificar el estado del boot system
```
show boot system stack-unit 0
```
Cambiar el booteo si es necesario
```
Econf-t# boot system stack-unit 0 primary system A: o B:
```

