# Agregar usuario como sudo
```
visudo
```
Al final del documento agregar la siguiente entrada y una por usuario
```
uroot  ALL=(ALL) NOPASSWD:ALL
```