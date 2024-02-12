# Windows installer al 100%

El problema del Windows Installer pueden ser varias cosas.

1-Poner el servicio de Windows Installer en modo manual

Correr los siguientes comandos para verificar el filesystem (administrator)
```
DISM.exe /Online /Cleanup-image /Restorehealth
sfc /scannow
```

2-Correr el troubleshooter de Windows Update

3-Finalizar la tarea ```"tiworker.exe"```
Apagar el servicio de Windows Update
Eliminar la carpeta SoftwareDistribution