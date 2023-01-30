Obtener el numero de archivos dentro de un directorio en Bash
=====

## Utilizando wc

### Numero de elementos en un directorio
```bash
ls | wc -l
```

### Numero de elementos en un directorio con un nombre especifico

```bash
ls | grep 2023_01_25* | wc -l
```
* Se permite el uso de regex

---
## Utilizando tree

```bash
tree /var/logs
```

### Si deseamos incluir tambien archivos ocultos, agregamos el parametro -a

```bash
tree -a /var/logs
```
---
## Utilizando find

```bash
find /var/logs -type f | wc -l
```
* En caso de estar parado sobre el directorio que queremos hacer la busqueda, se puede reemplazar la ruta por . (punto)