# Robocopy

Para copiar todo de un source a un destination

- /MIR equivale a todo el contenido, folders, subfolders, files
- /COPY:DATSOU mantiene acl y atributos de los archivos
- /E copia subdirectorios incluidos los que estan vacios

Ejecutar el CMD como administrador
```
robocopy "d:\folder" "f:\folder" /MIR /E /COPY:DATSOU
```

## 19fs01
```
D:\Archive\QA
D:\FileBackups
D:\Software
```
## 16wsus01
```
robocopy "D:\Archive\QA" "D:\Archive\QA" /MIR /E /COPY:DATSOU
```