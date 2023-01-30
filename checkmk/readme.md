## Plugins para windows
Los agentes para diferentes funcionalidades se encuentran en
```
C:\Program Files (x86)\checkmk\service\plugins
```

En el caso de windows update se copio windows_updates.vbs de la carpeta antes mencionada a
```
C:\programdata\checkmk\agent\plugins
```
Segun el testeo realizado los scripts son inicializados por el agente de checkmk y durante un escaneo se pueden ver los nuevos sensores