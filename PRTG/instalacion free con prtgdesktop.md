# PRTG Desktop
La instalaicon de pertg desktop solamente deja incorporar hasta 2 servidores free pero esa limitante se puede modificar cambiando las tablas directamente de la base de datos SQL Lite.
La ruta de la base de datos varia en funciona del nombre de usuario pero aca se da un ejemplo:
```
C:\Users\Pela\AppData\Roaming\Paessler\PRTG Desktop\data
```
Dentro de esa carpeta hay 2 archivos de SQL Lite:
- multiserversets.db
- prtgdesktop.db

Utilizando la herrmienta SQL Lite Studio se abre el archivo prtgdesktop.db
las entradas a agregar se encuentra en la tabla "ACCOUNTS"
Para saltear la limitante de registracion pero obtener los datos verdaderos se recomiendan las siguientes acciones:
- Cerra la aplicacion completamente
- Respaldar prtgdesktop.db a prtgdesktop.bkp
- Ingresar a la aplicacion y modificar las entradas por las nuevas a agregar
- Cerra la aplicacion y abrir la base de datos en SQL Lite Studio
- Copiar todos los valores de alta nuevos a la base de datos productiva prtgdesktop.bkp
- Reemplazar prtgdesktop.db por prtgdesktop.bkp manteniendo siempre un respaldo del archivo prtgdesktop.db